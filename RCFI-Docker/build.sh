#!/bin/bash

#===-- build.sh ------------------------------------------------------------===#
#
# This file is distributed under the Apache License v2.0
# Author: Andreas Vollert and Oliver Braunsdorf, Fraunhofer AISEC
#
#===----------------------------------------------------------------------===#

# Build script for RCFI with LLVM 9 in Docker
# Author: Andreas Vollert <andreas.vollert@aisec.fraunhofer.de>

# Variables are configured externally! E.g. in a .env file for
# docker-compose

BUILD_DIR="$1"
if [ ! -d "$BUILD_DIR" ]; then
    echo "Cannot find build directory \"$BUILD_DIR\"! Abort"
    exit 1
fi


if [[ $BUILD_DEBUG == "YES" ]]; then
    BUILD_TYPE="Debug"
    SHARED_LIBS="ON"
    ASSERTIONS="ON"
else
    BUILD_TYPE="Release"
    SHARED_LIBS="OFF"
fi


if [[ $BUILD_CLANG == "YES" ]]; then
    if [ ! -d "clang" ]; then
	echo "Cannot find clang directory! Abort"
	exit 1
    fi
    [[ $ENABLED_PROJECTS == "" ]] && ENABLED_PROJECTS="clang" || ENABLED_PROJECTS+=";clang"
fi

if [[ $BUILD_LLD == "YES" ]]; then
    if [ ! -d "lld" ]; then
	echo "Cannot find lld directory! Abort"
	exit 1
    fi
    [[ $ENABLED_PROJECTS == "" ]] && ENABLED_PROJECTS="lld" || ENABLED_PROJECTS+=";lld"
fi

if [[ $BUILD_COMPILER_RT == "YES" ]]; then
    if [ ! -d "compiler-rt" ]; then
	echo "Cannot find compiler-rt directory! Abort"
	exit 1
    fi
    [[ $ENABLED_PROJECTS == "" ]] && ENABLED_PROJECTS="compiler-rt" || ENABLED_PROJECTS+=";compiler-rt"
fi


if [[ $USE_GCC == "YES" ]]; then
    C_COMPILER="/usr/bin/gcc"
    CXX_COMPILER="/usr/bin/g++"
else
    C_COMPILER="/usr/bin/clang"
    CXX_COMPILER="/usr/bin/clang++"
fi

if [[ $USE_CCACHE == "YES" ]]; then
    USE_CCACHE="ON"
else
    USE_CCACHE="OFF"
fi

if [[ $USE_DISTCC == "YES" ]]; then
    if [[ $USE_CCACHE == "ON" ]]; then
	export CCACHE_PREFIX=distcc
    else
	COMPILE_LAUNCHER="distcc"
    fi
fi


if [ ! -d "llvm" ]; then
    echo "Cannot find llvm directory! Abort"
    exit 1
fi



echo "Options that will be given to cmake:"
echo "-G Ninja \
      -DCMAKE_BUILD_TYPE=\"$BUILD_TYPE\" \
      -DLLVM_ENABLE_PROJECTS=\"$ENABLED_PROJECTS\" \
      -DCMAKE_C_COMPILER=\"$C_COMPILER\" \
      -DCMAKE_CXX_COMPILER=\"$CXX_COMPILER\" \
      -DLLVM_CCACHE_BUILD=\"$USE_CCACHE\" \
      -DBUILD_SHARED_LIBS=\"$SHARED_LIBS\" \
      -DLLVM_ENABLE_ASSERTIONS=\"$ASSERTIONS\" \
      -DCMAKE_C_COMPILER_LAUNCHER=\"$COMPILE_LAUNCHER\" \
      -DCMAKE_CXX_COMPILER_LAUNCHER=\"$COMPILE_LAUNCHER\""

cd "$BUILD_DIR" && \
    cmake ../llvm \
	-G Ninja \
	-DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
	-DLLVM_ENABLE_PROJECTS="$ENABLED_PROJECTS" \
	-DCMAKE_C_COMPILER="$C_COMPILER" \
	-DCMAKE_CXX_COMPILER="$CXX_COMPILER" \
	-DLLVM_CCACHE_BUILD="$USE_CCACHE" \
    -DBUILD_SHARED_LIBS="$SHARED_LIBS" \
    -DLLVM_ENABLE_ASSERTIONS="$ASSERTIONS" \
	-DCMAKE_C_COMPILER_LAUNCHER="$COMPILE_LAUNCHER" \
	-DCMAKE_CXX_COMPILER_LAUNCHER="$COMPILE_LAUNCHER" \


if [[ $USE_DISTCC == "YES" ]]; then
    eval "$(distcc-pump --startup)"
    ninja -j"$(distcc -j)"
    distcc-pump --shutdown
else
    if [[ ! -z $BUILD_CORES ]]; then
        ninja -j $BUILD_CORES
    else
        ninja
    fi
fi
