From: Peter Kay <syllopsium@syllopsium.co.uk>
Subject: Two disk RAID10 inactive on boot if partition is missing
Date: Tue, 17 May 2016 02:52:20 +0100
Message-ID: <CAN4OnogXN45Z3UUJyFzGgACPXuQMm1Gfw18kY9bjATrt5tvNqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a two disk RAID10 device consisting of a partition on one SSD
(/dev/sda12), and an entire other SSD (/dev/sdc). This is used to
create an mdraid device, acting as a cache for bcache.

This works fine if it boots up with the ssd and partition, and also if
one device goes offline whilst the system is still up, and then the
device is added again.

If the entire SSD device is missing on boot, the mdraid fails to exist
(/dev/md/mdcache is not present), saying it's inactive and the
partition device is a spare, thus causing the bcache to fail to exist
also.

One factor, that probably is not significant due to the metadata, is
that the dev/sdc will be mapped by the kernel to another disk if the
SSD does not exist on startup i.e. because the BIOS skips over it
/dev/sdc will now be a hard drive used by another disk array, not the
missing SSD. Shouldn't be a problem as the devices are not hardcoded :

I had no mdadm.conf, I've changed it to the following with no effect :

DEVICE /dev/sda12 /dev/sd*
ARRAY /dev/md/mdcache  metadata=1.2
UUID=e634085b:95d697c9:7a422bc2:c94b142d name=gladstone:mdcache
ARRAY /dev/md/mdbigraid  metadata=1.2
UUID=b5d09362:28d19835:21556221:36531da3 name=gladstone:mdbigraid

uname -a

Linux gladstone 4.5.2-xen #1 SMP PREEMPT Wed Apr 27 02:12:36 BST 2016
x86_64 Intel(R) Core(TM)2 Quad CPU    Q6700  @ 2.66GHz GenuineIntel
GNU/Linux

(This is a Xen dom0. Have tried with an earlier Linux kernel, under
bare metal : no difference)

/dev/md/mdcache:
        Version : 1.2
  Creation Time : Sun Apr 10 22:51:53 2016
     Raid Level : raid10
     Array Size : 117151744 (111.72 GiB 119.96 GB)
  Used Dev Size : 117151744 (111.72 GiB 119.96 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue May 17 01:14:29 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : far=2
     Chunk Size : 512K

           Name : gladstone:mdcache  (local to host gladstone)
           UUID : e634085b:95d697c9:7a422bc2:c94b142d
         Events : 125

    Number   Major   Minor   RaidDevice State
       0       8       12        0      active sync   /dev/sda12
       2       8       32        1      active sync   /dev/sdc

A cat /proc/mdstat when it's working

(yes, testing a rebuild of another four disk raid10)

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md126 : active raid10 sdf[0] sde[4] sdb[3] sdd[2]
      1953261568 blocks super 1.2 512K chunks 2 offset-copies [4/3] [U_UU]
      [=====>...............]  recovery = 25.0% (244969472/976630784)
finish=213.5min speed=57106K/sec

md127 : active raid10 sda12[0] sdc[2]
      117151744 blocks super 1.2 512K chunks 2 far-copies [2/2] [UU]

unused devices: <none>

mdadm --examine of the partition

/dev/sda12:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e634085b:95d697c9:7a422bc2:c94b142d
           Name : gladstone:mdcache  (local to host gladstone)
  Creation Time : Sun Apr 10 22:51:53 2016
     Raid Level : raid10
   Raid Devices : 2

 Avail Dev Size : 234305410 (111.73 GiB 119.96 GB)
     Array Size : 117151744 (111.72 GiB 119.96 GB)
  Used Dev Size : 234303488 (111.72 GiB 119.96 GB)
    Data Offset : 131072 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 35309acc:c28c8b78:360f2d49:e87870db

    Update Time : Tue May 17 01:29:23 2016
       Checksum : 90634a13 - correct
         Events : 125

         Layout : far=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)

and disk

/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e634085b:95d697c9:7a422bc2:c94b142d
           Name : gladstone:mdcache  (local to host gladstone)
  Creation Time : Sun Apr 10 22:51:53 2016
     Raid Level : raid10
   Raid Devices : 2

 Avail Dev Size : 234310576 (111.73 GiB 119.97 GB)
     Array Size : 117151744 (111.72 GiB 119.96 GB)
  Used Dev Size : 234303488 (111.72 GiB 119.96 GB)
    Data Offset : 131072 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 76c6dba4:36e4a87a:ff54f25d:9e7a8970

    Update Time : Tue May 17 02:09:25 2016
       Checksum : 14a09cd9 - correct
         Events : 125

         Layout : far=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)

The partition was of type 83. I have changed to type FD with no difference.


Any clues? I can blow this away/change the disk (sdc) to be a
partition so the raid isn't using a partition and a disk if necessary,
but I can't see why it shouldn't work and would rather get to the root
cause.

If I tell mdam to activate the raid I get no errors, and nothing happens.

Cheers!

PK
