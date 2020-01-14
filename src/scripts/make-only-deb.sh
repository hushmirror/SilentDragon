#!/bin/bash
# Copyright (c) 2020 The Hush developers
# Released under the GPLv3

DEBLOG=deb.log.$$
APP_VERSION=$(cat src/version.h | cut -d\" -f2)
if [ -z $APP_VERSION ]; then echo "APP_VERSION is not set"; exit 1; fi

# This assumes we already have a staticly compiled SD

echo -n "Packaging.............."
APP=SilentDragon-v$APP_VERSION
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
#TODO: and param files

tar czf $APP.tar.gz $DIR/
cd ..

echo -n "Building deb..........."
debdir=bin/deb/silentdragon-v$APP_VERSION
mkdir -p $debdir > /dev/null
mkdir    $debdir/DEBIAN
mkdir -p $debdir/usr/local/bin

cat src/scripts/control | sed "s/RELEASE_VERSION/$APP_VERSION/g" > $debdir/DEBIAN/control

cp silentdragon                   $debdir/usr/local/bin/
# TODO: how does this interact with hushd deb ?
cp $HUSH_DIR/artifacts/komodod $debdir/usr/local/bin/hush-komodod

mkdir -p $debdir/usr/share/pixmaps/
cp res/silentdragon.xpm           $debdir/usr/share/pixmaps/

mkdir -p $debdir/usr/share/applications
cp src/scripts/desktopentry    $debdir/usr/share/applications/silentdragon.desktop

dpkg-deb --build $debdir >/dev/null
cp $debdir.deb                 artifacts/$DIR.deb
echo "[OK]"

exit 0
