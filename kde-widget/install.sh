#!/bin/bash
# Installs the MeteoClock plasmoid and its icon for the current user.
set -e
here="$(cd "$(dirname "$0")" && pwd)"

# The applet icon is looked up in the icon theme, so the app icon has to live in
# hicolor; shipping it inside the package alone is not enough.
for size in 16 22 24 32 48 64 128 256 512; do
    dir="$HOME/.local/share/icons/hicolor/${size}x${size}/apps"
    mkdir -p "$dir"
    cp "$here/package/contents/icons/meteoclock-${size}.png" "$dir/meteoclock.png"
done
command -v xdg-icon-resource >/dev/null && xdg-icon-resource forceupdate --mode user || true

if kpackagetool6 -t Plasma/Applet --list 2>/dev/null | grep -q com.obla.meteoclock; then
    kpackagetool6 -t Plasma/Applet --upgrade "$here/package"
else
    kpackagetool6 -t Plasma/Applet --install "$here/package"
fi
