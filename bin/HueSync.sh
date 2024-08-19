#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]
then
		DECKY="FALSE"
else
		DECKY="TRUE"
fi

if [ ! -f "${HOME}/homebrew/plugins/HueSync/package.json" ]
then
	INSTALLED="FALSE"
else
	INSTALLED="TRUE"
fi

case ${1} in
	check)
		echo "${INSTALLED}"
		exit 0
		;;
	TRUE)
		if [ "${INSTALLED}" = "TRUE" ]
		then
			echo "Already installed."
			exit 0
		fi
		if [ "${DECKY}" = "FALSE" ]
		then
			${SCRIPT_PATH}/"Decky Loader.sh"
		fi
		curl -L https://raw.githubusercontent.com/honjow/huesync/main/install.sh | sh
		;;
	FALSE)

		if [ "${INSTALLED}" = "FALSE" ]
		then
			echo "Nothing to do."
			exit 0
		fi
		sudo systemctl stop plugin_loader.service
		sudo rm -rf ${HOME}/homebrew/plugins/huesync
		sudo systemctl start plugin_loader.service
		;;
esac
