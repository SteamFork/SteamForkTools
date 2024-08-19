#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]
then
	INSTALLED="FALSE"
else
	INSTALLED="TRUE"
fi

case ${1} in
	check)
		echo ${INSTALLED}
		exit 0
		;;
	*)
		if [ "${INSTALLED}" = "FALSE" ]
		then
			echo "Installing: Decky Loader"
			curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh
		fi
		### Fix the decky plugin loader service sighup timeout that's slowing shutdown significantly.
		sudo sed -i 's~TimeoutStopSec=.*$~TimeoutStopSec=2~g' /etc/systemd/system/plugin_loader.service
		sudo systemctl daemon-reload
		;;
esac
