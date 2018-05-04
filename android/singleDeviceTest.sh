#!/bin/bash

. log.sh
. auto_test.sh

#开始测试，demo，烧写单个车机，需要传入三个参数：image源路径，image目标路径，设备ID
if [ $# -ne 3 ];then
	log red "ERROR:parameter error"
	exit 1
fi
SOU_PATH="$1"
IMAGES="boot;system;userdata;vendor"
DES_PATH="$2"
DEVICE="$3"
resolve_images_para "$IMAGES"
for var in $(seq $num_images);do
	get_image "$SOU_PATH" "${images[$var]}" "$DES_PATH"
done

get_devices
if [[ ${devices[@]} =~ ${DEVICE} ]];then
	log blue "${DEVICE} exist"
else
	exit 1
fi
#对测试设备进行测试，后续有了设备，根据需要固定设备
fastboot_mod $DEVICE
for i in $(seq $num_images);do
	flash_image ${images[$i]} $DES_PATH
done
fastboot_reboot $DEVICE
