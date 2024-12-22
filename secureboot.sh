#!/bin/bash

# Key enrollment process
mkdir /home/$USER/tempnvd
cd /home/$USER/tempnvd
PATH="/home/$USER/tempnvd"
openssl req -new -x509 -newkey rsa:2048 -keyout $PATH/nvidia.key -outform DER -out $PATH/nvidia.der -nodes -days 36500 -subj "/CN=Graphics Drivers"

## Disable nouveau
echo options nouveau modeset=0 | sudo tee -a /etc/modprobe.d/nouveau-kms.conf
sudo update-initramfs -u

# Enroll with mokutil
echo "You will be prompt to enter passphrase (Not necessarily your password)"
sudo mokutil --import $PATH/nvidia.key

# To-do: Put nvidia.sh to startup for automatically installation

sudo reboot

