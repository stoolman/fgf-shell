#!/bin/bash

#判断一个变量是否是数字，需要传入一个参数
function is_num()
{
	if [ $# -ne 1 ];then
		echo "please input one parameter!"
		return -1
	fi
	local num=`echo $1 | grep '^[[:digit:]]*$'`
	if [ -n "$num" ];then
		echo "$num"
	else
		echo "Not a num!!!"
		return -1
	fi
}

function add()
{
	if [ $# -ne 2 ];then
		echo "please input two parameter"
		return -1
	fi
	is_num $1
	if [ $? -ne 0 ];then
		return -1
	fi
	is_num $2
	if [ $? -ne 0 ];then
		return -1
	fi
	local sum=$[ $1+$2 ]
	echo $sum
}
