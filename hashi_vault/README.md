# Run Hashicorp vault in a container (using podman rootlessly)

## Introduction

This repo shows you how to spin up Hashicorp vault in a container using podman in rootless mode

## Reference instructions used to create this solution

[Vault at Docker Hub](https://hub.docker.com/_/vault)

## Assumed Knowledge

- Linux
- Containers 
- Podman (or Docker)

## Running the container in DEVELOPER MODE aka the easy way

The example below has been tested on Fedora Server 35 and 36

The command below runs vault in a container, and is rootless if you run it as an unprivileged user.
It will:
- Run Vault in "developer" mode rather than "server" mode
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
  -e 'VAULT_LOCAL_CONFIG={"backend": {"file": {"path": "/vault/file"}}, "default_lease_ttl": "168h", "max_lease_ttl": "720h"}' \
  --tz=local \
  docker.io/hashicorp/vault:latest
```

Check the container is running:
```
podman ps -a
```

Grab the "Unseal Key" and the "Root Token" with the command below:
```
podman logs vault
```

The tail end of the output will contain something like:
```
WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.

You may need to set the following environment variable:

    $ export VAULT_ADDR='http://0.0.0.0:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: 3eflbtWypVzEgErCdJcKkY/6o9Jdnw3fp7Dk0dpTwC0=
Root Token: hvs.6uLmQoIEdRa54DqXEGXYcEGn

Development mode should NOT be used in production installations!
```

## Open the firewall ports on the container host

You then need to allow port 8200 in the firewall of your host, e.g.
```
firewall-cmd --zone=FedoraServer --add-port=8200/tcp
```

## Open the Vault UI

Access the Vault UI via your browser at:

[http://<IP of container host>:8200](http://<IP of container host>:8200)

Use the Root Token to log in

## Add some keys

Follow the instructions at: 

[Tutorial: Your First Secret](https://learn.hashicorp.com/tutorials/vault/getting-started-first-secret)

## Alternative method: Running the container in SERVER MODE aka the hard way

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

To unseal the vault and get all the relevant tokens you need to jump into the container:
```
podman exec -it vault /bin/sh
```

Once in the container, run the following to initialise the vault
```
export VAULT_ADDR='http://0.0.0.0:8200'
vault operator init
```
The output will look like
```
/ #  export VAULT_ADDR='http://0.0.0.0:8200'                                                                             
/ # vault operator init                                                                                                  
Unseal Key 1: NpEhugU3rvB+gRuJ+3X3uhnH2d5IFi8VcNjCT6PaEZpG                                                               
Unseal Key 2: bS0zUKgV1iQYfe5yoR3JkUEzqZluTutbD9hGrTyHiYto                                                               
Unseal Key 3: bZqXwZ6vq2RudORgIrVhZIylXaAsULlnSMswHQySS+hc                                                               
Unseal Key 4: N18C3OfjGUeVp32dEVEOxLwiiXccW5keTW8NUOiY7CBV                                                               
Unseal Key 5: RCeFup10Dr6kgxjORdqfGh7QsiL1LuZT5m0J9DTwhZ2o                                                               
                                                                                                                         
Initial Root Token: hvs.VCOxpbGGQ9227uxqLKbkLuw4                                                                         
                                                                                                                         
Vault initialized with 5 key shares and a key threshold of 3. Please securely                                            
distribute the key shares printed above. When the Vault is re-sealed,                                                    
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 3 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

Now unseal the vault from within the container:
```
vault operator unseal NpEhugU3rvB+gRuJ+3X3uhnH2d5IFi8VcNjCT6PaEZpG
vault operator unseal bS0zUKgV1iQYfe5yoR3JkUEzqZluTutbD9hGrTyHiYto
vault operator unseal bZqXwZ6vq2RudORgIrVhZIylXaAsULlnSMswHQySS+hc
```

After passing the third key, the vault should show as unsealed as per:
```
/ # vault operator unseal RCeFup10Dr6kgxjORdqfGh7QsiL1LuZT5m0J9DTwhZ2o
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.11.2
Build Date      2022-07-29T09:48:47Z
Storage Type    file
Cluster Name    vault-cluster-f64ce007                                                                                   
Cluster ID      6b717a66-6d4c-6cb5-9052-721210b48f8f                                                                     
HA Enabled      false                                                               
```



