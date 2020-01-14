#!/bin/bash
# Copyright (c) 2020 The Hush developers
# Released under the GPLv3

DEBLOG=deb.log.$$
APP_VERSION=$(cat src/version.h | cut -d\" -f2)
if [ -z $APP_VERSION ]; then echo "APP_VERSION is not set"; exit 1; fi

# This assumes we already have a staticly compiled SD

echo -n "Packaging.............."
APP=SilentDragon-v$APP_VERSION-linux
DIR=$APP
mkdir $DIR
strip silentdragon

cp silentdragon   $DIR
cp komodod        $DIR
cp komodo-cli     $DIR
cp komodo-tx      $DIR
cp hushd          $DIR
cp hush-cli       $DIR
cp hush-tx        $DIR
cp README.md      $DIR
cp LICENSE        $DIR
#TODO: and param files?

tar czf $APP.tar.gz $DIR/
