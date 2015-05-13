#!/bin/bash
for i in `env`
do
  echo "export $i" >> /home/jenkins/.bashrc
done
/usr/sbin/sshd -D