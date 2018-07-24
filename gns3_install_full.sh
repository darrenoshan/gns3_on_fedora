#!/bin/bash
#=================== Start ===========================#
# Check if the script is being run by root
if [ "$(id -u)" != "0" ]; then
	echo "This scripts must be run as root" 1>&2
	exit 1
fi

# Update system
#======================Update Fedora and Restart========================#
# you shoud update your fedora manually using the command below :
# dnf -y update && restart

# Install dnf packages
dnf -y install gns3-server gns3-gui.noarch gcc cmake elfutils-libelf-devel libuuid-devel libpcap-devel python3-devel redhat-rpm-config python3-qt5 python3-sip glibc-static xterm wget git bison flex docker tigervnc wireshark-qt elfutils-libelf-devel libpcap-devel glibc-devel.i686 elfutils-devel.i686 libpcap-devel.i686
dnf copr enable athmane/gns3-extra -y
dnf install vpcs -y

#======================dynamips========================#
# Create a temporary folder on /tmp
git clone git://github.com/GNS3/dynamips.git /tmp/build-dynamips
cd /tmp/build-dynamips && mkdir build && cd build && cmake .. -DDYNAMIPS_ARCH=x86 && make install
#======================iouyap========================#
git clone http://github.com/ndevilla/iniparser.git /tmp/iniparser/
cd /tmp/iniparser/ && make
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include
sudo cp src/dictionary.h /usr/local/include
#============
git clone https://github.com/GNS3/iouyap.git /tmp/iouyap/
cd /tmp/iouyap/ && make && sudo make install

#==================CLEAN UP==================#
rm -rf /tmp/build-dynamips /tmp/iniparser/ /tmp/iouyap/

newgrp docker && groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
sudo usermod -a -G wireshark `who | head -n 1 | cut -d " " -f 1`

#=====================display to user==================#
echo " GNS3 Installation script finished          "
