#!/usr/bin/env bash

# Changes to be made: 
# - Add labels for maintainer and description

buildah from registry.fedoraproject.org/fedora-minimal:35

buildah run fedora-minimal-working-container microdnf install -y cargo alsa-lib-devel make gcc
buildah run fedora-minimal-working-container microdnf clean all
buildah run fedora-minimal-working-container rm -rf /var/cache/dnf
buildah run fedora-minimal-working-container cargo install librespot

buildah config --entrypoint "/root/.cargo/bin/librespot" fedora-minimal-working-container 
buildah config --cmd "--name=NUC LibreSpot Speaker --bitrate=320 --zeroconf-port=49999 --device=hdmi:CARD=PCH,DEV=0 --initial-volume=75 -v" fedora-minimal-working-container

buildah config --label maintainer="Benjamin Blasco"
buildah config --label description="Fedora-based container for running librespot, built on Rust"

buildah commit fedora-minimal-working-container librespot-container
