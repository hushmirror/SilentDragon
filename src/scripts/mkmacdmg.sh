#!/bin/bash
# Copyright (c) 2019-2021 The Hush developers
# Released under the GPLv3

# Accept the variables as command line arguments as well
POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -q|--qt_path)
    QT_PATH="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--hush_path)
    HUSH_DIR="$2"
    shift # past argument
    shift # past value
    ;;
    -u|--username)
    APPLE_USERNAME="$2"
    shift # past argument
    shift # past value
    ;;
    -p|--password)
    APPLE_PASSWORD="$2"
    shift # past argument
    shift # past value
    ;;
   -c|--certificate)
    CERTIFICATE="$2"
    shift # past argument
    shift # past value
    ;;
    -v|--version)
    APP_VERSION="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -z $QT_PATH ]; then 
    echo "QT_PATH is not set. Please set it to the base directory of Qt"; 
    exit 1; 
fi

if [ -z $HUSH_DIR ]; then
    echo "HUSH_DIR is not set. Please set it to the base directory of a compiled hushd";
    exit 1;
fi

if [ -z "$APPLE_USERNAME" ]; then 
    echo "APPLE_USERNAME is not set. Please set it the name of the MacOS developer login email to submit the binary for Apple for notarization"; 
    exit 1; 
fi

if [ -z "$APPLE_PASSWORD" ]; then 
    echo "APPLE_PASSWORD is not set. Please set it the name of the MacOS developer Application password to submit the binary for Apple for notarization"; 
    exit 1; 
fi

if [ -z "$CERTIFICATE" ]; then 
    echo "CERTIFICATE is not set. Please set it the name of the MacOS developer certificate to sign the binary with"; 
    exit 1; 
fi

if [ -z $APP_VERSION ]; then
    echo "APP_VERSION is not set. Please set it to the current release version of the app";
    exit 1;
fi

if [ ! -f $HUSH_DIR/src/hushd ]; then
    echo "Could not find compiled hushd in $HUSH_DIR/src/.";
    exit 1;
fi

if ! cat src/version.h | grep -q "$APP_VERSION"; then
    echo "Version mismatch in src/version.h"
    exit 1
fi

export PATH=$PATH:/usr/local/bin

#Clean
echo -n "Cleaning..............."
make distclean >/dev/null 2>&1
rm -f artifacts/macOS-silentdragon-v$APP_VERSION.dmg
echo "[OK]"


echo -n "Configuring............"
# Build
QT_STATIC=$QT_PATH src/scripts/dotranslations.sh >/dev/null
$QT_PATH/bin/qmake silentdragon.pro CONFIG+=release >/dev/null
echo "[OK]"


echo -n "Building..............."
make -j4 >/dev/null
echo "[OK]"

#Qt deploy
echo -n "Deploying.............."
mkdir artifacts >/dev/null 2>&1
rm -f artifcats/silentdragon.dmg >/dev/null 2>&1
rm -f artifacts/rw* >/dev/null 2>&1
cp $HUSH_DIR/src/hushd silentdragon.app/Contents/MacOS/
cp $HUSH_DIR/src/hush-cli silentdragon.app/Contents/MacOS/
cp $HUSH_DIR/sapling-output.params silentdragon.app/Contents/MacOS/
cp $HUSH_DIR/sapling-spend.params silentdragon.app/Contents/MacOS/
$QT_PATH/bin/macdeployqt silentdragon.app 
codesign --deep --force --verify --verbose -s "$CERTIFICATE" --options runtime --timestamp silentdragon.app
echo "[OK]"

# Code Signing Note:
# On MacOS, you still need to run signbinaries.sh to staple.
#

echo -n "Building dmg..........."
create-dmg --volname "silentdragon-v$APP_VERSION" --volicon "res/logo.icns" --window-pos 200 120 --icon "silentdragon.app" 200 190  --app-drop-link 600 185 --hide-extension "silentdragon.app"  --window-size 800 400 --hdiutil-quiet --background res/dmgbg.png  artifacts/macOS-silentdragon-v$APP_VERSION.dmg silentdragon.app >/dev/null 2>&1
if [ ! -f artifacts/macOS-silentdragon-v$APP_VERSION.dmg ]; then
    echo "[ERROR]"
    exit 1
fi
echo  "[OK]"

# Submit to Apple for notarization
echo -n "Apple notarization....."
xcrun altool --notarize-app -t osx -f artifacts/macOS-silentdragon-v$APP_VERSION.dmg --primary-bundle-id="com.myHush.silentdragon" -u "$APPLE_USERNAME" -p "$APPLE_PASSWORD"
echo  "[OK]"
