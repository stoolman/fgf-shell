#!/bin/bash

des_path='/home/fenggaofeng/image/'

#获取连接到PC的设备，devices[],dvices[0]=="devices",其余下标对应设备号，值为设备ID
function get_devices()
{
	local info_devices=`adb devices | grep -v "List" | cut -f 1`
	if [ ! $info_devices ];then
		echo "ERROR:no devices"
		exit 1
	fi
	num_devices=`echo "$info_devices" |wc -l`
	printf "%-5s %-15s\n" No device
	devices[0]="devices"
	for var in $(seq $num_devices);do
		devices[$var]=`echo $info_devices | cut -d " " -f $var`
		printf "%-5s %-15s\n" $var ${devices[$var]}
	done
}

#将image拷贝至$path_image，需要传入2个参数，eg.$1='chehejia@192.168.4.164:/home/chehejia/',image_type='system'
function get_image()
{
	if [ ! $1 ];then
		echo "ERROR:no image path passed in"
		exit 1
	fi
	if [ ! $2 ];then
		echo "ERROR:no image type passed in"
		exit 1
	fi
	image_type=$2
	scp $1"$2"".img" $des_path
	if [ $? != 0 ];then
		echo "ERROR:copy error"
		exit 1
	else
		echo "copy success!"
	fi
}

#烧写image，需要传入设备号，eg. ${devices[1]}
function update_image()
{
	adb -s $1 reboot bootloader
	fastboot erase $image_type
	fastboot flash $image_type
	fastboot reboot
}
get_devices
echo ${devices[0]}
echo ${devices[1]}

#get_image $1 $2

