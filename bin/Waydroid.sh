#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

git clone https://github.com/SteamFork/steamos-waydroid-installer
cd steamos-waydroid-installer
chmod 0755 installer.sh
./installer.sh
cd ..
rm -rf steamos-waydroid-installer
