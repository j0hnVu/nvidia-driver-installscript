#!/bin/bash

# Non-free for nvidia-detect
codename=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)
if ! grep -Eq "(^|[[:space:]])non-free($|[[:space:]])" /etc/apt/sources.list; then
	echo "deb http://deb.debian.org/debian/ $codename non-free" | sudo tee -a /etc/apt/sources.list
fi
# Prerequisite
sudo apt update
sudo apt install -y linux-headers-$(uname -r) pkg-config build-essential curl wget libglvnd-dev awk

# Variables
ver=""

getVer() {
    versions=$(curl -s "https://download.nvidia.com/XFree86/Linux-x86_64/" | grep -oE "href='[0-9]+\.[0-9]+(\.[0-9]+)?\/'" | sed "s/href='\(.*\)\/'/\1/" | sort -V)
    recommended=$(curl -s "https://download.nvidia.com/XFree86/Linux-x86_64/latest.txt" | awk '{print $1}')
    latest=$(echo "$versions" | tail -n 1)

    if nvidia-detect | grep -q "all driver versions"; then
        echo "Recommended version: $recommended"
        echo "Latest version: $latest"
    fi

    echo "Select version:"
    echo "1. Latest ($latest)"
    echo "2. Recommended ($recommended)"
    echo "3. Other"
    read -p "Option: " ver_opt
    case "$ver_opt" in
        1)
            ver=$latest
            ;;
        2)
            ver=$recommended
            ;;
        3)
            echo "Enter version:"
            read -p "Version (e.g., 525.78.01): " ver
            ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac
}

downloader() {
    local ver=$1
    url="https://us.download.nvidia.com/XFree86/Linux-x86_64/$ver/NVIDIA-Linux-x86_64-$ver.run"
    wget -nc "$url"
}

installNvidiaDriver() {
    mkdir -p /home/$USER/tempnvd
    sudo sh ./*"$ver"*.run --module-signing-secret-key=/home/$USER/tempnvd/nvidia.key --module-signing-public-key=/home/$USER/tempnvd/nvidia.der

    # Enable nvidia-resume.service
    echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp" | sudo tee -a /etc/modprobe.d/nvidia-power-management.conf
    echo "options nvidia NVreg_DynamicPowerManagement=0x02" | sudo tee -a /etc/modprobe.d/nvidia-power-management.conf
    sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service

    # NVIDIA DRM Modeset
    echo "options nvidia-drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf
    sudo update-initramfs -u
}

installSupergfxctl() {
    echo "Installing supergfxctl (For Optimus Laptop)" && sleep 2
    sudo apt install -y libudev-dev

    # Remove Xorg NVIDIA-only config
    sudo rm -rf /etc/X11/xorg.conf

    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"

    # Clone and install supergfxctl
    git clone https://gitlab.com/asus-linux/supergfxctl.git
    cd supergfxctl || exit
    make && sudo make install
    cd .. || exit

    sudo systemctl enable supergfxd.service --now
    sudo usermod -aG users "$USER"
}

# Main Execution
clear
getVer
downloader "$ver"
installNvidiaDriver

if xrandr --listproviders | grep -q "Providers: number : 2"; then
    echo "2 GPUs detected. Possible Optimus Laptop."
    read -p "Do you want to install supergfxctl? (y/n): " ans
    case "$ans" in
        [yY]*)
            installSupergfxctl
            ;;
        [nN]*)
            echo "Supergfxctl installation skipped."
            ;;
        *)
            echo "Invalid response. Exiting."
            exit 
            ;;
    esac
fi
