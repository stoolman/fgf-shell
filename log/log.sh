#!/bin/bash
#log函数，打印不同颜色的字体，usge：log [color] [text]
function log()
{
	case $1 in
		black) echo -e "\033[30m$2\033[0m"
		;;
		red) echo -e "\033[31m$2\033[0m"
		;;
		green) echo -e "\033[32m$2\033[0m"
		;;
		yellow) echo -e "\033[33m$2\033[0m"
		;;
		blue) echo -e "\033[34m$2\033[0m"
		;;
		purple) echo -e "\033[35m$2\033[0m"
		;;
		cerulean) echo -e "\033[36m$2\033[0m"
		;;
		white) echo -e "\033[37m$2\033[0m"
		;;
		*) echo $*
		;;
	esac
}

#可以通过set -x使用Bash内建调试功能，自定义调试信息可以使用该函数
#DEBUG statements,控制打印调试信息信息，_DEBUG="on" ./script.sh
function DEBUG()
{
    [ "$_DEBUG"=="on" ] && $@ || :
}

