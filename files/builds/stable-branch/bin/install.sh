#!/bin/bash

####################################################################################################
# Name:         Autodesk Fusion 360 - Setup Wizard (Linux)                                         #
# Description:  With this file you can install Autodesk Fusion 360 on Linux.                       #
# Author:       Steve Zabka                                                                        #
# Author URI:   https://cryinkfly.com                                                              #
# License:      MIT                                                                                #
# Copyright (c) 2020-2022                                                                          #
# Time/Date:    xx:xx/xx.xx.2022                                                                   #
# Version:      1.7.7                                                                              #
####################################################################################################

###############################################################################################################################################################
# DESCRIPTION IN DETAIL                                                                                                                                       #
###############################################################################################################################################################
# With the help of my setup wizard, you will be given a way to install Autodesk Fusion 360 with some extensions on                                            #
# Linux so that you don't have to use Windows or macOS for this program in the future!                                                                        #
#                                                                                                                                                             #
# Also, my setup wizard will guides you through the installation step by step and will install some required packages.                                        #
#                                                                                                                                                             #
# The next one is you have the option of installing the program directly on your system or you can install it on an external storage medium.                  #
#                                                                                                                                                             #
# But it's important to know, you must to purchase the licenses directly from the manufacturer of Autodesk Fusion 360, when you will work with them on Linux! #
###############################################################################################################################################################

# Window Title (Setup Wizard)
program_name="Autodesk Fusion 360 for Linux - Setup Wizard"

# Reset the driver-value for the installation of Autodesk Fusion 360!
driver_used=0

# Reset the logfile-value for the installation of Autodesk Fusion 360!
f360path_log=0

###############################################################################################################################################################
# ALL LOG-FUNCTIONS ARE ARRANGED HERE:                                                                                                                        #
###############################################################################################################################################################

# Provides information about setup actions during installation.
function setupact-install-log {
  mkdir -p "$HOME/.config/fusion-360/logs/"
  exec 5> $HOME/.config/fusion-360/logs/setupact.log
  BASH_XTRACEFD="5"
  set -x
}

# Check if already exists a Autodesk Fusion 360 installation on your system.
function setupact-check-f360 {
f360_path="$HOME/.config/fusion-360/logs/wineprefixes.log" # Search for f360-path.log file.
if [ -f "$f360_path" ]; then
    cp "$f360_path" "/tmp/fusion-360/logs"
    mv "/tmp/fusion-360/logs/wineprefixes.log" "/tmp/fusion-360/logs/wineprefixes"
    setupact-modify-f360 # Modify a exists Wineprefix of Autodesk Fusion 360.
else
    f360path_log=1
    setupact-select-f360-path # Install a new Wineprefix of Autodesk Fusion 360.
fi
}

# Save the path of the Wineprefix of Autodesk Fusion 360 into the f360-path.log file.
function setupact-log-f360-path {
if [ $f360path_log -eq 1 ]; then
    echo "$wineprefixname" >> $HOME/.config/fusion-360/logs/wineprefixes.log
fi
}

###############################################################################################################################################################
# THE INITIALIZATION OF DEPENDENCIES STARTS HERE:                                                                                                             #
###############################################################################################################################################################

# Create the structure for the installation of Autodesk Fusion 360.
function setupact-structure {
  mkdir -p $HOME/.config/fusion-360/bin
  mkdir -p $HOME/.config/fusion-360/locale/cs-CZ
  mkdir -p $HOME/.config/fusion-360/locale/de-DE
  mkdir -p $HOME/.config/fusion-360/locale/en-US
  mkdir -p $HOME/.config/fusion-360/locale/es-ES
  mkdir -p $HOME/.config/fusion-360/locale/fr-FR
  mkdir -p $HOME/.config/fusion-360/locale/it-IT
  mkdir -p $HOME/.config/fusion-360/locale/ja-JP
  mkdir -p $HOME/.config/fusion-360/locale/ko-KR
  mkdir -p $HOME/.config/fusion-360/locale/zh-CN
  mkdir -p $HOME/.config/fusion-360/driver/video
  mkdir -p $HOME/.config/fusion-360/driver/video/dxvk
  mkdir -p $HOME/.config/fusion-360/driver/video/opengl
  mkdir -p $HOME/.config/fusion-360/extensions
}

###############################################################################################################################################################

# Load the locale files for the setup wizard.
function setupact-load-locale {
  wget -N -P $HOME/.config/fusion-360/locale https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/builds/stable-branch/locale/locale.sh
  chmod +x $HOME/.config/fusion-360/locale/locale.sh
  . $HOME/.config/fusion-360/locale/locale.sh
}

function load-locale-cs {
  . $HOME/.config/fusion-360/locale/cs-CZ/locale-cs.sh
}

function load-locale-de {
  . $HOME/.config/fusion-360/locale/de-DE/locale-de.sh
}

function load-locale-en {
  . $HOME/.config/fusion-360/locale/en-US/locale-en.sh
}

function load-locale-es {
  . $HOME/.config/fusion-360/locale/es-ES/locale-es.sh
}

function load-locale-fr {
  . $HOME/.config/fusion-360/locale/fr-FR/locale-fr.sh
}

function load-locale-it {
  . $HOME/.config/fusion-360/locale/it-IT/locale-it.sh
}

function load-locale-ja {
  . $HOME/.config/fusion-360/locale/ja-JP/locale-ja.sh
}

function load-locale-ko {
  . $HOME/.config/fusion-360/locale/ko-KR/locale-ko.sh
}

function load-locale-zh {
  . $HOME/.config/fusion-360/locale/zh-CN/locale-zh.sh
}

###############################################################################################################################################################

# Load newest winetricks version for the Setup Wizard!
function setupact-load-winetricks {
  wget -N -P $HOME/.config/fusion-360/bin https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x $HOME/.config/fusion-360/bin/winetricks
}

###############################################################################################################################################################

# Load newest Autodesk Fusion 360 installer version for the Setup Wizard!
function setupact-load-f360exe {
  f360exe="$HOME/.config/fusion-360/bin/Fusion360installer.exe" # Search for a existing installer of Autodesk Fusion 360
  if [ -f "$f360exe" ]; then
      echo "Autodesk Fusion 360 installer exist!"
  else
      wget https://dl.appstreaming.autodesk.com/production/installers/Fusion%20360%20Admin%20Install.exe -O Fusion360installer.exe
      mv Fusion360installer.exe $HOME/.config/fusion-360/bin/Fusion360installer.exe
  fi
}

###############################################################################################################################################################
# ALL FUNCTIONS FOR DXVK AND OPENGL START HERE:                                                                                                               #
###############################################################################################################################################################
