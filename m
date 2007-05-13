From: evoltech@2inches.com
Subject: /proc/mdstat showing a device missing from array
Date: Sun, 13 May 2007 11:33:54 -0700
Message-ID: <1179081234.46475a12d46ba@mail.2inches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Hello all,

I just set up a new raid 5 array of 4 750G disks and am having a strange
experience where /proc/mdstat is showing that one device is missing from the
array.  The output from a "--detail" shows that there is some unnamed device
that has been removed from the array and I don't understand why or how to fix
it.  Can someone please shed some light?

kernel version: 2.6.20-1.2312.fc5xen0 (this is a fedora core 5 prebuilt kernel)
mdadm version: mdadm - v2.3.1 - 6 February 2006

[root@storage ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md2 : active raid5 sdg[4] sdf[2] sde[1] sdd[0]
      2197723392 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

[root@storage ~]# mdadm --query --detail /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Sat May 12 17:22:30 2007
     Raid Level : raid5
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
    Device Size : 732574464 (698.64 GiB 750.16 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sun May 13 04:07:57 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 6a0d59e6:e00ec820:d08e477f:3b7ef9bc
         Events : 0.68

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd
       1       8       64        1      active sync   /dev/sde
       2       8       80        2      active sync   /dev/sdf
       0       0        0        0      removed

       4       8       96        4      active sync   /dev/sdg
