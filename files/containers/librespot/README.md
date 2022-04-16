# Librespot Rust Package

Github repo
https://github.com/librespot-org/librespot

Rust Crates source
https://crates.io/crates/librespot

Parameters:
https://github.com/librespot-org/librespot/wiki/Options

Changing the audio backend
https://github.com/librespot-org/librespot/wiki/Audio-Backends

Compiling
https://github.com/librespot-org/librespot/blob/master/COMPILING.md

# Firewall ports required

Outside the container you need to enable mdns service (UDP port 5353) on the firewall:
```
firewall-cmd --list-all
firewall-cmd --permanent --zone=FedoraServer --add-port=49999/tcp
firewall-cmd --permanent --zone=FedoraServer --add-service=mdns 
```

# Sound packages to install on the container host
```
dnf install alsa-utils
```

# Getting the speaker working

```
[root@nuc images]# speaker-test -c 2 -D front --buffer 2000
```

Unmuted the master volume
```
amixer sset Master unmute
```
 
The sound works from the headphone jack ("front") once you do this

# Librespot identifying the sound device

Run the command
```
aplay -L
```

https://github.com/librespot-org/librespot/wiki/Devices

The command below definitely works, and the device name is from the output of the `aplay` command above
```
speaker-test -c 2 -D hdmi:CARD=PCH,DEV=0 --buffer 2000 
```
# My build in github

https://github.com/benblasco/fedoralaptop/blob/master/files/containers/librespot/librespot-buildah.sh

# How to run the container

Ephemeral
```
podman run -dt --rm --net host --device=/dev/snd --tz localhost/librespot
```
Pet
```
podman run -dt --net host --device=/dev/snd --tz=local localhost/librespot
```

# Scratchpad

We are using card 0, device 3, subdevice 0
Card 0
```
[root@nuc librespot]# cat /proc/asound/card0/pcm3p/sub0/hw_params 
```


## Multi stage builds
"You may also see Containerfiles with multistage builds where multiple FROM commands may be present. Multistage builds provide a means to help refine the runtime image as opposed to having an image which also contains all the necessary software to build. For instance you typically don’t need maven to run a java based jar but do need it to build."

## Podman auto update

@Sreejith: yes, you need to setup a systemd.timer and unit for the container in order to use the podman auto update feature.

This is available in podman 3.0

Automatic container image updates
Podman 3.0 ships with podman-auto-update.service systemd unit.  Triggered daily, by default, checks registry and pulls updated container image, then restarts affected containers using systemd

