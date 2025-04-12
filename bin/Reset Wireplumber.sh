#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

case ${1} in
	check)
		echo "FALSE"
		exit 0
		;;
	TRUE)
		echo "Reset Wireplumber: Resetting Wireplumber state..."
		rm -rf ${HOME}/.local/state/wireplumber
		echo "Reset Wireplumber: Reset completed. Please reboot your device when possible."
		;;
esac
