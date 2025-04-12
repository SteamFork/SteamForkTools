#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

# Inspired by https://github.com/pdx-rico/hogwarts-steamdeck-fix/blob/main/grub_update.sh

if grep -q "clearcpuid=514" /etc/default/grub; then
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
            echo "ClearCPUID: Already enabled, nothing to do."
            exit 0
        fi
        echo "ClearCPUID: Enabling..."
        sudo steamos-readonly disable
        sudo sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 clearcpuid=514"/' /etc/default/grub
        steamfork-grub-update
        sudo steamos-readonly enable
        echo "ClearCPUID: Enabled. Please reboot when possible."
        ;;
    FALSE)
        if [ "${ENABLED}" = "FALSE" ]; then
            echo "ClearCPUID: Not enabled, nothing to do."
            exit 0
        fi
        echo "ClearCPUID: Disabling..."
        sudo steamos-readonly disable
        sudo sed -i 's~ clearcpuid=514~~g' /etc/default/grub
        steamfork-grub-update
        sudo steamos-readonly enable
        echo "ClearCPUID: Disabled. Please reboot when possible."
        ;;
esac
