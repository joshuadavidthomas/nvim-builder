FROM ubuntu:22.04

# Add build argument for git tag with HEAD as default
ARG NVIM_TAG=HEAD

# Install build prerequisites as specified in BUILD.md
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  build-essential \
  cmake \
  curl \
  gettext \
  git \
  ninja-build \
  && rm -rf /var/lib/apt/lists/*

# Create and set working directory
WORKDIR /workdir

# Clone Neovim repository and checkout specified tag
RUN if [ "${NVIM_TAG}" = "HEAD" ]; then \
      git clone --depth 1 https://github.com/neovim/neovim; \
    else \
      git clone --depth 1 --branch ${NVIM_TAG} https://github.com/neovim/neovim; \
    fi

# Build Neovim following the official instructions
RUN cd neovim \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo \
  CMAKE_INSTALL_PREFIX=/workdir/output \
  && make install

# The output directory will be mounted from the host system
# Run with: docker run -v $(pwd)/output:/workdir/output neovim-builder
# Or with tag: docker run -v $(pwd)/output:/workdir/output neovim-builder --build-arg NVIM_TAG=stable
