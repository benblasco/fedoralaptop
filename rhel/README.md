# Build an Ansible EE to run the playbooks

## Pre-requisites
1. Podman or Docker installed on the host
2. Ansible Navigator and Ansible Builder installed on the host

### Installation Links:
- [Install ansible navigator](https://ansible-navigator.readthedocs.io/en/latest/installation/)
- [Install ansible builder](https://ansible-builder.readthedocs.io/en/stable/installation/)

## Instructions

1. Build the environment, named ee_test:v1
```
ansible-builder build -t ee_test:v1
```

2. Run a playbook using that environment
```
ansible-navigator run -m stdout --eei ee_test:v1 <playbook name>.yml -e ansible_become_password=<password>
```

A more complex example for running the same playbook
```
ansible-navigator run -m stdout --eei ee_test:v1 <playbook name>.yml --vault-password-file secret.txt --limit="rhel86*"
```
