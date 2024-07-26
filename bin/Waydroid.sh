#!/bin/sh
git clone https://github.com/SteamFork/steamos-waydroid-installer
cd steamos-waydroid-installer
chmod 0755 installer.sh
./installer.sh
cd ..
rm -rf steamos-waydroid-installer
