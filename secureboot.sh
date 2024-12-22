#!/bin/bash

# Key enrollment process
mkdir /home/$USER/tempnvd
cd /home/$USER/tempnvd
PATH="/home/$USER/tempnvd"
openssl req -new -x509 -newkey rsa:2048 -keyout $PATH/nvidia.key -outform DER -out $PATH/nvidia.der -nodes -days 36500 -subj "/CN=Graphics Drivers"

## Disable nouveau
echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
sudo update-initramfs -u

## Enroll with mokutil
echo "You will be prompt to enter passphrase (Not necessarily your password)"; sleep 2
sudo mokutil --import $PATH/nvidia.key

# To-do: Put nvidia.sh to startup for automatically installation

CRONTAB_ENTRY="@reboot ~/nvidia-driver-autoscript/nvidia.sh"
(crontab -l 2>/dev/null; echo "$CRONTAB_ENTRY") | crontab -

# Reboot for MOK key enrollment
sudo reboot

