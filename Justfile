# List available recipes
default:
    @just --list

# Build the Docker image
build:
    docker build -t neovim-builder .

# Build HEAD version
head: clean
    mkdir -p output
    docker run -v $(pwd)/output:/workdir/output \
        --user $(id -u):$(id -g) \
        neovim-builder

# Build latest release version
latest: clean
    #!/usr/bin/env bash
    latest_tag=$(curl -s https://api.github.com/repos/neovim/neovim/tags | jq -r '.[0].name')
    mkdir -p output
    docker run -v $(pwd)/output:/workdir/output \
        --user $(id -u):$(id -g) \
        -e NVIM_TAG="$latest_tag" \
        neovim-builder

# Interactively select and build a specific tag
select: clean
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

# Clean output directory
clean:
    rm -rf output
