#!/bin/bash

echo "set to deploy to: $1"

# deploy Qt to the device
rsync -avz /root/raspi/qt5pi "$1":/usr/local
