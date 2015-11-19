From: Nathan Peterson <nathan@uwgrads.com>
Subject: Ubuntu crashed during RAID6 grow
Date: Thu, 19 Nov 2015 21:37:46 +0000 (UTC)
Message-ID: <loom.20151119T222250-428@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello All,

I was attempting to add another hdd to my RAID6.  At about 4% into the 
operation the computer froze and crashed.  After rebooting and finding 
out it was a CPU overheating issue I fixed that.  The array now shows as 
the new drive has been officially added.  That cannot be possible.  I am 
hoping to get help on assembling this array properly so I can mount and 
see my data again.

The details:

Ubuntu 12.04.4 LTS (GNU/Linux 3.8.0-31-generic x86_64)
mdadm - v3.2.5 - 18th May 2012

Details before the grow:
cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md127 : active raid6 sdo1[12](S) sdn1[11](S) sdg1[10] sdi1[1] sdj1[2] 
sdh1[0] sdk1[4] sdl1[3] sdf1[9] sde1[8]
      11720291328 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[8/8] [UUUUUUUU]

/dev/md127:
        Version : 1.2
  Creation Time : Fri Nov  1 07:52:30 2013
     Raid Level : raid6
     Array Size : 11720291328 (11177.34 GiB 12001.58 GB)
  Used Dev Size : 1953381888 (1862.89 GiB 2000.26 GB)
   Raid Devices : 8
  Total Devices : 10
    Persistence : Superblock is persistent

    Update Time : Wed Nov 11 17:20:05 2015
          State : clean
 Active Devices : 8
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 512K

           Name : lithia:6  (local to host lithia)
           UUID : 62373b29:22c2640c:33b5a642:9b079bff
         Events : 656743

    Number   Major   Minor   RaidDevice State
       0       8      113        0      active sync   /dev/sdh1
       1       8      129        1      active sync   /dev/sdi1
       2       8      145        2      active sync   /dev/sdj1
       3       8      177        3      active sync   /dev/sdl1
       4       8      161        4      active sync   /dev/sdk1
      10       8       97        5      active sync   /dev/sdg1
       8       8       65        6      active sync   /dev/sde1
       9       8       81        7      active sync   /dev/sdf1

      11       8      209        -      spare   /dev/sdn1
      12       8      225        -      spare   /dev/sdo1

Details after the grow:
Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] 
[raid1] [raid10]
md126 : active (auto-read-only) raid6 sdj1[2] sdl1[3] sdf1[9] sdn1[11]
(S) sdi1[1] sdg1[10] sde1[8] sdh1[0] sdk1[4] sdo1[12]
      11720291328 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[9/9] [UUUUUUUUU]

/dev/md126:
        Version : 1.2
  Creation Time : Fri Nov  1 07:52:30 2013
     Raid Level : raid6
     Array Size : 11720291328 (11177.34 GiB 12001.58 GB)
  Used Dev Size : 1953381888 (1862.89 GiB 2000.26 GB)
   Raid Devices : 9
  Total Devices : 10
    Persistence : Superblock is persistent

    Update Time : Sat Nov 14 05:14:17 2015
          State : clean
 Active Devices : 9
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

  Delta Devices : 1, (8->9)

           Name : lithia:6  (local to host lithia)
           UUID : 62373b29:22c2640c:33b5a642:9b079bff
         Events : 657251

    Number   Major   Minor   RaidDevice State
       0       8      113        0      active sync   /dev/sdh1
       1       8      129        1      active sync   /dev/sdi1
       2       8      145        2      active sync   /dev/sdj1
       3       8      177        3      active sync   /dev/sdl1
       4       8      161        4      active sync   /dev/sdk1
      10       8       97        5      active sync   /dev/sdg1
       8       8       65        6      active sync   /dev/sde1
       9       8       81        7      active sync   /dev/sdf1
      12       8      225        8      active sync   /dev/sdo1

      11       8      209        -      spare   /dev/sdn1


Sadly, there was no --backup-file created during the grow.

Please let me know if you need more details/information.  Anything would 
be greatly appreciated.  Sorry if this has been asked before or I come 
off as a dunce.

-Nathan

