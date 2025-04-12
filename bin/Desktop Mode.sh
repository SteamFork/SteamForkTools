#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source steamfork-devicequirk-set

if [ -f "/etc/steamfork-default-session" ]; then
    ENABLED="TRUE"
else
    ENABLED="FALSE"
fi

case ${1} in
    check)
        echo "${ENABLED}"
        exit 0
        ;;
    TRUE)
        if [ "${ENABLED}" = "TRUE" ]; then
            echo "Desktop Mode: Already enabled, nothing to do."
            exit 0
        fi
        echo "Desktop Mode: Enabling..."
        steamos-session-select plasma-wayland-persistent --no-restart
        echo plasma-wayland-persistent | sudo tee /etc/steamfork-default-session > /dev/null
        echo "Desktop Mode: Enabled."
        ;;
    FALSE)
        if [ "${ENABLED}" = "FALSE" ]; then
            echo "Desktop Mode: Not enabled, nothing to do."
            exit 0
        fi
        echo "Desktop Mode: Disabling..."
        steamos-session-select gamescope --no-restart
        sudo rm -f /etc/steamfork-default-session
        echo "Desktop Mode: Disabled."
        ;;
esac
