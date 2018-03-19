#!/bin/bash

function timer()
{
	echo -n Timer count:
	tput sc
	count=0
	while true;do
		if [ $count -lt "$1" ];then
			let count++
			sleep 1
			tput rc
			tput ed
			echo -n $count
		else
			echo
			exit 0
		fi
	done
}

