From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: need help, possibly shred my array, no backups, debian install issue
Date: Tue, 11 Mar 2008 14:14:14 +0100
Message-ID: <200803111414.14400.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

wanted to migrate the raid server from slack to debain, installed etch on a 
stand alone disk, not the array. 
installed mdadm, asked me a couple of questions. then for reasons beyond me 
tried and assembled.
I got no clue how debian figured the mdadm.conf, I didn't write one.
so I stopped that array and had a look at the mdadm -E data, which are odd, my 
old mdadm.conf in slackware used these two lines:

DEVICE /dev/sd[abcd]1
ARRAY /dev/md0 UUID=7f103422:7be2c2ce:e67a70be:112a2914

now in mdadm -E /dev/sda I get this: 
(note: /dev/sda, should be sda1 but mdadm -E /dev/sda1 doesn't give me 
anything at all but an error)


# mdadm -E /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : db7e5b65:e35c69dc:7c267a5a:e676c929
  Creation Time : Mon May  8 00:05:16 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue May  9 00:43:46 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 61f0ffc4 - correct
         Events : 0.24796

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2       8       32        2      active sync   /dev/sdc

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd




# mdadm -E /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : db7e5b65:e35c69dc:7c267a5a:e676c929
  Creation Time : Mon May  8 00:05:16 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue May  9 00:43:46 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 61f0ffd6 - correct
         Events : 0.24796

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3       8       48        3      active sync   /dev/sdd

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd





# mdadm -E /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : db7e5b65:e35c69dc:7c267a5a:e676c929
  Creation Time : Mon May  8 00:05:16 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
     Array Size : 732595392 (698.66 GiB 750.18 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue May  9 00:43:46 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 61f0ffb2 - correct
         Events : 0.24796

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1       8       16        1      active sync   /dev/sdb

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd



# mdadm -E /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 7f103422:7be2c2ce:e67a70be:112a2914
  Creation Time : Tue May  9 01:11:41 2006
     Raid Level : raid5
    Device Size : 244187904 (232.88 GiB 250.05 GB)
     Array Size : 732563712 (698.63 GiB 750.15 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Jun 18 14:43:49 2007
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 354955e4 - correct
         Events : 0.1102278

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     4       8       48        4      spare   /dev/sdd

   0     0       0        0        0      removed
   1     1       8       33        1      active sync   /dev/.static/dev/sdc1
   2     2       8        1        2      active sync   /dev/.static/dev/sda1
   3     3       8       17        3      active sync   /dev/.static/dev/sdb1
   4     4       8       48        4      spare   /dev/sdd




The only proper UUID is on sdd and there it says its confed as spare.

ANY help appreciated
