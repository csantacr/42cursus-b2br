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

# % de uso de la cpu
vmstat 1 4 | tail -1 | awk '{print %15}'

# ultimo reinicio
who -b | awk '$1 == "system" {print $3 " " $4}'

# lvm
if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi
