#!/bin/bash

#script, to take the 4 input and to validate them.


COMP_NAME=( Ingestor Joiner Wrangler Validator )
SCALE_MEASURE=( Mid High Low )
VIEW_OPTION=( Auction Bid )
COUNT_NUMBER=( {1..9} )

read -p "Enter Component: " CompName
if [[ " ${COMP_NAME[*]} " =~ " ${CompName} " ]]; then
    echo " Valid component: $CompName selected "
fi

if [[ ! " ${COMP_NAME[*]} " =~ " ${CompName} " ]]; then
    echo "Oops! Invalid Component"
    read -p "Try again: " CompName
fi

read -p "Enter View option: " View
if [[ " ${VIEW_OPTION[*]} " =~ " ${View} " ]]; then
	echo " Valid component: $View selected "
fi

if [[ ! " ${VIEW_OPTION[*]} " =~ " ${View} " ]]; then
	echo " Oops! Invalid Component"
	read -p "Try again: " View
fi

echo "Enter the scale measure:"
select Scale  in "${SCALE_MEASURE[@]}"; do
	if [[ "${SCALE_MEASURE[*]}" == *"$Scale"* ]]; then
		echo "$Scale"
		break
	else
		echo "Oops! Invalid scale measure"
	fi
done

echo "Enter the count number:"
select Count  in "${COUNT_NUMBER[@]}"; do
	if [[ "${COUNT_NUMBER[*]}" == *"$Count"* ]]; then
		echo "$Count"
		break
	else
		echo "Oops! Invalid count name"
	fi
done


# The Below is code to alter in sig.conf file.
if [ "$View" == "Auction" ]; then
	if cat sig.conf | grep -n -v "vdopiasample-bid" | grep -n -q "$CompName" ; then
		lineNumber=$( cat sig.conf | grep -n -v  "vdopiasample-bid" | grep  "$CompName" | awk  -F ':' '{print $1}')
		scaling=$( cat sig.conf | grep -n -v  "vdopiasample-bid" | grep  "$CompName" | awk  -F ';' '{print $2}')
		counting=$( cat sig.conf | grep -n -v  "vdopiasample-bid" | grep  "$CompName" | awk  -F '=' '{print $2}')
		set -x				# this will enable the kind of mode in shell to print the executed commands.
		sed -i "${lineNumber}s/${scaling}/${Scale}/" sig.conf
		sed -i "${lineNumber}s/${counting}/${Count}/" sig.conf
		set +x 
		echo "file changed"
	else
		echo "not matched"
	fi
else
	if cat sig.conf | grep -n  "vdopiasample-bid" | grep -n -q "$CompName " ; then
		lineNumber=$( cat sig.conf | grep -n   "vdopiasample-bid" | grep  "$CompName" | awk  -F ':' '{print $1}')
		scaling=$( cat sig.conf | grep -n   "vdopiasample-bid" | grep  "$CompName" | awk  -F ';' '{print $2}')
		counting=$( cat sig.confi | grep -n   "vdopiasample-bid" | grep   "$CompName" | awk  -F '=' '{print $2}')

		sed -i "${lineNumber}s/${scaling}/${Scale}/" sig.conf
		sed -i "${lineNumber}s/${counting}/${Count}/" sig.conf
		echo "file changed"
	else
		echo "not matched"
	fi
fi

cat sig.conf
