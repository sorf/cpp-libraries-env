#!/bin/bash

# __STRICT_ANSI__ defined to workaround the float128 compilation error when using libstdc++.
# see https://stackoverflow.com/questions/13525774/clang-and-float128-bug-error
export CLANGXX_COMMAND="/usr/bin/clang++ -D__STRICT_ANSI__"
export CLANG_COMMAND="/usr/bin/clang-3.8 -D__STRICT_ANSI__"
export PS1="[clang_3.8-release]\u@\h:\w>"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${script_dir}/env_linux.sh clang_3.8 clang release && exec bash

