#!/usr/bin/env bash

# Download latest monero cli
wget https://downloads.getmonero.org/cli/linuxarm8 -O monero-cli.tar.bz2

# Extract downloaded monero client
mkdir -p software
tar -xf monero-cli.tar.bz2 --strip 1 -C software

# Cleanup
rm -f monero-cli.tar.bz2
