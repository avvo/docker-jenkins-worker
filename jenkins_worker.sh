#!/bin/bash

COUNT=${2-4}
RAMDISK=${RAMDISK-/mnt/ramdisk}
TEMPLATE=${TEMPLATE-$PWD/template.yml}

test -d $RAMDISK || ("RAMDISK: '$RAMDISK' doesn't exist" && exit 1)
test -f $TEMPLATE || ("TEMPLATE: '$TEMPLATE' doesn't exist" && exit 1)

function create_ramdisk() {
  if test -d ${RAMDISK}/mysql${1}
  then
    echo "Ramdisk for mysql ${1} exists, skipping"
  else
    echo "Creating ramdisk dir ${1}"
    mkdir ${RAMDISK}/mysql${1}
  fi
}

function create_yaml() {
  cp ${1} docker-compose${2}.yml
  sed -i "s/\$NUM/$2/g" docker-compose${2}.yml
}

function docker-service {
  echo docker-compose -p jenkins$1 -f docker-compose$1.yml $2
  docker-compose -p jenkins$1 -f docker-compose$1.yml $2
}

function start() {
  for i in `seq 1 $1`
  do
    create_ramdisk $i
    create_yaml $TEMPLATE $i
    echo starting $i
    docker-service $i "up -d"
  done
}

function stop() {
  for i in `seq 1 $1`
  do
    echo stopping $i
    docker-service $i stop
    docker-service $i "rm -f"
  done
}

function restart() {
  for i in `seq 1 $1`
  do
    echo restarting $i
    docker-service $i stop
    docker-service $i "rm -f"
    docker-service $i up -d
  done
}

case $1 in
start)
  start $COUNT
  ;;
stop)
  stop $COUNT
  ;;
restart)
  restart $COUNT
  ;;
*)
  echo "unknown command '$1'"
  exit 1
  ;;
esac
