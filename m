From: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Subject: raid issues after power failure
Date: Fri, 30 Jun 2006 11:12:53 +0200 (CEST)
Message-ID: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have some issues reviving my raid5 array after a power failure. I'm
running gentoo Linux 2.6.16, and I have a raid5 array /dev/md0 if 4 disks,
/dev/sd[a-d]1. On top of this, I have a crypto devmap with LUKS.

After the power failure, the array sort of starts up and doesn't at the
same time:

# cat /proc/mdstat
Personalities : [raid5] [raid4]
unused devices: <none>
# mdadm -A /dev/md0
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
# cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : inactive sda1[0] sdd1[3] sdc1[2]
      1172126208 blocks

unused devices: <none>
# mdadm --query /dev/md0
/dev/md0: 0.00KiB raid5 4 devices, 0 spares. Use mdadm --detail for more
detail./dev/md0: is too small to be an md component.
# mdadm --query --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Apr 25 16:17:14 2006
     Raid Level : raid5
    Device Size : 390708736 (372.61 GiB 400.09 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun 29 09:10:39 2006
          State : active, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 8a66d568:0be5b0a0:93b729eb:6f23c014
         Events : 0.2701790

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        -      removed
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
#


so it's sort of strange that on one hand (in /proc/mdstat) it's inactive,
but according to mdstat it's active? also, mdstat --query says it's
0.00KiB in size?


also, on the mdadm -A /dev/md0 call, the following is written to the syslog:


Jun 30 11:10:22 tower md: md0 stopped.
Jun 30 11:10:22 tower md: bind<sdc1>
Jun 30 11:10:22 tower md: bind<sdd1>
Jun 30 11:10:22 tower md: bind<sda1>
Jun 30 11:10:22 tower md: md0: raid array is not clean -- starting
background reconstruction
Jun 30 11:10:22 tower raid5: device sda1 operational as raid disk 0
Jun 30 11:10:22 tower raid5: device sdd1 operational as raid disk 3
Jun 30 11:10:22 tower raid5: device sdc1 operational as raid disk 2
Jun 30 11:10:22 tower raid5: cannot start dirty degraded array for md0
Jun 30 11:10:22 tower RAID5 conf printout:
Jun 30 11:10:22 tower --- rd:4 wd:3 fd:1
Jun 30 11:10:22 tower disk 0, o:1, dev:sda1
Jun 30 11:10:22 tower disk 2, o:1, dev:sdc1
Jun 30 11:10:22 tower disk 3, o:1, dev:sdd1
Jun 30 11:10:22 tower raid5: failed to run raid set md0
Jun 30 11:10:22 tower md: pers->run() failed ...


strange - why wouldn't it take all four disks (it's omitting /dev/sdb1)?


Though probably these are very lame questions, I'd still appreciate any
help...


Akos

