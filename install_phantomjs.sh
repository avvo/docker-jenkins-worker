#!/bin/bash

phantom_versions=(phantomjs-1.9.8-linux-x86_64 phantomjs-2.1.1-linux-x86_64)

for phantom_version in ${phantom_versions[@]}; do
    export PHANTOM_JS=${phantom_version}
    export DEST="/usr/local/share"

    set -e

    apt-get install -y build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev wget
    mkdir -p $DEST
    wget -O - -q https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 | tar -xvjC $DEST
    ln -s ${DEST}/${PHANTOM_JS}/bin/phantomjs /usr/local/bin/

done
