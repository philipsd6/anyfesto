#!/bin/bash

# Anyfesto Install Script for the PI
# CC 2017-2020 by tomwsmf
# Thanks to LMC for help in work on the PI recode. 

# Install the Basic Packages and Infrastructure

echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Starting the AnyfestoPI Install...."
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Installing the Basic Packages and Infrastructure."
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install locales
sudo locale-gen en_US en_US.UTF-8
sudo apt-get -y install vlc
sudo adduser --quiet --gecos --no-create-home --shell /bin/false --disabled-password vlc
sudo usermod -G audio,pi vlc
sudo apt-get -y install lighttpd
sudo apt-get -y install dnsmasq
sudo apt-get -y install isc-dhcp-server
sudo apt-get -y install hostapd
sudo apt-get -y install git zip unzip
sudo apt-get -y install perl sox libsox-fmt-all libav-tools
sudo rm /bin/sh
sudo ln /bin/bash /bin/sh
sudo chmod a+rw /bin/sh
cd ~
mkdir configs

# Setup the Directories and lighttpd 
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up the Directories and Lighttp Web Server"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
mkdir /home/pi/content
mkdir /home/pi/content/Radio
sudo usermod -d /home/pi/content/Radio vlc
sudo ln -s /home/pi/content /var/www/html/content   
cd /var/www/html
sudo rm index*.html
sudo wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/AnyfestoPI-index.html -O index.html
sudo wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/anyfestopilogosm.jpg -O logo.jpg
sudo wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/stream.m3u -O stream.m3u
cd ~
wget https://github.com/twbs/bootstrap/releases/download/v3.3.7/bootstrap-3.3.7-dist.zip
unzip bootstrap-3.3.7-dist.zip 
sudo cp -r bootstrap-3.3.7-dist/* /var/www/html/
cd /var/www/html/css
sudo wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/carousel.css
cd /var/www/html/js
sudo wget https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js
sudo wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/m3uStreamPlayer.js


#Setup Audio Streaming using VLC
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up the Audio Streaming Service"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
cd ~
cd configs
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/startpi.sh
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/lighttpd.conf
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/vlchosts
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/stream.m3u
sudo mkdir /etc/vlc 
cd /usr/share/vlc/lua/http/ 
sudo mv .hosts /etc/vlc 
sudo ln -s /etc/vlc/.hosts .hosts
cd /home/pi/content/Radio
wget https://archive.org/download/Old_Radio_Public_Service_Announcements/OldRadio_Pub--Jack_Benny_Tolerance1.mp3  -O welcome.mp3
sudo mv -f ~/configs/startpi.sh /etc/vlc/start.sh  
sudo chmod a+rx /etc/vlc/start.sh
sudo mv /home/pi/configs/stream.m3u /var/www/html/stream.m3u
sudo chown pi:pi /var/www/html/stream.m3u


#Setup Text Chat ircd-hybrid and kiwiirc web 
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up the Text Chat Service"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
sudo apt-get -y install ircd-hybrid
cd ~/configs
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/ircdpi.conf
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/ircd.motd
sudo chown root:root *
sudo chmod a+rx *
sudo mv -f ircdpi.conf /etc/ircd-hybrid/ircd.conf 
sudo mv -f ircd.motd /etc/ircd-hybrid/ircd.motd   
sudo apt-get -y install npm
cd ~
git clone https://github.com/prawnsalad/KiwiIRC.git
cd KiwiIRC
npm install
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/kiwiconfig.js
cp kiwiconfig.js config.js  
sudo chmod a+rx config.js
./kiwi build
./kiwi start
cd ~



#Setup Kiwix WikiMedia Server
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up Kiwix Wikimedia Server "
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
cd ~
wget https://download.kiwix.org/release/kiwix-tools/kiwix-tools_linux-armhf.tar.gz
tar xvf kiwix-tools_linux-armhf.tar.gz
chmod a+rx kiwix*
rm kiwi*bz2
sudo mv kiwix-serve /usr/bin/kiwix-serve
sudo mv kiwix-manage /usr/bin/kiwix-manage
mkdir /home/pi/content/kiwix
cd /home/pi/content/kiwix
sudo wget http://download.kiwix.org/zim/wiktionary_en_simple_all.zim
kiwix-manage /home/pi/content/kiwix/library.xml add /home/pi/content/kiwix/wiktionary_en_simple_all.zim
sudo chmod a+rx *
cd ~

echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setup Mumble Server for secure voip and chat"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
sudo apt-get -y install mumble-server
echo "When prompted answer the following questions as noted...."
echo "   Autostart:  Yes  "
echo "   High Priority: No   "
echo "   SuperUser: Set the admin password  "
sudo dpkg-reconfigure mumble-server
cd ~/configs
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/mumble-server.ini
chmod a+rx *
sudo mv -f mumble-server.ini /etc/mumble-server.ini
sudo update-rc.d mumble-server enable
cd ~/content
mkdir apps
chmod a+rx apps/
cd apps
wget https://f-droid.org/repo/com.morlunk.mumbleclient_73.apk
chmod a+rx *
cd ~

# Setup Network and Captive Portal 
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up The Network, Access Point and Captive Portal"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
cd ~/configs
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/dhcpdpi.conf 
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/dnsmasqpi.conf
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/hostapd
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/hostapdpi.conf
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/interfacespi
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/isc-dhcp-serverpi
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/hostspi
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/hostnamepi
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/vlcpi.service
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/kiwiircpi.service
wget https://raw.githubusercontent.com/tomhiggins/anyfesto/master/deployables/current/pi/kiwixpi.service
sudo chown root:root *
sudo chmod a+rx *

sudo mv -f dhcpdpi.conf /etc/dhcp/dhcpd.conf
sudo mv -f dnsmasqpi.conf /etc/dnsmasq.conf
sudo mv -f hostapd /etc/default/hostapd
sudo mv -f hostapdpi.conf /etc/hostapd/hostapd.conf 
sudo mv -f interfacespi /etc/network/interfaces 
sudo mv -f isc-dhcp-serverpi /etc/default/isc-dhcp-server
sudo mv -f lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo mv -f vlchosts /usr/share/vlc/lua/http/.hosts
sudo mv -f hostspi /etc/hosts
sudo mv -f hostnamepi /etc/hostname
sudo mv -f vlcpi.service /etc/systemd/system/vlc.service
sudo mv -f kiwiircpi.service /etc/systemd/system/kiwiirc.service
sudo mv -f kiwixpi.service /etc/systemd/system/kiwix.service


echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Installation Complete...Preparing To Reboot"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
read -p "Press any key to reboot the PI."
sudo /etc/init.d/hostapd  stop
sudo systemctl daemon-reload 
sudo systemctl enable vlc.service
sudo systemctl enable kiwix.service
sudo systemctl enable kiwiirc.service
sudo update-rc.d ircd-hybrid enable
sudo update-rc.d mumble-server enable
sudo update-rc.d hostapd enable
sudo update-rc.d isc-dhcp-server enable 
sudo ifconfig wlan0 down
sudo ifconfig wlan0 up
sudo sync 
sudo reboot
