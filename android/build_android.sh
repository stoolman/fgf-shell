#!/bin/bash

function main()
{
	. build/envsetup.sh
	lunch msm8996-userdebug

	case "$1" in
	'build')
		echo " **** build android **** "
		make -j$PROCESSOR_NUM
		;;

	'aboot')
		echo "**** build android bootloader ****"
		make aboot -j$PROCESSOR_NUM
		;;

	'systemimage')
		echo " **** build android systemimage **** "
		make systemimage -j$PROCESSOR_NUM
		;;

	'bootimage')
		echo " **** build android bootimage **** "
		make bootimage -j$PROCESSOR_NUM
		;;

	'snod')
		echo " **** build android snod **** "
		make snod -j$PROCESSOR_NUM
		;;

	'userdataimage')
		echo " **** build android userdataimage **** "
		make userdataimage -j$PROCESSOR_NUM
		;;

	'vendorimage')
		echo " **** build android vendorimage **** "
		make vendorimage -j$PROCESSOR_NUM
		;;

	'vnod')
		echo " **** build android vnod **** "
		make vnod -j$PROCESSOR_NUM
		;;

	'otapackage')
		echo " **** build android otapackage **** "
		str=`echo "$*" | sed "s/$1//g"`
		echo " **** upgrade $str **** "
		make otapackage AB_OTA_PARTITIONS:="$str" -j$PROCESSOR_NUM
		;;

	'kernel')
		echo " **** build android kernel **** "
		make kernel -j$PROCESSOR_NUM
		;;

	'kernelclean')
		echo " **** build android kernelclean **** "
		make kernelclean -j$PROCESSOR_NUM
		;;

	'clean')
		echo " **** clean android **** "
		make clean -j$PROCESSOR_NUM
       	;;
	*)
	;;
	esac
}
main $@
