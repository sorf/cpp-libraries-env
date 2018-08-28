#!/bin/bash

export GXX_COMMAND="g++-6 -fPIC"
export GCC_COMMAND="gcc-6 -fPIC"
export PS1="[gcc_6-release]\u@\h:\w>"

export CC=gcc
export CXX=g++

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${script_dir}/env_linux.sh gcc_6 gcc release && exec bash -norc

