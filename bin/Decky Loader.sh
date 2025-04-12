#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]; then
    INSTALLED="FALSE"
else
    INSTALLED="TRUE"
fi

case ${1} in
    check)
        echo "${INSTALLED}"
        exit 0
        ;;
    TRUE)
        if [ "${INSTALLED}" = "TRUE" ]; then
            echo "Decky Loader: Already installed, nothing to do."
            exit 0
        fi
        echo "Decky Loader: Installing..."
        curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
        sudo sed -i 's~TimeoutStopSec=.*$~TimeoutStopSec=2~g' /etc/systemd/system/plugin_loader.service
        sudo systemctl daemon-reload
        sudo systemctl restart plugin_loader.service
        echo "Decky Loader: Installation completed."
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "Decky Loader: Not installed, nothing to do."
            exit 0
        fi
        echo "Decky Loader: Removing..."
        sudo systemctl stop plugin_loader.service
        sudo rm -rf "${HOME}/homebrew"
        echo "Decky Loader: Removal completed."
        ;;
esac
