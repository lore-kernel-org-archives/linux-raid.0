From: Carl Karsten <carl@personnelware.com>
Subject: reconstruct raid superblock
Date: Wed, 16 Dec 2009 21:53:15 -0600
Message-ID: <549053140912161953x665f84cbnc457c45e47ac2a97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I took over a box that had 1 ide boot drive, 6 sata raid drives (4
internal, 2 external.)  I believe the 2 externals were redundant, so
could be removed.  so I did, and mkfs-ed them.  then I installed
ubuntu to the ide, and installed grub to sda, which turns out to be
the first sata.  which would be fine if the raid was on sda1, but it
is on sda, and now the raid wont' assemble.  no surprise, and I do
have a backup of the data spread across 5 external drives.  but before
I  abandon the array, I am wondering if I can fix it by recreating
mdadm's metatdata on sda, given I have sd[bcd] to work with.

any suggestions?

root@dhcp128:~# mdadm --examine /dev/sd[abcd]
mdadm: No md superblock detected on /dev/sda.
/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Tue Mar 31 23:08:02 2009
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : a4fbb93a - correct
         Events : 8430

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       16        6      spare   /dev/sdb

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       64        1      active sync   /dev/sde
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       80        5      active sync
   6     6       8       16        6      spare   /dev/sdb
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul 12 11:31:47 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : a59452db - correct
         Events : 580158

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       32        2      active sync   /dev/sdc

   0     0       8        0        0      active sync   /dev/sda
   1     1       0        0        1      faulty removed
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       96        5      active sync
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8d0cf436:3fc2d2ef:93d71b24:b036cc6b
  Creation Time : Wed Mar 25 21:04:08 2009
     Raid Level : raid6
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
     Array Size : 5860549632 (5589.06 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Jul 12 11:31:47 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : a59452ed - correct
         Events : 580158

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       48        3      active sync   /dev/sdd

   0     0       8        0        0      active sync   /dev/sda
   1     1       0        0        1      faulty removed
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       0        0        4      faulty removed
   5     5       8       96        5      active sync

-- 
Carl K
