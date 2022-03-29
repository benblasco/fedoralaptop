# Check which version we are running of
# State release date of OS
cat /etc/os-release

# Enable the Ansible repo
# Repo included with RHEL for
# - Ansible System Roles
# - Red Hat Insights
# - Security hardening
# This takes a while to complete
sudo subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms

# Install Ansible and SCAP Security Guide
# SCAP Security Guide helps with
# - Vulnerability Assessment
# - Configuration compliance
# - Includes playbooks for many compliance baselines
sudo dnf install -y ansible scap-security-guide

# Show the list of playbooks available
# Explain SCAP L1 and L2 for workstation and server
cd /usr/share/scap-security-guide/ansible/
ls -la
ls -la rhel8-playbook-cis*

# Run the playbook as root user, connected locally
# Will take several minutes
# Best run centrally from orchestrator, e.g. AAP
sudo ansible-playbook -i "localhost," -c local rhel8-playbook-cis_server_l1.yml
