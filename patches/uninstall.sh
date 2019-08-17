#!/bin/sh
rootdirectory="$PWD"
cd $rootdirectory
cd bootable/recovery
echo "Cleaning bootable/recovery patches..."
git checkout -- . && git clean -df
echo "Done!"
cd $rootdirectory
