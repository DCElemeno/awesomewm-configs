#!/bin/bash

# Declare Colors
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# check distro and see if we are on ubuntu
DISTRO="$(cat /etc/lsb-release | grep DISTRIB_ID | cut -d'=' -f2)"

#function that creates ~/.config/awesome if not there or cd if there
function copyAwesomeConfig {

	# check ~/.config
	if [ -d "~/.config" ]; then echo "config dir existed...";
	else echo "creating ~/.config..."; 	mkdir "~/.config"; fi;
	
	# check ~/.config/awesome
	if [ -d "~/.config/awesome" ]; then echo "config dir existed...";
	else echo "creating ~/.config..."; 	mkdir "~/.config/awesome"; fi;
	
	# copy if can, otherwise error
	{ sudo cp -avr ./awesome ~/.config/; } || { echo "${red}couldnt copy directory${reset}";}
}

# install a bunch of crap, only if ubuntu
if [ $DISTRO != 'Ubuntu' ]; then echo "${red}! NOT UBUNTU : couldnt do shit${reset}";
else 
	# add ppa for the latest version of awesomewm
	sudo add-apt-repository  ppa:klaus-vormweg/awesome -y;
	sudo apt update && sudo apt install awesome -y;

	# install basic programs and such
	sudo apt-get install curl vim build-essential htop git libssl-dev && sudo apt-get update;
	
	# install nodejs & npm
	{ curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash;
	  sudo apt-get install nodejs; 
	  echo "${green}Installed Node and NPM${reset}"; } ||
	{ echo "${red}Ran into issue installing Node / NPM${reset}"; }

	# sometimes need a symlink from nodejs to node
	{ sudo ln -s /usr/bin/nodejs /usr/bin/node && 
	  echo "${green}added symlink${green}"; } || 
	{ echo "didn't need symlink"; };

	# install sublime text 3
	{ sudo add-apt-repository ppa:webupd8team/sublime-text-3 &&
	  sudo apt-get update && 
	  sudo apt-get install sublime-text-installer &&
	  echo "${green}Installed Sublime 3${reset}"; } ||
	{ echo "${red}Ran into issue installing Sublime${reset}"; }

	# install google chrome stable
	{ wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -;
	  echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list;
	  sudo apt-get update && sudo apt-get install google-chrome-stable;
	  echo "${green}Installed Google Chrome stable${reset}"; } ||
	{ echo "${red}Ran into issue installing Google Chrome stable${reset}"; }

	#copy the awesome folder from here into ~/.config/awesome
	copyAwesomeConfig
fi