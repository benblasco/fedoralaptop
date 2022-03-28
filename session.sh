cat /etc/os-release
sudo subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
sudo dnf install -y ansible scap-security-guide
cd /usr/share/scap-security-guide/ansible/
ls -la
ls -la rhel8-playbook-cis*
sudo ansible-playbook -i "localhost," -c local rhel8-playbook-cis_server_l1.yml
