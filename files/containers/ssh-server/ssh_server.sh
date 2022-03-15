#!/usr/bin/env bash

# SSH server container built with a heavy kludge of the following article:
# Setting up containerized SSH servers for session recording with tlog
# https://www.redhat.com/sysadmin/session-recording-tlog

# Run the committed container with the following command (as non-root user)
# podman run -d -p 2022:2022 localhost/ssh-server-ubi8:latest 

# Access the container with the following command
# sftp -P 2022 <IP of container host>
# or
# ssh <IP of container host> -p 2022

# Security is provided by only allowing clients with the stored public keys to access the system

# Improvements to be made:
# - Mount a local volume
# - Prevent SSH access and only allow SFTP or SCP

CONTAINER=$(buildah from registry.access.redhat.com/ubi8/ubi-init:latest)

PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCY9P2Hh1ultuvNlBGHxQGNYlDkB35Z/kPQNR+tfsYaO2gGLhbtkVI0uoXf5SewEz5ecH+u8jHIPElXZz227h5PpxhZFzfokqUJ/U3mbEpu1/Krf4/eERCqIgz2nmXoGLlOJHgMk4MpK6LA6eb6SXZHLpxFicbEcCxUU3A9hbzhWUGDaMFG7CcExT5JAD/7VcniONxZhlJxUzyL1xmbmAN13DQpiUkew25VtuNHby1fYTgMxVaezUMfMwZn6qpNJUDXGCKX1NWv5kqB9yFxRIQbFS4zAkQPXH6w7eksNyknexRDwM1zghnaspSvE1Kn2RWIaKt5hmaoKozJuC9YnCwJ bblasco@localhost.localdomain"
PUBLIC_KEY2="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAn3neLVv5XnZx8O96hpZ5Kq4BZXkuQ+3GorRrDaKAt65JYXOVvGikGvw2FaSj4CPDukD8ZGhE8JXZJQRKcZdvDSN3ZsySnRQ765eILjCqrMb75sGtqd6ISUCcNxrhz01xaqP+l5hdz5YQN9S+A1BnK0hGYHGhdQMFO69j6YV3NcY0Ody3QL+2apmtTX+x5l9hWTQEQFTyFEhHMqy81bvYzcLwuy1YYJIQwbbbukJiIanGuPof5jNN8bxda4Ud+CUoPiAhBSWgzyzYt2xtnK8CdekvWyh3bqaSF5vo9KPu0sH8+XhIVOO/WHyqlNaLzmDxHTy1Yk6GS9sv7Bwo+Adb tholloway@talorpc"

buildah run ${CONTAINER} dnf install -y openssh-server ed openssh-clients glibc-langpack-en
buildah run ${CONTAINER} dnf clean all
buildah run ${CONTAINER} systemctl enable sshd
buildah run ${CONTAINER} sed -i 's/#Port.*$/Port 2022/' /etc/ssh/sshd_config 
buildah run ${CONTAINER} chmod 775 /var/run 
buildah run ${CONTAINER} rm -f /var/run/nologin
buildah run ${CONTAINER} mkdir /etc/systemd/system/sshd.service.d/
buildah run ${CONTAINER} touch /etc/systemd/system/sshd.service.d/sshd.conf
buildah run ${CONTAINER} bash -c 'echo -e "[Service]\nRestart=always" > /etc/systemd/system/sshd.service.d/sshd.conf'

buildah run ${CONTAINER} adduser --system -s /bin/bash -u 1000 tester
buildah run ${CONTAINER} sed -i 's/1000/0/g' /etc/passwd

buildah run ${CONTAINER} mkdir -p /home/tester/.ssh

#buildah run ${CONTAINER} touch /home/tester/.ssh/authorized_keys
#buildah run ${CONTAINER} bash -c "echo ${ADMIN_PUBLIC_KEY} >> /home/tester/.ssh/authorized_keys"
#buildah run ${CONTAINER} bash -c "echo ${ADMIN_PUBLIC_KEY2} >> /home/tester/.ssh/authorized_keys"

# Section below completed outside of container environment because buildah doesn't handle the combo
# of redirection and variables very well.
# Further reading at Rule 3 below:
# https://fossies.org/linux/buildah/troubleshooting.md

touch /tmp/${CONTAINER}_authorized_keys
echo $PUBLIC_KEY >> /tmp/${CONTAINER}_authorized_keys
echo $PUBLIC_KEY2 >> /tmp/${CONTAINER}_authorized_keys
buildah copy ${CONTAINER} /tmp/${CONTAINER}_authorized_keys /home/tester/.ssh/authorized_keys
rm /tmp/${CONTAINER}_authorized_keys

buildah config --port=2022 ${CONTAINER} 
buildah config --cmd="/sbin/init" ${CONTAINER}  

buildah config --label maintainer="Benjamin Blasco" ${CONTAINER}
buildah config --label description="RHEL UBI 8 container for SSH server" ${CONTAINER}

buildah commit ${CONTAINER} ssh-server-ubi8
