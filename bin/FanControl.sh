#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

SCRIPT_PATH="${SCRIPT_PATH:-$(dirname $(realpath "$0"))}"

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]; then
    DECKY="FALSE"
else
    DECKY="TRUE"
fi

if [ ! -f "${HOME}/homebrew/plugins/FanControl/package.json" ]; then
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
            echo "FanControl: Already installed, nothing to do."
            exit 0
        fi
        if [ "${DECKY}" = "FALSE" ]; then
            echo "FanControl: Installing Decky Loader..."
            "${SCRIPT_PATH}/Decky Loader.sh" TRUE
        fi
        echo "FanControl: Installing..."
        curl -L https://github.com/SteamFork/FanControl/raw/main/install.sh | sh
        echo "FanControl: Disabling built-in fan management."
        sudo systemctl stop steamfork-fancontrol
        sudo systemctl disable steamfork-fancontrol
        echo "FanControl: Installation completed."
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "FanControl: Not installed, nothing to do."
            exit 0
        fi
        echo "FanControl: Removing..."
        sudo systemctl stop plugin_loader.service
        sudo rm -rf "${HOME}/homebrew/plugins/FanControl"
        sudo systemctl start plugin_loader.service
        echo "FanControl: Removal completed."
        ;;
esac
