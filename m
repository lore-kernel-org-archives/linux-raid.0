From: Peter van Es <vanes.peter@gmail.com>
Subject: Help needed recovering from raid failure
Date: Mon, 27 Apr 2015 11:35:09 +0200
Message-ID: <4D8713B5-39E7-4EE2-898C-35DC0948B4CA@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for the long post...

I am running Ubuntu LTS 14.04.02 Server edition, 64 bits, with 4x 2.0TB drives in a raid-5 array.

The 4th drive was beginning to show read errors. Because it was weekend, I could not go out
and buy a spare 2TB drive to replace the one that was beginning to fail.

I first got a fail event:

This is an automatically generated mail message from mdadm
running on bali

A Fail event had been detected on md device /dev/md/1.

It could be related to component device /dev/sdd2.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md1 : active raid5 sdc2[2] sdb2[1] sda2[0] sdd2[3](F)
    5854290432 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]

md0 : active raid5 sdc1[2] sdd1[3] sdb1[1] sda1[0]
    5850624 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

And then subsequently, around 18 hours later:

This is an automatically generated mail message from mdadm
running on bali

A DegradedArray event had been detected on md device /dev/md/1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md1 : active raid5 sdc2[2] sdb2[1] sda2[0] sdd2[3](F)
    5854290432 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]

md0 : active raid5 sdc1[2] sdd1[3] sdb1[1] sda1[0]
    5850624 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

The server had taken the array off line at that point.

Needless to say, I can't boot the system anymore as the boot drive is /dev/md0, and GRUB can't
get at it. I do need to recover data (I know, but there's stuf on there I have no backup for--yet).

I booted Linux from a USB stick (which is on /dev/sdc1 hence changing the numbering),
in recovery mode. Below is the output of /proc/mdstat and 
mdadm --examine. It looks like somehow the /dev/sdd2 and /dev/sde2 drives took on the 
super block of the /dev/md127 device (my swap file). May that have been done by the boot from
the Ubuntu USB stick?

My plan... assemble a degraded array, with /dev/sde2 (the 4th drive, formerly known as /dev/sdd2) not in it.
Because the fail event put the file system in RO mode, I expect /dev/sdd2 (formerly /dev/sdc2) to be ok.
Then insert new 2TB drive in slot 4. Let system resync and recover.

I'm running xfs on the /dev/md1 device.

Questions:

1. is this the wise course of action ?
2. how exactly do I reassemble the array (/etc/mdadm.conf is inaccessible in recovery mode)
3. what command line options do I use exactly from the --examine output below without screwing things up

And help or pointers gratefully accepted

Peter van Es




/proc/mdstat (in recovery)

Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10] 
md126 : inactive sdb2[1](S) sda2[0](S)
     3902861312 blocks super 1.2

md127 : active raid5 sde2[5](S) sde1[3] sdb1[1] sda1[0] sdd1[2] sdd2[4](S)
     5850624 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>

mdadm --examine /dev/sd[abde]2 


/dev/sda2:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : 1f28f7bb:7b3ecd41:ca0fa5d1:ccd008df
          Name : ubuntu:1  (local to host ubuntu)
 Creation Time : Wed Apr  1 22:27:58 2015
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3902861312 (1861.03 GiB 1998.26 GB)
    Array Size : 5854290432 (5583.09 GiB 5994.79 GB)
 Used Dev Size : 3902860288 (1861.03 GiB 1998.26 GB)
   Data Offset : 262144 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : 713e556d:ca104217:785db68a:d820a57b

   Update Time : Sun Apr 26 05:59:13 2015
      Checksum : fda151f9 - correct
        Events : 18014

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : Active device 0
  Array State : AA.. ('A' == active, '.' == missing)

/dev/sdb2:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : 1f28f7bb:7b3ecd41:ca0fa5d1:ccd008df
          Name : ubuntu:1  (local to host ubuntu)
 Creation Time : Wed Apr  1 22:27:58 2015
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3902861312 (1861.03 GiB 1998.26 GB)
    Array Size : 5854290432 (5583.09 GiB 5994.79 GB)
 Used Dev Size : 3902860288 (1861.03 GiB 1998.26 GB)
   Data Offset : 262144 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : f1e79609:79b7ac23:55197f70:e8fbfd58

   Update Time : Sun Apr 26 05:59:13 2015
      Checksum : 696f4e76 - correct
        Events : 18014

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : Active device 1
  Array State : AA.. ('A' == active, '.' == missing)

/dev/sdd2:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
          Name : ubuntu:0  (local to host ubuntu)
 Creation Time : Wed Apr  1 22:27:42 2015
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3903121408 (1861.15 GiB 1998.40 GB)
    Array Size : 5850624 (5.58 GiB 5.99 GB)
 Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : 0f3f2b91:09cbb344:e52c4c4b:722d65c4

   Update Time : Mon Apr 27 08:37:15 2015
      Checksum : 7e241855 - correct
        Events : 26

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : spare
  Array State : AAAA ('A' == active, '.' == missing)

/dev/sde2:
         Magic : a92b4efc
       Version : 1.2
   Feature Map : 0x0
    Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
          Name : ubuntu:0  (local to host ubuntu)
 Creation Time : Wed Apr  1 22:27:42 2015
    Raid Level : raid5
  Raid Devices : 4

Avail Dev Size : 3903121408 (1861.15 GiB 1998.40 GB)
    Array Size : 5850624 (5.58 GiB 5.99 GB)
 Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
   Data Offset : 2048 sectors
  Super Offset : 8 sectors
         State : clean
   Device UUID : cdae3287:91168194:942ba99d:1a85c466

   Update Time : Mon Apr 27 08:37:15 2015
      Checksum : b8b529f3 - correct
        Events : 26

        Layout : left-symmetric
    Chunk Size : 512K

  Device Role : spare
  Array State : AAAA ('A' == active, '.' == missing)
