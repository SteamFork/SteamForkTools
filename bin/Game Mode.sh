#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source steamfork-devicequirk-set

sudo steamos-readonly disable
sudo steamfork-enable-sessions
rm -f /etc/sddm.conf.d/001-rotation.conf
rm -f /etc/X11/xorg.conf.d/99-touchscreen_orientation.conf
sudo steamos-readonly enable
