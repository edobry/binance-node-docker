#!/bin/bash

set -ex

ln -sf /node-binary/quicksync/linux/bnbchaind /usr/local/bin/bnbchaind
chmod +x /usr/local/bin/bnbchaind

ln -sf /node-binary/cli/${BNET}/${BVER}/linux/bnbcli /usr/local/bin/bnbcli
chmod +x /usr/local/bin/bnbcli
