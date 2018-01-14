#!/bin/bash

# Check if the script is being run by root
if [ "$(id -u)" != "0" ]; then
	echo "This scripts must be run as root" 1>&2
	exit 1
fi

# Update system
dnf -y update

# Install dynamips dependencies
dnf -y install gns3-server gns3-gui gcc cmake elfutils-libelf-devel libuuid-devel libpcap-devel python3-devel redhat-rpm-config python3-qt5 python3-sip glibc-static xterm wget git bison flex docker tigervnc wireshark-qt


#===================dynamips===========================#
mkdir -p /tmp/build-dynamips
cd /tmp/build-dynamips

git clone git://github.com/GNS3/dynamips.git
cd dynamips
mkdir build
cd build
cmake ..

# Install
make
make install

#======================iouyap========================#

cd /tmp
git clone http://github.com/ndevilla/iniparser.git
cd iniparser
make
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include
sudo cp src/dictionary.h /usr/local/include

cd /tmp
git clone https://github.com/GNS3/iouyap.git
cd iouyap
make
sudo make install


#=====================vpcs==================#
cd /tmp

git clone git://github.com/GNS3/ubridge.git
cd ubridge
make
make install

#=====================vpcs==================#

cd /opt/
git clone https://github.com/GNS3/vpcs.git
cd vpcs/src
sh mk.sh
chmod +rx -R /opt/vpcs


#======================= Clean UP =====================#
# Remove folder
rm -rf /tmp/build-dynamips
rm -rf /tmp/iouyap
rm -rf /tmp/iniparser
rm -rf /tmp/ubridge


#=====================display to user==================#



echo " GNS3 Installation script finishe          "
echo " VPCS Install directory: /opt/vpcs/src     "


echo " groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker"
echo " sudo usermod -a -G wireshark ${USER} "
