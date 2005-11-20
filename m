From: Remi Broemeling <rbroemeling@gmail.com>
Subject: Recovering a 4-disk RAID5 array from 2 clean disks and 2 spares
Date: Sun, 20 Nov 2005 02:23:48 -0700
Message-ID: <77c153970511200123xb1eb1f3qb8c4f5dc03eb1179@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have (had?) a 4-disk RAID5 array (/dev/md1), consisting of:

/dev/hda1
/dev/hdc1
/dev/hde1
/dev/hdg1

After some months of uptime, I had to reboot the system for a
non-related issue -- and when it came back up, the array was running
in degraded mode.  After further investigating, I had found that it
did not auto-add /dev/hdc1 to the RAID5 array because I had forgotten
to set it's type to 0xFD.  My bad.

I made up my mind to fix it, but didn't have the time at the moment
and so I shrugged, made a mental note of it, and re-added the drive to
the array manually with:

mdadm /dev/md1 -a /dev/hdc1

A `cat /proc/mdstat` showed me what I expected (that the array was
rebuilding), so I shrugged and went to do other things.

Some hours later, I returned to see that /dev/hdg1 had failed during
the rebuild process.  Now I have a completely snarfed array, with two
drives that mdadm sees as clean (/dev/hda1 and /dev/hde1), a
could-be-mostly-rebuilt-but-still-partial drive (/dev/hdc1) and a
corrupted-but-who-knows-how-badly drive (/dev/hdg1).

I was considering retiring the machine anyway, to be replaced with
something newer... so right now I just want to save anything that I
can off of the machine.  Is there any way for me to resurrect the
array and get some of my data off of it?

I tried the following, which I saw in the list archives:

mdadm -A /dev/md1 --uuid=a38910a6:51582805:6ccb5711:4ac501b2 --force
/dev/hdg1 /dev/hde1 /dev/hda1 /dev/hdc1

... but the response message was:

"mdadm: /dev/md1 assembled from 2 drives and 2 spares - not enough to
start the array."

Any help would be greatly appreciated.

mdadm --examine output for each of the involved partitions follows.

/dev/hdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a38910a6:51582805:6ccb5711:4ac501b2
  Creation Time : Mon Oct  4 14:48:20 2004
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Sun Nov 20 01:11:15 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : dfd92d15 - correct
         Events : 0.5800013

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     4      34        1        4      spare   /dev/hdg1

   0     0       3        1        0      active sync   /dev/hda1
   1     1       0        0        1      faulty removed
   2     2      33        1        2      active sync   /dev/hde1
   3     3       0        0        3      faulty removed
   4     4      34        1        4      spare   /dev/hdg1

/dev/hde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a38910a6:51582805:6ccb5711:4ac501b2
  Creation Time : Mon Oct  4 14:48:20 2004
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Sun Nov 20 01:11:15 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : dfd92d16 - correct
         Events : 0.5800013

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2      33        1        2      active sync   /dev/hde1

   0     0       3        1        0      active sync   /dev/hda1
   1     1       0        0        1      faulty removed
   2     2      33        1        2      active sync   /dev/hde1
   3     3       0        0        3      faulty removed
   4     4      34        1        4      spare   /dev/hdg1

/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a38910a6:51582805:6ccb5711:4ac501b2
  Creation Time : Mon Oct  4 14:48:20 2004
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1

    Update Time : Sun Nov 20 01:10:31 2005
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 2
       Checksum : dfd92d01 - correct
         Events : 0.5800012

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     5      22        1        5      spare   /dev/hdc1

   0     0       3        1        0      active sync   /dev/hda1
   1     1       0        0        1      faulty removed
   2     2      33        1        2      active sync   /dev/hde1
   3     3       0        0        3      faulty removed
   4     4      34        1        4      spare   /dev/hdg1
   5     5      22        1        5      spare   /dev/hdc1

/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a38910a6:51582805:6ccb5711:4ac501b2
  Creation Time : Mon Oct  4 14:48:20 2004
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 1

    Update Time : Sun Nov 20 01:11:15 2005
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : dfd92cf4 - correct
         Events : 0.5800013

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync   /dev/hda1

   0     0       3        1        0      active sync   /dev/hda1
   1     1       0        0        1      faulty removed
   2     2      33        1        2      active sync   /dev/hde1
   3     3       0        0        3      faulty removed
   4     4      34        1        4      spare   /dev/hdg1
