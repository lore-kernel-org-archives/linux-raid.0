From: kyle <kyle.upton.is@gmail.com>
Subject: HELP! RAID5 array disappeared after partitions deleted
Date: Thu, 19 Jan 2017 18:57:21 +1000
Message-ID: <e3f5d5ff-cea5-8cdc-c235-768e73293283@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have (had) a large RAID5 array (3x8TB) up and running on Ubuntu 16.04 
using the guide on the following page:

https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04

The array seemed to be running well, and was automatically loaded on 
re-boot etc, all good!

Today however, i was formatting some USB drives in gparted and it popped 
up some error about the partition table for the raid drives appearing 
corrupted, and using the backup. I didn't think much of this at the 
time, but it looks like that deleted the partition tables, and now i 
have no array.

Interestingly a raid 0 array i created at the same time is fine.

Does anyone know a safe(ish) way of recovering or recreating the 
partition tables, and re-loading the array? Or any other way to 
resurrect the array?

Happy to provide any other outputs that are helpful

lsblk shows all of the disks are there and detected. sda,b,c are the 
raid0 array which is fine. sdd,e,f should have partitions and be part of 
a raid5 array (md1).

|$ lsblk -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT NAME SIZE FSTYPE TYPE 
MOUNTPOINT sda 232.9G disk └─sda1 232.9G linux_raid_member part └─md0 
698.3G ext4 raid0 /fast sdb 232.9G disk └─sdb1 232.9G linux_raid_member 
part └─md0 698.3G ext4 raid0 /fast sdc 232.9G disk └─sdc1 232.9G 
linux_raid_member part └─md0 698.3G ext4 raid0 /fast sdd 7.3T disk sde 
7.3T disk sdf 7.3T disk nvme0n1 238.5G disk ├─nvme0n1p1 119.2G ext4 part 
/ └─nvme0n1p5 119.3G swap part [SWAP] |

Only 1 raid array is found by mdstat

|$ cat /proc/mdstat Personalities : [raid0] [linear] [multipath] [raid1] 
[raid6] [raid5] [raid4] [raid10] md0 : active raid0 sdc1[2] sdb1[1] 
sda1[0] 732198912 blocks super 1.2 64k chunks unused devices: |

|$ cat /etc/mdadm/mdadm.conf \# mdadm.conf CREATE owner=root group=disk 
mode=0660 auto=yes HOMEHOST MAILADDR root ARRAY /dev/md/0 metadata=1.2 
name=Octavius:0 UUID=b893dcb8:24d049e3:c810f89f:00c5f1b7 ARRAY /dev/md1 
metadata=1.2 name=Octavius:1 UUID=5858458f:6ebb00c9:c30c4aa6:5737eedb |

