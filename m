From: Michael McCallister <mike@mccllstr.com>
Subject: raid10,f2 Add a Controller: Which drives to move?
Date: Sun, 11 Apr 2010 17:08:30 +0000 (UTC)
Message-ID: <loom.20100411T185315-118@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have an existing raid10,f2 array with four drives, all running on a single
SATA controller.  I have a second controller to add to the system and I'd like
to split the existing drives between the two controllers.  I'm hoping to make
the configuration more robust against the possibility of a single controller
failure.  It would also be nice to get more performance out of the array, though
I doubt having a single controller is a bottleneck with only 4 7200RPM drives.

So with four drives sda, sdb, sdc, and sdd and two controllers C1 and C2, should
I go with

    C1: sda, sdb
    C2: sdc, sdd

or

    C1: sda, sdc
    C2: sdb, sdd

or some other configuration?

I've looked through the last six months of messages in the archives, and the
md(4) and mdadm(8) manpages, and the wiki on https://raid.wiki.kernel.org/ and
didn't see anything that quite answers this question at a level I can
understand.  If there is a reference I can consult, I'm happy to keep digging.

If it will help, the output of /proc/mdstat and "mdadm --detail" on the md
device are included below.


Mike McCallister


# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
[raid10]
md3 : active raid10 sda5[0] sdd5[3] sdc5[2] sdb5[1]
      1445318656 blocks super 1.1 256K chunks 2 far-copies [4/4] [UUUU]
      bitmap: 6/345 pages [24KB], 2048KB chunk

# mdadm --detail /dev/md3
/dev/md3:
        Version : 01.01.03
  Creation Time : Sun Nov  9 22:47:00 2008
     Raid Level : raid10
     Array Size : 1445318656 (1378.36 GiB 1480.01 GB)
  Used Dev Size : 1445318656 (689.18 GiB 740.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sun Apr 11 11:47:09 2010
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=1, far=2
     Chunk Size : 256K

           Name : ozark:3
           UUID : e7705941:e81cfbe1:7bf6ab9f:2b979a89
         Events : 84

    Number   Major   Minor   RaidDevice State
       0       8        5        0      active sync   /dev/sda5
       1       8       21        1      active sync   /dev/sdb5
       2       8       37        2      active sync   /dev/sdc5
       3       8       53        3      active sync   /dev/sdd5


