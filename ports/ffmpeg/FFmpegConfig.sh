#!/bin/bash
set -e
export PATH=/usr/bin:$PATH
pacman -Sy --noconfirm --needed diffutils make

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $DIR

echo "***args $1 $2 $3 $4"

		
if [ "$1" == "Win10" ]; then
    echo "Make Win10"

    if [ "$2" == "x86" ]; then
        echo "Make Win10 x86 $3"
        rm -rf Output/Windows10/x86/$3
        mkdir -p Output/Windows10/x86/$3
        cd Output/Windows10/x86/$3
		pwd
        ../../../../configure \
        --toolchain=msvc \
        --disable-dxva2 \
        --arch=x86 \
        --enable-shared \
        --enable-postproc \
        --enable-zlib \
        --disable-static \
        --disable-programs \
        --disable-devices \
        --disable-crystalhd \
        --enable-muxer=spdif \
        --enable-muxer=adts \
        --enable-muxer=asf \
        --enable-muxer=ipod \
        --enable-encoder=ac3 \
        --enable-encoder=aac \
        --enable-encoder=wmav2 \
        --enable-encoder=png \
        --enable-encoder=mjpeg \
        --enable-protocol=http \
        --enable-cross-compile \
        --target-os=win32 \
        --extra-cflags="-MD -DWINAPI_FAMILY=WINAPI_FAMILY_APP -D_WIN32_WINNT=0x0A00" \
        --extra-ldflags="-APPCONTAINER WindowsApp.lib" \
        --prefix=$4
        make install

    elif [ "$2" == "x64" ]; then
        echo "Make Win10 x64"
        rm -rf Output/Windows10/x64/$3
        mkdir -p Output/Windows10/x64/$3
        cd Output/Windows10/x64/$3
        ../../../../configure \
        --toolchain=msvc \
        --disable-programs \
        --disable-d3d11va \
        --disable-dxva2 \
        --arch=x86_64 \
        --enable-shared \
        --enable-cross-compile \
        --target-os=win32 \
        --extra-cflags="-MD -DWINAPI_FAMILY=WINAPI_FAMILY_APP -D_WIN32_WINNT=0x0A00" \
        --extra-ldflags="-APPCONTAINER WindowsApp.lib" \
        --prefix=$4
        make install

    elif [ "$2" == "ARM" ]; then
        echo "Make Win10 ARM"
        rm -rf Output/Windows10/ARM/$3
        mkdir -p Output/Windows10/ARM/$3
        cd Output/Windows10/ARM/$3
        ../../../../configure \
        --toolchain=msvc \
        --disable-programs \
        --disable-d3d11va \
        --disable-dxva2 \
        --arch=arm \
        --as=armasm \
        --cpu=armv7 \
        --enable-thumb \
        --enable-shared \
        --enable-cross-compile \
        --target-os=win32 \
        --extra-cflags="-MD -DWINAPI_FAMILY=WINAPI_FAMILY_APP -D_WIN32_WINNT=0x0A00 -D__ARM_PCS_VFP" \
        --extra-ldflags="-APPCONTAINER WindowsApp.lib" \
        --prefix=$4
        make install

    fi


elif [ "$1" == "Win7" ]; then
    echo "Make Win7"

    if [ "$2" == "x86" ]; then
        echo "Make Win7 x86"
        rm -rf Output/Windows7/x86/$3
        mkdir -p Output/Windows7/x86/$3
        cd Output/Windows7/x86/$3
        ../../../../configure \
        --toolchain=msvc \
        --disable-programs \
        --disable-d3d11va \
        --disable-dxva2 \
        --arch=x86 \
        --enable-shared \
        --enable-cross-compile \
        --target-os=win32 \
        --extra-cflags="-MD -D_WINDLL" \
        --extra-ldflags="-APPCONTAINER:NO -MACHINE:x86" \
        --prefix=$4
        make install

    elif [ "$2" == "x64" ]; then
        echo "Make Win7 x64"
        rm -rf Output/Windows7/x64/$3
        mkdir -p Output/Windows7/x64/$3
        cd Output/Windows7/x64/$3
        ../../../../configure \
        --toolchain=msvc \
        --disable-programs \
        --disable-d3d11va \
        --disable-dxva2 \
        --arch=amd64 \
        --enable-shared \
        --enable-cross-compile \
        --target-os=win32 \
        --extra-cflags="-MD -D_WINDLL" \
        --extra-ldflags="-APPCONTAINER:NO -MACHINE:x64" \
        --prefix=$4
        make install

    fi
fi

exit 0