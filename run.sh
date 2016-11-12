#!/bin/bash
for i in `env | grep -v HOME`
do
  echo "export $i" >> /home/jenkins/.bashrc
done
env | grep -v HOME > /home/jenkins/environment.properties

rvm default do gem install bundler
rvm default do bundle install
rvm default do bundle exec ./register.rb

/usr/sbin/sshd -D
