From: Nathan Hunsperger <linux-raid@hunsperger.com>
Subject: Forcing a disk online
Date: Fri, 9 Jan 2004 16:40:54 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040110004054.GB3322@munchnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello -

I'm not finding any documentation on forcing disks back online after
they are marked as failed, and could use some help on this.

Specifically, I have a 14 disk software raid5 array, which suffered
2 disks failing (the second failed during the resync).  Because the
first disk was failed for several hours of disk activity, it obviously
doesn't have up-to-date information on it, and it is currently marked
as removed.  The second disk seems to have only an 8K area of the disk
(in the middle) that cannot be read.  I have dd'd the disk to a spare,
and would like to put the disk online in place of the 2nd disk.

However, I don't see any way to 'force a disk online' like you can on
hardware raid.  How can I change the status?  If I can force the disk
online, I should be able to mount the array in degraded mode, and
recover most everything, except for the data that lies on the stripe
using those 8K.

Any help would be appreciated.
- Nathan
CSUA, UC Berkeley

Below is the output I have from looking at the status of each drive.
The very last disk is the partially rebuilt replacement for Raid
Device 7.  I need to mark RaidDevice 8 as active.

screwdriver:~# mdadm --examine /dev/scsi/host4/bus0/target1/lun0/part1
/dev/scsi/host4/bus0/target1/lun0/part1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 783f1b1d:be8dfcb6:9ff5a8df:54164efd
  Creation Time : Thu Jul 24 02:43:26 2003
     Raid Level : raid5
    Device Size : 35005504 (33.38 GiB 35.85 GB)
   Raid Devices : 14
  Total Devices : 15
Preferred Minor : 0

    Update Time : Thu Jan  8 20:37:35 2004
          State : dirty, no-errors
 Active Devices : 12
Working Devices : 13
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 553968b6 - correct
         Events : 0.16

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      65        1        1      active sync /dev/scsi/host4/bus0/target1/lun0/part1
   0     0       8      241        0      active sync /dev/scsi/host4/bus0/target0/lun0/part1
   1     1      65        1        1      active sync /dev/scsi/host4/bus0/target1/lun0/part1
   2     2      65       17        2      active sync /dev/scsi/host4/bus0/target2/lun0/part1
   3     3      65       33        3      active sync /dev/scsi/host4/bus0/target3/lun0/part1
   4     4      65       49        4      active sync /dev/scsi/host4/bus0/target4/lun0/part1
   5     5      65       65        5      active sync /dev/scsi/host4/bus0/target5/lun0/part1
   6     6      65       81        6      active sync /dev/scsi/host4/bus0/target6/lun0/part1
   7     7       0        0        7      faulty removed
   8     8      65      113        8      faulty /dev/scsi/host4/bus0/target8/lun0/part1
   9     9      65      129        9      active sync /dev/scsi/host4/bus0/target9/lun0/part1
  10    10      65      145       10      active sync /dev/scsi/host4/bus0/target10/lun0/part1
  11    11      65      161       11      active sync /dev/scsi/host4/bus0/target11/lun0/part1
  12    12      65      177       12      active sync /dev/scsi/host4/bus0/target12/lun0/part1
  13    13      65      193       13      active sync /dev/scsi/host4/bus0/target13/lun0/part1
  14    14      65       97       14 /dev/scsi/host4/bus0/target7/lun0/part1

