#!/bin/bash
for i in `env | grep -v HOME`
do
  echo "export $i" >> /home/jenkins/.bashrc
done
env | grep -v HOME > /home/jenkins/environment.properties
/usr/sbin/sshd -D