#!/bin/bash
set -e

# Default to HEAD if NVIM_TAG is not set
NVIM_TAG=${NVIM_TAG:-HEAD}

# Clone the appropriate version
if [ "${NVIM_TAG}" = "HEAD" ]; then
  git clone --depth 1 https://github.com/neovim/neovim
else
  git clone --depth 1 --branch ${NVIM_TAG} https://github.com/neovim/neovim
fi

cd /workdir/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo \
  CMAKE_INSTALL_PREFIX=/workdir/output \
  && make install
