#!/bin/bash
# Copyright 2019 The Hush Developers

JOBS=$(nproc)

qmake silentdragon.pro CONFIG+=debug
echo "Compiling with $JOBS threads..."
make -j$JOBS
