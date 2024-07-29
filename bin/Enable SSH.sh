#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

sudo steamos-readonly disable
sudo systemctl enable sshd
sudo systemctl start sshd
sudo steamos-readonly enable
