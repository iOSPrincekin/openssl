#!/bin/bash
ARCHITECTURE=${1}

echo Architecture is ${ARCHITECTURE}

if [[ ${ARCHITECTURE} = "i386" || ${ARCHITECTURE} = "x86_64"  ]]; then
    TARGET="iossimulator-xcrun"
else
    TARGET="ios-cross"
    export CROSS_TOP="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer"
    export CROSS_SDK="iPhoneOS.sdk"
    export CROSS_COMPILE=`xcode-select --print-path`/Toolchains/XcodeDefault.xctoolchain/usr/bin/
    TOOLCHAIN_ROOT="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain"
fi

./Configure $TARGET "-arch $ARCHITECTURE -fembed-bitcode" no-asm no-shared no-hw no-async --prefix=$(pwd)/${ARCHITECTURE}_install || exit 1 

export PATH=${TOOLCHAIN_ROOT}/usr/bin:$PATH
make && make install || exit 2



















echo buildplatform.sh done
