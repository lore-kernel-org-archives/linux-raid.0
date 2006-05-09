From: Maurice Hilarius <maurice@harddata.com>
Subject: strange RAID5 problem
Date: Mon, 08 May 2006 23:30:52 -0600
Message-ID: <4460290C.50202@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Good evening.

I am having a bit of a problem with a largish RAID5 set.
Now it is looking more and more like I am about to lose all the data on
it, so I am asking (begging?) to see if anyone can help me sort this out.


Here is the scenario: 16 SATA  disks connected to a pair of AMCC(3Ware)
9550SX-12 controllers.

RAID 5, 15 disks, plus 1 hot spare.

SMART started reporting errors on a disk, so it was retired with the
3Ware CLI, then removed and replaced.
The new disk had a JBOD signature added with the 3Ware CLI, then a
single large partition was created with fdisk.

At this point I would expect to be able to add the disk back to the
array by:
[root@box ~]# mdadm /dev/md3 -a /dev/sdw1

But, I get this error message:
mdadm: hot add failed for /dev/sdw1: No such device

What? We just made the partition on sdw a moment ago in fdisk. It IS there!

So. we look around a bit:
# /cat/proc/mdstat

md3 : inactive sdq1[0] sdaf1[15] sdae1[14] sdad1[13] sdac1[12] sdab1[11]
sdaa1[10] sdz1[9] sdy1[8] sdx1[7] sdv1[5] sdu1[4] sdt1[3] sds1[2]
sdr1[1]
      5860631040 blocks

Yup, that looks correct, missing sdw1[6]

Looking more:
# mdadm -D /dev/md3

/dev/md3:
        Version : 00.90.01
  Creation Time : Tue Jan 10 19:21:23 2006
     Raid Level : raid5
    Device Size : 390708736 (372.61 GiB 400.09 GB)
   Raid Devices : 16
  Total Devices : 15
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Mon May  8 19:33:36 2006
          State : active, degraded
 Active Devices : 15
Working Devices : 15
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           UUID : 771aa4c0:48d9b467:44c847e2:9bc81c43
         Events : 0.1818687

    Number   Major   Minor   RaidDevice State
       0      65        1        0      active sync   /dev/sdq1
       1      65       17        1      active sync   /dev/sdr1
       2      65       33        2      active sync   /dev/sds1
       3      65       49        3      active sync   /dev/sdt1
       4      65       65        4      active sync   /dev/sdu1
       5      65       81        5      active sync   /dev/sdv1
     609       0        0        0      removed
       7      65      113        7      active sync   /dev/sdx1
       8      65      129        8      active sync   /dev/sdy1
       9      65      145        9      active sync   /dev/sdz1
      10      65      161       10      active sync   /dev/sdaa1
      11      65      177       11      active sync   /dev/sdab1
      12      65      193       12      active sync   /dev/sdac1
      13      65      209       13      active sync   /dev/sdad1
      14      65      225       14      active sync   /dev/sdae1
      15      65      241       15      active sync   /dev/sdaf1

That also looks to be as expected.

So, lets try to assemble it again and force sdw1 in to it:

[root@box ~]# mdadm
--assemble /dev/md3 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1
/dev/sdv1 /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1
/dev/sdac1 /dev/sdad1 /dev/sdae1 /dev/sdaf1
mdadm: superblock on /dev/sdw1 doesn't match others - assembly aborted

[root@box ~]# mdadm
--assemble /dev/md3 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1
/dev/sdv1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
/dev/sdad1 /dev/sdae1 /dev/sdaf1
mdadm: failed to RUN_ARRAY /dev/md3: Invalid argument

[root@box ~]# mdadm
-A /dev/md3 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1
/dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
/dev/sdad1 /dev/sdae1 /dev/sdaf1
mdadm: device /dev/md3 already active - cannot assemble it

[root@box ~]# cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdb3[1] hda3[0]
      115105600 blocks [2/2] [UU]

md2 : active raid5 sdp1[15] sdo1[14] sdn1[13] sdm1[12] sdl1[11] sdk1[10]
sdj1[9] sdi1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
sda1[0]
      5860631040 blocks level 5, 256k chunk, algorithm 2 [16/16]
[UUUUUUUUUUUUUUUU]

md3 : inactive sdq1[0] sdaf1[15] sdae1[14] sdad1[13] sdac1[12] sdab1[11]
sdaa1[10] sdz1[9] sdy1[8] sdx1[7] sdv1[5] sdu1[4] sdt1[3] sds1[2]
sdr1[1]
      5860631040 blocks
md0 : active raid1 hdb1[1] hda1[0]
      104320 blocks [2/2] [UU]

unused devices: <none>

[root@box ~]# mdadm /dev/md3 -a /dev/sdw1
mdadm: hot add failed for /dev/sdw1: No such device

OK, let's mount the degraded RAID and try to copy the files to somewhere
else, so we can make it from scratch:

[root@box ~]# mount /dev/md3 /all/boxw16/
/dev/md3: Invalid argument
mount: /dev/md3: can't read superblock

[root@box ~]# fsck /dev/md3
fsck 1.35 (28-Feb-2004)
e2fsck 1.35 (28-Feb-2004)
fsck.ext2: Invalid argument while trying to open /dev/md3

The superblock could not be read..

[root@box ~]# mke2fs -n /dev/md3
mke2fs 1.35 (28-Feb-2004)
mke2fs: Device size reported to be zero.  Invalid partition specified,
or partition table wasn't reread after running fdisk, due to
a modified partition being busy and in use.  You may need to
reboot to re-read your partition table.


So, now what to do?

Any ideas would be DEEPLY appreciated !


-- 

Regards,
	Maurice

