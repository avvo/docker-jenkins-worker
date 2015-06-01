#!/bin/bash

COUNT=4

function start() {
  for i in `seq 1 $COUNT`
  do
    echo starting $i
    docker-service $i "up -d"
  done
}

function stop() {
  for i in `seq 1 $COUNT`
  do
    echo stopping $i
    docker-service $i stop
    docker-service $i "rm -f"
  done
}

function restart() {
  for i in `seq 1 $COUNT`
  do
    echo restarting $i
    docker-service $i stop
    docker-service $i "rm -f"
    docker-service $i up -d
  done
}

function docker-service {
  echo docker-compose start -p jenkins$1 -f docker-compose$1.yml $2
  docker-compose start -p jenkins$1 -f docker-compose$1.yml $2
}

case $1 in
start)
  start
  ;;
stop)
  stop
  ;;
restart)
  restart
  ;;
*)
  echo "unknown command '$1'"
  exit 1
  ;;
esac
