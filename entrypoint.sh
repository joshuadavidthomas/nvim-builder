#!/bin/bash
set -e

cd /workdir/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo \
  CMAKE_INSTALL_PREFIX=/workdir/output \
  && make install
