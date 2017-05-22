From: Roger Heflin <rogerheflin@gmail.com>
Subject: raid5 to raid6 reshape never appeared to start, how to cancel/revert
Date: Mon, 22 May 2017 13:57:44 -0500
Message-ID: <CAAMCDefCqUCY4Pd5im1u-JPh_SLG6BG8Onb8JxuPwoAkgXOkrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had a 3 disk raid5 with a hot spare.  I ran this:
mdadm --grow /dev/md126 --level=6 --backup-file /root/r6rebuild

I suspect I should have changed the number of devices in the above command to 4.

The reshape "started" according to /proc/mdstat but never got past
block 1, and the time to complete started going up.  I did stop the
array and have tried to do a revert-reshape but it indicates it will
only revert a number of devices change.

The backup-file was created on a separate ssd.

trying assemble now gets this:
 mdadm --assemble /dev/md126 /dev/sd[abe]1 /dev/sdd
--backup-file=/root/r6rebuild
mdadm: Failed to restore critical section for reshape, sorry.

examine shows this (sdd was the spare when the --grow was issues)
 mdadm --examine /dev/sdd
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.91.00
           UUID : 2fb920b1:ce7407fd:dd1a1aa6:74dcda71
  Creation Time : Wed May 19 19:04:03 2010
     Raid Level : raid6
  Used Dev Size : 488384384 (465.76 GiB 500.11 GB)
     Array Size : 976768768 (931.52 GiB 1000.21 GB)


   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 126

  Reshape pos'n : 0
     New Layout : left-symmetric

    Update Time : Mon May 22 09:25:38 2017
          State : clean
Internal Bitmap : present
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bc406f24 - correct
         Events : 6140735

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       48        3      active   /dev/sdd

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8        1        2      active sync   /dev/sda1
   3     3       8       48        3      active   /dev/sdd

mdadm-3.4-2.fc25.x86_64

kernel 4.10.15.200 fc25 fully updated as of 2 days ago.

Examine seems to indicate that the reshape never stopped but the
revert is unable to cancel this grow even though it did not start at
all.

The data is not super critical I don't believe I lose anything as this
one is being used primarily for backups.

It does appear that I added sdd rather than sdd1 but I don't believe
that is anything critical to the issue as it should still work fine
with the entire disk.

Ideas on how to abort the reshape that never started or how to get it
to continue?   The desired final target is a 4 disk raid6.  I have not
as of yet rebooted.
