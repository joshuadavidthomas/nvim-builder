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

# Copy entrypoint script and make it executable  
COPY entrypoint.sh /workdir/
RUN chmod +x /workdir/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/workdir/entrypoint.sh"]
