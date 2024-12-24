#!/bin/bash

# Prequisite
sudo apt install linux-headers-$(uname -r) pkg-config build-essential curl wget # Missing quite a few prequisite packages here

# NVIDIA driver
echo "Which branch? (1, 2, 3)"
echo "1. Recommended"
echo "2. New Feature"
echo "3. Beta"
printf "Option: "
read br_option

case $br_option in
	1)
		echo "Which version? (1, 2, 3)"
		echo "1. 550.142"
		echo "2. 535.216"
		echo "3. 470.256"
		printf "Option: "
		read ver_option
		case $ver_option in
			1)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/550.142/NVIDIA-Linux-x86_64-550.142.run
				;;
			2)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/535.216.01/NVIDIA-Linux-x86_64-535.216.01.run
				;;
			3)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/470.256.02/NVIDIA-Linux-x86_64-470.256.02.run
				;;
		esac
		;;
	2)
		echo "Which version? (1, 2, 3)"
		echo "1. 565.77"
		echo "2. 560.35"
		echo "3. 555.58"
		printf "Option: "
		read ver_option
		case $ver_option in
			1)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/565.77/NVIDIA-Linux-x86_64-565.77.run
				;;
			2)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/560.35.03/NVIDIA-Linux-x86_64-560.35.03.run
				;;
			3)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/555.58.02/NVIDIA-Linux-x86_64-555.58.02.run
				;;
		esac
		;;
	3)
		echo "Which version? (1, 2, 3)"
		echo "1. 565.57"
		echo "2. 560.31"
		echo "3. 555.42"
		printf "Option: "
		read ver_option
		case $ver_option in
			1)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/565.57.01/NVIDIA-Linux-x86_64-565.57.01.run
				;;
			2)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/560.31.02/NVIDIA-Linux-x86_64-560.31.02.run
				;;
			3)
				wget -nc https://us.download.nvidia.com/XFree86/Linux-x86_64/555.52.04/NVIDIA-Linux-x86_64-555.52.04.run
				;;
		esac
		;;
esac

sudo sh ./*.run --module-signing-secret-key=/home/$USER/tempnvd/nvidia.key --module-signing-public-key=/home/$USER/tempnvd/nvidia.der

# supergfxctl
clear
echo "Installing supergfxctl? (For Optimus Laptop) (y/n)"
read supergfxctl_option
if [ "$supergfxctl_option"="y" ]; then
	## remove xorg NVIDIA-only cfg for hybrid
	sudo apt install livglvnd-dev libudev-dev 
	rm -rf /etc/X11/xorg.conf

	## Installing Rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.cargo/env

	## supergfxctl
	git clone https://gitlab.com/asus-linux/supergfxctl.git
	cd supergfxctl
	make && sudo make install

	sudo systemctl enable supergfxd.service --now
	sudo usermod -a -G users $USER
else
	echo "Won't install supergfxctl"
fi