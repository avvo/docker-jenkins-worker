#!/bin/bash
for i in `env | grep -v HOME`
do
  echo "export $i" >> /home/jenkins/.bashrc
done
env | grep -v HOME > /home/jenkins/environment.properties

gem install bundler
bundle install
bundle exec ./register.rb

/usr/sbin/sshd -D
