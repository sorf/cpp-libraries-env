#!/bin/bash

export GXX_COMMAND="g++-8 -fPIC"
export GCC_COMMAND="gcc-8 -fPIC"
export PS1="[gcc_8-debug]\u@\h:\w>"

export CC=gcc
export CXX=g++

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${script_dir}/env_linux.sh gcc_8 gcc debug && exec bash -norc

