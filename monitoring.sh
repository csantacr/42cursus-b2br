#!/bin/bash

arch=$(uname -a)

cores=$(lscpu | grep "Core(s) per socket" | awk '{print $4}')
sockets=$(lscpu | grep "Socket(s)" | awk '{print $2}')

vcores=$(nproc)

u_ram=$(free --mega | awk '$1 == "Mem:" {print $3}')
t_ram=$(free --mega | awk '$1 == "Mem:" {print $2}')

u_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{u_disk += $3} END {print u_disk}')
t_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{t_disk += $2} END {print t_disk}')

i_cpu=$(vmstat 1 2 | tail -1 | awk '{print $15}')

lst_boot=$(who -b | awk '{print $3 " " $4}')

lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

tcp=$(ss -ta | grep ESTAB | wc -l)

n_usr=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

n_sudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $arch
	#CPU physical : $((cores*sockets))
	#vCPU : $vcores
	#Memory Usage: $u_ram/${t_ram}MB ($((u_ram*100/t_ram))%)
	#Disk Usage: $u_disk/$((t_disk/1024))Gb ($((u_disk*100/t_disk))%)
	#CPU load: $((100-i_cpu))%
	#Last boot: $lst_boot
	#LVM use: $lvm
	#Connections TCP : $tcp ESTABLISHED
	#User log: $n_usr
	#Network: IP $ip ($mac)
	#Sudo : $n_sudo cmd"
