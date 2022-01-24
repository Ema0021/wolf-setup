#!/bin/bash

# Get this script's path
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

set -e

source $SCRIPTPATH/support/fun.cfg

USAGE="Usage: \n run_docker [OPTIONS...]
\n\n
Help Options:
\n 
-h,--help \tShow help options
\n\n
Application Options:
\n 
-i,--install \tInstall options [base|app|all], example: -i all
\n 
-b,--branch \tBranch to install when installing the app, example: -b devel"

# Default
INSTALL_OPT=all
BRANCH=devel

echo ' 
###########################################
#                                         #
#                  WoLF                   #
#                                         #
#  https://github.com/graiola/wolf-setup  #
#                       .                 #
#                      / V\               #
#                    / .  /               #
#                   <<   |                #
#                   /    |                #
#                 /      |                #
#               /        |                #
#             /    \  \ /                 #
#            (      ) | |                 #
#    ________|   _/_  | |                 #
#  <__________\______)\__)                #
#                                         #
###########################################
'

if [[ ( $1 == "--help") ||  $1 == "-h" ]] 
then 
	echo -e $USAGE
	exit 0
fi

while [ -n "$1" ]; do # while loop starts
	case "$1" in
	-i|--install)
		INSTALL_OPT="$2"
		shift
		;;
	-b|--branch)
		BRANCH="$2"
		shift
		;;
	*) echo "Option $1 not recognized!" 
		echo -e $USAGE
		exit 0;;
	esac
	shift
done

# Checks
if [[ ( $INSTALL_OPT == "base") ||  ( $INSTALL_OPT == "app") ||  ( $INSTALL_OPT == "all")]] 
then 
	echo "Selected install option: $INSTALL_OPT"
else
	echo "Wrong install option!"
	echo -e $USAGE
	exit 0
fi

# Check ubuntu version and select the right ROS
UBUNTU=$(lsb_release -cs)
if   [ $UBUNTU == "bionic" ]; then
	ROS_DISTRO=melodic
	PYTHON_NAME=python
elif [ $UBUNTU == "focal" ]; then
	ROS_DISTRO=noetic
	PYTHON_NAME=python3
else
    echo -e "${COLOR_WARN}Wrong Ubuntu! This script supports Ubuntu 18.04 - 20.04${COLOR_RESET}"
fi

if [[ ( $INSTALL_OPT == "base") || ( $INSTALL_OPT == "all") ]]
then 
	sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros-latest.list'
	wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
	sudo apt-get update
	echo -e "${COLOR_INFO}Install system libraries${COLOR_RESET}"
	cat $SCRIPTPATH/config/sys_deps_list.txt | grep -v \# | xargs sudo apt-get install -y
	echo -e "${COLOR_INFO}Install python libraries${COLOR_RESET}"
	cat $SCRIPTPATH/config/python_deps_list.txt | grep -v \# | xargs printf -- "${PYTHON_NAME}-%s\n" | xargs sudo apt-get install -y
	echo -e "${COLOR_INFO}Install ROS packages${COLOR_RESET}"
	cat $SCRIPTPATH/config/ros_deps_list.txt | grep -v \# | xargs printf -- "ros-${ROS_DISTRO}-%s\n" | xargs sudo apt-get install -y
	sudo ldconfig
	sudo rosdep init
	rosdep update
	#echo -e "${COLOR_INFO}Install ADVR debian packages${COLOR_RESET}"
	#wget http://xbot.cloud/nightly/xbot2-full-devel/${UBUNTU}-nightly.tar.gz -P /tmp/ &&
	#tar --strip-components 1 -xvf /tmp/${UBUNTU}-nightly.tar.gz -C /tmp/ &&
	#bash /tmp/install.sh
fi

if [[ ( $INSTALL_OPT == "app") || ( $INSTALL_OPT == "all") ]]
then 
	# Download the debians
	/bin/bash $SCRIPTPATH/support/get_debians.sh
	echo -e "${COLOR_INFO}Install ADVR debian packages${COLOR_RESET}"
	sudo $SCRIPTPATH/debs/$BRANCH/$UBUNTU/advr/install.sh
	echo -e "${COLOR_INFO}Install WoLF debian packages${COLOR_RESET}"
	sudo dpkg -i --force-overwrite $SCRIPTPATH/debs/$BRANCH/$UBUNTU/*.deb
fi

# Setup Bashrc
if grep -Fwq "/opt/ros/${ROS_DISTRO}/setup.bash" ~/.bashrc
then 
	echo -e "${COLOR_INFO}Bashrc is already updated with /opt/ros/${ROS_DISTRO}/setup.bash${COLOR_RESET}"
else
	echo -e "${COLOR_INFO}Add /opt/ros/${ROS_DISTRO}/setup.bash to the bashrc${COLOR_RESET}"
	echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
fi
if grep -Fwq "/opt/xbot/setup.sh" ~/.bashrc
then 
	echo -e "${COLOR_INFO}Bashrc is already updated with /opt/xbot/setup.bash${COLOR_RESET}"
else
	echo -e "${COLOR_INFO}Add /opt/xbot/setup.sh to the bashrc ${COLOR_RESET}"
echo "source /opt/xbot/setup.sh" >> ~/.bashrc
fi
