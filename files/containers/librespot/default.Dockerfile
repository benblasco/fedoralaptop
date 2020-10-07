# Dockerfile with cache (maybe)
FROM registry.fedoraproject.org/fedora-minimal:32
LABEL maintainer Benjamin Blasco
LABEL description Fedora container for creating Rust applications

# Note each command here builds a new layer, which is extremely wasteful.  We will want to squash this later
#RUN dnf install -y cargo alsa-lib-devel make gcc
#RUN cargo install librespot 
#RUN PATH=$PATH:/root/.cargo/bin && RUN librespot -n "F32 VM LibreSpot Speaker" -b 320 &


#RUN dnf install -y cargo alsa-lib-devel make gcc \
RUN microdnf install cargo alsa-lib-devel make gcc \
        && microdnf clean all \
        && rm -rf /var/cache/dnf \
        && cargo install librespot

ENTRYPOINT /root/.cargo/bin/librespot --name="NUC LibreSpot Speaker" --bitrate=320 --zeroconf-port=49999 --initial-volume=75 -v
