#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

WORK_DIR="$(dirname $(realpath "${0}"))"
SOURCE_FILE="${WORK_DIR}/SteamForkTools/data/tools.index"
SCRIPT_PATH="${WORK_DIR}/SteamForkTools/bin"

if [ ! -d "${WORK_DIR}/SteamForkTools" ]
then
	echo "Cloning repository..."
	git clone https://github.com/SteamFork/SteamForkTools.git
fi

declare -a allTools=()
while read TOOLS
do
	TOOL="${TOOLS%|*}"
	DESCRIPTION="${TOOLS#*|}"
	echo "Found tool: "${TOOL}"..."
	allTools+=("FALSE" "${TOOL}" "${DESCRIPTION}")
done < ${SOURCE_FILE}

echo "[${allTools[@]}]"

HELPERS=$( zenity --title "Software Installation Tool" \
	--list \
	--checklist \
	--height=600 \
	--width=350 \
	--text="Please choose the components that you would like to install." \
	--column="Selection" \
	--column="Component" \
	--column="Description" \
	"${allTools[@]}")

declare arrSelected=()
IFS='|' read -r -a arrSelected <<< ${HELPERS}
for ITEM in "${arrSelected[@]}"
do
	echo "Install: ${ITEM}"
	if [ -e "${SCRIPT_PATH}/${ITEM}.sh" ]
	then
		"${SCRIPT_PATH}/${ITEM}.sh"
	fi
done
