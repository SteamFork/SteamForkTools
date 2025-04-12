#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

# Enable debug output if DEBUG=true is passed in the environment
DEBUG=${DEBUG:-false}

debug() {
    if [ "${DEBUG}" = "true" ]; then
        echo "DEBUG: $*"
    fi
}

source /etc/os-release

export WORK_DIR="$(dirname $(realpath "${0}"))"
debug "WORK_DIR is set to ${WORK_DIR}"

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

debug "SOURCE_FILE is set to ${SOURCE_FILE}"
debug "SCRIPT_PATH is set to ${SCRIPT_PATH}"

declare -a allTools=()
while IFS='|' read -r RELEASE_VER OS_VER TOOL DESCRIPTION; do
    debug "Parsing tool entry: RELEASE_VER=${RELEASE_VER}, OS_VER=${OS_VER}, TOOL=${TOOL}, DESCRIPTION=${DESCRIPTION}"
    ACTIVE=$("${SCRIPT_PATH}/${TOOL}.sh" check)
    debug "ACTIVE status for ${TOOL} is ${ACTIVE}"

    echo "TOOLS: Found ${TOOL}."
    if [[ $(vercmp "${VERSION_ID}" "${RELEASE_VER}") -ge 0 && $(vercmp "${STEAMOS_VERSION}" "${OS_VER}") -ge 0 ]]; then
        echo "TOOLS: ${TOOL} is supported by this version of SteamFork."
        allTools+=("${ACTIVE}" "${TOOL}" "${DESCRIPTION}")
    else
        echo "TOOLS: ${TOOL} is not supported by this version of SteamFork."
    fi
done < "${SOURCE_FILE}"

debug "allTools array contains: ${allTools[@]}"

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

debug "HELPERS contains ${HELPERS}"

declare arrSelected=()
IFS='|' read -r -a arrSelected <<< "${HELPERS}"
debug "arrSelected array contains: ${arrSelected[@]}"

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
    RELEASE_VER="${TOOLS%%|*}"
    TOOLS="${TOOLS#*|}"
    OS_VER="${TOOLS%%|*}"
    TOOLS="${TOOLS#*|}"
    TOOL="${TOOLS%%|*}"
    DESCRIPTION="${TOOLS##*|}"
    debug "Checking if ${TOOL} needs to be uninstalled."
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
