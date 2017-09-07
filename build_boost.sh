#!/bin/bash

if [ -z "$BOOST_TOOLSET" ]; then
    echo BOOST_TOOLSET not set
    exit 1
fi
if [ -z "$DEBUG_RELEASE" ]; then
    echo DEBUG_RELEASE not set
    exit 1
fi
if [ -z "$ADDRESS_MODEL" ]; then
    echo ADDRESS_MODEL not set
    exit 1
fi
if [ -z "$BOOST_SOURCE_FOLDER" ]; then
    echo BOOST_SOURCE_FOLDER not set
    exit 1
fi
if [ -z "$BZIP2_SOURCE_FOLDER" ]; then
    echo BZIP2_SOURCE_FOLDER not set
    exit 1
fi
if [ -z "$ZLIB_SOURCE_FOLDER" ]; then
    echo ZLIB_SOURCE_FOLDER not set
    exit 1
fi
if [ -z "$BOOST_INCLUDE_FOLDER" ]; then
    echo BOOST_INCLUDE_FOLDER not set
    exit 1
fi
if [ -z "$BOOST_LIB_FOLDER" ]; then
    echo BOOST_LIB_FOLDER not set
    exit 1
fi
if [ -z "$BOOST_TMP_FOLDER" ]; then
    echo BOOST_TMP_FOLDER not set
    exit 1
fi
if [ -z "$BOOST_EXEC_FOLDER" ]; then
    echo BOOST_EXEC_FOLDER not set
    exit 1
fi

current_folder=$(pwd)

layout=system
with_libraries="\
 --with-atomic\
 --with-chrono\
 --with-container\
 --with-context\
 --with-coroutine\
  --with-fiber\
 --with-iostreams\
 --with-program_options\
 --with-test\
 --with-thread
"

additional_flags="\
 -sBZIP2_SOURCE="$BZIP2_SOURCE_FOLDER"\
 -sZLIB_SOURCE="$ZLIB_SOURCE_FOLDER"\
 cxxflags="-std=c++14"\
"

b2_command="b2\
 --build-dir="$BOOST_TMP_FOLDER"\
 --includedir="$BOOST_INCLUDE_FOLDER"\
 --libdir="$BOOST_LIB_FOLDER"\
 --exec-prefix="$BOOST_EXEC_FOLDER"\
 --layout=$layout\
 $with_libraries\
 toolset=$BOOST_TOOLSET\
 variant=$DEBUG_RELEASE\
 address-model=$ADDRESS_MODEL\
 link=static\
 runtime-link=shared\
 $additional_flags\
 install"

echo Building libraries: $with_libraries
echo $b2_command

mkdir -p "$BOOST_INCLUDE_FOLDER"
cd $BOOST_SOURCE_FOLDER
$b2_command
cd $current_folder