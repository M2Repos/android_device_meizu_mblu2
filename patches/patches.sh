#!/bin/bash

DEVICE_DIR="device/meizu/mblu2"

[ ! -d "$PWD/build" ] || [ ! -d "$PWD/$DEVICE_DIR" ] && echo "Incorrect folder" && exit 0

rootdirectory="$PWD"
dirs="bootable/recovery"

function arguments() {
    if [ "$1" != "--install" ] && [ "$1" != "-i" ] && [ "$1" != "--uninstall" ] && [ "$1" != "-u" ]; then
        echo "Unknown argument detected.
Use $0 with:
  -i, --install
  -u, --uninstall"
        exit 0
    fi
}

for arg in "$@"; do
    arguments $arg
    if [ "$arg" == "--install" ] || [ "$arg" == "-i" ]; then
        install=true
    fi
    if [ "$arg" == "--uninstall" ] || [ "$arg" == "-u" ]; then
        uninstall=true
    fi
done

if [ "$install" != "true" ] && [ "$uninstall" != "true" ]; then
    arguments
fi

for dir in $dirs ; do
    cd $rootdirectory
    cd $dir
    if [ "$install" == "true" ]; then
        echo "Applying $dir patches..."
        git apply $rootdirectory/$DEVICE_DIR/patches/$dir/*.patch
    fi
    if [ "$uninstall" == "true" ]; then
        echo "Reverting $dir patches..."
        git apply -R $rootdirectory/$DEVICE_DIR/patches/$dir/*.patch
    fi
done

cd $rootdirectory
echo "Done!"
