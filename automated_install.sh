#!/usr/bin/env bash

# Create temporary swapfile, if not exist
source ./temp_swapfile.sh

# Update Package Cache
sudo apt-get update

# Install pkg-config
sudo apt install -y pkg-config

# Install Bluetooth and BT Low Energy support libraries (Linux only)
sudo apt-get install -y libboost-python-dev libboost-thread-dev libbluetooth-dev libglib2.0-dev

# Install libusb and libudev (Linux only)
sudo apt-get install -y libusb-1.0-0-dev libudev-dev

# Install autoconf
sudo apt-get install -y autoconf

# Install libpng (Linux only)
sudo apt-get install -y libpng-dev

# Install git
sudo apt-get install -y git

# Install gcc (needed to build open-zwave)
sudo apt-get install -y build-essential

# Install nanomsg
sudo apt-get install -y libnanomsg5 libnanomsg-dev

# Install additional dependencies for Debian (where python points to python 2.7)
sudo apt-get install -y python-pip python3-pip #openjdk-8-jre #fire-fox

# Install Python cffi tool
sudo apt-get install -y libffi-dev python-cffi python3-cffi

# Install curl (needed to install nvm)
sudo apt-get install -y curl

# Install nvm (Recommended) - may be manually needed
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
if [ ! -d ~/.nvm ]; then
    cd ~; wget https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh
    sudo chmod +x ~/install.sh
    source ~/install.sh
    source ~/.nvm/nvm.sh
    source ~/.profile
    source ~/.bashrc
    nvm install 8.15
    nvm use
    nvm alias default $(node -v)
fi

# Let user know they need to run next script
echo "=================================================="
echo "* For loading NVM, please logout and login again *"
echo "  and run next setup by 'bash automated_build.sh' "
echo "=================================================="

