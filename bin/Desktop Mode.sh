#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source steamfork-devicequirk-set

if [ -f "/etc/X11/xorg.conf.d/99-touchscreen_orientation.conf" ]
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
                if [ "${INSTALLED}" = "TRUE" ]
		then
			echo "Already installed."
			exit 0
                fi
		sudo steamos-readonly disable
		sudo steamfork-disable-sessions
		cat <<EOF | sudo tee /etc/sddm.conf.d/001-rotation.conf
[XDisplay]
DisplayCommand=/etc/X11/Xsession.d/999rotate-screen
EOF

			case ${X11_ROTATION} in
				left)
					X11_TOUCH="0 -1 1 1 0 0 0 0 1"
					;;
				right)
					X11_TOUCH="0 1 0 -1 0 1 0 0 1"
					;;
				normal)
					X11_TOUCH="1 0 0 0 1 0 0 0 1"
					;;
				inverted)
					X11_TOUCH="-1 0 1 0 -1 1 0 0 1"
					;;
			esac

		cat <<EOF | sudo tee /etc/X11/xorg.conf.d/99-touchscreen_orientation.conf
Section "InputClass"
	Identifier "Coordinate Transformation Matrix"
	MatchIsTouchscreen "on"
	MatchDevicePath "/dev/input/event*"
	MatchDriver "libinput"
	Option "CalibrationMatrix" "${X11_TOUCH}"
EndSection
EOF
		sudo steamos-readonly enable
			;;
		FALSE)
			source steamfork-devicequirk-set
			sudo steamos-readonly disable
			sudo steamfork-enable-sessions
			sudo rm -f /etc/sddm.conf.d/001-rotation.conf 2>/dev/null
			sudo rm -f /etc/X11/xorg.conf.d/99-touchscreen_orientation.conf 2>/dev/null

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
		fi
		sudo steamos-readonly enable
		;;
esac
