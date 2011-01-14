From: =?ISO-8859-1?Q?Bj=F6rn_Englund?= <be@smarteye.se>
Subject: raid6 recovery
Date: Fri, 14 Jan 2011 17:16:26 +0100
Message-ID: <4D3076DA.4020204@smarteye.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

After a loss of communication with a drive in a 10 disk raid6 the disk
was dropped out of the raid.

I added it again with
mdadm /dev/md16 --add /dev/sdbq1

The array resynced and I used the xfs filesystem on top of the raid.

After a while I started noticing filesystem errors.

I did
echo check > /sys/block/md16/md/sync_action

I got a lot of errors in /sys/block/md16/md/mismatch_cnt

I failed and removed the disk I added before from the array.

Did a check again (on the 9/10 array)
echo check > /sys/block/md16/md/sync_action

No errors  /sys/block/md16/md/mismatch_cnt

Wiped the superblock from /dev/sdbq1 and added it again to the array.
Let it finish resyncing.
Did a check and once again a lot of errors.

The drive now has slot 10 instead of slot 3 which it had before the
first error.

Examining each device (see below) shows 11 slots and one failed?
(0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3) ?


Any idea what is going on?

mdadm --version
mdadm - v2.6.9 - 10th March 2009

Centos 5.5


mdadm -D /dev/md16
/dev/md16:
        Version : 1.01
  Creation Time : Thu Nov 25 09:15:54 2010
     Raid Level : raid6
     Array Size : 7809792000 (7448.00 GiB 7997.23 GB)
  Used Dev Size : 976224000 (931.00 GiB 999.65 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 16
    Persistence : Superblock is persistent

    Update Time : Fri Jan 14 16:22:10 2011
          State : clean
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 256K

           Name : 16
           UUID : fcd585d0:f2918552:7090d8da:532927c8
         Events : 90

    Number   Major   Minor   RaidDevice State
       0       8      145        0      active sync   /dev/sdj1
       1      65        1        1      active sync   /dev/sdq1
       2      65       17        2      active sync   /dev/sdr1
      10      68       65        3      active sync   /dev/sdbq1
       4      65       49        4      active sync   /dev/sdt1
       5      65       65        5      active sync   /dev/sdu1
       6      65      113        6      active sync   /dev/sdx1
       7      65      129        7      active sync   /dev/sdy1
       8      65       33        8      active sync   /dev/sds1
       9      65      145        9      active sync   /dev/sdz1



mdadm -E /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : fcd585d0:f2918552:7090d8da:532927c8
           Name : 16
  Creation Time : Thu Nov 25 09:15:54 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
     Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
  Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 5db9c8f7:ce5b375e:757c53d0:04e89a06

    Update Time : Fri Jan 14 16:22:10 2011
       Checksum : 1f17a675 - correct
         Events : 90

     Chunk Size : 256K

    Array Slot : 0 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
   Array State : Uuuuuuuuuu 1 failed



mdadm -E /dev/sdq1
/dev/sdq1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : fcd585d0:f2918552:7090d8da:532927c8
           Name : 16
  Creation Time : Thu Nov 25 09:15:54 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
     Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
  Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : fb113255:fda391a6:7368a42b:1d6d4655

    Update Time : Fri Jan 14 16:22:10 2011
       Checksum : 6ed7b859 - correct
         Events : 90

     Chunk Size : 256K

    Array Slot : 1 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
   Array State : uUuuuuuuuu 1 failed


 mdadm -E /dev/sdr1
/dev/sdr1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : fcd585d0:f2918552:7090d8da:532927c8
           Name : 16
  Creation Time : Thu Nov 25 09:15:54 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
     Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
  Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : afcb4dd8:2aa58944:40a32ed9:eb6178af

    Update Time : Fri Jan 14 16:22:10 2011
       Checksum : 97a7a2d7 - correct
         Events : 90

     Chunk Size : 256K

    Array Slot : 2 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
   Array State : uuUuuuuuuu 1 failed


mdadm -E /dev/sdbq1
/dev/sdbq1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : fcd585d0:f2918552:7090d8da:532927c8
           Name : 16
  Creation Time : Thu Nov 25 09:15:54 2010
     Raid Level : raid6
   Raid Devices : 10

 Avail Dev Size : 1952448248 (931.00 GiB 999.65 GB)
     Array Size : 15619584000 (7448.00 GiB 7997.23 GB)
  Used Dev Size : 1952448000 (931.00 GiB 999.65 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 93c6ae7c:d8161356:7ada1043:d0c5a924

    Update Time : Fri Jan 14 16:22:10 2011
       Checksum : 2ca5aa8f - correct
         Events : 90

     Chunk Size : 256K

    Array Slot : 10 (0, 1, 2, failed, 4, 5, 6, 7, 8, 9, 3)
   Array State : uuuUuuuuuu 1 failed


and so on for the rest of the drives.
