#!/bin/bash

tmn_cols=`tput cols`
tmn_lines=`tput lines`

function tmn_print()
{
	if [ $# -ne 3 ];then
		echo "parameter wrong,input position ex. 20 30"
		return -1
	fi
	tput cup "$1" "$2"
	echo "$3"
}
tmn_print 25 0 "hello kakaka"
