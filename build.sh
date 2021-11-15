#!/bin/bash
# Copyright 2018-2021 The Hush Developers
# Released under the GPLv3

set -e
UNAME=$(uname)

if [ "$UNAME" == "Linux" ] ; then
    JOBS=$(nproc)
elif [ "$UNAME" == "FreeBSD" ] ; then
    JOBS=$(nproc)
elif [ "$UNAME" == "Darwin" ] ; then
    JOBS=$(sysctl -n hw.ncpu)
else
    JOBS=1
fi

VERSION=$(cat src/version.h |cut -d\" -f2)
echo "Compiling SilentDragon $VERSION with $JOBS threads..."
CONF=silentdragon.pro

if ! command -v qmake &> /dev/null
then
    echo "qmake could not be found. Please install QT and try again."
    exit 1
fi

if ! command -v make &> /dev/null
then
    echo "make could not be found. Please install it and try again."
    exit 1
fi


qbuild () {
   qmake $CONF -spec linux-clang CONFIG+=debug
   make -j$JOBS
}

qbuild_release () {
   qmake $CONF -spec linux-clang CONFIG+=release
   make -j$JOBS
}

if [ "$1" == "clean" ]; then
   make clean
elif [ "$1" == "linguist" ]; then
    lupdate $CONF
    lrelease $CONF
elif [ "$1" == "cleanbuild" ]; then
   make clean
   qbuild
elif [ "$1" == "release" ]; then
   qbuild_release
else
   qbuild
fi
