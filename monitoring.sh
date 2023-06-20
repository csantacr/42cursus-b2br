#!/bin/bash

# arquitectura y kernel
arch=$(uname -a)

# nucleos fisicos
cpu=$(grep "physical id" /proc/cpuinfo | wc -l)

# nucleos virtuales
vcpu=$(grep processor /proc/cpuinfo | wc -l)

# ram
ram=$(free --mega | awk '$1 == "Mem:" {print $3}')

# disco duro
disk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}')

#[!] pendiente
# % de uso de la cpu
# vmstat 1 4 | tail -1 | awk '{print %15}'

# ultimo reinicio
lst_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# lvm
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ] then echo yes else echo no fi)

# conexiones tcp

tcp=$(ss -ta | grep ESTAB | wc -l)

# usuarios
n_usr=$(users | wc -w)

# ip y mac
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# sudo count
sucmd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	Architecture: $arch
	CPU physical : $cpu
	vCPU : $vcpu
	Memory Usage: $ram/${ram}MB ($((ram*100/ram))%)
	Disk Usage: $disk/${disk}MB ($((disk*100/disk))%)
	CPU load: $cpu%
	Last boot: $lst_boot
	LVM use: $lvm
	Connections TCP : $tcp ESTABLISHED
	User log: $n_usr
	Network: IP $ip ($mac)
	Sudo : $sucmd cmd"
