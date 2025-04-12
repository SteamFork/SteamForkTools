#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source steamfork-devicequirk-set

if [ -f "/etc/steamfork-default-session" ]
then
	ENABLED="TRUE"
else
	ENABLED="FALSE"
fi

case ${1} in
	check)
		echo "${ENABLED}"
		exit 0
		;;
	TRUE)
		if [ "${ENABLED}" = "TRUE" ]
		then
			echo "Already installed."
			exit 0
		fi
    steamos-session-select plasma-wayland-persistent
    echo plasma-wayland-persistent | sudo tee /etc/steamfork-default-session > /dev/null
		;;
  FALSE)
    steamos-session-select gamescope
    ;;
esac
