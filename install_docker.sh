#!/bin/bash

echo 'deb     https://get.docker.io/ubuntu docker main' | tee /etc/apt/sources.list.d/docker.list
apt-key add 2048R/A88D21E9
apt-get update
apt-get install -y lxc-docker