#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

HAVE_DRIVER=$(pacman -Q xone-dkms 2>/dev/null)

if [ -z "${HAVE_DRIVER}" ]; then
    INSTALLED="FALSE"
else
    INSTALLED="TRUE"
fi

if [ ! -d "/etc/post-update.d" ]; then
    sudo mkdir -p /etc/post-update.d
fi

case ${1} in
    check)
        echo "${INSTALLED}"
        exit 0
        ;;
    TRUE)
        if [ "${INSTALLED}" = "TRUE" ]; then
            echo "Xone Driver: Already installed, nothing to do."
            exit 0
        fi
        echo "Xone Driver: Installing..."
        cat <<EOF | sudo tee /etc/post-update.d/0010-install-xone-driver.sh
#!/bin/sh
sudo steamos-readonly disable
sudo pacman -Sy --noconfirm xone-dkms xone-dongle-firmware
sudo steamos-readonly enable
EOF
        sudo chmod 0755 /etc/post-update.d/0010-install-xone-driver.sh
        /etc/post-update.d/0010-install-xone-driver.sh
        echo "Xone Driver: Installation completed."
        ;;
    FALSE)
        if [ "${INSTALLED}" = "FALSE" ]; then
            echo "Xone Driver: Not installed, nothing to do."
            exit 0
        fi
        echo "Xone Driver: Removing..."
        sudo steamos-readonly disable
        sudo pacman -R --noconfirm xone-dkms xone-dongle-firmware
        sudo rm -f /etc/post-update.d/0010-install-xone-driver.sh
        sudo steamos-readonly enable
        echo "Xone Driver: Removal completed."
        ;;
esac
