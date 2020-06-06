#!/bin/bash

# env.sh is the environment setup for building the project.
# the script should export LOOPY_HOME and point it to the local project root.
source env.sh

# Following https://grpc.io/docs/languages/cpp/quickstart/#grpc-and-protocol-buffers

export LOOPY_PREFIX="$LOOPY_HOME/local"

mkdir -p $LOOPY_PREFIX
echo $LOOPY_PREFIX
export PATH="$PATH:$LOOPY_PREFIX/bin"

mkdir -p grpc/cmake/build
pushd grpc/cmake/build >/dev/null

cmake -DgRPC_INSTALL=ON \
      -DgRPC_BUILD_TESTS=OFF \
      -DgRPC_ZLIB_PROVIDER=package \ # https://github.com/grpc/grpc.io/issues/265
      -DCMAKE_INSTALL_PREFIX=$LOOPY_PREFIX \
      ../..

make -j
make install
popd
