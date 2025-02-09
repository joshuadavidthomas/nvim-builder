# List available recipes
default:
    @just --list

# Build the Docker image with default tag (HEAD)
build:
    docker build -t neovim-builder .

# Interactively select and build a specific tag
build-select:
    #!/usr/bin/env bash
    tag=$(printf "HEAD\n" && \
        curl -s https://api.github.com/repos/neovim/neovim/tags | \
        jq -r '.[].name' | \
        fzf --height 40% --reverse)
    if [ -n "$tag" ]; then
        docker build -t neovim-builder --build-arg NVIM_TAG="$tag" .
    fi

# Build latest release version
build-latest:
    #!/usr/bin/env bash
    latest_tag=$(curl -s https://api.github.com/repos/neovim/neovim/tags | jq -r '.[0].name')
    docker build -t neovim-builder --build-arg NVIM_TAG="$latest_tag" .

# Run the build and output to ./output directory
run:
    mkdir -p output
    docker run -v $(pwd)/output:/workdir/output \
        --user $(id -u):$(id -g) \
        neovim-builder

# Clean output directory
clean:
    rm -rf output

# Build and run in one command (HEAD version)
all: build run

# Build and run latest release version
latest: build-latest run

# Select tag, build and run
select: build-select run
