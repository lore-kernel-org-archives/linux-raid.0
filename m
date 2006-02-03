From: jurriaan <thunder7@xs4all.nl>
Subject: ludicrous speed: raid6 reconstruction
Date: Fri, 3 Feb 2006 22:15:58 +0100
Message-ID: <20060203211558.GA7559@amd64.of.nowhere>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [raid6] 
md0 : active raid6 sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      1465175424 blocks level 6, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]
      [==================>..]  resync = 91.0% (222239104/244195904) finish=0.0min speed=7369041K/sec
      bitmap: 23/233 pages [92KB], 512KB chunk
I am reminded of Spaceball's 'ludicrous speed' here. This is after a
reboot from 2.6.16-rc1-mm3 (where the array was built) to 2.6.16-rc1-mm5
(where rebuilding continued thanks to the bitmap).

/dev/md0:
        Version : 00.90.03
  Creation Time : Fri Feb  3 19:52:27 2006
     Raid Level : raid6
     Array Size : 1465175424 (1397.30 GiB 1500.34 GB)
    Device Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent
  Intent Bitmap : Internal
    Update Time : Fri Feb  3 21:53:55 2006
          State : active, resyncing
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
     Chunk Size : 64K
 Rebuild Status : 91% complete
           UUID : 128dc711:3f60812f:79b28619:8d0aa46d
         Events : 0.8
    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
Might I also add this bitmap idea is a GREAT thing to have!
Jurriaan
-- 
I will dedicate myself to the study of dangerous assumptions.
There is power in them, which the Nahia have neglected.
	Stephen R Donaldson - The Killing Stroke
Debian (Unstable) GNU/Linux 2.6.16-rc1-mm5 4427 bogomips load 6.27
