#!/usr/bin/env bash

# Set up Bluetooth permissions
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
sudo setcap cap_net_raw+eip $(eval readlink -f `which python3`)

# Build and Install openzwave
#cd ~/mozilla-iot
#if [ ! -d open-zwave ]; then
#    git clone https://github.com/OpenZWave/open-zwave.git
#fi    
#cd open-zwave
#CFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 make && sudo CFLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 make install
#sudo ldconfig

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
sudo python -m pip install git+https://github.com/mycroftai/adapt#egg=adapt-parser
sudo python3 -m pip install git+https://github.com/mycroftai/adapt#egg=adapt-parser

#adapt-parser 0.3.2 has requirement six==1.10.0, but you'll have six 1.10.0 which is incompatible. 
#sudo pip install six==1.10.0, but below happens
#jsonschema 3.0.1 has requirement six>=1.11.0, but you'll have six 1.10.0 which is incompatible.

# Install Python Add-on Bindings (Optional)
#sudo python2 -m pip install git+https://github.com/mozilla-iot/gateway-addon-python#egg=gateway_addon --user
#sudo python3 -m pip install git+https://github.com/mozilla-iot/gateway-addon-python#egg=gateway_addon --user
sudo pip install git+https://github.com/mozilla-iot/gateway-addon-python.git
sudo pip3 install git+https://github.com/mozilla-iot/gateway-addon-python.git

# Download lastest version of gateway
cd ~/mozilla-iot
if [ ! -d gateway ]; then
    git clone https://github.com/mozilla-iot/gateway.git
    # DB410c - Replace platform script and image for DB410c support
    cp -r ./db410c/* ./gateway/
fi

# DB410c - Build nanomsg and sqlite3
#cd ~/mozilla-iot
#if [ -d ./gateway/node_modules/nanomsg ]; then 
#    cd ~/mozilla-iot/gateway/node_modules/nanomsg
#    make
#fi
#cd ~/mozilla-iot
#if [ -d ./gateway/node_modules/sqlite3 ]; then
#    cd ~/mozilla-iot/gateway/node_modules/sqlite3
#    make
#fi

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
