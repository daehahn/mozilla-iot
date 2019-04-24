#!/usr/bin/env bash

# Set up Bluetooth permissions
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
sudo setcap cap_net_raw+eip $(eval readlink -f `which python3`)

# Download and Build Gateway
mkdir ~/mozilla-iot
cd ~/mozilla-iot

# Build and Install openzwave
git clone https://github.com/OpenZWave/open-zwave.git
cd open-zwave
CFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 make && sudo CFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 make install
sudo ldconfig

# Add into ~/.profile 
export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
ld_lib_path=`cat ~/.profile | grep -o "LD_LIBRARY_PATH"`
if [ "$ld_lib" = "" ] ; then
    echo "export LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH" | tee -a ~/.profile > /dev/null
fi

# Intent Parser for the Mozilla WebThings Gateway
git clone https://github.com/mozilla-iot/intent-parser.git
sudo python3 -m pip install git+https://github.com/mycroftai/adapt#egg=adapt-parser

# Install Python Add-on Bindings (Optional)
python2 -m pip install git+https://github.com/mozilla-iot/gateway-addon-python#egg=gateway_addon --user
python3 -m pip install git+https://github.com/mozilla-iot/gateway-addon-python#egg=gateway_addon --user

# Download lastest version of gateway
git clone https://github.com/mozilla-iot/gateway.git

# DB410c - Replace platform script and copy DB410c support
cp db410c/src/* ~/mozilla-iot/gateway/src/
cp db410c/image/*  ~/mozilla-iot/gateway/image

# DB410c - Build nanomsg and sqlite3 
cd ~/mozilla-iot/gateway/node_modules/nanomsg
make
cd ~/mozilla-iot/gateway/node_modules/sqlite3
make

# Build node
nvm install
nvm use
nvm alias default $(node -v)

node --version
npm --version

npm install
npm start

# Autostart - Please do this manually after testing
#cp ~/mozilla-iot/gateway/image/prepare-base.sh ~/
#source ~/prepare-base.sh
