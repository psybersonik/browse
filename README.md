# Bliss

A first version of a local Firefox browser environment for Ubuntu Server
26.04 / 26.04.1 amd64. It uses Mozilla's Firefox snap, Xorg, and Openbox.
It does not install a desktop suite or enable automatic login.

## Install on the Ubuntu machine

Finish the normal Ubuntu Server installation, reboot, and sign in using the
machine's connected keyboard and monitor. Internet access and a user with
sudo access are required. Copy this folder onto that machine, using a USB
drive or a file transfer. If using the release archive, copy
`bliss-0.1.2.tar.gz` to your Ubuntu home folder and run:

```bash
tar -xzf bliss-0.1.2.tar.gz
cd bliss-0.1.2
```

From the extracted folder, install and launch:

```bash
bash install.sh
sudo reboot
```

After rebooting, log in at the machine's keyboard and monitor and run
`bliss`. On subsequent runs, no installation or reboot is needed.

Version 0.1.1 fixes Firefox Snap startup by using the systemd login user bus
instead of creating a separate D-Bus session. To update 0.1.0, extract this
archive, rerun its installer, and reboot once. Existing browsing data is kept.

Version 0.1.2 renames the launch command to `bliss`. Rerun the installer from
this version to install the new command on an existing machine.

When cloning the GitHub repository, enter the cloned `bliss` folder and run
`bash install.sh` directly; archive extraction is unnecessary.

The installer downloads Ubuntu packages and Mozilla's Firefox snap. It enables
Ubuntu's Universe repository and the snap service. It can be rerun if a download
fails. Do not run the whole installer or browser with sudo; the installer requests
administrative access only for installation steps.

Optionally open a particular page:

```bash
bliss https://www.mozilla.org
```

## Use

- Ctrl+L: address bar; Ctrl+T: new tab; Ctrl+W: close tab.
- F11: toggle full screen.
- Close every Firefox window, or use Firefox's Quit menu, to end the graphical
  session and return to the terminal. Closing one tab may leave other windows open.
- Bookmarks, history, logins, and settings persist in
  `~/snap/firefox/common/bliss-profile`. Firefox settings control their retention.
- Firefox uses its own normal download preferences. This first version has no
  separate file manager or desktop settings application.

## Troubleshooting and limits

Launch only from the physical machine's text console, not SSH. You can switch
to another console with Ctrl+Alt+F3 and log in there. Do not launch a second
browser session while the first remains active.

The latest session log is `~/.local/state/bliss-browser/session.log` unless you
set XDG_STATE_HOME. If Xorg fails to start, inspect that log and
`~/.local/share/xorg/Xorg.0.log`. Graphics hardware and drivers need to be tested
on your actual machine. Do not disable browser security or run Firefox as root
to work around errors.

Audio, video acceleration, printing, and desktop integrations are not configured
by this initial installer. Firefox and Ubuntu packages receive updates through
their normal update mechanisms; keep both current.

This workspace is macOS: scripts have been checked locally, but the Ubuntu
installation and graphical session have not been tested here.

## Remove the launcher

```bash
sudo rm /usr/local/bin/bliss
sudo rm /usr/local/lib/bliss-browser/session.sh
sudo rmdir /usr/local/lib/bliss-browser
```

This leaves installed packages, Firefox, and saved browsing data in place.

## References

- [Ubuntu 26.04.1 installation images](https://releases.ubuntu.com/26.04/)
- [Mozilla Firefox installation on Linux](https://support.mozilla.org/en-US/kb/install-firefox-linux)
- [Mozilla's Firefox snap](https://snapcraft.io/firefox)
- [Firefox command line parameters](https://firefox-source-docs.mozilla.org/browser/CommandLineParameters.html)
