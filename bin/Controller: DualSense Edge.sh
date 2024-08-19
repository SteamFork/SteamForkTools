#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024 SteamFork (https://github.com/SteamFork)

CONTROLLER="ds5-edge"
DEFAULT_CONTROLLER="xbox-elite"
DEVICE=$(steamfork-device-id)
QUIRK_PATH="/home/.steamos/offload/customdevicequirks/${DEVICE}/boot.d/"
if [ ! -f "${QUIRK_PATH}/99-${CONTROLLER}.sh" ]
then
		ENABLED="FALSE"
else
		ENABLED="TRUE"
fi

case ${1} in
	check)
		echo "${ENABLED}"
		exit 0
		;;
	TRUE)
		if [ "${ENABLED}" = "TRUE" ]
		then
			echo "Already enabled."
			exit 0
		fi
		sudo mkdir -p "${QUIRK_PATH}"
		sudo cat <<EOF | sudo tee "${QUIRK_PATH}/99-${CONTROLLER}.sh"
#!/bin/sh
busctl call org.shadowblip.InputPlumber /org/shadowblip/InputPlumber/CompositeDevice0 org.shadowblip.Input.CompositeDevice SetTargetDevices "as" 1 "${CONTROLLER}"
EOF
		sudo chmod 0755 "${QUIRK_PATH}/99-${CONTROLLER}.sh"
		"${QUIRK_PATH}/99-${CONTROLLER}.sh"
		;;
	FALSE)
		if [ "${ENABLED}" = "FALSE" ]
		then
			echo "Nothing to do."
			exit 0
		fi
		rm -f "${QUIRK_PATH}/99-${CONTROLLER}.sh"
		busctl call org.shadowblip.InputPlumber /org/shadowblip/InputPlumber/CompositeDevice0 org.shadowblip.Input.CompositeDevice SetTargetDevices "as" 1 "${DEFAULT_CONTROLLER}"
		;;
esac
