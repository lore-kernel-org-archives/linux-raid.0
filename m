From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: raidreconf won't resize a RAID 5 array. Can it be done with mkraid -f ?
Date: Mon, 17 May 2004 16:59:25 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00bf01c43c51$d697b2e0$0201a8c0@windows>
References: <200405172028.i4HKSkB08658@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I bit my tongue and tried doing a "mkraid -f /dev/md1" after ensuring that
my raidtab had the correct order of disks. The raid array did successfully
resize without any loss of data, and began to resync. My current status is:

cat /proc/mdstat

md1 : active raid5 hdc1[2] md0[1] hdg1[0]
      390382208 blocks level 5, 64k chunk, algorithm 0 [3/3] [UUU]
      [>....................]  resync =  3.7% (7268880/195191104)
finish=6181.6min speed=504K/sec
md0 : active linear hda3[2] hdi1[1] hdk1[0]
      195191168 blocks 128k rounding

Summary: I had a RAID 5 array that did not take up all available disk space
on the drives. I stopped the raid array, ensured that my raidtab was up to
date, and ran mkraid -f on the array. This overwrote the old array's
superblocks and created a new array on top of the old one that took up the
maximum available space and preserved the contents of the old array.

The output from raidreconf is very odd to me too. The size of the array is
incorrect. The size of the disks look pretty close, though. Here's the
output after I resized the array. Before I did it, everything was the same
except that the array was only approx 345102528 blocks.

root@darkstar:/home# fdisk -l /dev/hdg

Disk /dev/hdg: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdg1             1     24321 195358401   83  Linux

root@darkstar:/home# fdisk -l /dev/hdc

Disk /dev/hdc: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1             1     24321 195358401   fd  Linux raid autodetect

root@darkstar:/home# fdisk -l /dev/hdk

Disk /dev/hdk: 120.0 GB, 120034123776 bytes
255 heads, 63 sectors/track, 14593 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdk1             1     14593 117218241   83  Linux

root@darkstar:/home# fdisk -l /dev/hdi

Disk /dev/hdi: 46.1 GB, 46115758080 bytes
16 heads, 63 sectors/track, 89355 cylinders
Units = cylinders of 1008 * 512 = 516096 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdi1             1     89355  45034888+  83  Linux

root@darkstar:/home# fdisk -l /dev/hda

Disk /dev/hda: 40.0 GB, 40020664320 bytes
16 heads, 63 sectors/track, 77545 cylinders
Units = cylinders of 1008 * 512 = 516096 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1             1     10159   5120104+  83  Linux
/dev/hda2         10160     12191   1024128   82  Linux swap
/dev/hda3         12192     77545  32938416   83  Linux

root@darkstar:/home# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Sat May 15 13:07:11 2004
     Raid Level : linear
     Array Size : 195191168 (186.15 GiB 199.88 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat May 15 13:07:11 2004
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 128K

    Number   Major   Minor   RaidDevice State
       0      57        1        0      active sync   /dev/hdk1
       1      56        1        1      active sync   /dev/hdi1
       2       3        3        2      active sync   /dev/hda3
           UUID : f9f7071e:b673fea6:ff12b406:9bb0576a
         Events : 0.1

root@darkstar:/home# mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Mon May 17 11:19:55 2004
     Raid Level : raid5
     Array Size : 390382208 (372.30 GiB 399.75 GB)
    Device Size : 195191104 (186.15 GiB 199.88 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon May 17 11:19:55 2004
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 64K

 Rebuild Status : 5% complete

    Number   Major   Minor   RaidDevice State
       0      34        1        0      active sync   /dev/hdg1
       1       9        0        1      active sync   /dev/md0
       2      22        1        2      active sync   /dev/hdc1
           UUID : 5cf50002:0bcbc32e:07694ae5:d5735f48
         Events : 0.1


----- Original Message ----- 
From: Guy
To: 'TJ Harrell' ; linux-raid@vger.kernel.org
Sent: Monday, May 17, 2004 4:28 PM
Subject: RE: raidreconf won't resize a RAID 5 array. Can it be done with
mkraid -f ?


I don't understand the size of your array!
If you have 3 disks about 200G each, your RAID5 array should be about 400G.
But your array is 1171815940 blocks!  That's 1171G, about 3 times larger
than it should be.

Just to verify the size of the disks and the array, do these commands:
fdisk -l /dev/hdg
fdisk -l /dev/hdc
fdisk -l /dev/hdk
fdisk -l /dev/hdi
fdisk -l /dev/hda
cat /proc/mdstat
mdadm -D /dev/md0
mdadm -D /dev/md1

Guy



