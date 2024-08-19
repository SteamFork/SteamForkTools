#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source /etc/os-release
export WORK_DIR="$(dirname $(realpath "${0}"))"
export SOURCE_FILE="${WORK_DIR}/SteamForkTools/data/tools.index"
export SCRIPT_PATH="${WORK_DIR}/SteamForkTools/bin"

if [ ! -d "${WORK_DIR}/SteamForkTools" ]
then
	echo "Cloning repository..."
	git clone https://github.com/SteamFork/SteamForkTools.git
fi

declare -a allTools=()
while read TOOLS
do
	VER="${TOOLS%%|*}"
	TOOLS="${TOOLS#*|}"
	TOOL="${TOOLS%%|*}"
	DESCRIPTION="${TOOLS##*|}"
	ACTIVE=$("{SCRIPT_PATH}/${ITEM}.sh" check)
	echo "Found tool: "${TOOL}"..."
	if (( $(echo "${BUILD_ID}>${VER}" | bc -l ) ))
	then
		echo "${TOOL} is supported by this version of SteamFork."
		allTools+=("${ACTIVE}" "${TOOL}" "${DESCRIPTION}")
	fi
done < ${SOURCE_FILE}

echo "[${allTools[@]}]"

HELPERS=$( zenity --title "SteamFork Helper" \
	--list \
	--checklist \
	--height=640 \
	--width=480 \
	--text="Please choose the items that you would like to install or run." \
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

rm -rf ${WORK_DIR}/SteamForkTools
