#!/bin/bash
# Copyright (c) 2019-2021 The Hush developers
# Released under the GPLv3

APP_VERSION=$(cat src/version.h | cut -d\" -f2)
if [ -z $APP_VERSION ]; then echo "APP_VERSION is not set"; exit 1; fi

# This assumes we already have a staticly compiled SD

set -e
OS=$(uname)
ARCH=$(uname -i)
APP=SilentDragon-v$APP_VERSION-$OS-$ARCH
DIR=$APP
echo "Making tarball for $APP..."
if [ -e $DIR ]; then
    mv $DIR $DIR.$(perl -e 'print time')
fi
mkdir -p $DIR
strip silentdragon
strip hushd
strip hush-tx
strip hush-cli

cp silentdragon   $DIR
cp hushd          $DIR
cp hush-cli       $DIR
cp hush-tx        $DIR
cp README.md      $DIR
cp LICENSE        $DIR

# We make tarballs without params for people who already have them installed
echo "Creating $APP-noparams.tar.gz..."
tar czf $APP-noparams.tar.gz $DIR/

cp sapling-output.params $DIR
cp sapling-spend.params $DIR

# By default we tell users to use the normal tarball with params, which will
# be about 50MB larger but should cause less user support issues
echo "Creating $APP.tar.gz..."
tar czf $APP.tar.gz $DIR/

echo "CHECKSUMS for $APP_VERSION"
sha256sum $APP-noparams.tar.gz
sha256sum $APP.tar.gz
