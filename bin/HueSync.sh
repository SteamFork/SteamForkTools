#!/bin/sh
if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]
then
        echo "Installing: Decky Loader (Prerequisite)"
        curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
fi
curl -L https://raw.githubusercontent.com/honjow/huesync/main/install.sh | sh
