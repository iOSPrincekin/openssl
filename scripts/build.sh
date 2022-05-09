#!/bin/bash

BASEDIR=$(dirname "$0")
cd ${BASEDIR}
BASEDIR=`pwd`

set -x

archs=(iOS_arm64)

#
# first clean up all previous build artifacts:
#



cd ../
### 
### build each platform
### 
for arch in "${!archs[@]}"
do
  TARGET=${archs[$arch]}
  echo $TARGET
  IFS='_' read -r -a TARGET_array <<< "$TARGET"
  PLATFORM=${TARGET_array[0]}
  ARCHITECTURE=${TARGET_array[1]}
  BUILDDIR=build
  rm -rf ${BUILDDIR}
  mkdir ${BUILDDIR}
  echo "---${PLATFORM}---${ARCHITECTURE}--${BASEDIR}/buildplatform.sh"
  cp ${BASEDIR}/buildplatform.sh ./${BUILDDIR}
  chmod +x ./${BUILDDIR}/buildplatform.sh
  pushd ./${BUILDDIR}
  ./buildplatform.sh ${PLATFORM} ${ARCHITECTURE}
  popd 
done 













  


