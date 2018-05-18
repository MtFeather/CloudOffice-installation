#!/bin/bas
#2017/7/1 rhuei
check=$1
##########################################################################################
echo 'This script will setup CentOS 7.x Linux to Cloud Office system.'
echo 'You MOST setup the '/vm_data' directory which better mounted on a partition or disk.' 
echo 'If you want to skip check System,release and internet. You can add option "--nocheck".' 

read -p 'Do you want to do this scripts?(yes/no): ' ans
if [ "${ans}" != "Y" -a "${ans}" != "y" -a "${ans}" != "yes" ]; then
	echo "Exit"
	exit 0
fi
##########################################################################################
if [ "${check}" == "nocheck" ]; then
	break
else
	# Check System is Physical or Virtual Machine
	echo "Check System is Physical or Virtual Machine:"
	system=$( grep hypervisor /proc/cpuinfo )
	if [ "${system}" != "" ]; then
		echo -e 'System: \E[31m\033[1mvirtual machine\033[0m'
		echo -e '\E[41;37m'"\033[1mPlease use Physical Machine.\033[0m"
		exit 0
	else
		echo -e 'System: \E[32m\033[1mphysical machine\033[0m'
	fi
	echo
	##########################################################################################
	# Check Operating System and Release
	echo "Check Operating System and Release:"
	. /etc/os-release
	OS=$NAME
	if [ ! -f "/etc/centos-release"  ]; then
		echo -e 'Operating System: \E[31m\033[1m'${OS}'\033[0m'
		echo -e '\E[41;37m'"\033[1mPlease use CentOS system\033[0m"
		exit 0
	else 
		echo -e 'Operating System: \E[32m\033[1m'${OS}'\033[0m'
		version=$( cat /etc/centos-release |cut -d ' ' -f 4 |cut -d '.' -f1,2 )
		var=$(awk 'BEGIN{ print "'${version}'">="'7.2'" }')	
		if [ ! ${var} -eq 1 ]; then
			echo -e 'Version: \E[31m\033[1m'${version}'\033[0m'
			echo -e '\E[41;37m\033[1mPlease use "yum -y update" to update system\033[0m'
	        	exit 0
		fi
		echo -e 'Version: \E[32m\033[1m'${version}'\033[0m'
	fi
	echo
	##########################################################################################
	# check internet
	echo -n "Check the internet: "
	wget -q --spider www.google.com; checknet=$?
	if [ "${checknet}" != "0" ]; then
		echo -e 'Version: \E[31m\033[1mInternet error\033[0m'
		echo -e '\E[41;37m'"\033[1mPlease check your internet\033[0m"
		exit 0 
	fi
	echo -e '\E[32m\033[1mInternet connected\033[0m'
	echo
fi
##########################################################################################
# 1. SELinux to permissive
echo "Modify the SELinux from Enforcing to Permissive:"
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/g' /etc/selinux/config
setenforce 0 
echo  -e 'The SELinux mode is now in: \E[32m\033[1m'$( getenforce )'\033[0m'
echo 
##########################################################################################
# 2. ssh setting
echo -n "Not allow root login and set 2288 port to sshd: "
testing=$( grep '^PermitRootLogin no' /etc/ssh/sshd_config )
if [ "${testing}" == "" ]; then
	echo "PermitRootLogin no" >> /etc/ssh/sshd_config
	systemctl restart sshd
fi
testing=$( grep '^Port 2288' /etc/ssh/sshd_config )
if [ "${testing}" == "" ]; then
	echo "Port 2288" >> /etc/ssh/sshd_config
	systemctl restart sshd
fi
echo -e '\E[32m\033[1mOk\033[0m'
echo
##########################################################################################
# 6. install nodejs mysql
echo "Install ntp,iptables,nodejs,mariadb,mrtg,kvm,qemu,qemu-kvm,libvirt,vier-viewer,novnc,python-websockify,numpy for CloudOffice system:"
curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - &> /dev/null
yum -y install epel-release ntpdate iptables-services nodejs mariadb mariadb-server mrtg qemu-kvm libvirt virt-viewer
yum --enablerepo=epel -y install novnc python-websockify numpy
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
	fi
done
if [ ! -z ${service} ]; then
	echo "Now reinstall ${service[@]}"
	yum -y install ${service[@]}
	echo -e '\E[32m\033[1mOk\033[0m'
else
	echo -e '\E[32m\033[1mOk\033[0m'
fi
echo
##########################################################################################
# 4. ntpdate
echo "Use ntpdate to correction time:"
systemctl stop chronyd
systemctl disable chronyd
echo "5 2 * * * root ntpdate clock.stdtime.gov.tw &> /dev/null" >> /etc/crontab
ntpdate clock.stdtime.gov.tw
hwclock -w
echo -e '\E[32m\033[1mOk\033[0m'
echo
##########################################################################################
# 5. setup firewall
echo -n "Use iptables to set firewall:"
systemctl stop firewalld
systemctl disable firewalld
systemctl start iptables
systemctl enable iptables
sh script/firewall.sh
echo -e '\E[32m\033[1mOk\033[0m'
echo 
##########################################################################################
# 7. Mariadb
echo "setting mysql:"
systemctl start mariadb
systemctl enable mariadb
echo "show databases" | mysql -u root &> /dev/null ; res=$?
if [ "$res" == 0 ]; then
	./bin/mysql_secure_installation
	echo "CREATE DATABASE nodejs; GRANT all privileges ON nodejs.* TO 'nodejs'@localhost IDENTIFIED BY 'cloudoffice#nodejs';" | mysql -u root --password=2727175
	mysql -u nodejs --password=cloudoffice#nodejs nodejs < data/nodejs.sql
	echo "INSERT INTO empdata SET account='admin', password=sha1('admin'), name='admin', level=0, sex='男', email='admin@gmail.com', join_time=NOW(), last_time='',verify=1" | mysql -u nodejs --password=cloudoffice#nodejs nodejs
	echo "INSERT INTO user_xml SET eid='1', user_uuid='7a60a500-a64c-4eac-8b5e-49f7a25163ba', oid='0', user_mac1='54:52:00:ea:b7:de', user_mac2='54:52:00:1d:b5:67', user_port='0', user_ip='0', user_cdrom='0', broadcast='0'" | mysql -u nodejs --password=cloudoffice#nodejs nodejs
fi
echo
##########################################################################################
# 8. nodejs systemd
echo -n "Create nodejs user:"
useradd -M -s /sbin/nologin nodejs
sed -i 's/^Defaults    requiretty/#Defaults    requiretty/g' /etc/sudoers 
sed -i '/^root[[:space:]]*ALL=(ALL)[[:space:]]*ALL/a nodejs  ALL=(ALL)       NOPASSWD: ALL' /etc/sudoers 
echo "
[Unit]
Description=CloudOffice nodejs web server
After=network.target

[Service]
User=nodejs
Environment=REDIS_HOST=localhost
WorkingDirectory=/srv/cloudoffice/www
ExecStart=/usr/bin/node bin/www

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/nodeserver.service
systemctl daemon-reload
echo -e '\E[32m\033[1mOk\033[0m'
echo
##########################################################################################
# 9. web page
echo "Copy web page to /srv/cloudoffice:"
tar -zxvf data/cloudoffice.tar.gz -C /srv
echo -e '\E[32m\033[1mOk\033[0m'
echo
##########################################################################################
# 10. vm data
echo "Copy vm data to /vm_data:"
tar -zxvf data/vm_data.tar.gz -C /
qemu-img create -f qcow2 -o backing_file=/vm_data/usb/public.img,cluster_size=2M /vm_data/usb/admin.img &> /dev/null
echo -e '\E[32m\033[1mOk\033[0m'
echo
##########################################################################################
# 11. MRTG
card=$( route -n | grep "^0.0.0.0" | awk '{print $8}' )
sed -i "s/^nip=.*/nip=${card}/g" /srv/cloudoffice/mrtg/mrtg.net
echo "*/5 * * * * root /srv/cloudoffice/mrtg/run.all.sh &> /dev/null" >> /etc/crontab
/srv/cloudoffice/mrtg/run.all.sh &> /dev/null
##########################################################################################
# Check partition mount
echo "Check partition mount:"
echo 'There is no enforce mount. But  mounting is better. Becuse web will be show this partition space status.'
part=$( df | grep -w '/vm_data$' )
if [ "${part}" != "" ]; then
	echo -e '\E[32m'"\033[1mOK\033[0m /vm_data is mounted."
else 
	echo -e '\E[33m'"\033[1mWARNING\033[0m /vm_data is not mount."
fi
echo
##########################################################################################
# start service
systemctl start libvirtd.service
systemctl enable libvirtd.service
sed -i s/192.168.122/192.168.100/g /etc/libvirt/qemu/networks/default.xml
virsh net-define /etc/libvirt/qemu/networks/default.xml
virsh net-destroy default
virsh net-start default
systemctl start nodeserver.service &> /dev/null
systemctl enable nodeserver.service &> /dev/null
echo '#########################################################################################'
echo '## Cloud Office System install complete.                                               ##'
echo '## You can use systemctl to start or restart web service.                              ##'
echo '## Example: "systemctl [start|stop|status|restart|enable|disable] nodeserver.service"  ##'
echo '## web default user: admin, password: admin.                                           ##'
echo '## Thanks.                                                                             ##'
echo '#########################################################################################'

