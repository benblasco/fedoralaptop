#!/bin/bash
ansible -i hosts webserver -m yum_repository -a "name=ben_repo baseurl=http://example.com/ben_repo gpgcheck=yes gpgkey=http://example.com/ben_repo.gpgkey description='Bens test repo'" -b

#
#   yum_repository:
#      name: ben_repo
#      baseurl: http://example.com/ben_repo
#      description: Ben test repo
#      gpgcheck: yes
#      gpgkey: http://example.com/ben_repo.gpgkey
#    when: "'webserver' in group_names"
#
