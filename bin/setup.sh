#!/bin/bash

set -ex

if [ ! -d "${BNCHOME}/config/" ]; then
mkdir -p ${BNCHOME}/config/
cp /node-binary/fullnode/${BNET}/quicksync/config/* ${BNCHOME}/config/
chown -R bnbchaind:bnbchaind ${BNCHOME}/config/
fi

ln -sf /node-binary/quicksync/linux/bnbchaind /usr/local/bin/bnbchaind
chmod +x /usr/local/bin/bnbchaind

ln -sf /node-binary/cli/${BNET}/${BVER}/linux/bnbcli /usr/local/bin/bnbcli
chmod +x /usr/local/bin/bnbcli
