# Dockerfile with cache (maybe)
FROM quay.io/fedora/fedora:32-x86_64
LABEL maintainer Benjamin Blasco
LABEL description Fedora container for creating Rust applications

# Note each command here builds a new layer, which is extremely wasteful.  We will want to squash this later
#RUN dnf install -y cargo alsa-lib-devel make gcc
#RUN cargo install librespot 
#RUN PATH=$PATH:/root/.cargo/bin && RUN librespot -n "F32 VM LibreSpot Speaker" -b 320 &


#RUN dnf install -y cargo alsa-lib-devel make gcc \
RUN dnf install -y cargo alsa-lib-devel make gcc net-tools procps-ng iproute \
        && dnf clean all \
        && rm -rf /var/cache/dnf \
        && cargo install librespot
#CMD /root/.cargo/bin/librespot -n "F32 VM LibreSpot Speaker" -b 320 --zeroconf-port=49999 --device "hdmi:CARD=PCH,DEV=0"
#ENTRYPOINT /root/.cargo/bin/librespot -n "NUC LibreSpot Speaker" -b 320 --zeroconf-port=49999 --device "hdmi:CARD=PCH,DEV=0"
ENTRYPOINT /root/.cargo/bin/librespot --name="NUC LibreSpot Speaker" --bitrate=320 --zeroconf-port=49999 --device="hdmi:CARD=PCH,DEV=0"
#ENTRYPOINT [/root/.cargo/bin/librespot, -n, "NUC LibreSpot Speaker", -b, 320, "--zeroconf-port=49999", --device, "hdmi:CARD=PCH,DEV=0"]
