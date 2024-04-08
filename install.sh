#!/bin/bash
# Automatically install the Klipper probing test patch
#
# Copyright (C) 2024 TheFuzzyGiggler <github.com/TheFuzzyGiggler>
#
# This file may be distributed under the terms of the GNU GPLv3 License.

#!/bin/bash

# Force script to exit if an error occurs
set -e

KLIPPER_PATH="${HOME}/klipper"
SYSTEMDDIR="/etc/systemd/system"
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/ && pwd )"

# Verify we're not running as root
if [ "$(id -u)" -eq 0 ]; then
    echo "This script must not run as root"
    exit -1
fi

# Check if Klipper is installed
if [ "$(sudo systemctl list-units --full -all -t service --no-legend | grep -F "klipper.service")" ]; then
    echo "Klipper service found!"
else
    echo "Klipper service not found, please install Klipper first"
    exit -1
fi

# Check command line argument
ACTION="${1:-install}"  # Default to "install" if no argument is provided


case "$ACTION" in
    install)
        echo "Installing..."
        # Backup existing homing.py if it exists
        if [ -f "${KLIPPER_PATH}/klippy/extras/homing.py" ]; then
            echo "Backing up existing homing.py to homing.py.bak..."
            cp -f "${KLIPPER_PATH}/klippy/extras/homing.py" "${KLIPPER_PATH}/klippy/extras/homing.py.bak"
        fi
        # Link homing.py to klipper
        echo "Linking probing patch to Klipper..."
        ln -sf "${SRCDIR}/homing.py" "${KLIPPER_PATH}/klippy/extras/homing.py"

        # Restart klipper
        echo "Restarting Klipper..."
        sudo systemctl restart klipper
        ;;

    uninstall)
        echo "Uninstalling..."
        # Remove homing.py
        echo "Removing probing patch from Klipper..."
        rm -f "${KLIPPER_PATH}/klippy/extras/homing.py"

        # Check if backup exists and restore it
        if [ -f "${KLIPPER_PATH}/klippy/extras/homing.py.bak" ]; then
            echo "Restoring original homing.py from backup..."
            mv -f "${KLIPPER_PATH}/klippy/extras/homing.py.bak" "${KLIPPER_PATH}/klippy/extras/homing.py"
        fi

        # Restart klipper
        echo "Restarting Klipper..."
        sudo systemctl restart klipper
        ;;

    *)
        echo "Invalid action: $ACTION"
        echo "Usage: $0 [install|uninstall]"
        exit 1
        ;;
esac

echo "Operation $ACTION completed successfully."
