#!/bin/bash

# arquitectura y kernel
uname -a

# nucleos fisicos
grep "physical id" /proc/cpuinfo | wc -l

# nucleos virtuales
grep processor /proc/cpuinfo | wc -l

# ram
free --mega | awk '$1 == "Mem:" {print $3}'

# disco duro
df -m | grep "/dev/" | grep -v "/boot" | awk '{memory_use += $3} END {print memory_use}'

#[!] pendiente
# % de uso de la cpu
# vmstat 1 4 | tail -1 | awk '{print %15}'

# ultimo reinicio
who -b | awk '$1 == "system" {print $3 " " $4}'

# lvm
if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]
then echo yes
else echo no
fi

# conexiones tcp

ss -ta | grep ESTAB | wc -l

# usuarios
users | wc -w

# ip y mac
hostname -I
ip link | grep "link/ether" | awk '{print $2}'

# sudo count
journalctl _COMM=sudo | grep COMMAND | wc -l

wall "
    Architecture: 
	CPU physical: 
	vCPU: 
	Memory Usage: 
	Disk Usage: 
	CPU load: 
	Last boot: 
	LVM use: 
	Connections TCP: 
	User log: 
	Network: 
	Sudo:
    "
