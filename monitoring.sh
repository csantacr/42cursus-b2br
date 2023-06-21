#!/bin/bash

# arch
arch=$(uname -a)

# physical cores
cpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# virtual cores
vcpu=$(grep processor /proc/cpuinfo | wc -l)

# ram
u_ram=$(free --mega | awk '$1 == "Mem:" {print $3}')
t_ram=$(free --mega | awk '$1 == "Mem:" {print $2}')

# hard disk
u_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{u_disk += $3} END {print u_disk}')
t_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{t_disk += $2} END {printf("%d"), t_disk/1024}')
p_disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{u_disk += $3} {t_disk+= $2} END {printf("%d"), u_disk/t_disk*100}')

# cpu
vmstat | tail -1 | awk '{print %15}'

# last boot
lst_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# lvm
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# tcp
tcp=$(ss -ta | grep ESTAB | wc -l)

# users
n_usr=$(users | wc -w)

# ip and mac
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# sudo count
sucmd=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $arch
	#CPU physical : $cpu
	#vCPU : $vcpu
	#Memory Usage: $u_ram/${t_ram}MB ($((u_ram*100/t_ram))%)
	#Disk Usage: $u_disk/${t_disk}Gb ($p_disk%)
	#CPU load: $cpu%
	#Last boot: $lst_boot
	#LVM use: $lvm
	#Connections TCP : $tcp ESTABLISHED
	#User log: $n_usr
	#Network: IP $ip ($mac)
	#Sudo : $sucmd cmd"
