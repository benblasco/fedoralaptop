#!/usr/bin/env bash

CONTAINER=$(buildah from registry.fedoraproject.org/fedora-minimal:35)

buildah run ${CONTAINER} microdnf install -y cargo make gcc alsa-lib-devel 
buildah run ${CONTAINER} microdnf clean all
buildah run ${CONTAINER} rm -rf /var/cache/dnf
buildah run ${CONTAINER} cargo install librespot --no-default-features --features "alsa-backend"

buildah config --entrypoint "/root/.cargo/bin/librespot" ${CONTAINER} 
#buildah config --cmd "--name=Buildah_LibreSpot_Speaker --bitrate=320 --zeroconf-port=49999 --device=hdmi:CARD=PCH,DEV=0 --initial-volume=75 -v" ${CONTAINER}
buildah config --cmd "--name=Buildah_LibreSpot_Speaker --bitrate=320 --zeroconf-port=49999 --backend=alsa --device=default --initial-volume=75 -v" ${CONTAINER}

buildah config --label maintainer="Benjamin Blasco" ${CONTAINER}
buildah config --label description="Fedora-based container for running librespot, built on Rust" ${CONTAINER}

buildah commit ${CONTAINER} librespot-container
