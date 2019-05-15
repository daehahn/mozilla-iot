#!/usr/bin/env bash

#
# Get Swap Memory Size, if it's less than 510MB, we will create own 512MB a temp swap file
#
create_swapfile()
{
  SWAPSIZE=`free | awk '/Swap/ { printf "%d", $2/1024 }'`
  while [[ "$SWAPSIZE" -lt "511" ]]; do
    echo "=============================================================="
    echo "Create a temporary swap. It will be disappear when you reboot."
    echo "** Please consider to add a permanent SWAP file/parition.   **"
    echo "=============================================================="
    #dd if=/dev/zero of=/tmp/swapfile.swp bs=1M count=512 status=progress
    #chmod 600 /tmp/swapfile.swp
    #sudo mkswap /tmp/swapfile.swp
    #sudo swapon /tmp/swapfile.swp
    sudo modprobe zram num_devices=1
    sudo -i bash -c '$(echo $((512 * 1024 * 1024)) > /sys/block/zram0/disksize)'
    sudo mkswap /dev/zram0
    sudo swapon -p 5 /dev/zram0
    SWAPSIZE=`free | awk '/Swap/ { printf "%d", $2/1024}'`
  done
  free
}

# Create temporary swpafile (384 MiB) 
create_swapfile

echo "=============================================================="
echo "        AiVA-96 Mozilla WebThings Gateway Installation.       "
echo "=============================================================="

cd ~/mozilla-iot
