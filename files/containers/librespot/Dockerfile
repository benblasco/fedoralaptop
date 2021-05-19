# Dockerfile with cache (maybe)
FROM registry.fedoraproject.org/fedora-minimal:32
LABEL maintainer Benjamin Blasco
LABEL description Fedora container for creating Rust applications

# Note: We run all commands together in order to prevent multiple layers being added to the container image.  Could also look at squashing this further.
RUN microdnf install cargo alsa-lib-devel make gcc \
        && microdnf clean all \
        && rm -rf /var/cache/dnf \
        && cargo install librespot

ENTRYPOINT [ "/root/.cargo/bin/librespot" ]
CMD        [ "--name=\"NUC LibreSpot Speaker\"", \
             "--bitrate=320", \
             "--zeroconf-port=49999", \
             "--device=hdmi:CARD=PCH,DEV=0", \
             "--initial-volume=75", \
             "-v" ]

# Alternative CMD and ENTRYPOINT attempts
# More reading here: https://aws.amazon.com/blogs/opensource/demystifying-entrypoint-cmd-docker/
#ENTRYPOINT /root/.cargo/bin/librespot --name="NUC LibreSpot Speaker" --bitrate=320 --zeroconf-port=49999 --device="hdmi:CARD=PCH,DEV=0" --initial-volume=75 -v
#CMD /root/.cargo/bin/librespot -n "F32 VM LibreSpot Speaker" -b 320 --zeroconf-port=49999 --device "hdmi:CARD=PCH,DEV=0"
#ENTRYPOINT /root/.cargo/bin/librespot -n "NUC LibreSpot Speaker" -b 320 --zeroconf-port=49999 --device "hdmi:CARD=PCH,DEV=0"
#ENTRYPOINT [/root/.cargo/bin/librespot, -n, "NUC LibreSpot", -b, 320, "--zeroconf-port=49999", --device, "hdmi:CARD=PCH,DEV=0"]

#ENTRYPOINT /root/.cargo/bin/librespot --name="NUC LibreSpot Speaker" --bitrate=320 --zeroconf-port=49999 --initial-volume=75 -v
