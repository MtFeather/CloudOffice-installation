#!/bin/bash
#2017/7/1 rhuei
allok=0
##########################################################################################
echo 'This script will check Cloud Office system need service.'

read -p 'Do you want to do this scripts?(yes/no): ' ans
if [ "${ans}" != "Y" -a "${ans}" != "y" -a "${ans}" != "yes" ]; then
	echo "Exit"
	exit 0
fi
##########################################################################################
# Check System is Physical or Virtual Machine
echo "Check System is Physical or Virtual Machine:"
system=$( grep hypervisor /proc/cpuinfo )
if [ "${system}" != "" ]; then
        echo -e '[ \E[31m'"\033[1mFAILED\033[0m ] System: virtual machine"
        echo -e '\E[41;37m'"\033[1mPlease use Physical Machine.\033[0m"
        allok=1
else
	echo -e '[ \E[32m'"\033[1mOK\033[0m ] System: physical machine"
fi
echo
##########################################################################################
# Check Operating System and Release
echo "Check Operating System and Release:"
. /etc/os-release
OS=$NAME
if [ ! -f "/etc/centos-release"  ]; then
	echo -e '[ \E[31m'"\033[1mFAILED\033[0m ] Operating System: ${OS}"
	echo -e '\E[41;37m'"\033[1mPlease use CentOS system\033[0m"
	allok=1
else 
	echo -e '[ \E[32m'"\033[1mOK\033[0m ] Operating System: ${OS}"
	version=$( cat /etc/centos-release |cut -d ' ' -f 4 |cut -d '.' -f1,2 )
	var=$(awk 'BEGIN{ print "'$version'">="'7.2'" }')	
	if [ ! ${var} -eq 1 ]; then
		echo -e '[ \E[31m'"\033[1mFAILED\033[0m ] Version: ${version}"
		echo -e '\E[41;37m\033[1mPlease use "yum -y update" to update system\033[0m'
        	allok=1
	fi
	echo -e '[ \E[32m'"\033[1mOK\033[0m ] Version: ${version}"
fi
echo
##########################################################################################
# check internet
echo "Check the internet:"
wget -q --spider www.google.com; checknet=$?
if [ "${checknet}" != "0" ]; then
	echo -e '[ \E[31m'"\033[1mFAILED\033[0m ] Internet disconnect."
	echo -e '\E[41;37m'"\033[1mPlease check your internet\033[0m"
        allok=1
fi
echo -e '[ \E[32m'"\033[1mOK\033[0m ] Internet connected"
echo
##########################################################################################
# Check partition mount
echo "Check partition mount:"
echo 'There is no enforce mount. But  mounting is better. Becuse web will be show this partition space status.'
part=$( df | grep -w '/vm_data$' )
if [ "${part}" != "" ]; then
	echo -e '[ \E[32m'"\033[1mOK\033[0m ] /vm_data is mounted."
else 
	echo -e '[ \E[33m'"\033[1mWARNING\033[0m ] /vm_data is not mount."
fi
echo
##########################################################################################
# Check service
echo "Check services to installation:"
declare -a services
services=( 'ntpdate' 'iptables-services' 'nodejs' 'mariadb' 'mrtg' 'qemu-kvm' 'libvirt' 'novnc' 'python-websockify' 'numpy' )
service=()
for (( i=0;i<${#services[@]};i++ ))
do
	rpm=$( rpm -qa |grep -i "${services[$i]}" )
	if [ "${rpm}" == "" ]; then
		service+=("${services[$i]}")
		echo -e '[ \E[31m'"\033[1mFAILED\033[0m ] ${services[$i]} not install."
	else 
		echo -e '[ \E[32m'"\033[1mOK\033[0m ] ${services[$i]} is installed."
	fi
done

if [ ! -z ${service} ]; then 
	echo -e '[ \E[31m'"\033[1mFAILED\033[0m ] Some services not install."
	echo -e '\E[41;37m\033[1mPlease use "yum install '${service[@]}'" to install service\033[0m';
        allok=1
else
	echo -e '[ \E[32m\033[1mOK\033[0m ] All services is installed'
fi
echo
##########################################################################################
# done
if [ ${allok} -eq 0 ];then 
	echo -e '\E[32m\033[1mAll checks is done. Can start installation "Cloudoffice" system.\033[0m'
else
	echo -e '\E[31m\033[1mCheck error. Please re-run the script to check.\033[0m'
fi	
