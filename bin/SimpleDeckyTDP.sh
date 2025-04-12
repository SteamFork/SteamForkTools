#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

SCRIPT_PATH="${SCRIPT_PATH:-$(dirname $(realpath "$0"))}"

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]; then
    DECKY="FALSE"
else
    DECKY="TRUE"
fi

if [ ! -f "${HOME}/homebrew/plugins/SimpleDeckyTDP/package.json" ]; then
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
            echo "SimpleDeckyTDP is already installed."
            exit 0
        fi
        if [ "${DECKY}" = "FALSE" ]; then
            "${SCRIPT_PATH}/Decky Loader.sh" TRUE
        fi
        echo "Installing SimpleDeckyTDP..."
        curl -L https://github.com/aarron-lee/SimpleDeckyTDP/raw/main/install.sh | sh
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "SimpleDeckyTDP is not installed."
            exit 0
        fi
        echo "Uninstalling SimpleDeckyTDP..."
        sudo systemctl stop plugin_loader.service
        sudo rm -rf "${HOME}/homebrew/plugins/SimpleDeckyTDP"
        sudo systemctl start plugin_loader.service
        ;;
esac
