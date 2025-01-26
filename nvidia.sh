#!/bin/bash

# Prequisite
sudo apt install linux-headers-$(uname -r) pkg-config build-essential curl wget libglvnd-dev awk

installNvidiaDriver(){
	sudo sh ./*.run --module-signing-secret-key=/home/$USER/tempnvd/nvidia.key --module-signing-public-key=/home/$USER/tempnvd/nvidia.der

	# TO-DO: modeset=1 fbdev=1

	# Enable nvidia-resume.service
	## Fix for graphics tearing after wake from sleep on KDE Plasma
	sudo touch /etc/modprobe.d/nvidia-power-management.conf >> /dev/null
	echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp" >> sudo tee -a /etc/modprobe.d/nvidia-power-management.conf
	echo "options nvidia NVreg_DynamicPowerManagement=0x02" >> sudo tee -a /etc/modprobe.d/nvidia-power-management.conf
	sudo systemctl enable nvidia-suspend.server nvidia-hibernate.service nvidia-resume.service

	#nvidia-drm modeset=1 fbdev=1
	sudo touch /etc/modprobe.d/nvidia.conf >> /dev/null
	echo "options nvidia-drm modeset=1 fbdev=1" >> sudo tee -a /etc/modprobe.d/nvidia.conf
	sudo update-initramfs -u


}

# supergfxctl
installSupergfxctl(){
	echo "Installing supergfxctl (For Optimus Laptop)" && sleep 2
	sudo apt install libudev-dev 

	## remove xorg NVIDIA-only cfg for hybrid
	sudo rm -rf /etc/X11/xorg.conf

	## Installing Rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.cargo/env

	## supergfxctl
	git clone https://gitlab.com/asus-linux/supergfxctl.git
	cd supergfxctl
	make && sudo make install

	sudo systemctl enable supergfxd.service --now
	sudo usermod -a -G users $USER
}

getVer(){
	versions=$(curl -s "https://download.nvidia.com/XFree86/Linux-x86_64/" | grep -oE "href='[0-9]+\.[0-9]+(?:\.[0-9]+)?\/'" | sed "s/href='\(.*\)\/'/\1/" | sort -V)
	recommended=$(curl -s "https://download.nvidia.com/XFree86/Linux-x86_64/latest.txt" | awk '{print $1}')
}

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


