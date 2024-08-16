#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source steamfork-devicequirk-set

sudo steamos-readonly disable
sudo steamfork-enable-sessions
sudo rm -f /etc/sddm.conf.d/001-rotation.conf
sudo rm -f /etc/X11/xorg.conf.d/99-touchscreen_orientation.conf

cat <<EOF | sudo tee /etc/sddm.conf.d/autologin.conf
[General]
DisplayServer=wayland

[Autologin]
User=deck
Session=gamescope-wayland.desktop
Relogin=true

[X11]
# Janky workaround for wayland sessions not stopping in sddm, kills
# all active sddm-helper sessions on teardown
DisplayStopCommand=/usr/bin/gamescope-wayland-teardown-workaround
EOF

sudo steamos-readonly enable
