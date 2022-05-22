#!/bin/bash

display_usage() {
	echo "Usage: this script takes three parameters, two strings and a directory name, and substitutes any occurence of the first string with the second string for any file in the directory, recursively."
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

# if less than three arguments supplied, display usage
if [ $# -le 2 ]; then
	display_usage
	exit 1
fi

# run if the supplied folder path exists, otherwise display usage
if [[ -d $3 ]]
then
	grep -rl $1 $3 | xargs sed -i "s/$1/$2/g"
	echo "Done."
else
	display_path
	exit 1
fi
