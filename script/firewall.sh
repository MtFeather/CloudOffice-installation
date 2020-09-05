#!/bin/bash

iptables -F
iptables -X
iptables -Z

iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 2288 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3000 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
iptables -A INPUT -i virbr0 -p udp -m udp --dport 53 -j ACCEPT
iptables -A INPUT -i virbr0 -p tcp -m tcp --dport 53 -j ACCEPT
iptables -A INPUT -i virbr0 -p udp -m udp --dport 67 -j ACCEPT
iptables -A INPUT -i virbr0 -p tcp -m tcp --dport 67 -j ACCEPT
iptables -A INPUT -i virbr0 -p udp -m udp --dport 68 -j ACCEPT
iptables -A INPUT -i virbr0 -p tcp -m tcp --dport 68 -j ACCEPT
iptables -A INPUT -i virbr0 -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -i virbr0 -p tcp -m tcp --dport 27017 -j ACCEPT
iptables -A INPUT -i virbr0 -p tcp -m tcp --dport 3000 -j ACCEPT

iptables -F -t nat
iptables -X -t nat
iptables -Z -t nat

iptables -t nat -P PREROUTING  ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -P OUTPUT      ACCEPT

#iptables -t nat -A POSTROUTING -s 120.114.142.0/24 -o enp1s0f1 -j MASQUERADE
iptables -A FORWARD -d 192.168.100.0/24 -o virbr0 -m state --state new,RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.168.100.0/24 -i virbr0 -j ACCEPT
iptables -A FORWARD -i virbr0 -o virbr0 -j ACCEPT
iptables -A FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -A FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -t nat -A PREROUTING ! -s 192.168.100.0/24 -p tcp --dport 80 -j REDIRECT --to-port  3000
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 -j MASQUERADE
iptables-save > /etc/sysconfig/iptables
