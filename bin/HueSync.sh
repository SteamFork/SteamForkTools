#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]
then
        ${SCRIPT_PATH}/DeckyLoader.sh
fi

curl -L https://raw.githubusercontent.com/honjow/huesync/main/install.sh | sh
