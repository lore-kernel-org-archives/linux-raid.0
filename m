From: Andreas-Sokov <andre.s@j8.com.ru>
Subject: mdadm 2.6.4 : How i can check out current status of reshaping ?
Date: Mon, 4 Feb 2008 07:08:02 +0300
Message-ID: <79188012.20080204070802@j8.com.ru>
Reply-To: Andreas-Sokov <andre.s@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi linux-raid.

on DEBIAN :

root@raid01:/# mdadm -D /dev/md1
/dev/md1:
        Version : 00.91.03
  Creation Time : Tue Nov 13 18:42:36 2007
     Raid Level : raid5
     Array Size : 1465159488 (1397.29 GiB 1500.32 GB)
  Used Dev Size : 488386496 (465.76 GiB 500.11 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Feb  4 06:51:47 2008
          State : clean, degraded
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

  Delta Devices : 1, (4->5)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          UUID : 4fbdc8df:07b952cf:7cc6faa0:04676ba5
         Events : 0.683598

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf
       4       0        0        4      removed

       5       8       16        -      spare   /dev/sdb



root@raid01:/# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty]
md1 : active raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
      1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]

unused devices: <none>

##############################################################################
But how i can see the status of reshaping ?
Is it reshaped realy ? or may be just hang up ? or may be mdadm nothing do not give in
general ?
How long wait when reshaping will finish ?
##############################################################################




-- 
Best regards,
Andreas-Sokov

