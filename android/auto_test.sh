#!/bin/bash

. log.sh
#获取连接到PC的设备数量num_devices,以及设备号数组devices[]；注：dvices[0]=="devices",其余下标对应设备号，值为设备ID
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
		log blue "$2 copy success!"
	fi
}

#解析传入的image参数（eg. boot;system），获取images数量以及类型数组。注：images[0]=images，参数的分隔符，下面两个函数分别支持“；”“,”
function resolve_images_para()
{
	if [ -z "$1" ];then
		log red "[ERROR]:No images passed in"
		exit 1
	fi
	images[0]="images"
	num_images=0
	for var in $(seq 20);do
		local image_type=`echo $1 | cut -d ';' -f $var`
		if [ -n "$image_type" ];then
			images[$var]="$image_type"
		else
			let var--
			num_images=$var
			break
		fi
	done
		
}

function resolve_images_para2()
{
	[ -z "$1" ] && log red "[ERROR]:No images passed in"; exit 1 
	images[0]="images"
	num_images=0
	orig_ifs=$IFS
	IFS=,
	for i in $1;do
		let num_images++
		images[$num_images]=$i
	done
	IFS=$orig_ifs
}
#进入fastboot，传入一个参数，DeviceID
function fastboot_mod()
{
	adb -s $1 reboot bootloader
	if [ $? -ne 0 ];then
		log red "ERROR:bootloader error ×"
		exit 1
	else
		log blue "device $1 turn to fastboot mod success" 
	fi
}

#烧写image，需要传入2个参数：image类型（boot,system）;des_path
function flash_image()
{
	#fastboot erase $2
	fastboot flash "$1" "$2""$1"'.img'
	if [ $? -ne 0 ];then
		log red "ERROR:flash error ×"
		exit 1
	fi
	log blue "$1 image flash finished"
}

#fastboot reboot，需要传入传入设备ID，用以判断是否已经重启
function fastboot_reboot()
{
	fastboot reboot
	if [ $? -ne 0 ];then
		log red "ERROR:reboot error ×"
		exit 1
	fi
	log blue "reboot the device..."
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

