#!/bin/sh
rootdirectory="$PWD"
cd $rootdirectory
cd bootable/recovery
echo "Applying bootable/recovery patches..."
git apply $rootdirectory/device/meizu/mblu2/patches/bootable/recovery/*.patch
echo "Done!"
cd $rootdirectory
