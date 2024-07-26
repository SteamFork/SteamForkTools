#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

WORK_DIR="$(dirname $(realpath "${0}"))"
SOURCE_FILE="${WORK_DIR}/.tools.index"
SCRIPT_PATH="${WORK_DIR}/bin"

if [ ! -e "${SOURCE_FILE}" ]
then
	echo "Fetching source data..."
	curl -Lo "${SOURCE_FILE}" "https://github.com/SteamFork/SteamForkTools/raw/main/data/tools.index"
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
