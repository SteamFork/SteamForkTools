#!/bin/sh
if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]
then
        echo "Installing: Decky Loader (Prerequisite)"
        curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
        sudo sed -i 's~TimeoutStopSec=.*$~TimeoutStopSec=2~g' /etc/systemd/system/plugin_loader.service
        sudo systemctl daemon-reload
fi
curl -L https://github.com/SteamFork/SimpleDeckyTDP/raw/main/install.sh | sh
