# List available recipes
default:
    @just --list

# Build the Docker image with default tag (HEAD)
build:
    docker build -t neovim-builder .

# Interactively select and build a specific tag
build-select:
    #!/usr/bin/env bash
    tag=$(curl -s https://api.github.com/repos/neovim/neovim/tags | \
        jq -r '.[].name' | \
        fzf --height 40% --reverse)
    if [ -n "$tag" ]; then
        docker build -t neovim-builder --build-arg NVIM_TAG="$tag" .
    fi

# Build stable version
build-stable:
    docker build -t neovim-builder --build-arg NVIM_TAG=stable .

# Run the build and output to ./output directory
run:
    mkdir -p output
    docker run -v $(pwd)/output:/workdir/output neovim-builder

# Clean output directory
clean:
    rm -rf output

# Build and run in one command (HEAD version)
all: build run

# Build and run stable version
stable: build-stable run

# Select tag, build and run
select: build-select run
