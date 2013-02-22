From: anon20120409 <anon20120409@gmail.com>
Subject: help needed - broken raid 1 array - I think I messed up
Date: Sat, 23 Feb 2013 00:29:34 +0200
Message-ID: <5127F14E.3070600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,
I am not sure if I am using this mailing list correctly, but I have a 
big problem with my raid setup. So if anyone is interested, please help...

I have a raid1 setup with 2 hdd. One day I saw in the SMART data of one 
on the disks that it had some bad sectors, so I thought I must replace 
that disk before it is too late. Following are the trial and error steps 
that I took and messed up the situation...

While the pc was off, I diconected the hdd with the bad sectors and 
place in the same port a new disk (same model and brand).

I entered the Matrix Raid system and as I remember it said something 
like "One of you disks needs to be rebuilt, do you want to do this?" and 
of course I presses yes.

I tried to boot into ubuntu, but the drive was not mounted.

So I thought I must sync the disks. I tried to mdadm --assemble --force, 
but the disks were in use by dmraid (which I didnt know that existed), 
so no results. I also tried different mdadm commands (--scan, --create, 
--examine), but I think nothing happened as the disks were busy by the 
dmraid.

After, I plug all 3 disks and reboot. Probably bad idea.
*root@archive:~# dmraid -r*
/dev/sdd: isw, "isw_eacbgfdicf", GROUP, ok, 2930277166 sectors, data@ 0 
(new empty disk)
/dev/sdc: isw, "isw_eacbgfdicf", GROUP, ok, 2930277166 sectors, data@ 0 
(old disk without bad sectors)
/dev/sdb: isw, "isw_dbaiefcihd", GROUP, ok, 2930277166 sectors, data@ 0 
(old disk with bad sectors)
*root@archive:~# dmraid -ay *
ERROR: isw: wrong number of devices in RAID set "isw_dbaiefcihd_Volume0" 
[1/2] on /dev/sdb
ERROR: creating degraded mirror mapping for "isw_dbaiefcihd_Volume0"
RAID set "isw_dbaiefcihd_Volume0" was not activated
RAID set "isw_eacbgfdicf_Volume0" already active
*root@archive:~# dmraid -s *
ERROR: isw: wrong number of devices in RAID set "isw_dbaiefcihd_Volume0" 
[1/2] on /dev/sdb
*** Group superset isw_dbaiefcihd
--> *Inconsistent* Subset
name   : isw_dbaiefcihd_Volume0
size   : 2930272512
stride : 128
type   : mirror
status : inconsistent
subsets: 0
devs   : 1
spares : 0
*** Group superset isw_eacbgfdicf
--> Active Subset
name   : isw_eacbgfdicf_Volume0
size   : 2930272512
stride : 128
type   : mirror
status : nosync
subsets: 0
devs   : 2
spares : 0


I reboot with only the 2 old disks pluged.
*root@archive:~# dmraid -r*
/dev/sdc: isw, "isw_eacbgfdicf", GROUP, ok, 2930277166 sectors, data@ 0 
(old disk without bad sectors)
/dev/sdb: isw, "isw_dbaiefcihd", GROUP, ok, 2930277166 sectors, data@ 0 
(old disk with bad sectors)
*root@archive:~# dmraid -s*
ERROR: isw: wrong number of devices in RAID set "isw_dbaiefcihd_Volume0" 
[1/2] on /dev/sdb
ERROR: isw: wrong number of devices in RAID set "isw_eacbgfdicf_Volume0" 
[1/2] on /dev/sdc
*** Group superset isw_dbaiefcihd
--> *Inconsistent* Subset
name   : isw_dbaiefcihd_Volume0
size   : 2930272512
stride : 128
type   : mirror
status : inconsistent
subsets: 0
devs   : 1
spares : 0
*** Group superset isw_eacbgfdicf
--> *Inconsistent* Subset
name   : isw_eacbgfdicf_Volume0
size   : 2930272512
stride : 128
type   : mirror
status : inconsistent
subsets: 0
devs   : 1
spares : 0
*root@archive:~# sfdisk -d /dev/sdc | sfdisk /dev/sdb*
Checking that no-one is using this disk right now ...
OK

Disk /dev/sdb: 182401 cylinders, 255 heads, 63 sectors/track

sfdisk: ERROR: sector 0 does not have an msdos signature
  /dev/sdb: unrecognized partition table type
Old situation:
No partitions found

sfdisk: ERROR: sector 0 does not have an msdos signature
  /dev/sdc: unrecognized partition table type
No partitions found
New situation:
No partitions found

sfdisk: no partition table present.
*root@archive:~# dmraid -rE*
Do you really want to erase "isw" ondisk metadata on /dev/sdc ? [y/n] :n
Do you really want to erase "isw" ondisk metadata on /dev/sdb ? [y/n] :y
*root@archive:~# dmraid -R isw_eacbgfdicf /dev/sdb*
ERROR: isw: wrong number of devices in RAID set "isw_eacbgfdicf_Volume0" 
[1/2] on /dev/sdc
isw: drive to rebuild: /dev/sdb

RAID set "isw_eacbgfdicf_Volume0" was activated
sgpio app not found
sgpio app not found
*root@archive:~# dmraid -r*
/dev/sdc: isw, "isw_eacbgfdicf", GROUP, ok, 2930277166 sectors, data@ 0
/dev/sdb: isw, "isw_eacbgfdicf", GROUP, ok, 2930277166 sectors, data@ 0
*root@archive:~# dmraid -s*
*** Group superset isw_eacbgfdicf
--> Active Subset
name   : isw_eacbgfdicf_Volume0
size   : 2930272512
stride : 128
type   : mirror
status : ok
subsets: 0
devs   : 2
spares : 0
*root@archive:~# dmsetup status*
isw_eacbgfdicf_Volume0: 0 2930272520 mirror 2 8:16 8:32 22357/22357 1 AA 
1 core
*root@archive:~# sudo mount -a*
mount: wrong fs type, bad option, bad superblock on 
/dev/mapper/isw_eacbgfdicf_Volume0,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so
*root@archive:~# dmraid -ay*
RAID set "isw_eacbgfdicf_Volume0" already active

and at this point I think that the old disk without bad sectors synced 
from the blank new disk and I lost everything, but I am not sure.

Any help is very appreciated...

Thanks in advance!

