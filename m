From: Frank Corrao <fcorrao@temp555.com>
Subject: reshaping raid6 in-place
Date: Wed, 12 May 2010 19:10:35 -0400 (EDT)
Message-ID: <alpine.LRH.2.00.1005121857150.2432@appaloosa.temp555.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 5-disk raid5 array which I recently reshaped to raid6 while 
simultaneously adding a 6th disk.  mdadm (3.1.1) reported that the 
kernel I was running at the time (2.6.30) wasn't safe to perform the 
in-place portion of the reshaping.  The array was partitionally 
converted to raid6, but I believe the Q blocks are all on the last 
device I added.  mdadm seems to report the algorithm as 
left-symmetric-6 as opposed to left-symmetric.  Today I upgraded to 
2.6.32 and mdadm 3.1.2 and attempted to complete the re-shaping but ran 
into a snag:

$ sudo ./mdadm -v --grow /dev/md2 -l 6 -n 6 -p left-symmetric
mdadm: /dev/md2: Something wrong - reshape aborted

Is my syntax correct?

Frank





Relevant portion of /proc/mdstat:

md2 : active raid6 sda3[0] sde3[5] sdd3[4] sdf3[3] sdc3[2] sdb3[1]
       5721706496 blocks level 6, 1024k chunk, algorithm 18 [6/6] [UUUUUU]



$ sudo ./mdadm --detail /dev/md2
/dev/md2:
         Version : 0.90
   Creation Time : Mon Oct 19 14:15:33 2009
      Raid Level : raid6
      Array Size : 5721706496 (5456.64 GiB 5859.03 GB)
   Used Dev Size : 1430426624 (1364.16 GiB 1464.76 GB)
    Raid Devices : 6
   Total Devices : 6
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Wed May 12 19:05:51 2010
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric-6
      Chunk Size : 1024K

            UUID : 677f0016:b447937b:afdaf140:4080c53a
          Events : 0.16148

     Number   Major   Minor   RaidDevice State
        0       8        3        0      active sync   /dev/sda3
        1       8       19        1      active sync   /dev/sdb3
        2       8       35        2      active sync   /dev/sdc3
        3       8       83        3      active sync   /dev/sdf3
        4       8       51        4      active sync   /dev/sdd3
        5       8       67        5      active sync   /dev/sde3
