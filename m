From: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Sat, 14 Jun 2014 23:58:53 +0200
Message-ID: <1896515726.20140614235853@oudeis.org>
Reply-To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

today I replaced two old 750GB disks in a RAID1 with two new 1TB
disks:

/dev/md0 (sda1, sdb1) (root filesystem)
/dev/md1 (sda3, sdb3) LVM with /var (and others)

- remove 750GB sdb, add new 1TB sdb, fdisk & sync sda -> sdb md0 and md1
- remove 750GB sda, add new 1TB sda, fdisk & sync sdb -> sda md0 (md1 pending)
here I had some problems with grub, system did not boot from new sdb,
so I switched SATA ports on both disks and worked on grub & bios to
finally boot from sdb (maybe this was were the sh!t hit the fan)

on next boot, LVM reported the following:

Found duplicate PV efP9J0elVh1bokdArXcwsCB0KW0Yy9Ya: using /dev/sda3 not /dev/md1

this doesn't look good, does it?

is there any way to convince LVM to use md1 instead of sda3,
preferrably without shutting down/rebooting the server? (remember,
/var is an LVM volume) otherwise, I need to drive 70km, but that's OK
if necessary.

[root@gateway ~]# pvdisplay
  Found duplicate PV efP9J0elVh1bokdArXcwsCB0KW0Yy9Ya: using /dev/sda3 not /dev/md1
  --- Physical volume ---
  PV Name               /dev/sda3
  VG Name               vg_gateway
  PV Size               688.64 GB / not usable 1.56 MB
  Allocatable           yes
  PE Size (KByte)       4096
  Total PE              176291
  Free PE               154787
  Allocated PE          21504
  PV UUID               efP9J0-elVh-1bok-dArX-cwsC-B0KW-0Yy9Ya

[root@gateway ~]# mdadm --misc -D /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Thu May 26 02:42:30 2011
     Raid Level : raid1
     Array Size : 8385792 (8.00 GiB 8.59 GB)
  Used Dev Size : 8385792 (8.00 GiB 8.59 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Jun 14 23:55:03 2014
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : e305eb48:ccdead21:b2113316:370d4eaa
         Events : 0.138466

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1

[root@gateway ~]# mdadm --misc -D /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Mon Jun  6 23:12:19 2011
     Raid Level : raid1
     Array Size : 722089536 (688.64 GiB 739.42 GB)
  Used Dev Size : 722089536 (688.64 GiB 739.42 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sat Jun 14 23:56:06 2014
          State : clean, degraded, recovering
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

 Rebuild Status : 96% complete

           UUID : 7b278c55:0642253d:7f816378:91d6e631
         Events : 0.300608

    Number   Major   Minor   RaidDevice State
       2       8        3        0      spare rebuilding   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3

[root@gateway ~]# lvdisplay
  Found duplicate PV efP9J0elVh1bokdArXcwsCB0KW0Yy9Ya: using /dev/sda3 not /dev/md1
  --- Logical volume ---
  LV Name                /dev/vg_gateway/lv_home
  VG Name                vg_gateway
  LV UUID                yeBeOp-yho6-rIvS-sGhr-lpWL-T3ss-T1L9tk
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                12.00 GB
  Current LE             3072
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Name                /dev/vg_gateway/lv_var
  VG Name                vg_gateway
  LV UUID                j5P82N-irO3-AS1k-TQtk-KwSG-PZWS-j8jsx2
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                12.00 GB
  Current LE             3072
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

  --- Logical volume ---
  LV Name                /dev/vg_gateway/lv_data
  VG Name                vg_gateway
  LV UUID                ihCove-bOaa-HfYn-KNcU-5P4a-OYzO-XrbzEU
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                60.00 GB
  Current LE             15360
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2

tnx in advance.

