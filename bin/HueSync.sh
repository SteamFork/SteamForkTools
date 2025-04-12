#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

SCRIPT_PATH="${SCRIPT_PATH:-$(dirname $(realpath "$0"))}"

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]; then
    DECKY="FALSE"
else
    DECKY="TRUE"
fi

if [ ! -f "${HOME}/homebrew/plugins/HueSync/package.json" ]; then
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
            echo "HueSync: Already installed, nothing to do."
            exit 0
        fi
        if [ "${DECKY}" = "FALSE" ]; then
            "${SCRIPT_PATH}/Decky Loader.sh" TRUE
        fi
        echo "HueSync: Installing..."
        curl -L https://raw.githubusercontent.com/honjow/huesync/main/install.sh | sh
        echo "HueSync: Installation completed."
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "HueSync: Not installed, nothing to do."
            exit 0
        fi
        echo "HueSync: Removing..."
        sudo systemctl stop plugin_loader.service
        sudo rm -rf "${HOME}/homebrew/plugins/HueSync"
        sudo systemctl start plugin_loader.service
        echo "HueSync: Removal completed."
        ;;
esac
