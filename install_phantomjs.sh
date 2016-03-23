#!/bin/bash
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
export DEST="/usr/local/share"

apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
mkdir -p $DEST
wget -O - -q https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 | tar -xvjC $DEST
ln -s ${DEST}/${PHANTOM_JS}/bin/phantomjs /usr/local/bin/
