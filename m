From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Need help with recovery
Date: Wed, 14 Jul 2010 16:37:09 +0200
Message-ID: <4C3DCB95.9010104@computer.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010505000607020604000907"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010505000607020604000907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi guys.

I've been having trouble with a four-disk raid5 array, which I now believe were caused by a flaky eSATA cable. The cable has been replaced, and the controller now seems to reliably see all four disks.

In fact I have five disks, and so a partition on the fifth disk acts as a spare. Over the past several days I've been connecting and disconnecting drives in ways that I didn't realise were unreliable (due to the faulty cable).

This has resulted in the md metadata being out of sync on the different partitions. Please could someone provide advice as to how to recover this array (which contains an ext3 filesystem)?


Many thanks!

Jan

--------------010505000607020604000907
Content-Type: text/plain;
 name="mdadm-examine.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdadm-examine.txt"

/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 714e46f1:479268a7:895e209c:936fa570
  Creation Time : Fri Jun 22 20:56:51 2007
     Raid Level : raid5
  Used Dev Size : 311588608 (297.15 GiB 319.07 GB)
     Array Size : 934765824 (891.46 GiB 957.20 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Wed Jul 14 13:19:56 2010
          State : active
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 242755b4 - correct
         Events : 24565

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2

   0     0       8       66        0      active sync   /dev/sde2
   1     1       8        2        1      active sync   /dev/sda2
   2     2       8       18        2      active sync   /dev/sdb2
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2
/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 714e46f1:479268a7:895e209c:936fa570
  Creation Time : Fri Jun 22 20:56:51 2007
     Raid Level : raid5
  Used Dev Size : 311588608 (297.15 GiB 319.07 GB)
     Array Size : 934765824 (891.46 GiB 957.20 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 2

    Update Time : Tue Jul 13 03:47:51 2010
          State : active
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 2425708a - correct
         Events : 21017

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
   4     4       8       82        4      spare   /dev/sdf2
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 714e46f1:479268a7:895e209c:936fa570
  Creation Time : Fri Jun 22 20:56:51 2007
     Raid Level : raid5
  Used Dev Size : 311588608 (297.15 GiB 319.07 GB)
     Array Size : 934765824 (891.46 GiB 957.20 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Wed Jul 14 13:20:13 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 2427b5fa - correct
         Events : 24574

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       34        4      spare   /dev/sdc2

   0     0       8       66        0      active sync   /dev/sde2
   1     1       0        0        1      faulty removed
   2     2       8       18        2      active sync   /dev/sdb2
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2
/dev/sdd2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 714e46f1:479268a7:895e209c:936fa570
  Creation Time : Fri Jun 22 20:56:51 2007
     Raid Level : raid5
  Used Dev Size : 311588608 (297.15 GiB 319.07 GB)
     Array Size : 934765824 (891.46 GiB 957.20 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Wed Jul 14 13:20:13 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 2427b5ec - correct
         Events : 24574

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       18        2      active sync   /dev/sdb2

   0     0       8       66        0      active sync   /dev/sde2
   1     1       0        0        1      faulty removed
   2     2       8       18        2      active sync   /dev/sdb2
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2
/dev/sde2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 714e46f1:479268a7:895e209c:936fa570
  Creation Time : Fri Jun 22 20:56:51 2007
     Raid Level : raid5
  Used Dev Size : 311588608 (297.15 GiB 319.07 GB)
     Array Size : 934765824 (891.46 GiB 957.20 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Wed Jul 14 13:20:13 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 2427b618 - correct
         Events : 24574

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       66        0      active sync   /dev/sde2

   0     0       8       66        0      active sync   /dev/sde2
   1     1       0        0        1      faulty removed
   2     2       8       18        2      active sync   /dev/sdb2
   3     3       0        0        3      faulty removed
   4     4       8       34        4      spare   /dev/sdc2

--------------010505000607020604000907--
