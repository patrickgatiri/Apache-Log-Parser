#!/usr/bin/env bash

# Welcome note.
echo " Hello there. This is a script that can be used to parse Apache log files."
echo " Created with <3, by Patrick Gatiri."

echo -e "\n"

# Help output.
function usage(){
	echo " USAGE: ./log_parser.sh PATH_TO_LOG_FILE"
}

if [[ $# -ne 1 ]];
then
	usage
	exit 1
fi

# Retrieve the name of the log file.
log_file=$1


function list_ip_address_stats(){
	# Declare an array that will store the present IP addresses.
	ip_address_list=()

	# Read values from the file line by line.
	while read -r line; 
	do
		# Read an IP address and add it to the list.
		ip_address=$(echo $line | awk -F'"' '{print $8}');
		ip_address_list+=($ip_address)
	done < $log_file

	echo " The IP addresses present in the log file are: "
	find_frequency_of_elements "${ip_address_list[@]}"
}

function list_date_stats(){
	# Declare an array that will store the present dates.
	dates_list=()

	# Read values from the file line by line.
	while read -r line;
	do
		# Read a date and add it to the list.
		date=$(echo $line | awk -F' ' '{print $4}' | awk -F':' '{print $1}' | sed 's/^\[//g');
		dates_list+=($date)
	done < $log_file

	echo " The dates present in the log file are: "
	find_frequency_of_elements "${dates_list[@]}"
}

function sort_array(){
	# Compute the size of the array.
	my_array=$1
	n=${#my_array[@]}

	echo "Sorting array $n"

	for (( i = 0; i < $n ; i++ ))
	do
	    for (( j = $i; j < $n; j++ ))
	    do
	        if [ ${my_array[$i]} -gt ${my_array[$j]}  ]; then
	        t=${my_array[$i]}
	        my_array[$i]=${my_array[$j]}
	        my_array[$j]=$t
        	fi
	    done
	done

	echo "Sorted array"
	for a in "${my_array[@]}"
	do
		echo " "$a
	done
}

function find_frequency_of_elements {
	array=( "$@" )
	(IFS=$'\n'; sort <<< "${array[*]}") | uniq -c
	echo ""
}

list_ip_address_stats

list_date_stats
