From: "Matthias Herrmanny" <Matthias.Herrmanny@gmx.de>
Subject: Help with the loss of a software raid (5)
Date: Mon, 25 Jun 2012 13:44:35 +0200
Message-ID: <20120625114435.10700@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day, sorry for my English schelchtes.

I have a little problem with my two raid 5 system.
I have been in use Ubuntu 11.xx and then I lost 2 hard drives with a hardware defect, whereupon I have my new hard drives 2TB concerned. Since Ubuntu can not handle drives larger than 2TB, I've also changed Centos 6.2.
One of my two Raid 5 5x (250Gb) system, I can write off. Since there are two disc finally broken (hardware failure)
The other raid 5 system (3x 80G) I have then taken. Now on a disc that has no partition disappears, the second one was a spare Displayed and the third has no superblock more.
[root@sonne ~]# fdisk -l
Disk /dev/sdg: 82.0 GB, 81964302336 bytes
255 heads, 63 sectors/track, 9964 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00032373

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sde: 120.1 GB, 120060444672 bytes
255 heads, 63 sectors/track, 14596 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00037e0a

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1        9970    80076800   fd  Linux raid autodetect
/dev/sde2            9970       14597    37167105    5  Extended
/dev/sde5            9970       14597    37167104   fd  Linux raid autodetect

Disk /dev/sdf: 82.0 GB, 81964302336 bytes
255 heads, 63 sectors/track, 9964 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00050d72

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1        9965    80041984   fd  Linux raid autodetect
  
  
  [root@sonne ~]# mdadm --examine /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5874972e:5326304f:37228c78:dd15d965
           Name : sonne:5
  Creation Time : Sun Nov 27 03:44:57 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 160081920 (76.33 GiB 81.96 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 8bc40fb6:73fe82b4:c1c001f6:046775d4

    Update Time : Mon Jun 18 01:35:12 2012
       Checksum : 59fcdac3 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)

   
   [root@sonne ~]#   mdadm --examine /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 5874972e:5326304f:37228c78:dd15d965
           Name : sonne:5
  Creation Time : Sun Nov 27 03:44:57 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 160151552 (76.37 GiB 82.00 GB)
  Used Dev Size : 160081920 (76.33 GiB 81.96 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : eab5a0b6:f7034d85:b143bc4c:4f3b5054

    Update Time : Mon Jun 18 01:35:12 2012
       Checksum : 1ee38df - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)


Now I've put some try to run the RAID system again. Unfortunately, all to no avail.
mdadm -A /dev/md125 /dev/sde1 /dev/sdf1 /dev/sdg1
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: /dev/sde1 has no superblock - assembly aborted

mdadm -Av /md/md5 --uuid5874972e:5326304f:37228c78:dd15d965 /dev/*

mdadm --manage /dev/md125 --re-add /dev/sdg1
mdadm: cannot get array info for /dev/md125
mdadm --assemble /dev/md125 --auto=yes --scan --update=summaries --verbose
mdadm: /dev/md125 not identified in config file.
mdadm -Cv /dev/md125 -e 1.20 --assume-clean -n3 -l5 /dev/sde1 /dev/sdf1 /dev/sdg1
mdadm: unrecognised metadata identifier: 1.20
mdadm -Cv /dev/md125 -e 1.20 --assume-clean -n3 -l5 /dev/sde1 /dev/sdf1 /dev/sdg1 --force
mdadm: unrecognised metadata identifier: 1.20


I hope you still have an idea how I got the raid again and running quickly.
Thanks in advance.

MFG
Herrmanny
-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
