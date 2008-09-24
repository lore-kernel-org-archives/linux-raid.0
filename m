From: Chris Eddington <chriseddington@gmail.com>
Subject: problem adding disk
Date: Tue, 23 Sep 2008 20:43:53 -0700
Message-ID: <48D9B779.1060309@principia.edu>
References: <18649.35056.921038.589168@notabene.brown>
Reply-To: chrise@principia.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18649.35056.921038.589168@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I had a disk failure and replaced it with an equivalent disk, partition, 
etc. 

It seems to add correctly to the existing array when using mdadm 
/dev/md0 --add /dev/sdd1 after re-syncing, but when I restart the array 
(or reboot) it never accepts it, reporting the message below.  It thinks 
the 4th partition is <sdd> instead of sdd1. 

Turns out that /dev/sdd1 does not exist, but fdisk -l reports that it is 
there (also below).
Try to start the array with just sdd does not work either:
altair:~$ sudo mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 
/dev/sdd
mdadm: /dev/md0 has been started with 3 drives (out of 4).
altair:~$ sudo mdadm --stop /dev/md0

Does anyone have instructions on what to try?  Why is /dev/sdd1 not 
visible? 

Thanks,
Chris

[  580.723453] md: bind<sdb1>
[  580.723710] md: bind<sdc1>
[  580.723875] md: bind<sdd>
[  580.724051] md: bind<sda1>
[  580.724152] md: kicking non-fresh sdd from array!
[  580.724274] md: unbind<sdd>
[  580.724355] md: export_rdev(sdd)
[  580.756272] raid5: device sda1 operational as raid disk 0
[  580.756277] raid5: device sdc1 operational as raid disk 2
[  580.756279] raid5: device sdb1 operational as raid disk 1
[  580.757005] raid5: allocated 4274kB for md0
[  580.757009] raid5: raid level 5 set md0 active with 3 out of 4 
devices, algorithm 2
[  580.757012] RAID5 conf printout:
[  580.757013]  --- rd:4 wd:3
[  580.757015]  disk 0, o:1, dev:sda1
[  580.757016]  disk 1, o:1, dev:sdb1
[  580.757018]  disk 2, o:1, dev:sdc1

------------------------------------------------------------------------------------
Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0009f318

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1       60801   488384001   fd  Linux raid 
autodetect

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x000a56ab

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       60801   488384001   fd  Linux raid 
autodetect

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x000acab6

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       60801   488384001   fd  Linux raid 
autodetect

Disk /dev/sdd: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xbc28bcf8

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       60801   488384001   fd  Linux raid 
autodetect
