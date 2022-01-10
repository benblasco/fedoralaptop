# PREREQUISITES OLD MACHINE

- Backup your Calibre book library following instructions at:
    https://blog.calibre-ebook.com/how-to-backup-move-and-export-your-library-in-calibre/
- Complete a backup of the user's entire home directory
    Note: refer to files under ~/rsync/ for reference
- Firefox
    - Backup the configuration of "auto tab discard" firefox extension
    - Backup the configuration of "FoxyProxy" firefox extension
      Note: This is checked into github under files/foxyproxy
    - Backup bookmarks and settings using Firefox Sync
- Synchronise Joplin Notes
- Synchronise your Gnome Extensions with Extensions Sync at https://extensions.gnome.org/extension/1486/extensions-sync/
- Check for new versions of any downloaded packages e.g. bluejeans, vpn clients etc.
- Update this playbook with all of the above wherever possible, and check it in

# PREREQUISITES NEW BUILD

- Install Ansible and git:
```
sudo dnf install ansible git
```

Restore your home directory from the remote source via rsync

# USAGE/EXECUTION AND UPDATES

- Add the SSH key for this machine in Github (probably not needed if reusing SSH key)
    https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
    https://github.com/settings/keys

```
git clone https://github.com/benblasco/fedoralaptop.git
cd fedoralaptop
ansible-playbook -i hosts laptop.yml --ask-become-pass --ask-vault-pass --tags=ssh
ansible-playbook -i hosts laptop.yml --ask-become-pass --ask-vault-pass --tags=cubox
ansible-playbook -i hosts laptop.yml --ask-become-pass --ask-vault-pass --check 
ansible-playbook -i hosts laptop.yml --ask-become-pass --ask-vault-pass
```

- Change the remote URL so you can use your SSH key
    https://docs.github.com/en/free-pro-team@latest/github/using-git/changing-a-remotes-url#switching-remote-urls-from-https-to-ssh

```
git remote set-url origin git@github.com:benblasco/fedoralaptop.git
```

# TASKS TO ADD TO THIS PLAYBOOK

Mouse
- [x] Switch mouse to left handed
- [x] Set mouse speed to maximum
- [ ] Keep track pad right handed

Time
- [x] Enable automatic time zone

Displays
- [x] Enable night light

Nautilus File Manager
- [x] Sort folders before files
- [x] Show action to permanently delete files and folders
- [x] Switch view to list style
- [x] Arrange by file type
- [x] Allow you to free type another path into the title bar

Power management
- [ ] Via Gnome Tweaks, ensure closing lid does not put laptop to sleep
- [x] Blank screen and lock after 15 minutes, rather than 5 (idle delay?)

Install Gnome extensions Sync:
- https://github.com/oae/gnome-shell-extensions-sync
- Configure the correct Github gist/token (check Joplin Notes)
- Click to download the extensions
- Reboot or log off to restart Gnome

How to open Gnome looking glass
- Alt+F2
- Then type "lg"

Install GMail addons for Chrome/Firefox
- Trello
- Others?

Restore bookmarks and settings using Firefox Sync
Install Firefox extensions
- Firstly, login and sync.  It should download the extensions for you
- Open the Multi Account Containers extension and allow it to sync
- Restore the list of auto tab discard exceptions (auto-tab-discard-preferences.json)
- Restore the FoxyProxy configuration
- Log in to your Pocket account

Configure Firefox Hardware Acceleration:
- https://www.reddit.com/r/firefox/comments/r5wilh/the_road_to_vaapi_on_linux_by_default_looks/
- https://mastransky.wordpress.com/2020/06/03/firefox-on-fedora-finally-gets-va-api-on-wayland/

Disable ctrl-q shortcut in Firefox as per https://superuser.com/questions/1318336/how-to-disable-ctrlq-shortcut-in-firefox-on-linux
about:config
browser.sessionstore.warnOnQuit true
browser.warnOnQuit true

Configure Joplin Notes
- File -> Synchronise: Tell it to use Dropbox and authenticate it
- Change the default date format (Tools -> Options)
- Switch default editor to vi mode (Tools -> Options -> General -> Show Advanced Settings -> Keyboard Mode: Vim)

Configure Evernote (NixNote2)
- Tools -> Sync, then log in to your account

# QUESTIONS/UPDATES REQUIRED

Try IDM integration as per:
https://mojo.redhat.com/docs/DOC-1199178
(See Engineering Server - non-fresh RHEL 7, non-fresh RHEL 8 or RHEL 5 or 6)

NOTES ON SOME OF THE TASKS COMPLETED

MANUAL TASKS THAT MAY NOT BE POSSIBLE TO AUTOMATE

- Change display position of second screen relative to laptop screen

Configure SpiderOak backups
https://redhat.service-now.com/help?id=kb_article&sys_id=c09f0e372b66b8004c71dc0e59da15ff
https://redhat.service-now.com/help?id=kb_article&sysparm_article=KB0000771
http://hdn.corp.redhat.com/rhel7-csb-stage/repoview/SpiderOakGroups.html

Connect to Wifi
https://redhat.service-now.com/help?id=kb_article&sysparm_article=KB0001616
or just grab the files for the SSIDs you want from /etc/sysconfig/network-scripts/
```
[bblasco@bblasco_fedora cloudfedora30]$ nmcli conn show --order type
NAME                UUID                                  TYPE      DEVICE
...
Red Hat Guest       0ccfd13b-5920-4fda-924d-059d0178993c  wifi      --
WiFi-6FE7           26e5b1fc-3171-4964-be2a-5fc283c1db28  wifi      --
eraser215           27e8eeb8-46b9-4cc6-8acd-a139711e2fa2  wifi      --
WiFi-6FE7-5G        3b94cd43-0f68-485b-a220-2d6fb657c54a  wifi      --
TelstraC083AB       5d30249a-c8a9-44bf-9763-8f087339cf99  wifi      --
Red Hat             916403a9-1bd7-4386-b1d9-7034396dac40  wifi      wlp4s0
Yarra               931b30d6-330d-440e-82e0-b7be4c5e731d  wifi      --
eraser215op6        a8598908-f3d3-45e0-ad29-df92c6ed2558  wifi      --
```
