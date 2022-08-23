# Run Hashicorp vault in a container (using podman rootlessly)

## Introduction

This repo shows you how to spin up Hashicorp vault in a container using podman in rootless mode

## Assumed Knowledge

- Linux
- Containers 
- Podman

## Running the container

The example below has been tested on Fedora Server 35 and 36

The command below runs vault in a container, and is rootless if you run it as an unprivileged user.
It will:
- Run Vault in "server" mode rather than "developer" mode
- Create two volumes, vault-logs and vault-file, so your data is persistent
- Expose the UI on port 8200
- Disable TLS (for simplicity), which is bad for security

```
podman run \
  --name vault \
  --rm \
  --detach \
  --publish 8200:8200 \
  --volume vault-logs:/vault/logs \
  --volume vault-file:/vault/file \
  -e 'VAULT_LOCAL_CONFIG={"backend": {"file": {"path": "/vault/file"}}, "default_lease_ttl": "168h", "max_lease_ttl": "720h", "disable_mlock": "true", "listener": {"tcp": {"address": "0.0.0.0:8200", "tls_disable": "1" }}, "ui": "true"}' \
  --tz=local \
  docker.io/hashicorp/vault:latest server
```

You then need to allow port 8200 in the firewall of your host, e.g.
```
firewall-cmd --zone=FedoraServer --add-port=8200/tcp
```

Access the Vault UI via your browser at:
http://<IP of container host>:8200/



