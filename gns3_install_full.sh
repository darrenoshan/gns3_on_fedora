#!/bin/bash
#===================dynamips===========================#
# Check if the script is being run by root
if [ "$(id -u)" != "0" ]; then
	echo "This scripts must be run as root" 1>&2
	exit 1
fi

# Update system
dnf -y update

# Install dynamips dependencies
dnf -y install gcc cmake elfutils-libelf-devel libuuid-devel libpcap-devel python3-devel redhat-rpm-config python3-qt5 python3-sip glibc-static xterm wget git bison flex docker tigervnc

# Create a temporary folder on /tmp
mkdir -p /tmp/build-dynamips
cd /tmp/build-dynamips

# Clone repo from github
git clone git://github.com/GNS3/dynamips.git
cd dynamips
mkdir build
cd build
cmake ..

# Install
make
make install

# Remove folder
rm -rf /tmp/build-dynamips

#======================iouyap========================#

# Install dynamips dependencies
dnf -y install 

cd /tmp
git clone http://github.com/ndevilla/iniparser.git
cd iniparser
make
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include
sudo cp src/dictionary.h /usr/local/include
cd ..

git clone https://github.com/GNS3/iouyap.git
cd iouyap
make
sudo make install

#=====================gns3-server and gui=========================#

#Install using pip3
pip3 install gns3-server

# Install gns3-gui via pip3
pip3 install gns3-gui


#=====================gns3-gui-shortcut==================#

#Start
cd /tmp

#Download file from the official website
wget https://avatars0.githubusercontent.com/u/2739187

mv 2739187 gns3_logo.png
#Dirty fix...
mv gns3_logo.png /usr/share/icons/hicolor/scalable/apps/

echo "[Desktop Entry]
Type=Application
Name=GNS3
GenericName=Graphical Network Simulator
Comment=Graphical Network simulator
Icon=/usr/share/icons/hicolor/scalable/apps/gns3_logo.png
TryExec=/usr/bin/gns3
Exec=/usr/bin/gns3 %f
Terminal=false
MimeType=application/vnd.tcpdump.pcap;application/x-pcapng;application/x-snoop;application/x-iptrace;application/x-lanalyzer;application/x-nettl;application/x-radcom;application/x-etherpeek;application/x-visualnetworks;application/x-netinstobserver;application/x-5view;
Categories=Application;Network;" > /usr/share/applications/gns3.desktop

#=====================vpcs==================#
git clone git://github.com/GNS3/ubridge.git
cd ubridge
make
make install

#=====================vpcs==================#

# Create a temporary folder on /tmp
cd /opt/

# Clone repo from github
git clone https://github.com/GNS3/vpcs.git
cd vpcs/src
sh mk.sh
chmod +rx -R /opt/vpcs


#=====================display to user==================#



echo " GNS3 Installation script finishe          "
echo " VPCS Install directory: /opt/vpcs/src     "


echo " newgrp docker "
echo " groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker"


