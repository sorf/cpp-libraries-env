#!/bin/bash

export CLANGXX_COMMAND="clang++-5.0"
export CLANG_COMMAND="clang-5.0"
# We need gcc as well for Boost.Build.
export GCC_COMMAND="/usr/bin/gcc"
export PS1="[clang_5.0-release]\u@\h:\w>"

export CC=clang
export CXX=clang++


script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${script_dir}/env_linux.sh clang_5.0 clang release && exec bash -norc

