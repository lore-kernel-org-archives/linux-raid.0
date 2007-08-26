From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Subject: degenerated raid5 array doesn't rebuild
Date: Sun, 26 Aug 2007 17:17:17 +0200
Message-ID: <1188141437.13134.13.camel@iap-neuro1.physik.uni-giessen.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I installed opensuse 10.3b2 on my server having 4 identical hard drives.
on each drive is an 290 gb partition used for raid5. It seems, that the
setup program created a degenerated array of sd[abc]2 and added the last
as a spare drive. mdadm -D /dev/md1 reports:

/dev/md1:
        Version : 01.00.03
  Creation Time : Sun Aug 26 14:23:29 2007
     Raid Level : raid5
     Array Size : 937488384 (894.06 GiB 959.99 GB)
  Used Dev Size : 624992256 (298.02 GiB 320.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Aug 26 17:12:52 2007
          State : active, degraded
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

           Name : 1
           UUID : 11c75eb5:f7281221:886b7d04:d46516e8
         Events : 4352

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       4       8       50        3      spare rebuilding   /dev/sdd2

and /proc/mdstat shows:

Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [linear] 
md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
      72248 blocks super 1.0 [4/4] [UUUU]
      bitmap: 0/9 pages [0KB], 4KB chunk

md1 : active raid5 sda2[0] sdd2[4] sdc2[2] sdb2[1]
      937488384 blocks super 1.0 level 5, 128k chunk, algorithm 2 [4/3]
[UUU_]
      bitmap: 6/299 pages [24KB], 512KB chunk

unused devices: <none>

There is no hard disk activity, so I guess md1 is not rebuildinh even if
mdadm states so. 
Is there a way to include the spare disk into the array? 
Why is this not done automaticaly?

Greetings

Marc

