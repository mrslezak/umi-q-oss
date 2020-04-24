#!/bin/bash
rm .version

clear
cd ~/umi-q-oss/
cp Makefile.clang11 Makefile

rm -rf out-clang
mkdir out-clang

# Resources
THREAD="-j8"
KERNEL="Image"
DTBIMAGE="dtb"

export CLANG_PATH=~/toolchains/Clang-11/bin/
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=${HOME}/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android- CC=clang CXX=clang++
#export CROSS_COMPILE_ARM32=${HOME}/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
export KBUILD_COMPILER_STRING=$(~/toolchains/Clang-11/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')
export CXXFLAGS="$CXXFLAGS -fPIC"
export DTC_EXT=dtc

DEFCONFIG="umi_user_defconfig"

# Paths
KERNEL_DIR=`pwd`
ZIMAGE_DIR="${HOME}/umi-q-oss/out-clang/arch/arm64/boot/"

# Kernel Details
VER=".1.0"

# Vars
BASE_AK_VER="MOD-Kernel-V0.1"
AK_VER="$BASE_AK_VER$VER"
export LOCALVERSION=~`echo $AK_VER`
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=MattoftheDead
export KBUILD_BUILD_HOST=Ubuntu18.04

DATE_START=$(date +"%s")

echo -e "${green}"
echo "-------------------"
echo "Making Kernel:"
echo "-------------------"
echo -e "${restore}"

echo
make CC="ccache clang" CXX="ccache clang++" O=out-clang $DEFCONFIG
make CC="ccache clang" CXX="ccache clang++" O=out-clang $THREAD 2>&1 | tee kernel.log

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
cd $ZIMAGE_DIR
ls -a
