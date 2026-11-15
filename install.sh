#!/usr/bin/env bash
set -euo pipefail

if (( EUID == 0 )); then
    echo 'Run as your normal login user: bash install.sh (it will request sudo).'
    exit 1
fi
if [[ ! -r /etc/os-release ]]; then
    echo 'This installer requires Ubuntu Server 26.04.' >&2
    exit 1
fi
source /etc/os-release
if [[ ${ID:-} != ubuntu || ${VERSION_ID:-} != 26.04 ]]; then
    echo 'This installer targets Ubuntu Server 26.04 only.' >&2
    exit 1
fi
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
for script in bliss-browser session.sh; do
    [[ -r "$source_dir/$script" ]] || { echo "Missing $script" >&2; exit 1; }
done
sudo -v
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y universe
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    xserver-xorg xinit xauth openbox dbus-x11 dbus-user-session libpam-systemd snapd \
    fonts-dejavu-core fonts-noto-color-emoji
sudo systemctl enable --now snapd.socket
sudo snap wait system seed.loaded
if ! snap list firefox >/dev/null 2>&1; then
    sudo snap install firefox --channel=latest/stable
fi
sudo install -d -m 755 /usr/local/lib/bliss-browser
sudo install -m 755 "$source_dir/session.sh" /usr/local/lib/bliss-browser/session.sh
sudo install -m 755 "$source_dir/bliss-browser" /usr/local/bin/bliss-browser
echo 'Installed. Reboot once, log in at the local text console, then run: bliss-browser'
