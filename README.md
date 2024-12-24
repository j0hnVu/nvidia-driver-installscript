# NVIDIA Proprietary Driver Installation with Secure Boot for Debian

These scripts automate the NVIDIA Proprietary Driver Installation Process with Secure Boot for Debian-based distro. The scripts will handle the process of generating keys, enrolling them with MOK (Machine Owner Key), and configuring the system to disable the Nouveau driver, which conflicts with the proprietary NVIDIA drivers.

*Reasons for the script because I reinstall Debian way too often*

## To-do list
- Running nvidia.sh automatically after reboot

## Prerequisites

- **Debian-based system** (Only been tested with Debian)
- **Secure Boot** enabled in the BIOS/UEFI settings & Can use MOK Manager to import key

## How to Use

```
git clone https://github.com/j0hnVu/nvidia-prop-driver-autoscript.git
cd nvidia-prop-driver-autoscript

chmod +x secureboot.sh
chmod +x nvidia.sh

./secureboot.sh
```

**After the MOK enrollment and you boot into Debian, run this command to install NVIDIA Proprietary Driver:**

```
./nvidia.sh
```
*Im trying to automate this process so the script will run after the reboot automatically*

## Troubleshooting

- **If you encounter issues with Secure Boot**: Sometimes you cannot import key using mokutil. In that case, you will have to manually import the keys on your UEFI.
- **NVIDIA freezing on signing key modules on Gnome**: On a case where your Gnome freezing while signing key modules, press **CTRL + ALT + F1**, then log in as usual and the installer should resume. There was a fix for this issue, however I lost the source of the fix so meh :<

## Customizing the Scripts

- **Custom NVIDIA driver version**: You can modify the `nvidia.sh` script to download and install a specific version of the NVIDIA driver if necessary.
- **Change the directory for storing keys**: The default directory for storing the generated keys is `/home/$USER/tempnvd`. You can change this if needed.


## Contact me
- **Discord**: thatonempd
- **Email**: hoanganh170788@gmail.com
