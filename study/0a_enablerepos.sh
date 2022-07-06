#!/bin/bash
ansible all -m yum_repository -a "name=ben_repo baseurl=http://example.com/ben_repo description='Ben test repo' gpgcheck=yes gpgkey=http://example.com/ben_repo.gpgkey" -b

#      yum_repository:
#        name: ben_repo
#        state: absent
#        baseurl: http://example.com/ben_repo
#        description: Ben's test repo
#        gpgcheck: yes
#        gpgkey: http://example.com/ben_repo.gpgkey
#      #when: "'webserver' in group_names"
#
