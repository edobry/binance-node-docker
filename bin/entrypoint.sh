#!/bin/bash

source setup.sh
echo "Running $0 in $PWD"
set -ev

su bnbchaind -c "ulimit -n 65535 && /usr/local/bin/bnbchaind start --iavl-mock true --home ${BNCHOME}"
