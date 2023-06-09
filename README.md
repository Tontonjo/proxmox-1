# Proxmox

## Informations:  
This repository contains somes scripts for Proxmox hypersor server, some terraform templates to deploy vm and ct using telmate\proxmox provider.

## Terraform

Terraform module that creates a cloud-init enabled VM in Proxmox.

### Requirements
Cloud Init and QEMU Guest Agent must be installed. 
iso9660 (isofs) module must be loaded for cloud-init to mount the Proxmox cloud-init drive.

### Improvements
- Expose all disk options
- Expose all network options

### Requirements

| Name | Version |
|------|---------|
| terraform | >=0.14 |
| proxmox | ~>2.9.0 |

## Providers

| Name | Version |
|------|---------|
| proxmox | ~>2.9.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [proxmox_vm_qemu](https://registry.terraform.io/providers/Telmate/proxmox/~>2.9.0/docs/resources/vm_qemu) |

## Usefull commands:
You'll find there some usefull commands used for proxmox and more generally debian

# 1 - Debian General
## 1.1 - Drives Management
### 1.1.1 - Find a disc with ID:
```shell
ls /dev/disk/by-id/ -la
```
```shell
ls /dev/disk/by-id/ -la | grep "serial"
```
## 1.1.2 - list disk informations: Replace X
```shell
lsblk -o name,model,serial,uuid /dev/sdX
```
##  1.1.3 - find disk UUID or partition UUID
```shell
ls -l /dev/disk/by-uuid
```
```shell
ls -l /dev/disk/by-partuuid
```

## 1.1.4 - Wipe Disk
```shell
wipefs -af /dev/sdX
```
## 1.1.5 - Read actual partition status after change
```shell
hdparm -z /dev/sdX
```
```shell
echo 1 > /sys/block/sdX/device/rescan
```  
##  1.1.6 - Find the actual blocksize of all disks - Usually 4k
```shell
lsblk -o NAME,PHY-SeC
```

##  1.2 - Zpool Management  
###  1.2.1 - Remove import of removed pools at startup:  
- Identify your pools:
```shell
systemctl | grep zfs
```
- Remove import of a pool at boot (remove old pools from load)
```shell
systemctl disable zfs-import@zpoolname.service
```
### 1.2.2 - Find ARC RAM usage for Zpool:
```shell
awk '/^size/ { print $1 " " $3 / 1048576 }' < /proc/spl/kstat/zfs/arcstats
```

### 1.2.3 - Find Compression ratio and used space:
```shell
zfs list -o name,avail,used,refer,lused,lrefer,mountpoint,compress,compressratio
``` 

### 1.2.4 - Replace Zpool Drive:
```shell
zpool replace pool /old/drive /new/drive
```

### 1.2.5 - Mark a pool as OK - Clear errors on pool and drives
```shell
zpool clear "poolname"
```

### 1.2.6 - Get Zpool version:
```shell
zpool --version
```

### 1.2.7 - Ugrade a zpool:
```shell
zpool upgrade "$poolname"
```  
### 1.2.8 - Zpool options settings
- Get your $poolname
```shell
zfs list
```
- find actual options - filter if necessary
```shell
zfs get all 
```
```shell
zfs get all | grep atime
```
- Set new option value
```shell
zfs set atime=off $poolname
```
```shell
zfs set compression=off $poolname
```  
### 1.2.9 - If pool is created with /dev/sdX instead of ID (wich may lead to mount fail)
```shell
zpool export $poolname
```  
```shell
zpool import -d /dev/disk/by-id -aN
```  
## 1.3 - Monitoring

### 1.3.1 - ZFS live disk IO
```shell
watch -n 1 "zpool iostat -v"
```

##  1.4 - PCI express  
### 1.4.1 - Determine bus speed of a PCI-E Device ( and others infos if you remove the grep part )  
- Identify your device:
```shell
lspci
```  
- Get infos
```shell
lspci -vv -s 2a:00.0
```  
##  1.5 - CPU
### 1.5.1 - Change CPU Gouvernor
#### Informations:
https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt
#### Get actual CPU gouvernor
```shell
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```  
#### List availables CPU Gouvernors
```shell
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
```  
#### Apply CPU Gouvernor
```shell
echo "ondemand" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```  
#### Make CPU Governor reboot resilient
```shell
crontab -e
```  
```shell
@reboot echo "ondemand" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null 2>&1
```  
## 1.6 - Benchmark and performance test
### 1.6.1 - Test with DD - oflag=dsync -> ignore cache for accurate result
```shell
dd if=/dev/zero of=/$pathtostorage/test1.img bs=1G count=1 oflag=dsync
```
### 1.6.2 - Test speed of drive (hdparm needed)
```shell
hdparm -t /dev/$sdX
```  
# 2 - Proxmox Virtual Environement  
## 2.1 - Stop all services:  
```shell
for i in pve-cluster pvedaemon vz qemu-server pveproxy pve-cluster; do systemctl stop $i ; done
```  
## 2.2 - Regenerate console login screen (usefull after ip changes)
```shell
pvebanner
```  
## 2.3 - VM Management

### 2.3.1 - Disk passtrough
```shell
qm set $vmid -scsi0 /dev/sdX
```
###  2.3.2 - Appliance Import
#### If OVA: extract content
```shell
tar -xvf "path_to_appliance.ova"
```
```shell
qm importdisk $vmid path_to_appliance_disk.vmdk local-lvm
```
##  2.3.3 - Appliance Export
- Identifiy the disk of a vm
```shell
qm config $vmid
```  
- Check absolute path ($absolutepath) for drive as seen by the OS
```shell
absolutepath=$(pvesm path local-lvm:vm-100-disk-0)
```  
```shell
echo $absolutepath
```  
- Export the drive wanted, watch for the format to be correct :-)
```shell
qemu-img convert -O qcow2 -f raw $absolutepath OUTPUT.qcow2
```  
# Usefull tools:
Ioping - usefull to simulate drive activity and therefore locating it.

s-tui - Graphical interface to monitor system performances

stress - install it with s-tui to be able to stress your system - dont use in prod