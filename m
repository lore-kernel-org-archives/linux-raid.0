From: Andrew <andyukguy@gmail.com>
Subject: mdadm "Used Dev Size" on 3TB drives
Date: Fri, 21 Oct 2011 11:18:58 +0100
Message-ID: <1C43E501-9252-4502-BAC7-0C67C15DC68E@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

A fresh installation of mdadm in a raid1 profile on 2x3TB drives is reporting as follows:

/dev/md1:
        Version : 01.00
  Creation Time : Fri Oct 21 01:03:57 2011
     Raid Level : raid1
     Array Size : 2930147192 (2794.41 GiB 3000.47 GB)
  Used Dev Size : 5860294384 (5588.81 GiB 6000.94 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Oct 21 10:40:09 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : 1
           UUID : 639ae43a:c079a412:3a0be350:72ff20be
         Events : 46

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2

While everything looks in order I've not seen Used Dev Size report double the disk size before on a mdadm raid1 array. Indeed on the /boot partition (md0) on the same drives it doesn't:

/dev/md0:
        Version : 00.90
  Creation Time : Fri Oct 21 01:03:40 2011
     Raid Level : raid1
     Array Size : 115648 (112.96 MiB 118.42 MB)
  Used Dev Size : 115648 (112.96 MiB 118.42 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Oct 21 06:53:22 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : e4d1bc12:51cd306a:de6491bb:b01e719b
         Events : 0.18

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3

and on other arrays on different servers it doesn't for any partition. The only thing I can see is that (oddly) the version number of mdadm changes between the md0 and md1 array. Is this simply a bug in v01.00 or should I be worried about the array's functionality and integrity?

Further info:

Model: ATA Hitachi HDS72303 (scsi)
Disk /dev/sda: 3001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  3146kB  2097kB                     bios_grub
 3      3146kB  122MB   118MB   ext3               raid
 2      122MB   3001GB  3000GB  ext4               raid

Model: ATA Hitachi HDS72303 (scsi)
Disk /dev/sdb: 3001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  3146kB  2097kB                     bios_grub
 3      3146kB  122MB   118MB   ext3               raid
 2      122MB   3001GB  3000GB  ext4               raid

/dev/sda2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 639ae43a:c079a412:3a0be350:72ff20be
           Name : 1
  Creation Time : Fri Oct 21 01:03:57 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 5860294384 (2794.41 GiB 3000.47 GB)
     Array Size : 5860294384 (2794.41 GiB 3000.47 GB)
   Super Offset : 5860294640 sectors
          State : clean
    Device UUID : 0ed46f31:1b100aa1:e2933dd4:f93716c1

    Update Time : Fri Oct 21 11:17:42 2011
       Checksum : 22b01b3e - correct
         Events : 46


    Array Slot : 0 (0, 1)
   Array State : Uu

/dev/sdb2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 639ae43a:c079a412:3a0be350:72ff20be
           Name : 1
  Creation Time : Fri Oct 21 01:03:57 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 5860294384 (2794.41 GiB 3000.47 GB)
     Array Size : 5860294384 (2794.41 GiB 3000.47 GB)
   Super Offset : 5860294640 sectors
          State : clean
    Device UUID : f992deee:76530588:337f82d3:b18e523e

    Update Time : Fri Oct 21 11:17:42 2011
       Checksum : 439b5f8e - correct
         Events : 46


    Array Slot : 1 (0, 1)
   Array State : uU

Thanks.