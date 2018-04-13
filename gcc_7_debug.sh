#!/bin/bash

export GXX_COMMAND="g++-7 -fPIC"
export GCC_COMMAND="gcc-7 -fPIC"
export PS1="[gcc_7-debug]\u@\h:\w>"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${script_dir}/env_linux.sh gcc_7 gcc debug && exec bash -norc

