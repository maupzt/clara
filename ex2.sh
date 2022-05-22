#!/bin/bash

display_usage() {
	echo "Usage: this script counts the number of script files in a directory subdividing it by the shebang interpreter."
}

display_path() {
  	display_usage
  	echo "The folder you provided doesn't exist. Try using the full path."
}

# check if the user supplied -h or --help and then display usage
if [[ ( $@ == "--help") ||  $@ == "-h" ]]; then
	display_usage
	exit 0
fi

# check the folder and execute, otherwise display usage
if [ -d $1 ];
then
	find $1 -name "*.sh" -exec head -1q {} \; | sort -n | uniq -c
  	echo "Done."
else
  	display_path
  	exit 1
fi
