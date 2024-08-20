#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

case ${1} in
	check)
		echo "FALSE"
		exit 0
		;;
	TRUE)
		sudo steamos-readonly disable
		sudo pacman -Syu --no-confirm
		sudo steamos-readonly enable
		echo "Please reboot when possible."
		;;
esac
