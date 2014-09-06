From: "azurIt" <azurit@pobox.sk>
Subject: =?utf-8?q?RAID0_size_over_2_TB?=
Date: Sat, 06 Sep 2014 23:09:28 +0200
Message-ID: <20140906230928.BB645CEE@pobox.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i'm having problems with growing my RAID0 array over 2 TB. I installed two 4 TB drives, created 4 TB partitions but array cannot be resized over 2 TB. Superblock versoin is 0.90 and kernel version is 3.2.53 - according to linux RAID wiki, it should support 4 TB component/array size:
https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-0.90_Superblock_Format

Some more info:

# mdadm --detail /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Tue Sep 28 16:54:04 2010
     Raid Level : raid1
     Array Size : 2147483520 (2048.00 GiB 2199.02 GB)
  Used Dev Size : 2147483520 (2048.00 GiB 2199.02 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Sep  6 23:04:44 2014
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 9a363004:ad04abfe:2e31e1c3:caf66df4
         Events : 0.77066

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1







# fdisk /dev/sdd

WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util fdisk doesn't support GPT. Use GNU Parted.


WARNING: The size of this disk is 4.0 TB (4000787030016 bytes).
DOS partition table format can not be used on drives for volumes
larger than (2199023255040 bytes) for 512-byte sectors. Use parted(1) and GUID 
partition table format (GPT).


Command (m for help): p

Disk /dev/sdd: 4000.8 GB, 4000787030016 bytes
256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1  4294967295  2147483647+  ee  GPT








# fdisk /dev/sdc

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util fdisk doesn't support GPT. Use GNU Parted.


WARNING: The size of this disk is 4.0 TB (4000787030016 bytes).
DOS partition table format can not be used on drives for volumes
larger than (2199023255040 bytes) for 512-byte sectors. Use parted(1) and GUID 
partition table format (GPT).


Command (m for help): p

Disk /dev/sdc: 4000.8 GB, 4000787030016 bytes
256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1  4294967295  2147483647+  ee  GPT






# mdadm --grow /dev/md2 --size=max       
mdadm: component size of /dev/md2 unchanged at 2147483520K







# mdadm --grow /dev/md2 --size=3221225280
mdadm: Cannot set device size for /dev/md2: No space left on device






Any hints? Thank you.


azur
