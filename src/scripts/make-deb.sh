#!/bin/bash
# Copyright (c) 2019-2021 The Hush developers
# Thanks to Zecwallet for the original code
# Released under the GPLv3

DEBLOG=deb.log.$$

if [ -z $QT_STATIC ]; then
    echo "QT_STATIC is not set; to set it use -static for QT configuration. Please set it to the base directory of a statically compiled Qt";
    exit 1;
fi

APP_VERSION=$(cat src/version.h | cut -d\" -f2)
if [ -z $APP_VERSION ]; then echo "APP_VERSION is not set"; exit 1; fi
#if [ -z $PREV_VERSION ]; then echo "PREV_VERSION is not set"; exit 1; fi

if [ -z $HUSH_DIR ]; then
    echo "HUSH_DIR is not set. Please set it to the src directory of hush3.git"
    exit 1;
fi

if [ ! -f $HUSH_DIR/hushd ]; then
    echo "Couldn't find hushd in $HUSH_DIR . Please build hushd."
    exit 1;
fi

if [ ! -f $HUSH_DIR/hush-cli ]; then
    echo "Couldn't find hush-cli in $HUSH_DIR . Please build hush-cli."
    exit 1;
fi

if [ ! -f $HUSH_DIR/hush-tx ]; then
    echo "Couldn't find hush-tx in $HUSH_DIR . Please build hush-tx."
    exit 1;
fi

if [ ! -f $HUSH_DIR/hush-smart-chain ]; then
    echo "Couldn't find hush-smart-chain in $HUSH_DIR . Please build hush-smart-chain."
    exit 1;
fi

echo "Cleaning..............."
rm -rf bin/*
rm -rf artifacts/*
make distclean >/dev/null 2>&1
echo "[OK]"

echo ""
echo "[Building $APP_VERSION on" `lsb_release -r`" logging to $DEBLOG ]"

echo "Translations............"
QT_STATIC=$QT_STATIC bash src/scripts/dotranslations.sh >/dev/null
echo -n "Configuring............"
$QT_STATIC/bin/qmake silentdragon.pro -spec linux-clang CONFIG+=release > /dev/null
echo "[OK]"


echo -n "Building..............."
rm -rf silentdragon
make clean > /dev/null
./build.sh release > /dev/null
echo "[OK]"


# Test for Qt
echo "Static link............"
if [[ $(ldd silentdragon | grep -i "Qt") ]]; then
    echo "FOUND QT; ABORT";
    exit 1
fi
echo "[OK]"


echo "Packaging.............."
APP=SilentDragon-v$APP_VERSION
DIR=bin/$APP
mkdir $DIR > /dev/null

#Organizing all bins & essentials to centralized folder for tar.gz
echo "Organizing binaries & essentials.............."
cp silentdragon $DIR > /dev/null
cp README.md $DIR > /dev/null
cp LICENSE $DIR > /dev/null

echo "Stripping silentdragon.............."
cd $DIR
strip silentdragon
cd ../..

echo "Compressing files.............."
cd bin/
tar -czf $APP.tar.gz ./$APP > /dev/null

echo "Copy compressed file.............."
mkdir artifacts >/dev/null 2>&1
cp $APP.tar.gz ./artifacts/$APP-linux.tar.gz
echo -n "[OK]"

echo "Verify Compressed File.............."
if [ -f artifacts/$APP-linux.tar.gz ] ; then
    echo -n "Package contents......."
    # Test if the package is built OK
    if tar -tf "artifacts/$APP-linux.tar.gz" | wc -l | grep -q "4"; then
        echo "[OK]"
    else
        echo "[ERROR] Wrong number of files does not match 11"
        exit 1
    fi
else
    echo "[ERROR]"
    exit 1
fi

echo "Building package..........."
debdir=deb/silentdragon-v$APP_VERSION
mkdir -p $debdir > /dev/null
mkdir    $debdir/DEBIAN
mkdir -p $debdir/usr/local/bin

mkdir -p $debdir/usr/lib
mkdir -p $debdir/usr/share/pixmaps/

cat ../src/scripts/control | sed "s/RELEASE_VERSION/$APP_VERSION/g" > $debdir/DEBIAN/control

echo "Copying silentdragon bin..........."
cp ../silentdragon $debdir/usr/local/bin/

echo "Copying core libraries from silentdragon binary..........."
# copy the required shared libs to the target folder
# create directories if required
for lib in `ldd $debdir/usr/local/bin/silentdragon | cut -d'>' -f2 | awk '{print $1}'` ; do
   if [ -f "$lib" ] ; then
        cp -v "$lib" $debdir/usr/lib/
   fi  
done

echo "Copying SilentDragon icon..........."
cp ../res/silentdragon.xpm $debdir/usr/share/pixmaps/

mkdir -p $debdir/usr/share/applications
cp ../src/scripts/desktopentry $debdir/usr/share/applications/silentdragon.desktop

dpkg-deb --build --root-owner-group $debdir >/dev/null

echo "[Success! $APP .deb has been created in $APP/bin/deb]"

exit 0
