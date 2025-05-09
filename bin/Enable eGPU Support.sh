#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

### Disable PCI advanced error reporting, as is currently required for eGPU support.

DEVICE_ID=$(steamfork-device-id)
QUIRK_PATH="/home/.steamos/offload/customdevicequirks/${DEVICE_ID}"

if [ -e "${QUIRK_PATH}/hardware_quirks.sh" ]; then
    grep 'pci=noaer' "${QUIRK_PATH}/hardware_quirks.sh" >/dev/null 2>&1
    if (( $? > 0 )); then
        INSTALLED="FALSE"
    else
        INSTALLED="TRUE"
    fi
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
            echo "Enable eGPU Support: Already enabled, nothing to do."
            exit 0
        fi
        echo "Enable eGPU Support: Enabling..."
        if [ ! -d "${QUIRK_PATH}" ]; then
            sudo mkdir -p "${QUIRK_PATH}"
        fi
        cat <<EOF | sudo tee -a ${QUIRK_PATH}/hardware_quirks.sh
export STEAMFORK_GRUB_ADDITIONAL_CMDLINEOPTIONS="\${STEAMFORK_GRUB_ADDITIONAL_CMDLINEOPTIONS} pci=noaer"
EOF
        sudo steamos-readonly disable
        sudo steamfork-grub-update
        sudo steamos-readonly enable
        echo "Enable eGPU Support: Enabled. Please reboot when possible."
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "Enable eGPU Support: Not enabled, nothing to do."
            exit 0
        fi
        echo "Enable eGPU Support: Disabling..."
        sudo sed -i '/^.*pci=noaer.*$/d' ${QUIRK_PATH}/hardware_quirks.sh
        sudo steamos-readonly disable
        sudo steamfork-grub-update
        sudo steamos-readonly enable
        echo "Enable eGPU Support: Disabled. Please reboot when possible."
        ;;
esac
