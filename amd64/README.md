Build your image to have necessary environment to cross-compile your Qt application. Follow the steps below to make use of this repository.

Pre-built images can be found here:
https://cloud.docker.com/repository/docker/mustafatekeli/qtbuilder/general

# Install a fresh Raspbian Stretch image
1. Download the image from https://downloads.raspberrypi.org/raspbian_latest
2. Unzip it
3. Write the image to your SD card. Follow these instructions: https://www.raspberrypi.org/documentation/installation/installing-images/README.md
4. Once the image is written you should see the `boot` volume of the Raspbian.

# Prepare the device for remote connection
## Connect your device to your network
1. *Note: If you are going to connect to your device to network via a cable you can jump to step 3.*  
Enter the `amd64/utils` directory and enter your WiFi credentials to the `wpa_supplicant.conf` file. 
2. Copy the `wpa_supplicant.conf` file over to `boot` volume.
3. Copy the `ssh` file over to `boot` volume. 
4. Boot the device. Make sure it is connected to your network and note down the IP of your device. For that you can use network scanning tools or login to your router and check for connected devices. Other option is to connect a monitor and a keyboard to your device. You can also follow these instructions: https://www.raspberrypi.org/documentation/remote-access/ip-address.md

## Passwordless SSH access
This is important to configure your device to allow your computer to access without providing a password each time you try to connect to it. The build scripts inside the docker container depends on this when it will try to sync the necessary libs from/to your device.

Follow the instructions here: https://www.raspberrypi.org/documentation/remote-access/ssh/passwordless.md

Test your passwordless SSH access:
```
ssh pi@<IP-ADDRESS>
```

If you are connected to device, congratulations! You can move to next step.

# Prepare rpi for cross-compile
1. Update your device
```
$ ssh pi@${RPI_HOST} 'sudo rpi-update'
$ ssh pi@${RPI_HOST} 'sudo reboot'
```
2. When device restarts you can move to next step.

# Start the build  
1. Run this target to start the build
```
$ make build-cross-rpi SSH_KEY_FILE=~/.ssh/id_rsa RPI_HOST=<IP_ADDRESS_OF_DEVICE>
```

`SSH_KEY_FILE` = your ssh credentials that you use to connect to your raspberrypi device.  
`RPI_HOST` = IP address of your device (e.g. `192.168.1.2`)

# Troubleshooting
I am getting this message:
```
E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?
```
Answer: Probably apt-get was halted while executing, leaving apt in a locked state.

Try removing the lock file and force a package reconfiguration:
```
sudo rm /var/lib/dpkg/lock
sudo dpkg --configure -a
```