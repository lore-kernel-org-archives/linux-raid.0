From: Jean-Rene Cormier <jrc@vgmidi.com>
Subject: Moving RAID 1 array to new server
Date: Mon, 10 Nov 2003 20:03:31 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1068509010.907.4.camel@forbidden.jrc.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just moved my RAID 1 array to a new server and I did the mistake of
moving only one disk at first to make sure that I would still have a
copy on the other server in case the new one couldn't read the array for
some reason. When I added the second disk it mark it as faulty or
something so I tried to remove it from the array and re-add it but it
added a spare drive instead. So now my array is running in degraded
mode, what can I do to so the second drive resync with the other one?

Here's the output of mdadm --detail /dev/md0:

/dev/md0:
        Version : 00.90.00
  Creation Time : Sat Mar  1 22:55:38 2003
     Raid Level : raid1
     Array Size : 60051456 (57.27 GiB 61.49 GB)
    Device Size : 60051456 (57.27 GiB 61.49 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Nov 10 16:50:06 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 1


    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1       0        0        1      faulty removed
           UUID : 97cdd679:0b676ca4:3d889120:566d5967
         Events : 0.27


Jean-Rene Cormier


