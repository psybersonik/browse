#!/usr/bin/env bash
set -euo pipefail

# Snap needs the login user's systemd bus, not a separate dbus-run-session bus.
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
if [[ ! -d $XDG_RUNTIME_DIR || ! -O $XDG_RUNTIME_DIR ]]; then
    echo 'No user runtime directory. Reboot and log in at the local console.' >&2
    exit 1
fi
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
if ! systemctl --user start dbus.socket; then
    echo 'User session unavailable. Install dbus-user-session, reboot, and log in again.' >&2
    exit 1
fi
systemctl --user show-environment >/dev/null
export MOZ_ENABLE_WAYLAND=0
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=Openbox
dbus-update-activation-environment --systemd \
    DISPLAY XAUTHORITY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP MOZ_ENABLE_WAYLAND
# Keep the profile inside the Firefox snap's writable persistent storage.
profile_dir=$HOME/snap/firefox/common/bliss-profile
mkdir -p -- "$profile_dir"
chmod 700 "$profile_dir"
openbox &
wm_pid=$!
cleanup() {
    kill "$wm_pid" 2>/dev/null || true
    wait "$wm_pid" 2>/dev/null || true
}
trap cleanup EXIT
/snap/bin/firefox --no-remote --profile "$profile_dir" "$@"
