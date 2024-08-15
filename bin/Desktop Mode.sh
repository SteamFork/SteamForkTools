#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source steamfork-devicequirk-set

sudo steamos-readonly disable
sudo steamfork-disable-sessions
cat <<EOF >/etc/sddm.conf.d/001-rotation.conf
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

cat <<EOF >/etc/X11/xorg.conf.d/99-touchscreen_orientation.conf
Section "InputClass"
	Identifier "Coordinate Transformation Matrix"
	MatchIsTouchscreen "on"
	MatchDevicePath "/dev/input/event*"
	MatchDriver "libinput"
	Option "CalibrationMatrix" "${X11_TOUCH}"
EndSection
EOF

sudo steamfork-readonly enable
