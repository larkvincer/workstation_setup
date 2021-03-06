#!/bin/bash

# This is bunch of functions for bash scripts whick
# automate software installation on Ubuntu-based distro


#Only user with uid=0 have root privileges
readonly ROOT_UID=0
# Make sure script runs by root user
function check_root() {
	if [ "$UID" -ne "$ROOT_UID" ]
	then
		echo "This script must be run as root"2>&1
		exit $E_NOTROOT
	fi
}

# Download package in specified folder.
# After downloading stays in download folder
# @param:$1 - source url, $2 - $package name,
# $3 - destination folder, [$4 - header]
function download_package() {
	# Invalid number of arguments
	echo "***Downloading package***"
	if [[ $# < 3 ]]; then
		echo "Illegal number of arguments"
		echo "Usage download_package source_url package_name destination folder [header]"
		exit 1
	fi

	# Bad destination path
	if [[ ! -e $3 && ! -d $3 ]]; then
		echo "Invalid destination folder"
		exit 1
	fi
	
	# Move to the destination folder
	cd $3
	wget -O $2 -c --no-check-certificate --no-cookies --header "$4" "${1}"
	echo "***Download completed***"
}

# Unpacke package and delete archive
# @param: $1 - package name $2 - folder contains package
function unpack_package() {
	echo "***Unpacking package***"
	if [[ $# < 2 ]]; then
		echo "Illegal number of arguments"
		echo "Usage unpack_package package_name folder_contains"
		exit 1
	fi

	# Bad path
	if [[ ! -e "$2/$1" ]]; then
		echo "Invalid file path: $2/$1"
		exit 1
	fi

	# Extract files and get folder name
	cd $2
	output="$(tar -xvf $1)"
	DIR_NAME=$(echo $output | head -n 1 | cut -f 1 -d '/')
	
	# Remove archive
	rm -f $1

	echo "***Unpacking completed***"
}
