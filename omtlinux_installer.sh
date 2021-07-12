#!/bin/bash

# Script to install OmegaT and then put the PISA 2021 + PIAAC customization atop it
#Changelog

#v1.5 26/08/2019 Have it download the VER zip files + checking if OMT is installed or not before downloading it
#v1.4 22/05/2019 Tweaks for Ubuntu 19.04
#v1.3 25/04/2019 Update to OMT 4.2
#v1.2 29/03/2019 Update for scripts in the /scripts folder
#v1.1 18/03/2019 Change of some paths on cat.capstan.be
#v1.0 22/02/2019 First version

#Create a temporary folder in /home/, .capstan folder will contain the config

echo "This script will install OmegaT and install the PISA 2021 customiser"

mkdir -p /home/$USER/.capstan/tmp

cd /home/$USER/.capstan/tmp

#check if OmegaT is already installed or not skipping the installation if it is the case
#Taken from OmegaT install script

OMTVERSION="OmegaT_4.2.0"

# check whether /opt/omegat/<OmegaT version> exists
# exit if it does

if  [ -d /opt/omegat/$OMTVERSION ]

then

   echo "OmegaT is already installed"


else

#This is where the part taken for the OMT installer ends

#Download OmegaT

echo "Downloading and installing OmegaT"

arch=`uname -m` #detect if computer is 32 or 64 bits

if [ ${arch} == "x86_64" ]
then
  # 64-bit 
  # 4.1.5_03
  ##wget -O omegat.tar.bz2 "https://downloads.sourceforge.net/project/omegat/OmegaT%20-%20Latest/OmegaT%204.1.5%20update%203/OmegaT_4.1.5_03_Beta_Linux_64.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fomegat%2Ffiles%2FOmegaT%2520-%2520Latest%2FOmegaT%25204.1.5%2520update%25203%2FOmegaT_4.1.5_03_Beta_Linux_64.tar.bz2%2Fdownload&ts=1550831199"
  # 4.1.5_04
  wget -O omegat.tar.bz2 "http://sourceforge.net/projects/omegat/files/OmegaT%20-%20Latest/OmegaT%204.2.0/OmegaT_4.2.0_Beta_Linux_64.tar.bz2/download"
else
  # 32-bit
  # 4.1.5_03
  ##wget -O omegat.tar.bz2 "https://downloads.sourceforge.net/project/omegat/OmegaT%20-%20Latest/OmegaT%204.1.5%20update%203/OmegaT_4.1.5_03_Beta_Linux.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fomegat%2Ffiles%2FOmegaT%2520-%2520Latest%2FOmegaT%25204.1.5%2520update%25203%2FOmegaT_4.1.5_03_Beta_Linux.tar.bz2%2Fdownload&ts=1550831271"
  # 4.1.5_04
  wget -O omegat.tar.bz2 "http://sourceforge.net/projects/omegat/files/OmegaT%20-%20Latest/OmegaT%204.2.0/OmegaT_4.2.0_Beta_Linux.tar.bz2/download"

fi

#extract OmegaT archive and cd to the extracted folder

echo "Extracting OmegaT"

tar -jxf omegat.tar.bz2
cd OmegaT*

#Run omegat installer
echo "Install OmegaT"
bash linux-install.sh
cd ../

fi

#Download the customization files

echo "Downloading the customization files"


wget -nH -r -q --no-parent  --cut-dirs=2 https://cat.capstan.be/OmegaT/manual/config.zip 	#config files
wget -nH -r -q --no-parent  --cut-dirs=2 https://cat.capstan.be/OmegaT/manual/plugins.zip 	#scripts
wget -nH -r -q --no-parent  --cut-dirs=2 https://cat.capstan.be/OmegaT/manual/scripts.zip 	#filters


echo "Extracting customization files"

mkdir config plugins scripts
unzip config.zip -d config/
unzip plugins.zip -d plugins/
unzip scripts.zip -d scripts/

echo "Applying the customization"

#move everything to its right place where they should be


cp -r config ../config
cp -r scripts ../
cp -r plugins ../config/plugins

#copy Vanilla scripts to custom scripts folder

cp -r /opt/omegat/OmegaT-default/scripts/* /home/$USER/.capstan/scripts/

#add customized settings to prefs file

sed -i "39i <scripts_dir>/home/$USER/.capstan/scripts</scripts_dir>" ../config/omegat.prefs 

cd /home/$USER

#Create a launch command
echo 'alias omegat_pisa="omegat --config-dir=/home/'$USER'/.capstan/config/ --config-file=/home/'$USER'/.capstan/config/omegat.prefs"' >> .bashrc
source /home/$USER/.bashrc

#Clean up tmp folder

rm -rf /home/$USER/.capstan/tmp

echo "OmegaT customization has been installed!"
echo "run omegat_pisa to use it" 
