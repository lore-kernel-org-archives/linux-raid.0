From: Jon Lewis <jlewis@lewis.org>
Subject: md: could not bd_claim hde1
Date: Sat, 10 Oct 2009 23:39:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0910102326250.22812@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a CentOS 4.8 system running software RAID1 on an identical pair 
of PATA drives.  At some point in the recent past, the system rebooted 
unexpectedly, and the two RAID1 devices degraded.  When trying to
mdadm /dev/md0 -a /dev/hde1
I get
mdadm: hot add failed for /dev/hde1: Invalid argument
and from the kernel,
md: could not bd_claim hde1.
md: error, md_import_device() returned -16

The same happens when trying to add hde3 back to md1.  The googling I've 
done suggests this is because something has these hde devices open. 
They're not mounted.  LVM is not in use.  Nothing that I can find is using 
these devices.  The system has been properly shut down a number of times 
since the arrays went degraded, but the errors we get when trying to readd 
the missing devices has not changed.

# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.01
   Creation Time : Wed Mar 23 15:49:58 2005
      Raid Level : raid1
      Array Size : 38547840 (36.76 GiB 39.47 GB)
     Device Size : 38547840 (36.76 GiB 39.47 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Oct 10 23:31:50 2009
           State : clean, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

     Number   Major   Minor   RaidDevice State
        0       0        0       -1      removed
        1      34        1        1      active sync   /dev/hdg1
            UUID : e5f38941:e40733ec:4b761dd4:cdc8f141
          Events : 0.60067904

Short of booting from some form of rescue image, and trying to readd the 
missing devices (and then waiting for synchronization before putting the 
machine back in service) is there anything worth trying to get the arrays 
back in sync?

Disk /dev/hde: 80.0 GB, 80026361856 bytes
255 heads, 63 sectors/track, 9729 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/hde1   *           1        4799    38547936   fd  Linux raid autodetect
/dev/hde2            4800        4930     1052257+  82  Linux swap
/dev/hde3            4931        9729    38547967+  fd  Linux raid autodetect

Disk /dev/hdg: 80.0 GB, 80026361856 bytes
255 heads, 63 sectors/track, 9729 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/hdg1   *           1        4799    38547936   fd  Linux raid autodetect
/dev/hdg2            4800        4930     1052257+  82  Linux swap
/dev/hdg3            4931        9729    38547967+  fd  Linux raid autodetect


----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
