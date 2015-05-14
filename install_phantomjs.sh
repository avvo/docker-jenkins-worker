#!/bin/bash

apt-get install -y build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev python

git clone git://github.com/ariya/phantomjs.git
pushd phantomjs
git checkout 2.0
echo "y" | ./build.sh
popd