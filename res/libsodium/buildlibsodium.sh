#!/bin/bash
# Copyright (c) 2019-2020 The Hush developers
# Released under the GPLv3

VERSION=1.0.18
LIB="libsodium"
DIR="$LIB-$VERSION"
FILE="$DIR.tar.gz"
URL=https://github.com/MyHush/libsodium/releases/download/${VERSION}/${FILE}

# First thing to do is see if libsodium.a exists in the res folder. If it does, then there's nothing to do
if [ -f res/${LIB}.a ]; then
    exit 0
fi

echo "Building $LIB"

# Go into the libsodium directory
cd res/$LIB
if [ ! -f $FILE ]; then
    curl -LO $URL
fi

if [ ! -d $DIR ]; then
    tar xf $FILE
fi

# Try to use full core count to build
if [ "$UNAME" == "Linux" ] ; then
    JOBS=$(nproc)
elif [ "$UNAME" == "FreeBSD" ] ; then
    JOBS=$(nproc)
elif [ "$UNAME" == "Darwin" ] ; then
    JOBS=$(sysctl -n hw.ncpu)
else
    JOBS=4
fi

# Now build it
cd $DIR
LIBS="" ./configure
make clean
echo "Building $LIB with $JOBS cores..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    make CFLAGS="-mmacosx-version-min=10.11" CPPFLAGS="-mmacosx-version-min=10.11" -j$JOBS
else
    make -j$JOBS
fi
cd ..

# copy the library to the parents's res/ folder
cp $DIR/src/libsodium/.libs/libsodium.a ../
