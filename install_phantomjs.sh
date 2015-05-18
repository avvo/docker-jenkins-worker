#!/bin/bash

# apt-get install -y build-essential g++ flex bison gperf ruby perl \
#   libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
#   libpng-dev libjpeg-dev python

# git clone git://github.com/ariya/phantomjs.git
# pushd phantomjs
# git checkout 2.0
# echo "y" | ./build.sh
# popd

# install 1.9.8 from https://gist.github.com/julionc/7476620
apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2
mv $PHANTOM_JS /usr/local/share
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin