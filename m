From: Stef Telford <stef@chronozon.artofdns.com>
Subject: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: 16 Apr 2003 19:53:14 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1050536716.13739.6.camel@testlin.hades>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


or rather not a 'rebuild'. 

The original problem was that one of the raid5 disks was
dead on waking up this morning, so, i used mdadm to set
it to fail, and then i set it removed. since it was software
raid5, i shut down the machine (sort of crazy with raid5
i know but) and then i put in a new 80gig drive and restarted
the machine, now, all i had to do was add back the drive
and then it should auto-rebuild. at least, thats the idea.



[root@survivor root]# mdadm --manage /dev/md0 -a
/dev/ide/host4/bus0/target0/lun0/part2
mdadm: add new device failed for /dev/ide/host4/bus0/target0/lun0/part2:
Device or resource busy

okay, so you probably would think that this device (or
/dev/hdi as its called short form) is being mounted or
used in someway, except i can assure you that its not.
this is the new disk and, yes, i have double checked
the actual device name ;>

this is under 2.5.67, under 2.5.62 it WOULD succeed however
the device would be inserted in location '0' in the raid
array rather than the empty (or -removed) slot. The output
from the raid5 is below:




[root@survivor root]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Dec 20 14:45:52 2002
     Raid Level : raid5
    Device Size : 58633216 (55.92 GiB 60.04 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Apr 15 17:45:24 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      33        6        0      active sync  
/dev/ide/host2/bus0/target0/lun0/part6
       1      34        1        1      active sync  
/dev/ide/host2/bus1/target0/lun0/part1
       2       0        0       -1      removed
       3      57        1        3      active sync  
/dev/ide/host4/bus1/target0/lun0/part1
           UUID : 5bced80a:8f74bfa6:3e658b6a:46a5055d
         Events : 0.1895


and for good measure, here is /proc/mdstat

[root@survivor root]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5]
md0 : inactive ide/host4/bus1/target0/lun0/part1[3]
ide/host2/bus1/target0/lun0/part1[1]
ide/host2/bus0/target0/lun0/part6[0]
      175900160 blocks
unused devices: <none>


any ideas/pointers ? i really would like the raid5
array back :D

regards 
Stef Telford <stef@chronozon.artofdns.com>

