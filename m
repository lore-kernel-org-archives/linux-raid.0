From: Johannes Moos <jmoos@gmx.de>
Subject: Data recovery from linear array (Intel SS4000-E)
Date: Thu, 13 Oct 2011 20:22:58 +0200
Message-ID: <4E972C82.1020605@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I've got an Intel SS4000-E NAS configured with a linear array consisting 
of four disks.
I made backups of the three remaining disks with ddrescue and was going 
to work with these.

Each disk contains three partitions (fdisk -l):

Disk /dev/sdb: 320.1 GB, 320072933376 bytes
16 heads, 63 sectors/track, 620181 cylinders, total 625142448 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Device Boot        Start            End                Blocks            
Id    System
/dev/sdc1            1                   526175         263087+        
83   Linux
/dev/sdc2            526176       789263          131544          82   
Linux swap / Solaris
/dev/sdc3            789264       625142448   312176592+ 89   Unknown]

disktype /dev/sdb:

--- /dev/sdb
Block device, size 298.1 GiB (320072933376 bytes)
DOS/MBR partition map
Partition 1: 256.9 MiB (269401600 bytes, 526175 sectors from 1)
   Type 0x83 (Linux)
   Ext3 file system
     UUID 02E4FD24-0781-46B3-B940-8389ADCED006 (DCE, v4)
     Volume size 256.8 MiB (269287424 bytes, 262976 blocks of 1 KiB)
   Linux RAID disk, version 0.90.1
     RAID1 set using 4 regular -2 spare disks
     RAID set UUID D774EADE-AF74-B140-7E3A-3815DA9DD6A1 (NCS)
Partition 2: 128.5 MiB (134701056 bytes, 263088 sectors from 526176)
   Type 0x82 (Linux swap / Solaris)
   Linux RAID disk, version 0.90.1
     RAID1 set using 4 regular 0 spare disks
     RAID set UUID 1C5B23CF-57FC-8CF6-C78D-D39F1BE32BF9 (MS GUID)
   Linux swap, version 2, subversion 1, 4 KiB pages, little-endian
     Swap size 128.5 MiB (134692864 bytes, 32884 pages of 4 KiB)
Partition 3: 297.7 GiB (319668830720 bytes, 624353185 sectors from 789264)
   Type 0x89 (Unknown)
   Linux RAID disk, version 0.90.1
     Linear set using 4 regular 0 spare disks
     RAID set UUID 9CF56E29-2D52-4F67-340A-E94ACCE8DE0C (NCS)

OK, so here is what I did so far:

losetup -v /dev/loop0 Disk0_Partition3.ddr
losetup -v /dev/loop1 Disk1_Partition3.ddr
losetup -v /dev/loop3 Disk3_Partition3.ddr

Then I tried to start the array with mdadm -v -A /dev/md0 /dev/loop{0,1,3}

mdadm output:

mdadm: looking for devices for /dev/md0
mdadm: /dev/loop0 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/loop1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/loop3 is identified as a member of /dev/md0, slot 3.
mdadm: added /dev/loop1 to /dev/md0 as 1
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: added /dev/loop3 to /dev/md0 as 3
mdadm: added /dev/loop0 to /dev/md0 as 0
mdadm: /dev/md0 assembled from 3 drives - not enough to start the array.

Additional information:
mdadm -E /dev/loop0 (same for loop1 and loop3):

/dev/loop0:
           Magic : a92b4efc
         Version : 0.90.01
            UUID : 296ef59c:674f522d:4ae90a34:0cdee8cc
   Creation Time : Mon Jun 30 12:54:30 2008
      Raid Level : linear
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 1

     Update Time : Mon Jun 30 12:54:30 2008
           State : active
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 351f715e - correct
          Events : 15

        Rounding : 64K

       Number   Major   Minor   RaidDevice State
this     0       8        3        0      active sync   /dev/sda3

    0     0       8        3        0      active sync   /dev/sda3
    1     1       8       19        1      active sync
    2     2       8       35        2      active sync
    3     3       8       51        3      active sync

Please help me out here recovering my data :)

Best regards,
Johannes Moos
