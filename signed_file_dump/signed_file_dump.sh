#!/bin/bash


function make_signed_file {
	filename="${1##*/}"
	username=$(whoami)
	current_date=$(date +%Y-%m-%d_%H%M%S)

	echo "Filename: $filename"
	cat $1
	echo "Date: $current_date"
	echo "Username: $username"
}

make_signed_file $1 | xxd -p
