#!/bin/bash

export GXX_COMMAND="g++-7 -fPIC"
export GCC_COMMAND="gcc-7 -fPIC"
export PS1="[gcc_7-release]\u@\h:\w>"

export CC=gcc
export CXX=g++

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${script_dir}/env_linux.sh gcc_7 gcc release && exec bash -norc

