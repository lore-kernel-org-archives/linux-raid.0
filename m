From: Brad Campbell <brad@fnarfbargle.com>
Subject: Problem with DISCARD and RAID10
Date: Tue, 06 Nov 2012 17:32:26 +0800
Message-ID: <5098D92A.3000503@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

G'day Shaohua,

I'm testing Vanilla 3.7.0-rc4 and bumping up against squillions of these :

[   41.094726] request botched: dev sdc: type=1, flags=122d8081
[   41.094774]   sector 28317178, nr/cnr 0/32
[   41.094815]   bio ffff8807fe885300, biotail ffff8807fe887300, buffer 
           (null), len 0
[   41.100045] request botched: dev sda: type=1, flags=122d8081
[   41.100094]   sector 28317403, nr/cnr 0/32
[   41.100134]   bio ffff8807fe885840, biotail ffff8807fe887840, buffer 
           (null), len 0
[   41.100718] request botched: dev sdb: type=1, flags=122d8081
[   41.100767]   sector 28317179, nr/cnr 0/224
[   41.100808]   bio ffff8807fe885a80, biotail ffff8807fe887d80, buffer 
           (null), len 0
[   41.104649] request botched: dev sdc: type=1, flags=122d8081
[   41.104697]   sector 28317179, nr/cnr 0/224
[   41.104738]   bio ffff8807fe886000, biotail ffff8807fe887300, buffer 
           (null), len 0

This is a staging system that is eventually intended for production use, 
however it's not important at the moment and might make a good test mule 
for a while.

I'll lay out my whole background and config.

I have 6 x 240GB SSD on a test bench (3 Intel 330 & 3 Samsung 830). I 
have the three Samsung connected to the on-board AHCI ports and I have 
the three Intel on a Marvell PCIe board serviced by sata_mv.

System is an AMD FX8350 with 32G ram. Kernel is X86_64. Nothing else of 
note.

All drives pass individual read/write and filesystem trim tests (if I 
just create the filesystem on the individual drive).

All six drives are partitioned identically.

root@test:~# sfdisk -d /dev/sda
# partition table of /dev/sda
unit: sectors

/dev/sda1 : start=       63, size=   273042, Id=83, bootable
/dev/sda2 : start=   273105, size=419441085, Id=83
/dev/sda3 : start=        0, size=        0, Id= 0
/dev/sda4 : start=        0, size=        0, Id= 0


Partition 1 on all drives is a bootable 6 way RAID-1 and not relevant 
here (gets mounted as /boot and is ext2).

The second partitions are configured in a RAID10 near 2, so there are 
three pairs of mirrors that are striped together (Intel/Samsung x 3).

root@test:~# mdadm --detail /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Thu Nov  1 20:11:38 2012
      Raid Level : raid10
      Array Size : 628767744 (599.64 GiB 643.86 GB)
   Used Dev Size : 209589248 (199.88 GiB 214.62 GB)
    Raid Devices : 6
   Total Devices : 6
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Nov  6 17:07:13 2012
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=2
      Chunk Size : 128K

            Name : test:2  (local to host test)
            UUID : abe7511b:5eb834e1:f425f2a9:3d3ebd56
          Events : 842

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       66        1      active sync   /dev/sde2
        2       8       18        2      active sync   /dev/sdb2
        3       8       82        3      active sync   /dev/sdf2
        4       8       34        4      active sync   /dev/sdc2
        5       8       98        5      active sync   /dev/sdg2


The array is partitioned :
root@test:~# sfdisk -d /dev/md2
# partition table of /dev/md2
unit: sectors

/dev/md2p1 : start=     3072, size= 41942016, Id=83
/dev/md2p2 : start= 41945088, size= 83887104, Id=83
/dev/md2p3 : start=125832192, size=1131703296, Id=83
/dev/md2p4 : start=        0, size=        0, Id= 0

All three partitions are default ext4 created with mke2fs -t ext4 /dev/blah

The Intel drives support :
            *    Data Set Management TRIM supported (limit 1 block)
            *    Deterministic read data after TRIM

The Samsung Drives support :
            *    Data Set Management TRIM supported (limit 8 blocks)

I don't use, test or intend to use discard as a filesystem option, 
however on my other machines (with single or multiple non-RAID ssd's) I 
batch fun fstrim once a week or so.

Kernel version is vanilla git 3.7.0-rc4.

When I run fstrim on a partition in the array :

ie fstrim -v /home (where /home is on /dev/md2p2)

I get a dmesg full of the messages quoted at the top of the mail.

I did see some data corruption on one of the partitions that required a 
re-format and re-load at one point, but I have been unable to reproduce 
that.

As this is a test system, a complete reformat and reload is mostly 
automated and therefore loss or corruption is of little overall consequence.

Please let me know if there is anything I can do to assist.

Regards,
Brad
