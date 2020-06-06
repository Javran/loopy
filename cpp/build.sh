#!/bin/bash

# env.sh is the environment setup for building the project.
# the script should export LOOPY_HOME and point it to the local project root.
source ../env.sh
export LOOPY_PREFIX="$LOOPY_HOME/local"

pushd $LOOPY_HOME/cpp >/dev/null

cmake -DMAKE_PREFIX_PATH=$LOOPY_PREFIX .
make -j

popd >/dev/null

