# Build an Ansible EE to run the playbooks

### Pre-requisites
1. Podman or Docker installed on the host
2. ansible-navigator and ansible-builder installed on the host

Links:
https://ansible-navigator.readthedocs.io/en/latest/installation/
https://ansible-builder.readthedocs.io/en/stable/installation/

### Instructions

1. Build the environment, named ee_test:v1
```
ansible-builder build -t ee_test:v1
```

2. Run a playbook using that environment
```
ansible-navigator run -m stdout --eei ee_test:v1 <playbook name>.yml -e ansible_become_password=<password>
```
