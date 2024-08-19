#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

if [ ! -f "${HOME}/homebrew/services/PluginLoader" ]
then
		DECKY="FALSE"
else
		DECKY="TRUE"
fi

if [ ! -f "${HOME}/homebrew/plugins/SimpleDeckyTDP/package.json" ]
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
	*)
		if [ "${INSTALLED}" = "FALSE" ]
		then
			if [ "${DECKY}" = "FALSE" ]
			then
				${SCRIPT_PATH}/DeckyLoader.sh
			fi
			curl -L https://github.com/SteamFork/SimpleDeckyTDP/raw/main/install.sh | sh
		else
			sudo systemctl stop plugin_loader.service
			sudo rm -rf ${HOME}/homebrew/plugins/SimpleDeckyTDP
			sudo systemctl start plugin_loader.service
		fi
		;;
esac
