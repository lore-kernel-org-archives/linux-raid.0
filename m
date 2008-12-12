From: Federico <undicizeri@gmail.com>
Subject: RAID1 extreme low performance
Date: Fri, 12 Dec 2008 13:47:31 +0100
Message-ID: <26c008d70812120447kb91f8a1x6747bf5d4c7cfc0c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I all,
a couple of weeks ago I've updated the kernel (now I'm using .27-7)
and mdadm to version 2.6.7 and now I have terrible RAID1 performance:
during I/O operation I have 100% cpu utilization and all the system
freeze until the operation ends. Seeking and reading from the RAID is
extremely slow (sometime 4 or 5 seconds just to show an "ls -l"
output) and writing is even worst.
I've tested the same hard disk without RAID and It seem working well.
This is the output of mdadm -D /dev/md*


/dev/md0:
        Version : 00.90
  Creation Time : Sat May  3 21:53:16 2008
     Raid Level : raid1
     Array Size : 7815488 (7.45 GiB 8.00 GB)
  Used Dev Size : 7815488 (7.45 GiB 8.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Dec 12 13:46:27 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 2a37b0a1:4b6b28fc:0209446b:c3b28f2a
         Events : 0.142

    Number   Major   Minor   RaidDevice State
       0       8       37        0      active sync   /dev/sdc5
       1       8       17        1      active sync   /dev/sdb1

/dev/md1:
        Version : 00.90
  Creation Time : Sat May  3 21:53:32 2008
     Raid Level : raid1
     Array Size : 152264000 (145.21 GiB 155.92 GB)
  Used Dev Size : 152264000 (145.21 GiB 155.92 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Dec 12 13:46:27 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 19c49c5d:e3193aa1:657f267b:b23c2dee
         Events : 0.14

    Number   Major   Minor   RaidDevice State
       0       8       38        0      active sync   /dev/sdc6
       1       8       18        1      active sync   /dev/sdb2

/dev/md2:
        Version : 00.90
  Creation Time : Mon May  5 03:39:59 2008
     Raid Level : raid1
     Array Size : 293049600 (279.47 GiB 300.08 GB)
  Used Dev Size : 293049600 (279.47 GiB 300.08 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Fri Dec 12 13:37:06 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 62a5cb51:36ca61a3:1298e6c2:30fde3ba
         Events : 0.20

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
