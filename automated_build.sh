#!/usr/bin/env bash

# Set up Bluetooth permissions
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
sudo setcap cap_net_raw+eip $(eval readlink -f `which python3`)

# Build and Install openzwave
cd ~/mozilla-iot
if [ ! -d open-zwave ]; then
    git clone https://github.com/OpenZWave/open-zwave.git
    # For fix compile error, it's temporary until they fixed
    sudo sed -i s/"char usercode\[254\],"/"char usercode\[255\],"/ ./open-zwave/cpp/src/command_classes/DoorLockLogging.cpp
fi    
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
cd ~/mozilla-iot
if [ ! -d intent-parser ]; then
    git clone https://github.com/mozilla-iot/intent-parser.git
fi

# Adapt-parser has requirement six==1.10.0, but you'll need 1.11.0 or later for 'jsonschema'.
#sudo python3 -m pip install git+https://github.com/mycroftai/adapt#egg=adapt-parser
cd ~/mozilla-iot
if [ ! -d adapt ]; then
    git clone https://github.com/mycroftai/adapt.git
    sudo sed -i s/"six==1.10.0"/"six>=1.10.0"/ ./adapt/setup.py 
    sudo sed -i s/"six==1.10.0"/"six>=1.10.0"/ ./adapt/requirements.txt
    sudo python3 -m pip install ./adapt/
fi

# Install Python Add-on Bindings (for TP-Link and more)
sudo python2 -m pip install git+https://github.com/mozilla-iot/gateway-addon-python#egg=gateway_addon
sudo python3 -m pip install git+https://github.com/mozilla-iot/gateway-addon-python#egg=gateway_addon

# Download lastest version of gateway
cd ~/mozilla-iot
if [ ! -d gateway ]; then
    git clone https://github.com/mozilla-iot/gateway.git
    # DB410c - Replace platform script and image for DB410c support
    cp -r ./db410c/* ./gateway/
fi

# Checking node verion
cd ~/mozilla-iot/gateway
node --version
npm --version

npm install
npm audit fix
npm start

# Trace specific file 
#npm install -g nodemon

# Autostart - Please do this manually after testing
#cp ~/mozilla-iot/gateway/image/prepare-base.sh ~/
#source ~/prepare-base.sh

# Running gateway
#cd ~/mozilla-iot/gateway
#bash ./run-app.sh
