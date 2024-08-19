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
	ACTIVE=$("${SCRIPT_PATH}/${TOOL}.sh" check)
	echo "Found tool: "${TOOL}"..."
	if (( $(echo "${BUILD_ID}>${VER}" | bc -l ) ))
	then
		echo "${TOOL} is supported by this version of SteamFork."
		allTools+=("${ACTIVE}" "${TOOL}" "${DESCRIPTION}")
	fi
done < ${SOURCE_FILE}

HELPERS=$( zenity --title "SteamFork Helper" \
	--list \
	--checklist \
	--height=600 \
	--width=700 \
	--text="Please choose the items that you would like to install or run." \
	--column="Selection" \
	--column="Component" \
	--column="Description" \
	"${allTools[@]}")

if [ ! $? = 0 ]
then
	echo "Cancelled."
	exit 0
fi

declare arrSelected=()
IFS='|' read -r -a arrSelected <<< ${HELPERS}
for ITEM in "${arrSelected[@]}"
do
	echo "Install: ${ITEM}"
	if [ -e "${SCRIPT_PATH}/${ITEM}.sh" ]
	then
		"${SCRIPT_PATH}/${ITEM}.sh" TRUE
	fi
done

while read TOOLS
do
	VER="${TOOLS%%|*}"
	TOOLS="${TOOLS#*|}"
	TOOL="${TOOLS%%|*}"
	DESCRIPTION="${TOOLS##*|}"
	if [[ ! "${arrSelected[@]}" =~ ${TOOL} ]]
	then
		echo "Uninstall: ${TOOL}"
		if [ -e "${SCRIPT_PATH}/${TOOL}.sh" ]
		then
			"${SCRIPT_PATH}/${TOOL}.sh" FALSE
		fi
	fi
done < ${SOURCE_FILE}

rm -rf ${WORK_DIR}/SteamForkTools
