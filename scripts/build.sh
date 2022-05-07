#!/bin/bash

BASEDIR=$(dirname "$0")
cd ${BASEDIR}

set -x
OPENSSLVERSION=openssl-1.1.1i
OPENSSLTARBALL=${OPENSSLVERSION}.tar.gz

archs=(arm64)

#
# first clean up all previous build artifacts:
#


for arch in "${!archs[@]}"
do 
  BUILDDIR=${archs[$arch]}
  rm -rf ${BUILDDIR}
done 

rm -rf build
mkdir build 


### 
### build each platform
### 
for arch in "${!archs[@]}"
do 
  cd ../
  ARCHITECTURE=${archs[$arch]}
  BUILDDIR=iOS_${ARCHITECTURE}_build
  mkdir ${BUILDDIR}
  cp buildplatform.sh ./${BUILDDIR}/${OPENSSLVERSION}
  chmod +x ./${BUILDDIR}/${OPENSSLVERSION}/buildplatform.sh
  pushd ./${BUILDDIR}/${OPENSSLVERSION}
  ./buildplatform.sh ${ARCHITECTURE}
  popd 
done 



### 
### create a fat library:
### 
function CreateFatLibrary ()
{
    LIBRARY_NAME=$1
    /usr/bin/lipo -create -arch i386 build/i386/lib/lib${LIBRARY_NAME}.a \
        -arch x86_64 build/x86_64/lib/lib${LIBRARY_NAME}.a \
	    -arch armv7 build/armv7/lib/lib${LIBRARY_NAME}.a \
	    -arch armv7s build/armv7s/lib/lib${LIBRARY_NAME}.a \
	    -arch arm64 build/arm64/lib/lib${LIBRARY_NAME}.a \
	    -output build/lib/lib${LIBRARY_NAME}.a
	/usr/bin/lipo -info build/lib/lib${LIBRARY_NAME}.a
}

mkdir build/lib
CreateFatLibrary ssl || exit 3
CreateFatLibrary crypto || exit 4










  


