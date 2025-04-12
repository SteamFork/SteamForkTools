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
            echo "SimpleDeckyTDP: Already installed, nothing to do."
            exit 0
        fi
        if [ "${DECKY}" = "FALSE" ]; then
            "${SCRIPT_PATH}/Decky Loader.sh" TRUE
        fi
        echo "SimpleDeckyTDP: Installing..."
        curl -L https://github.com/aarron-lee/SimpleDeckyTDP/raw/main/install.sh | sh
        echo "SimpleDeckyTDP: Installation completed."
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "SimpleDeckyTDP: Not installed, nothing to do."
            exit 0
        fi
        echo "SimpleDeckyTDP: Removing..."
        sudo systemctl stop plugin_loader.service
        sudo rm -rf "${HOME}/homebrew/plugins/SimpleDeckyTDP"
        sudo systemctl start plugin_loader.service
        echo "SimpleDeckyTDP: Removal completed."
        ;;
esac
