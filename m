From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Can't add disk to failed raid array
Date: Mon, 17 Jul 2006 14:36:33 -0400
Message-ID: <44BBD8B1.9010602@waldoware.com>
References: <200607152056.55090.pwaldo@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200607152056.55090.pwaldo@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All has been quiet on this topic for a while--any more takers?  Please 
help if you can!  Thanks in advance.  Here is the current state of affairs:

[root@paul ~]# mdadm --add /dev/md1 /dev/hdd2
mdadm: add new device failed for /dev/hdd2 as 2: Invalid argument
[root@paul ~]# mdadm --detail /dev/md1
/dev/md1:
         Version : 00.90.03
   Creation Time : Fri Jun 23 22:35:27 2006
      Raid Level : raid6
      Array Size : 776541440 (740.57 GiB 795.18 GB)
     Device Size : 155308288 (148.11 GiB 159.04 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Mon Jul 17 14:02:13 2006
           State : clean, degraded
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 256K

            UUID : 2e316d9e:20cac82a:2555918e:bb9acc07
          Events : 0.1416894

     Number   Major   Minor   RaidDevice State
        0       3        2        0      active sync   /dev/hda2
        1      22        2        1      active sync   /dev/hdc2
        0       0        0    1883272037      removed
        3      33        2        3      active sync   /dev/hde2
        4      34        2        4      active sync   /dev/hdg2
        5       8        2        5      active sync   /dev/sda2
        6       8       18        6      active sync   /dev/sdb2
[root@paul ~]# fdisk -l /dev/hdd

Disk /dev/hdd: 160.0 GB, 160029999616 bytes
255 heads, 63 sectors/track, 19455 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/hdd1               1         122      979933+  fd  Linux raid 
autodetect
/dev/hdd2             123       19455   155292322+  fd  Linux raid 
autodetect

[root@paul ~]# tail -5 /var/log/messages
Jul 17 14:02:08 paul kernel: md: md_import_device returned -22
Jul 17 14:35:47 paul kernel: md: hdd2 has invalid sb, not importing!
Jul 17 14:35:47 paul kernel: md: md_import_device returned -22
Jul 17 14:35:47 paul kernel: md: hdd2 has invalid sb, not importing!
Jul 17 14:35:47 paul kernel: md: md_import_device returned -22


Paul Waldo wrote:
> Hi all,
> 
> I have a RAID6 array where a disk went bad.  I removed the old disk, put in an 
> identical one, and repartitioned the new disk.  I am now trying to add the 
> new partition to the array, but I get this error: 
> 
> [root@paul ~]# mdadm --add /dev/md1  /dev/hdd2
> mdadm: add new device failed for /dev/hdd2 as 2: Invalid argument
> 
> When I perform that command, /var/log/messages says this:
> Jul 15 20:48:39 paul kernel: md: hdd2 has invalid sb, not importing!
> Jul 15 20:48:39 paul kernel: md: md_import_device returned -22
> 
> 
> Below is the relevant data.  What might I be doing wrong?  Thanks in advance!
> 
> Paul
> 
> [root@paul ~]# cat /proc/mdstat
> Personalities : [raid6] [raid1]
> md0 : active raid1 hdd1[6](S) hda1[0] hdc1[1] hde1[2](S) hdg1[3](S) sda1[4](S) 
> sdb1[5](S)
>       979840 blocks [2/2] [UU]
> 
> md1 : active raid6 sdb2[6] sda2[5] hdg2[4] hde2[3] hdc2[1] hda2[0]
>       776541440 blocks level 6, 256k chunk, algorithm 2 [7/6] [UU_UUUU]
> 
> unused devices: <none>
> [root@paul ~]# fdisk -l /dev/hdd
> 
> Disk /dev/hdd: 160.0 GB, 160029999616 bytes
> 255 heads, 63 sectors/track, 19455 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/hdd1               1         122      979933+  fd  Linux raid autodetect
> /dev/hdd2             123       19455   155292322+  fd  Linux raid autodetect
> 
> [root@paul log]# mdadm --detail /dev/md1
> /dev/md1:
>         Version : 00.90.03
>   Creation Time : Fri Jun 23 22:35:27 2006
>      Raid Level : raid6
>      Array Size : 776541440 (740.57 GiB 795.18 GB)
>     Device Size : 155308288 (148.11 GiB 159.04 GB)
>    Raid Devices : 7
>   Total Devices : 6
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Jul 15 20:53:29 2006
>           State : clean, degraded
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 256K
> 
>            UUID : 2e316d9e:20cac82a:2555918e:bb9acc07
>          Events : 0.1396384
> 
>     Number   Major   Minor   RaidDevice State
>        0       3        2        0      active sync   /dev/hda2
>        1      22        2        1      active sync   /dev/hdc2
>    3157553       0        0        5      removed
>        3      33        2        3      active sync   /dev/hde2
>        4      34        2        4      active sync   /dev/hdg2
>        5       8        2        5      active sync   /dev/sda2
>        6       8       18        6      active sync   /dev/sdb2
> 
> [root@paul log]# uname -rv
> 2.6.17-1.2139_FC5 #1 Fri Jun 23 12:40:16 EDT 2006

