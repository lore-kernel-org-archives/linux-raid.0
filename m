From: Karsten Desler <kdesler@soohrt.org>
Subject: 5 HDD RAID5 not starting after controller failure
Date: Sun, 3 Jun 2007 11:47:14 +0200
Message-ID: <20070603094714.GI22122@soohrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a RAID5 that recently failed. sda-sdd are on the same SATA controller and
every thing was running fine, until Linux decided it was a good idea to disable
the controllers interrupt. After a reboot the RAID isn't starting anymore.

Before I do something stupid, I wanted to ask if the following command will
probably restore the array with minimal data corruption.

  mdadm --assemble /dev/md6 --run --force /dev/sda8 /dev/sdb8 /dev/sdc8 /dev/sdd8
  mdadm /dev/md6 -a /dev/sde1

Looking at the events counter, sda-sdc agree and sdd is very close so I'd guess
that I have the best chances at getting as little corruption as possible. Or does
it make more sense to start it with all disks active?

img2:~# mdadm -E /dev/sda8
/dev/sda8:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f52098d4:862caf6c:4c56c819:9f529bcc
  Creation Time : Thu Jan 25 02:41:06 2007
     Raid Level : raid5
    Device Size : 381431168 (363.76 GiB 390.59 GB)
     Array Size : 1525724672 (1455.04 GiB 1562.34 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Jun  3 11:10:03 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b3017829 - correct
         Events : 0.253660

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        8        0      active sync   /dev/sda8

   0     0       8        8        0      active sync   /dev/sda8
   1     1       8       24        1      active sync   /dev/sdb8
   2     2       8       40        2      active sync   /dev/sdc8
   3     3       8       56        3      active sync   /dev/sdd8
   4     4       8       65        4      active sync   /dev/sde1
img2:~# mdadm -E /dev/sdb8
/dev/sdb8:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f52098d4:862caf6c:4c56c819:9f529bcc
  Creation Time : Thu Jan 25 02:41:06 2007
     Raid Level : raid5
    Device Size : 381431168 (363.76 GiB 390.59 GB)
     Array Size : 1525724672 (1455.04 GiB 1562.34 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Jun  3 11:10:03 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b301783b - correct
         Events : 0.253660

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       24        1      active sync   /dev/sdb8

   0     0       8        8        0      active sync   /dev/sda8
   1     1       8       24        1      active sync   /dev/sdb8
   2     2       8       40        2      active sync   /dev/sdc8
   3     3       8       56        3      active sync   /dev/sdd8
   4     4       8       65        4      active sync   /dev/sde1
img2:~# mdadm -E /dev/sdc8
/dev/sdc8:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f52098d4:862caf6c:4c56c819:9f529bcc
  Creation Time : Thu Jan 25 02:41:06 2007
     Raid Level : raid5
    Device Size : 381431168 (363.76 GiB 390.59 GB)
     Array Size : 1525724672 (1455.04 GiB 1562.34 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Jun  3 11:10:03 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b301784d - correct
         Events : 0.253660

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       40        2      active sync   /dev/sdc8

   0     0       8        8        0      active sync   /dev/sda8
   1     1       8       24        1      active sync   /dev/sdb8
   2     2       8       40        2      active sync   /dev/sdc8
   3     3       8       56        3      active sync   /dev/sdd8
   4     4       8       65        4      active sync   /dev/sde1
img2:~# mdadm -E /dev/sdd8
/dev/sdd8:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f52098d4:862caf6c:4c56c819:9f529bcc
  Creation Time : Thu Jan 25 02:41:06 2007
     Raid Level : raid5
    Device Size : 381431168 (363.76 GiB 390.59 GB)
     Array Size : 1525724672 (1455.04 GiB 1562.34 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Jun  3 11:10:02 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : b2fd9982 - correct
         Events : 0.253661

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       56        3      active sync   /dev/sdd8

   0     0       8        8        0      active sync   /dev/sda8
   1     1       8       24        1      active sync   /dev/sdb8
   2     2       8       40        2      active sync   /dev/sdc8
   3     3       8       56        3      active sync   /dev/sdd8
   4     4       8       65        4      active sync   /dev/sde1
img2:~# mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f52098d4:862caf6c:4c56c819:9f529bcc
  Creation Time : Thu Jan 25 02:41:06 2007
     Raid Level : raid5
    Device Size : 381431168 (363.76 GiB 390.59 GB)
     Array Size : 1525724672 (1455.04 GiB 1562.34 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 6

    Update Time : Sun Jun  3 11:12:47 2007
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 3
  Spare Devices : 0
       Checksum : b3017954 - correct
         Events : 0.253664

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1

Best Regards,
 Karsten Desler
