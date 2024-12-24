#!/bin/bash

# Key enrollment process
mkdir /home/$USER/tempnvd
cd /home/$USER/tempnvd
DIR_PATH="/home/$USER/tempnvd"
sudo apt update
openssl req -new -x509 -newkey rsa:2048 -keyout $DIR_PATH/nvidia.key -outform DER -out $DIR_PATH/nvidia.der -nodes -days 36500 -subj "/CN=Graphics Drivers"

## Disable nouveau
if [ ! -f /etc/modprobe.d/nouveau-kms.conf ]; then
	echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
fi
sudo update-initramfs -u

## Enroll with mokutil
echo "You will be prompt to enter passphrase (Only used to enroll key)"; sleep 2
sudo mokutil --import $DIR_PATH/nvidia.der

# To-do: Put nvidia.sh to startup for automatically installation

# CRONTAB_ENTRY="@reboot ~/nvidia-driver-autoscript/nvidia.sh"
# (crontab -l 2>/dev/null; echo "$CRONTAB_ENTRY") | crontab -
# Not working for some reasons. Looking for alternative. Manually run nvidia.sh

# Reboot for MOK key enrollment
sudo reboot

