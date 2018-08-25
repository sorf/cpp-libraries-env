#!/bin/bash

export CLANGXX_COMMAND="clang++-6.0 -fPIC"
export CLANG_COMMAND="clang-6.0 -fPIC"
# We need gcc as well for Boost.Build.
export GCC_COMMAND="/usr/bin/gcc"
export PS1="[clang_6.0-release]\u@\h:\w>"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${script_dir}/env_linux.sh clang_6.0 clang release && exec bash -norc

