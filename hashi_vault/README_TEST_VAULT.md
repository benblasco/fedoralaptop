# Run Hashicorp vault in a container (using podman rootlessly)

## Introduction

The instructions below show you how to test pulling a secret from Hashicorp vault via an Ansible playbook

## Reference instructions used to help create this example solution

[Your First Secret](https://learn.hashicorp.com/tutorials/vault/getting-started-first-secret)

## Adding your secret to Vault via the GUI

1. Navigate to the Vault URL: e.g. http://192.168.1.3:8200
2. Sign in using your root token
3. Navigate to the "secret" Secrets Engine (key/value secret storage)
4. Create a new secret, e.g. Path = mynewsecret, Key = mynewsecret, Value = 5up3R53cr3t! 

## How to test retrieval of secrets from Vault with an Ansible playbook

### Edit your Ansible variables to add the Vault login parameters

1. Open the Ansible playbook variables file `vault_vars.yml` with your favourite editor, e.g. vim
2. Update the following variables to match your configuration, e.g.
```
vault_ip: "192.168.1.6"
vault_port: "8200"
vault_token: "hvs.VqkfOJJxq81T733Vqh2Gw2Vl"
secret_path: "secret/data/mynewsecret"
```

3. Save and quit

4. If required, edit the playbook itself to refer to the correct host that will contact Vault, e.g.
```
- hosts: localhost
```


### Test your playbook

1. Run the playbook using the following syntax:

```
ansible-playbook test_vault_ansible.yml --ask-become-pass
```
Note: The playbook requires root priveleges to ensure the HashiCorp Vault API client for Python 3 is installed.

2. The output will look something like:
```
[bblasco@micro hashi_vault]$ ansible-playbook test_vault_ansible.yml --ask-become-pass
BECOME password: 
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match
'all'

PLAY [Learning all about hashicorp vault] *******************************************************************************

TASK [Ensure the HashiCorp Vault API client for Python 3 is installed] **************************************************
ok: [localhost]

TASK [Grab a secret from the vault] *************************************************************************************
[DEPRECATION WARNING]: The default value for 'token_validate' will change from True to False.. This feature will be 
removed in version 4.0.0. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [localhost] => {
    "msg": {
        "mynewsecret": "5up3R53cr3t!"
    }
}
```

