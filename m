From: linux@horizon.com
Subject: Minor RAID-1 oddity... any way to fix?
Date: 4 Sep 2003 20:37:19 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030904203719.16703.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After /dev/hde glitched recently, I added it back into the arrays it's part of:

md7 : active raid1 hde2[0] hdi2[1]
      999872 blocks [2/2] [UU]
      
md3 : active raid1 hde3[2] hdi3[1]
      58612096 blocks [2/1] [_U]
      [====>................]  recovery = 21.1% (12401216/58612096) finish=36.6min speed=20987K/sec
md1 : active raid1 hde1[2] hdk1[5] hdi1[4] hdg1[3] hdc1[1] hda1[0]
      439360 blocks [6/6] [UUUUUU]

Notice that in md1 and md7, it took its usual drive number in sequence and is happy.
In md3, it got bumped up to drive 2, leaving the drive 0 number unassigned.

I tried removing /dev/md3 from the array, zeroing its raid superblock, and adding
it back in (mdadm /dev/md3 -a /dev/hde3), but it still lands on drive 2.

It's mostly a cosmetic complaint, but I'd like to understand why.  The mirror has
consisted of only the two partitions ever since it was created; there have been
no drive replacements or other fiddling around.

Superblocks are as follows:

/dev/hde3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : bd0220c6:5292b039:df73c602:3144ff8e
  Creation Time : Thu Dec 20 16:15:15 2001
     Raid Level : raid1
    Device Size : 58612096 (55.90 GiB 60.02 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 3

    Update Time : Thu Sep  4 15:58:41 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : -1
  Spare Devices : 3
       Checksum : 48722ee4 - correct
         Events : 0.127


      Number   Major   Minor   RaidDevice State
this     2      33        3        2      spare   /dev/hde3
   0     0       0        0        0      faulty removed
   1     1      56        3        1      active sync   /dev/hdi3
   2     2      33        3        2      spare   /dev/hde3
   3     0       0        0        0      spare
   4     0       0        0        0      spare

/dev/hdi3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : bd0220c6:5292b039:df73c602:3144ff8e
  Creation Time : Thu Dec 20 16:15:15 2001
     Raid Level : raid1
    Device Size : 58612096 (55.90 GiB 60.02 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 3

    Update Time : Thu Sep  4 15:58:41 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : -1
  Spare Devices : 3
       Checksum : 48722eff - correct
         Events : 0.127


      Number   Major   Minor   RaidDevice State
this     1      56        3        1      active sync   /dev/hdi3
   0     0       0        0        0      faulty removed
   1     1      56        3        1      active sync   /dev/hdi3
   2     2      33        3        2      spare   /dev/hde3
   3     0       0        0        0      spare
   4     0       0        0        0      spare

I'm not sure why the number of spare devices is 3.  There have never
been any spare devices.


(P.S. Does RAID work on 2.6 with a chunk size greater than 64K yet?
I tried it on one machine and the IDE driver got very unhappy being asked
to deal with "bio too big", which led to disk corruption.  I've been
avoiding it ever since.)
