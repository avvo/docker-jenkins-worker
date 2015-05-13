#!/bin/bash
for i in `env`
do
  echo "export $i" >> /home/jenkins/.bashrc
done
env > /home/jenkins/environment.properties
/usr/sbin/sshd -D