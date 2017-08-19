#!/bin/bash

CPP_TOOLCHAIN=$1
if [ -z "$CPP_TOOLCHAIN" ]; then
    CPP_TOOLCHAIN=NA
fi
export CPP_TOOLCHAIN

BOOST_TOOLSET=$2
if [ -z "$BOOST_TOOLSET" ]; then
    BOOST_TOOLSET=gcc
fi
export BOOST_TOOLSET

DEBUG_RELEASE=$3
if [ -z "$DEBUG_RELEASE" ]; then
    DEBUG_RELEASE=debug
fi
export DEBUG_RELEASE

ADDRESS_MODEL=64
export ADDRESS_MODEL

# Boost settings
export BASE_FOLDER=~/local
export BOOST_VERSION=1_64_0
export BOOST_SOURCE_FOLDER=${BASE_FOLDER}/src/boost_${BOOST_VERSION}
export BZIP2_SOURCE_FOLDER=${BASE_FOLDER}/src/bzip2-1.0.6
export ZLIB_SOURCE_FOLDER=${BASE_FOLDER}/src/zlib-1.2.11

export BUILD_VARIANT=${CPP_TOOLCHAIN}_${DEBUG_RELEASE}_${ADDRESS_MODEL}

# Boost paths
export BOOST_INCLUDE_FOLDER=${BASE_FOLDER}/include/boost_${BOOST_VERSION}
export BOOST_LIB_FOLDER=${BASE_FOLDER}/lib/boost_${BOOST_VERSION}_${BUILD_VARIANT}
export BOOST_TMP_FOLDER=${BASE_FOLDER}/tmp/boost_${BOOST_VERSION}_${BUILD_VARIANT}
export BOOST_EXEC_FOLDER=${BASE_FOLDER}/misc/boost_${BOOST_VERSION}_${BUILD_VARIANT}


echo BOOST_VERSION="${BOOST_VERSION}"
echo BOOST_INCLUDE_FOLDER="${BOOST_INCLUDE_FOLDER}"
echo BOOST_LIB_FOLDER="${BOOST_LIB_FOLDER}"
echo BOOST_TOOLSET="${BOOST_TOOLSET}"
echo ADDRESS_MODEL="${ADDRESS_MODEL}"

# gcc-style include and lib paths  (so they come before the system ones)
export GCC_INCLUDE_PATHS=-isystem${BOOST_INCLUDE_FOLDER}
export GCC_LIB_PATHS=-L${BOOST_LIB_FOLDER}

# redirect the actual compiler
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export PATH="${script_dir}/linux_compiler_redirect:${PATH}"

