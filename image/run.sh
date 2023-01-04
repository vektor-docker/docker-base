#!/bin/bash
docker run \
    --name base \
    --rm \
    -it \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -e LOG_LEVEL="INFO" \
    ghcr.io/vektor-docker/docker-base:3.0 \
    $@
