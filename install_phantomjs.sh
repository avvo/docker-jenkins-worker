#!/bin/bash
export PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
export PHANTOM_JS_211="phantomjs-2.1.1-linux-x86_64"
export DEST="/usr/local/share"

phantom_versions=(${PHANTOM_JS} ${PHANTOM_JS_211})

set -e

apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev wget
mkdir -p $DEST

for phantom_version in ${phantom_versions[@]}; do
    wget -O - -q https://bitbucket.org/ariya/phantomjs/downloads/${phantom_version}.tar.bz2 | tar -xvjC $DEST
done

ln -s ${DEST}/${PHANTOM_JS}/bin/phantomjs /usr/local/bin/
ln -s ${DEST}/${PHANTOM_JS_211}/bin/phantomjs /usr/local/bin/phantomjs-211
