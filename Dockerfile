FROM ubuntu:22.04

# Install build prerequisites as specified in BUILD.md
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  build-essential \
  cmake \
  curl \
  gettext \
  git \
  ninja-build \
  && rm -rf /var/lib/apt/lists/*

# Create and set working directory with proper permissions
WORKDIR /workdir
RUN chmod 777 /workdir

# Copy entrypoint script and make it executable  
COPY entrypoint.sh /workdir/
RUN chmod +x /workdir/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/workdir/entrypoint.sh"]
