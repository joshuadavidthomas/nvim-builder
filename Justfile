# List available recipes
default:
    @just --list

# Build the Docker image
build:
    docker build -t neovim-builder .

# Build HEAD version
head: clean build
    just run

# Build latest release version
latest: clean build
    #!/usr/bin/env bash
    latest_tag=$(curl -s https://api.github.com/repos/neovim/neovim/tags | jq -r '.[0].name')
    just run "$latest_tag"

# Interactively select and build a specific tag
select: clean build
    #!/usr/bin/env bash
    tag=$(( echo "HEAD" && \
        curl -s https://api.github.com/repos/neovim/neovim/tags | \
        jq -r '.[].name' ) | \
        fzf --height 40% --reverse | tr -d '\n')
    if [ -n "$tag" ]; then
        just run "$tag"
    fi

run TAG="HEAD":
    mkdir -p output
    docker run -v $(pwd)/output:/workdir/output \
        --user $(id -u):$(id -g) \
        -e NVIM_TAG="{{ TAG }}" \
        neovim-builder

# Clean output directory
clean:
    rm -rf output
