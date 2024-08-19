#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

case ${1} in
	check)
		echo "FALSE"
		exit 0
		;;
	TRUE)
		rm -rf ${HOME}/.local/state/wireplumber
		echo "Reboot your device when possible."
		;;
esac
