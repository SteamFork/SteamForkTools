#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

# source: https://rasmuskirk.com/articles/2024-12-23_why-nix-is-the-perfect-package-manager-for-your-steam-deck/

if [ ! -f "/nix/nix-installer" ]
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
		curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install steam-deck --no-confirm
		echo "Install Complete."
		;;
	FALSE)
		if [ "${INSTALLED}" = "FALSE" ]
		then
			echo "Nothing to do."
			exit 0
		fi
		/nix/nix-installer uninstall
		echo "Uninstall Complete."
esac
