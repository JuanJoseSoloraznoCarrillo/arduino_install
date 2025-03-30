#!/bin/bash
#===============================================================================
# Author: Solorzano, Juan Jose.
# Date: 2023-12-10
# Title: Arduino installation script.
# Description: This script will install arduino-mk and screen packages.
# Also, it will create the necessary directories and files to start working
# with arduino.
# Version: 1.0
#-------------------------------------------------------------------------------
# Usage: ./test.sh
# Note: Run as root user.
#===============================================================================

# Constants
arduino="arduino-mk"
ino_screen="screen"
SUCCESS=255
FAILED=254
user="$(ls /home/)" # gets the user name
# Ctrl+C to exit the script.
trap ctrl_c INT
function ctrl_c {
  echo "[*] exit ..."
  exit 1
}
# Check if arduino-mk and screen are installed.
function check_installation {
  arduino_installed=false
  screen_installed=false
  dpkg -l | grep -E "$arduino" > /dev/null
  if [ "$(echo $?)" == 0 ]; then
    echo "[+] $arduino is already installed."
    arduino_installed=true
  else
    echo "[!] $arduino is not installed."
  fi
  dpkg -l | grep -E "$ino_screen" > /dev/null
  if [ "$(echo $?)" == 0 ]; then
    echo "[+] $ino_screen is already installed."
    screen_installed=true
  else
    echo "[!] $ino_screen is not installed."
  fi
  if $arduino_installed && $screen_installed; then 
    return $SUCCESS
  else
    return $FAILED
  fi
}
# Install arduino-mk and screen packages.
function install_arduino_mk {
  echo ">> Installing 'arduino-mk'"
  sudo apt-get install "$arduino" -y 1>/dev/null 
  if [ "$(echo $?)" == 0 ]; then
    echo ">> arduino-mk installation Success"
  else
    echo "[!] Error: No possible to install arduino-mk"
    exit 1
  fi
  sudo apt-get install "$ino_screen" -y 1>/dev/null
  if [ "$(echo $?)" == 0 ]; then
    echo ">> $ino_screen installation Success"
  else
    echo "[!] Error: No possible to install $ino_screen"
    exit 1
  fi
}
# Create the necessary directories.
function create_dirs {
  mkdir -p /home/"$user"/arduino/sketchbook/libraries
}
# Create the Makefile configuration file.
function create_makefile {
  touch /home/"$user"/arduino/sketchbook/Makefile
  echo "ARDUINO_DIR = /usr/share/arduino
ARDUINO_PORT = /dev/ttyACM*

USER_LIB_PATH = /home/$user/arduino/sketchbook/libraries
BOARD_TAG = uno

include /usr/share/arduino/Arduino.mk" > /home/"$user"/arduino/sketchbook/Makefile
}
# Check if avrdude.conf file exists.
function check_avrdude_cnf_file {
  ls /usr/share/arduino/hardware/tools/avr/etc 2>/dev/null 1>&2
  if [ "$(echo $?)" == 2 ]; then
    mkdir -p /usr/share/arduino/hardware/tools/avr/etc
    cp -f /etc/avrdude.conf /usr/share/arduino/hardware/tools/avr/etc/
  else
    echo ">> avrdude.conf correctly found"
  fi
}
# Create the first script.
function create_first_script {
  touch /home/"$user"/arduino/sketchbook/first_script.ino
  echo 'void setup(){
  pinMode(13, OUTPUT);
  Serial.begin(9600);
}

void loop(){
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
  Serial.println("Hello world");
}' > /home/$user/arduino/sketchbook/first_script.ino
} 

function message {
  echo ""
  echo "============================================================================"
  echo "[?]    How to use the:"
  echo "============================================================================"
  echo "[*] Connect the arduino board and execute the following commands:"
  echo "    \$ make"
  echo "    \$ make upload"
  echo "    \$ make clean"
  echo "Also you can combine this commands by:"
  echo "    \$ make upload clean"
  echo "----------------------------------------------------------------------------"
  echo "[*] Run monitor mode:"
  echo "    \$ make monitor"
  echo "[*] Go out from the monitor:"
  echo "    - Press: ctrl-a + ctrl+d"
  echo "[*] Stop monitor port:"
  echo "    \$ screen -X quit"
}
# Main code flow
if [ "$(id -u)" == "0" ];then
  check_installation # checking if arduino package is already installed.
  if [ "$(echo $?)" == $SUCCESS ]; then
    create_dirs
  else
    install_arduino_mk # if arduino package is not installed, it will be installed.
    create_dirs
  fi
  create_makefile # create make configuration file
  check_avrdude_cnf_file
  create_first_script
  echo ">> Arduino configuration: Success"
  message
  sudo chown -R "$user:$user" /home/"$user"/arduino/
else
  echo "[!] Error: Run as root user."
fi