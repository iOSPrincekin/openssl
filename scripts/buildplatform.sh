#!/bin/bash

BASEDIR=$(dirname "$0")
cd ${BASEDIR}
BASEDIR=`pwd`

ARCHITECTURE=${2}

PLATFORM=${1}

echo Architecture is ${ARCHITECTURE}

if [ "$PLATFORM" = "iOS" ]; then 
    echo "build for iOS platform..."
	TARGET="ios-cross"
	export CROSS_TOP="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer"
	export CROSS_SDK="iPhoneOS.sdk"
	export CROSS_COMPILE=`xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/bin/
	TOOLCHAIN_ROOT="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain"

	../Configure $TARGET "-arch $ARCHITECTURE -fembed-bitcode" no-asm no-shared no-hw no-async --prefix=${BASEDIR}/../install/${PLATFORM}/${ARCHITECTURE} || exit 1 

elif [ "$PLATFORM" = "Android" ]; then 
    echo "build for Android platform..."
else
    echo "unknown platform!!!"
fi;

export PATH=${TOOLCHAIN_ROOT}/usr/bin:$PATH
make -j4 && make install || exit 2

echo buildplatform.sh done
