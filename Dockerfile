FROM ubuntu:22.04

# Install build prerequisites as specified in BUILD.md
RUN apt-get update && apt-get install -y \
    ninja-build \
    gettext \
    cmake \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create and set working directory
WORKDIR /workdir

# Clone Neovim repository
RUN git clone https://github.com/neovim/neovim

# Build Neovim following the official instructions
RUN cd neovim \
    && make CMAKE_BUILD_TYPE=RelWithDebInfo \
    CMAKE_INSTALL_PREFIX=/workdir/output \
    && make install

# The output directory will be mounted from the host system
# Run with: docker run -v $(pwd)/output:/workdir/output neovim-builder
