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
ansible-playbook -i hosts laptop.yml --ask-become-pass --vault-id @prompt --tags=ssh
ansible-playbook -i hosts laptop.yml --ask-become-pass --vault-id @prompt --tags=cubox
ansible-playbook -i hosts laptop.yml --ask-become-pass --vault-id @prompt --check 
# ansible-playbook -i hosts laptop.yml --ask-become-pass --vault-id @prompt --skip-tags=wifi
```

- Change the remote URL so you can use your SSH key
    https://docs.github.com/en/free-pro-team@latest/github/using-git/changing-a-remotes-url#switching-remote-urls-from-https-to-ssh

```
git remote set-url origin git@github.com:benblasco/fedoralaptop.git
```

# POST INSTALL TASKS

Mouse
- [x] Switch mouse to left handed
- [x] Set mouse speed to maximum
- [ ] Keep track pad right handed

Time
- [x] Enable automatic time zone

Displays
- [ ] Orient the screens correctly
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

Restore bookmarks and settings using Firefox Sync
Install Firefox extensions
- Firstly, login and sync.  It should download the extensions for you
- Open the Multi Account Containers extension and allow it to sync
- Restore the list of auto tab discard exceptions (auto-tab-discard-preferences.json)
- Restore the FoxyProxy configuration
- Log in to your Pocket account
- Click on the extensions icon to show the list of extensions, and then right click on an extension to select "pin to toolbar"
    - https://www.reddit.com/r/firefox/comments/10f8ohq/how_to_bring_back_addon_icons_to_toolbar_after/

Configure Firefox Hardware Acceleration (which should already be done out of the box nowadays):
- https://fedoraproject.org/wiki/Firefox_Hardware_acceleration

Disable ctrl-q shortcut in Firefox as per https://superuser.com/questions/1318336/how-to-disable-ctrlq-shortcut-in-firefox-on-linux
1. Go to about:config
2. Set `browser.warnOnQuit true`
3. Set `browser.warnOnQuitShortcut true`
Note: These appear to be enabled by default now probably due to Firefox sync

Install Gnome extensions Sync:
- https://github.com/oae/gnome-shell-extensions-sync
- Configure the correct Github gist/token (see Joplin Notes or encrypted roles/workstation/vars/gnome_extensions_sync_gist.yml)
- Click to download the extensions
- Reboot or log off to restart Gnome

How to open Gnome looking glass
- Alt+F2
- Then type "lg"

Configure Joplin Notes
- File -> Synchronise: Tell it to use Dropbox and authenticate it
- Change the default date format (Tools -> Options)
- Switch default editor to vi mode (Tools -> Options -> General -> Show Advanced Settings -> Keyboard Mode: Vim)

Configure Dropbox
- Run Dropbox and follow the prompts
- Disable annoying notifications via the following commands as regular user:
    - https://discourse.joplinapp.org/t/joplin-i-love-you-but-this-is-driving-me-nuts-dropbox/10842/13
    - https://help.dropbox.com/sync/ignored-files
    ```
    $ attr -s com.dropbox.ignore -V 1 /home/bblasco/Dropbox/Apps/Joplin/.sync/
    $ attr -s com.dropbox.ignore -V 1 /home/bblasco/Dropbox/Apps/Joplin/locks/
    ```
    - Also note that accessing the dropbox GUI depends on legacy tray icon support in Gnome:
    https://extensions.gnome.org/extension/615/appindicator-support/

Grab your VSCode extensions and settings
- https://code.visualstudio.com/docs/editor/settings-sync

Install and restore Calibre E-Book library
- https://calibre-ebook.com/download_linux
- https://manual.calibre-ebook.com/faq.html#how-do-i-move-my-calibre-data-from-one-computer-to-another

Configure the APAC SecurePrint printer (while on the VPN)
```
lpadmin -p APAC_SecurePrint -E -v ipp://aws-rps01.win.redhat.com:631/ipp/print/APAC_SecurePrint_IPP -m everywhere
```
