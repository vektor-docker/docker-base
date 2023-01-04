#!/bin/bash
docker run \
    --rm \
    -it \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    ghcr.io/vektor-docker/docker-base:3.0 \
    my_init --skip-runit -- bash $@
