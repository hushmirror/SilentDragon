#!/bin/bash
# Copyright 2019 The Hush Developers

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

echo "Compiling with $JOBS threads..."

if [ "$1" == "clean" ]; then
   make clean
elif [ "$1" == "cleanbuild" ]; then
   make clean
   qmake silentdragon.pro CONFIG+=debug; make -j$JOBS
else
   qmake silentdragon.pro CONFIG+=debug; make -j$JOBS
fi
