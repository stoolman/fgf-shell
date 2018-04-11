#!/bin/bash

. log.sh
#获取连接到PC的设备，devices[],dvices[0]=="devices",其余下标对应设备号，值为设备ID
function get_devices()
{
	local info_devices=`adb devices | grep -v "List" | cut -f 1`
	if [ ! $info_devices ];then
		log red "ERROR:no devices ×"
		exit 1
	fi
	log blue "get devices info,shown below:"
	num_devices=`echo "$info_devices" |wc -l`
	printf "%-5s %-15s\n" No device
	devices[0]="devices"
	for var in $(seq $num_devices);do
		devices[$var]=`echo $info_devices | cut -d " " -f $var`
		printf "%-5s %-15s\n" $var ${devices[$var]}
	done
}

#将image拷贝至$path_image，需要传入3个参数：image路径，image类型，目的路径；eg.$1='chehejia@192.168.4.164:/home/chehejia/',$2='system',$3=/home/fenggaofeng/
function get_image()
{
	if [ ! $1 ];then
		log red "ERROR:no image path passed in ×"
		exit 1
	fi
	if [ ! $2 ];then
		log red "ERROR:no image type passed in ×"
		exit 1
	fi
	scp $1"$2"".img" $3
	if [ $? != 0 ];then
		log red "ERROR:copy error ×"
		exit 1
	else
		log blue "copy success!"
	fi
}

#烧写image，需要传入3个参数：设备号，eg. ${devices[1]};image类型（boot,system）;des_path
function update_image()
{
	adb -s $1 reboot bootloader
	if [ $? -ne 0 ];then
		log red "ERROR:bootloader error ×"
		exit 1
	fi
	#fastboot erase $2
	fastboot flash "$2" "$3""$2"'.img'
	if [ $? -ne 0 ];then
		log red "ERROR:flash error ×"
		exit 1
	fi
	fastboot reboot
	if [ $? -ne 0 ];then
		log red "ERROR:reboot error ×"
		exit 1
	fi
	log blue "flash image success,reboot the device..."
	local device_exist=""
	local timer=`date +%s`
	while [ ! "$device_exist" ];do
		local timeout=$[ $(date +%s) - $timer ]
		if [ $timeout -gt 180 ];then
			log red "ERROR:reboot timeout ×"
			exit 1
		fi
		log yellow "waiting for reboot..."
		sleep 5
		device_exist=`adb devices | grep $1`
	done
	log blue "update image success"
}

#开始测试，demo，烧写所有连接PC的车机，暂未进行具体测试内容
if [ $# -ne 3 ];then
	log red "ERROR:parameter error"
	exit 1
fi
SOU_PATH="$1"
IMAGE_TYPE="$2"
DES_PATH="$3"
get_image "$SOU_PATH" "$IMAGE_TYPE" "$DES_PATH"
get_devices
for var in $(seq $num_devices);do
	update_image ${devices[$var]} $IMAGE_TYPE $DES_PATH
done 
