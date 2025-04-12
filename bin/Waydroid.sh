#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

if [ -f "/usr/lib/systemd/system/waydroid-container.service" ]; then
    INSTALLED="TRUE"
else
    INSTALLED="FALSE"
fi

case ${1} in
    check)
        echo "${INSTALLED}"
        exit 0
        ;;
    TRUE)
        if [ "${INSTALLED}" = "TRUE" ]; then
            echo "Waydroid: Already installed, nothing to do."
            exit 0
        fi
        echo "Waydroid: Installing..."
        git clone https://github.com/SteamFork/steamos-waydroid-installer
        cd steamos-waydroid-installer
        chmod 0755 installer.sh
        ./installer.sh
        cd ..
        rm -rf steamos-waydroid-installer
        echo "Waydroid: Installation completed."
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "Waydroid: Not installed, nothing to do."
            exit 0
        fi
        echo "Waydroid: Uninstalling..."
        zenity --info --text="Waydroid: Please uninstall Waydroid using Waydroid Toolbox."
        ;;
esac
