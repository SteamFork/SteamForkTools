#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

if [ "$(systemctl is-enabled sshd)" = "enabled" ]; then
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
            echo "Enable SSH: Already enabled, nothing to do."
            exit 0
        fi
        echo "Enable SSH: Enabling..."
        sudo systemctl enable sshd
        sudo systemctl start sshd
        echo "Enable SSH: Enabled."
        ;;
    FALSE)
        if [ "${ENABLED}" = "FALSE" ]; then
            echo "Enable SSH: Not enabled, nothing to do."
            exit 0
        fi
        echo "Enable SSH: Disabling..."
        sudo systemctl stop sshd
        sudo systemctl disable sshd
        echo "Enable SSH: Disabled."
        ;;
esac
