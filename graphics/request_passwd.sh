#!/bin/bash
function request_passwd()
{
	echo -e "Enter Password: "
	stty -echo
	read password
	stty echo
	echo
}
