# List available recipes
default:
    @just --list

# Build the Docker image
build:
    docker build -t neovim-builder .

# Interactively select and build a specific tag
build-select:
    #!/usr/bin/env bash
    tag=$(( echo "HEAD" && \
        curl -s https://api.github.com/repos/neovim/neovim/tags | \
        jq -r '.[].name' ) | \
        fzf --height 40% --reverse | tr -d '\n')
    if [ -n "$tag" ]; then
        mkdir -p output
        docker run -v $(pwd)/output:/workdir/output \
            --user $(id -u):$(id -g) \
            -e NVIM_TAG="$tag" \
            neovim-builder
    fi

# Build latest release version
build-latest:
    #!/usr/bin/env bash
    latest_tag=$(curl -s https://api.github.com/repos/neovim/neovim/tags | jq -r '.[0].name')
    mkdir -p output
    docker run -v $(pwd)/output:/workdir/output \
        --user $(id -u):$(id -g) \
        -e NVIM_TAG="$latest_tag" \
        neovim-builder

# Run the build and output to ./output directory (HEAD version)
run:
    mkdir -p output
    docker run -v $(pwd)/output:/workdir/output \
        --user $(id -u):$(id -g) \
        neovim-builder

# Clean output directory
clean:
    rm -rf output

# Build and run in one command (HEAD version)
all: clean build run

# Build and run latest release version
latest: clean build

# Select tag and build
select: clean build build-select
