From: "Brian Bonner" <bkbonner@gmail.com>
Subject: How does md determine which partitions to use in RAID1 when DEVICE partitions is specified
Date: Mon, 3 Jul 2006 16:27:57 -0400
Message-ID: <e0904ff40607031327o5fd9fcc6v9b431656d5a01d02@mail.gmail.com>
Reply-To: bkbonner@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have Fedora Core 5 installed with mirroring on the Boot partition
and root partition.  I created a Logical Volume Group on the mirrored
root partition.

How does md figure out which partitions are actually specified.  It
says it stores the uuid in the superblock, but I can't seem to figure
out where this is, or how to get it.  is it in the partition, or
volume.

The reason I'm asking this, I'd like to add two USB 2.0 drives that
are mirrored, and I would specify the device name (/dev/sdd, /dev/sde)
for the ARRAY, but I found that the allocation of these device names
is dependent upon when the drive is inserted into the USB.

I'm going to ask if there is a way to "lock" the volume names for
devices (I'm thinking by UUID) for USB devices in partitions.

Thanks.

Brian

Here's more details:

These mirrors were created by anaconda at installation and the
mdadm.conf file is as follows:

# mdadm.conf written out by anaconda
DEVICE partitions
MAILADDR root
ARRAY /dev/md2 level=raid1 num-devices=2 uuid=a94ec909:c3c5386b:5e8b311e:6eea3fb
4
ARRAY /dev/md0 level=raid1 num-devices=2 uuid=11118406:0792eb6b:aa28aac9:6217b69
5
ARRAY /dev/md1 level=raid1 num-devices=2 uuid=0e5beeb3:49ffc108:4b09e081:5966b20
c


When I look at partitions, I see:

[root@test ~]# more /proc/partitions
major minor  #blocks  name

   8     0   78125000 sda
   8     1     200781 sda1
   8     2    2096482 sda2
   8     3   75826800 sda3
   8    16   78125000 sdb
   8    17     200781 sdb1
   8    18    2096482 sdb2
   8    19   75826800 sdb3
   9     2   75826688 md2
   9     1    2096384 md1
   9     0     200704 md0
 253     0    8388608 dm-0
 253     1   21168128 dm-1
 253     2    8388608 dm-2
 253     3   21069824 dm-3
 253     4   16777216 dm-4



[root@test ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Fri Apr 28 22:22:55 2006
     Raid Level : raid1
     Array Size : 200704 (196.03 MiB 205.52 MB)
    Device Size : 200704 (196.03 MiB 205.52 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jun 21 07:14:49 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 11118406:0792eb6b:aa28aac9:6217b695
         Events : 0.108

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1



[root@test ~]# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Fri Apr 28 22:22:45 2006
     Raid Level : raid1
     Array Size : 2096384 (2047.59 MiB 2146.70 MB)
    Device Size : 2096384 (2047.59 MiB 2146.70 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu May 25 14:05:53 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 0e5beeb3:49ffc108:4b09e081:5966b20c
         Events : 0.8

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2


[root@test ~]# mdadm --detail /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Fri Apr 28 22:22:43 2006
     Raid Level : raid1
     Array Size : 75826688 (72.31 GiB 77.65 GB)
    Device Size : 75826688 (72.31 GiB 77.65 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon Jul  3 16:29:17 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : a94ec909:c3c5386b:5e8b311e:6eea3fb4
         Events : 0.2922997

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3




[root@test ~]# dumpe2fs -h /dev/sda1
dumpe2fs 1.38 (30-Jun-2005)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          3da31122-c5d8-41a7-94dd-366fc8730640
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype n
eeds_recovery sparse_super
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              50200
Block count:              200704
Reserved block count:     10035
Free blocks:              179287
Free inodes:              50164
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      256
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         2008
Inode blocks per group:   251
Filesystem created:       Fri Apr 28 22:22:56 2006
Last mount time:          Wed Jun 21 07:14:49 2006
Last write time:          Wed Jun 21 07:14:49 2006
Mount count:              7
Maximum mount count:      -1
Last checked:             Fri Apr 28 22:22:56 2006
Check interval:           0 (<none>)
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Journal inode:            8
Default directory hash:   tea
Directory Hash Seed:      4399f9cb-2032-4b72-8ef1-baec0ba451c0
Journal backup:           inode blocks
