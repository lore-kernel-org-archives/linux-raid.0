From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Which (physical) disk is broken?
Date: Wed, 22 Dec 2004 11:39:12 -0500
Message-ID: <200412221639.iBMGdH911479@www.watkins-home.com>
References: <87ekhj6h88.fsf@pumba.bayour.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ekhj6h88.fsf@pumba.bayour.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Turbo Fredriksson' <turbo@bayour.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since it was removed, it is not a disk.  It is no disk.
The question is: what disk was it?

You could determine which disks it is not!
If you access your array, every disk in it will have disk activity.
The disks that do not have activity are not in the array.
If you have more arrays, you would need to determine which disks they use
also.
If you have non array disks, you will need to identify them also.
Once all but one disk is identified, it must be your disk.

Use a command like this to cause your disks to have activity, then look for
the blinking lights:
dd if=/dev/md/1 of=/dev/null bs=64k

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Turbo Fredriksson
Sent: Tuesday, December 21, 2004 6:09 AM
To: linux-raid@vger.kernel.org
Subject: Which (physical) disk is broken?

I've forgot, and I can't seem to find out which physical disk
is broken/removed from an array...

----- s n i p -----
aurora:~# mdadm -D /dev/md/1
/dev/md/1:
        Version : 00.90.01
  Creation Time : Wed Oct 27 08:12:44 2004
     Raid Level : raid5
     Array Size : 141483520 (134.93 GiB 144.88 GB)
    Device Size : 17685440 (16.87 GiB 18.11 GB)
   Raid Devices : 9
  Total Devices : 8
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Dec 21 12:04:43 2004
          State : dirty, degraded
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync
/dev/scsi/host3/bus0/target4/lun0/part1
       1       8       81        1      active sync
/dev/scsi/host3/bus0/target8/lun0/part1
       2       8       97        2      active sync
/dev/scsi/host3/bus0/target9/lun0/part1
       3       8      241        3      active sync
/dev/scsi/host4/bus0/target4/lun0/part1
       4      65        1        4      active sync
/dev/scsi/host4/bus0/target5/lun0/part1
       5      65       17        5      active sync
/dev/scsi/host4/bus0/target8/lun0/part1
       6      65       33        6      active sync
/dev/scsi/host4/bus0/target9/lun0/part1
       7      65      113        7      active sync
/dev/scsi/host4/bus0/target14/lun0/part1
       8       0        0       -1      removed
           UUID : d0b4e775:290f5785:2e6ad7d1:5a66178b
         Events : 0.974012
----- s n i p -----

I _THINK_ (!!) it's '/dev/scsi/host4/bus0/target15/lun0/part', but
I'm not sure.... Don't want to yank a perfectly working disk :)

----- s n i p -----
aurora:~# mdadm -E /dev/scsi/host4/bus0/target15/lun0/part1
mdadm: No super block found on /dev/scsi/host4/bus0/target15/lun0/part1
(Expected magic a92b4efc, got 00000000)
----- s n i p -----

Is there any way I can find out exactly which disk 'number 8' is?

----- s n i p -----
aurora:~# mdadm --version
mdadm - v1.6.0 - 4 June 2004
aurora:~# uname -a
Linux aurora 2.6.8.1 #1 SMP Sun Dec 12 21:04:58 CET 2004 sparc64 unknown
----- s n i p -----
-- 
Ortega assassination explosion FBI president PLO Iran domestic
disruption genetic Ft. Bragg Rule Psix $400 million in gold bullion
Clinton Cocaine Treasury
[See http://www.aclu.org/echelonwatch/index.html for more about this]
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

