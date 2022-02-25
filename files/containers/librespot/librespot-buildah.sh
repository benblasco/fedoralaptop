#!/usr/bin/env bash

# Changes to be made: 
# - Add labels for maintainer and description

CONTAINER=$(buildah from registry.fedoraproject.org/fedora-minimal:35)

buildah run ${CONTAINER} microdnf install -y cargo alsa-lib-devel make gcc
buildah run ${CONTAINER} microdnf clean all
buildah run ${CONTAINER} rm -rf /var/cache/dnf
buildah run ${CONTAINER} cargo install librespot

buildah config --entrypoint "/root/.cargo/bin/librespot" ${CONTAINER} 
buildah config --cmd "--name=NUC LibreSpot Speaker --bitrate=320 --zeroconf-port=49999 --device=hdmi:CARD=PCH,DEV=0 --initial-volume=75 -v" ${CONTAINER}

buildah config --label maintainer="Benjamin Blasco"
buildah config --label description="Fedora-based container for running librespot, built on Rust"

buildah commit ${CONTAINER} librespot-container
