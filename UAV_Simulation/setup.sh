cd ~

sudo apt-get update
#sudo apt-get upgrade -y #uncomment if you wish to upgrade

sudo apt-get install git libtool libtool-bin automake autoconf libexpat1-dev openssh-server build-essential python mc -y
sudo apt-get install gcc make perl python-matplotlib python-serial python-wxgtk2.8 python-lxml -y
sudo apt-get install python-scipy python-opencv ccache gawk git python-pip python-pexpect -y

sudo apt-get install libgtk-3-dev -y
sudo apt-get install gtk2.0 -y
sudo apt-get install libgl1-mesa-glx libglu1-mesa libgl1-mesa-dev libglu1-mesa-dev libgstreamer0.10-dev libgconf2-dev libsdl1.2-dev zlib1g-dev libjpeg62-dev libtiff4-dev python-gst0.10-dev -y
#sudo pip install --upgrade --trusted-host wxpython.org --pre -f http://wxpython.org/Phoenix/snapshot-builds/ wxPython_Phoenix 

sudo apt-get install espeak libespeak-dev libudev-dev libsdl1.2-dev -y
sudo apt-get install python-pip python-dev python-numpy python-opencv python-serial python-pyparsing python-wxgtk2.8 -y
sudo apt-get remove modemmanager -y

sudo pip install --upgrade pip
sudo pip install pymavlink MAVProxy
sudo pip install --upgrade pymavlink MAVProxy

sudo pip install dronekit #more dronekit info
sudo pip install dronekit-sitl
sudo apt-get install python-wxtools -y
sudo pip install future

sudo pip uninstall python-dateutil
sudo pip install droneapi #http://dev.ardupilot.com/wiki/droneapi-tutorial/

echo "module load droneapi.module.api" >> ~/.mavinit.scr #http://dronecode.github.io/MAVProxy/html/getting_started/mavinit.html, so now dronekit will autostart when mavproxy starts

git clone https://github.com/Parrot-Developers/mavlink.git
git clone git://github.com/diydrones/ardupilot.git
cd ardupilot
git submodule init
git submodule update --init --recursive
cd ~
git clone git://github.com/tridge/jsbsim.git
git clone http://github.com/dronekit/dronekit-python.git #contains a lot of usefull sample scripts

cd jsbsim
git pull
./autogen.sh --enable-libraries
make

# old way to add to the path, will not survive reboots
# export PATH=$PATH:$HOME/jsbsim/src
# export PATH=$PATH:$HOME/ardupilot/Tools/autotest 
# export PATH=/usr/lib/ccache:$PATH

#will survive reboots
echo "export PATH=$PATH:$HOME/jsbsim/src:$HOME/ardupilot/Tools/autotest:/usr/lib/ccache" >> ~/.profile

. ~/.bashrc
source ~/.profile
. ~/.profile

sudo apt-get update
#sudo apt-get upgrade -y #uncomment if you wish to upgrade

sudo reboot #reboot the machine



#some Zach Birnbaum Notes as I was working found below

#mavlogdump.py --format=csv --types=ATTITUDE,SERVO_OUTPUT_RAW,NAV_CONTROLLER_OUTPUT ~/ardupilot/ArduPlane/test/logs/2015-12-15/flight3/flight.tlog > ~/test7_cim.csv
# list of arduplane paramaters http://plane.ardupilot.com/wiki/arduplane-parameters/
# sim_vehicle.py --mavproxy-args="--aircraft test"
#sim_vehicle.py --out=udp:10.103.44.96:14550 -S 5 --mavproxy-args="--aircraft test"

#http://ardupilot.org/dev/docs/setting-up-sitl-on-linux.html
#sim_vehicle.sh --console --map --aircraft test
#wp load ../Tools/autotest/ArduPlane-Missions/CMAC-toff-loop.txt
#arm throttle
#mode auto

#mavlink messages:https://pixhawk.ethz.ch/mavlink/
#Copy over mavlink into flight gear directory /data/Protocol
#change sim vehicle FG out to ip of main box
