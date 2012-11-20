From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: mdadm --wait returns while array under construction?
Date: Tue, 20 Nov 2012 09:55:41 -0800
Message-ID: <1353434141.27671.13.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: ross@biostat.ucsf.edu
List-Id: linux-raid.ids

While switching the disks a RAID 1 is based on I used the --wait command
to wait for the rebuild to finish.  It returned immediately, but a
subsequent query showed it had not been rebuilt.  Have I misunderstood
something, or is this an error?

While doing these commands a much larger rebuild was going on with a
different array, involving some of the same physical disks but different
partitions.  The partitions being rebuilt are on different physical
disks for the different arrays.

Here are the logs, with version info at the end (Debian Lenny + more
recent kernel):
markov:~# date; mdadm --detail /dev/md0
Tue Nov 20 09:37:07 PST 2012
/dev/md0:
        Version : 00.90
  Creation Time : Mon Dec 15 06:49:51 2008
     Raid Level : raid1
     Array Size : 96256 (94.02 MiB 98.57 MB)
  Used Dev Size : 96256 (94.02 MiB 98.57 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Nov 20 07:41:04 2012
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 313d5489:7869305b:5b5da825:51e3856c
         Events : 0.1602

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
markov:~# date; mdadm --fail /dev/md0 /dev/sdc1
Tue Nov 20 09:37:58 PST 2012
mdadm: set /dev/sdc1 faulty in /dev/md0
markov:~# date; mdadm --add /dev/md0 /dev/sdd2
Tue Nov 20 09:39:05 PST 2012
mdadm: added /dev/sdd2
markov:~# date; mdadm --detail /dev/md0
Tue Nov 20 09:39:14 PST 2012
/dev/md0:
        Version : 00.90
  Creation Time : Mon Dec 15 06:49:51 2008
     Raid Level : raid1
     Array Size : 96256 (94.02 MiB 98.57 MB)
  Used Dev Size : 96256 (94.02 MiB 98.57 MB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Nov 20 09:39:05 2012
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1

           UUID : 313d5489:7869305b:5b5da825:51e3856c
         Events : 0.1606

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       2       8       50        1      spare rebuilding   /dev/sdd2

       3       8       33        -      faulty spare   /dev/sdc1
markov:~# time mdadm --wait /dev/md0; date

real    0m0.002s
user    0m0.000s
sys     0m0.004s
Tue Nov 20 09:40:07 PST 2012
markov:~# date; mdadm --detail /dev/md0
Tue Nov 20 09:40:20 PST 2012
/dev/md0:
        Version : 00.90
  Creation Time : Mon Dec 15 06:49:51 2008
     Raid Level : raid1
     Array Size : 96256 (94.02 MiB 98.57 MB)
  Used Dev Size : 96256 (94.02 MiB 98.57 MB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Nov 20 09:39:15 2012
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1

           UUID : 313d5489:7869305b:5b5da825:51e3856c
         Events : 0.1608

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       2       8       50        1      spare rebuilding   /dev/sdd2

       3       8       33        -      faulty spare   /dev/sdc1
markov:~# uname -a
Linux markov 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x86_64 GNU/Linux
markov:~# mdadm --version
mdadm - v2.6.7.2 - 14th November 2008


I notice that in this case, unlike the other array, the message during
the rebuild (the last detail report) does not include a line like
Rebuild Status : 0% complete

I just tried --wait again to see if there was some kind of race, but
once again it returned immediately, though detail says the spare is
rebuilding.

Ross Boylan

