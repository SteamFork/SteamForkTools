#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

source /etc/os-release

export WORK_DIR="$(dirname $(realpath "${0}"))"

if [ -f "${WORK_DIR}/data/tools.index" ] && [ -d "${WORK_DIR}/bin" ]; then
    echo "SETUP: Running from the local repository in ${WORK_DIR}."
    export SOURCE_FILE="${WORK_DIR}/data/tools.index"
    export SCRIPT_PATH="${WORK_DIR}/bin"
else
    echo "SETUP: Cloning repository into ${WORK_DIR}/SteamForkTools..."
    git clone https://github.com/SteamFork/SteamForkTools.git "${WORK_DIR}/SteamForkTools"
    export SOURCE_FILE="${WORK_DIR}/SteamForkTools/data/tools.index"
    export SCRIPT_PATH="${WORK_DIR}/SteamForkTools/bin"
fi

declare -a allTools=()
while read TOOLS; do
    VER="${TOOLS%%|*}"
    TOOLS="${TOOLS#*|}"
    TOOL="${TOOLS%%|*}"
    DESCRIPTION="${TOOLS##*|}"
    ACTIVE=$("${SCRIPT_PATH}/${TOOL}.sh" check)
    echo "TOOLS: Found ${TOOL}."
    if (( $(echo "${BUILD_ID}>${VER}" | bc -l) )); then
        echo "TOOLS: ${TOOL} is supported by this version of SteamFork."
        allTools+=("${ACTIVE}" "${TOOL}" "${DESCRIPTION}")
    else
        echo "TOOLS: ${TOOL} is not supported by this version of SteamFork."
    fi
done < "${SOURCE_FILE}"

HELPERS=$(zenity --title "SteamFork Helper" \
    --list \
    --checklist \
    --height=600 \
    --width=700 \
    --text="Please choose the items that you would like to install or run." \
    --column="Selection" \
    --column="Component" \
    --column="Description" \
    "${allTools[@]}")

if [ ! $? = 0 ]; then
    echo "USER: Operation cancelled by the user."
    exit 0
fi

declare arrSelected=()
IFS='|' read -r -a arrSelected <<< "${HELPERS}"
for ITEM in "${arrSelected[@]}"; do
    echo "INSTALL: Installing ${ITEM}..."
    if [ -e "${SCRIPT_PATH}/${ITEM}.sh" ]; then
        "${SCRIPT_PATH}/${ITEM}.sh" TRUE
        echo "INSTALL: ${ITEM} installation completed."
    else
        echo "INSTALL: Script for ${ITEM} not found. Skipping."
    fi
done

while read TOOLS; do
    VER="${TOOLS%%|*}"
    TOOLS="${TOOLS#*|}"
    TOOL="${TOOLS%%|*}"
    DESCRIPTION="${TOOLS##*|}"
    if [[ ! " ${arrSelected[@]} " =~ " ${TOOL} " ]]; then
        echo "UNINSTALL: Uninstalling ${TOOL}..."
        if [ -e "${SCRIPT_PATH}/${TOOL}.sh" ]; then
            "${SCRIPT_PATH}/${TOOL}.sh" FALSE
            echo "UNINSTALL: ${TOOL} uninstallation completed."
        else
            echo "UNINSTALL: Script for ${TOOL} not found. Skipping."
        fi
    fi
done < "${SOURCE_FILE}"

if [ -d "${WORK_DIR}/SteamForkTools" ]; then
    echo "CLEANUP: Removing cloned repository at ${WORK_DIR}/SteamForkTools."
    rm -rf "${WORK_DIR}/SteamForkTools"
fi
