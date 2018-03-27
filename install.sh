#!/bin/bash

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
	{ sudo cp -avr ./awesome ~/.config/; } || { tpu setaf 1; echo "couldnt copy directory"; tput sgr0;}
}

# install a bunch of crap, only if ubuntu
if [ $DISTRO != 'Ubuntu' ]; then echo "not ubuntu";
else 
	# add ppa for the latest version of awesomewm
	sudo add-apt-repository  ppa:klaus-vormweg/awesome -y;
	sudo apt update && sudo apt install awesome -y;

	# install basic programs and such
	sudo apt-get install curl vim build-essential htop git libssl-dev && sudo apt-get update;
	
	# install nodejs & npm
	curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash;
	sudo apt-get install nodejs;
	{ sudo ln -s /usr/bin/nodejs /usr/bin/node && echo "added symlink"; } || { echo "didn't need symlink"; };

	# install sublime text 3
	sudo add-apt-repository ppa:webupd8team/sublime-text-3;
	sudo apt-get update;
	sudo apt-get install sublime-text-installer;

	# install google chrome stable
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -;
	echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list;
	sudo apt-get update && sudo apt-get install google-chrome-stable;

	#copy the awesome folder from here into ~/.config/awesome
	copyAwesomeConfig
fi