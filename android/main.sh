#!/bin/bash

. log.sh
. auto_test.sh

#开始测试，demo，烧写所有连接PC的车机，暂未进行具体测试内容
if [ $# -ne 2 ];then
	log red "ERROR:parameter error"
	exit 1
fi
SOU_PATH="$1"
IMAGES="boot;system;userdata;vendor"
DES_PATH="$2"
resolve_images_para "$IMAGES"
for var in $(seq $num_images);do
	get_image "$SOU_PATH" "${images[$var]}" "$DES_PATH"
done
get_devices
for var in $(seq $num_devices);do
	fastboot_mod ${devices[$var]}
	for i in $(seq $num_images);do
		flash_image ${images[$i]} $DES_PATH
	done
	fastboot_reboot ${devices[$var]}
done 
