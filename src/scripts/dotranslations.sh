#!/bin/bash
# Copyright (c) 2019-2021 The Hush developers
# Released under the GPLv3

if [ -z $QT_STATIC ]; then 
    echo "QT_STATIC is not set. Please set it to the base directory of a statically compiled Qt"; 
    exit 1; 
fi

rm -f res/*.qm
$QT_STATIC/bin/lrelease silentdragon.pro

# Then update the qt base translations. First, get all languages
ls res/*.qm | awk -F '[_.]' '{print $4}' | while read -r language ; do 
    if [ -f $QT_STATIC/translations/qtbase_$language.qm ]; then
        $QT_STATIC/bin/lconvert -o res/silentdragon_$language.qm $QT_STATIC/translations/qtbase_$language.qm res/silentdragon_$language.qm
    fi
done
