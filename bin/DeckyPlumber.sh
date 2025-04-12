#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

SCRIPT_PATH="${SCRIPT_PATH:-$(dirname $(realpath "$0"))}"

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]; then
    DECKY="FALSE"
else
    DECKY="TRUE"
fi

if [ ! -f "${HOME}/homebrew/plugins/DeckyPlumber/package.json" ]; then
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
            echo "Decky Plumber is already installed."
            exit 0
        fi
        if [ "${DECKY}" = "FALSE" ]; then
            echo "Installing Decky Loader..."
            "${SCRIPT_PATH}/Decky Loader.sh" TRUE
            if [ $? -ne 0 ]; then
                echo "Failed to install Decky Loader. Exiting."
                exit 1
            fi
        fi
        echo "Installing Decky Plumber..."
        curl -L https://github.com/aarron-lee/DeckyPlumber/raw/main/install.sh | sh
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "Decky Plumber is not installed."
            exit 0
        fi
        echo "Uninstalling Decky Plumber..."
        sudo systemctl stop plugin_loader.service
        sudo rm -rf "${HOME}/homebrew/plugins/DeckyPlumber"
        sudo systemctl start plugin_loader.service
        ;;
esac
