From: David Greaves <david@dgreaves.com>
Subject: Help - this doesn't look good...
Date: Thu, 25 Nov 2004 13:05:27 +0000
Message-ID: <41A5D897.3010600@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sigh,

I'm having what might be xfs/nfsd conflicts and thought I'd reboot into 
an old 2.6.6 kernel which used to be stable.

Of course it spotted the fd partitions and tried to start the array.
It failed (the old kernel didn't have a driver for the new controller so 
some devices were missing)

However when I came back to 2.6.9 I get the rather conflicting status 
shown below.

It already mounted (xfs) but I unmounted quite quickly.
Can this do any harm?

Should I leave it to complete?
Can I safely remount?

My worry is that the kernel and mdadm think all the devices are 'up' and 
so may write to them and upset the resync (I suspect it thinks /dev/sdf1 
is dirty since that wasn't there under 2.6.6)

cu:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Sun Nov 21 21:36:49 2004
     Raid Level : raid5
     Array Size : 1225543680 (1168.77 GiB 1254.96 GB)
    Device Size : 245108736 (233.75 GiB 250.99 GB)
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Nov 25 12:51:46 2004
          State : dirty, resyncing
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 4096K

 Rebuild Status : 0% complete

           UUID : 44e121b0:6e3422b0:4d67f451:51df5ae0
         Events : 0.35500

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       3       65        4      active sync   /dev/hdb1
       5       8       81        5      active sync   /dev/sdf1

       6       8       65        -      spare   /dev/sde1
cu:~#
cu:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sdf1[5] sde1[6] sdd1[3] sdc1[2] sdb1[1] sda1[0] hdb1[4]
      1225543680 blocks level 5, 4096k chunk, algorithm 2 [6/6] [UUUUUU]
      [>....................]  resync =  0.3% (905600/245108736) 
finish=304.3min speed=13369K/sec
unused devices: <none>

