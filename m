From: John Obaterspok <john.obaterspok@gmail.com>
Subject: Hints on reducing kickouts
Date: Thu, 1 Mar 2012 19:14:38 +0100
Message-ID: <CAOscVd+CWwJoRknhGOvexC7w64o_5H-Q+USheTYZULJbJ8EOYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

Occasionally my system don't shutdown cleanly and almost all time
mdadm kicks one of the disks on the RAID5 array.
Is there anything I can do to help prevent this?

I'm using sw raid 5 with 3 x 3TB Hitachi Deskstar (7K3000 HDS723030ALA640 64MB).

--------

/dev/md2:
        Version : 1.2
  Creation Time : Thu Jul 28 07:23:45 2011
     Raid Level : raid5
     Array Size : 5706313728 (5441.96 GiB 5843.27 GB)
  Used Dev Size : 2853156864 (2720.98 GiB 2921.63 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Thu Mar  1 18:59:21 2012
          State : clean, degraded, recovering
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 14% complete

           Name : Emperor:2  (local to host Emperor)
           UUID : a9f823df:05acab4f:1b02cfb9:70173894
         Events : 792

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       4       8       19        1      spare rebuilding   /dev/sdb3
       3       8       35        2      active sync   /dev/sdc3

--------



/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : a9f823df:05acab4f:1b02cfb9:70173894
           Name : Emperor:2  (local to host Emperor)
  Creation Time : Thu Jul 28 07:23:45 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 5706314639 (2720.98 GiB 2921.63 GB)
     Array Size : 11412627456 (5441.96 GiB 5843.27 GB)
  Used Dev Size : 5706313728 (2720.98 GiB 2921.63 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : abafe531:af25e9ab:54bba541:775a1c11

    Update Time : Thu Mar  1 19:11:53 2012
       Checksum : 3b777715 - correct
         Events : 794

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : a9f823df:05acab4f:1b02cfb9:70173894
           Name : Emperor:2  (local to host Emperor)
  Creation Time : Thu Jul 28 07:23:45 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 5706314639 (2720.98 GiB 2921.63 GB)
     Array Size : 11412627456 (5441.96 GiB 5843.27 GB)
  Used Dev Size : 5706313728 (2720.98 GiB 2921.63 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 713289232 sectors
          State : clean
    Device UUID : adefab73:b8a595de:666a951b:41513425

    Update Time : Thu Mar  1 19:11:53 2012
       Checksum : c875cb12 - correct
         Events : 794

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : a9f823df:05acab4f:1b02cfb9:70173894
           Name : Emperor:2  (local to host Emperor)
  Creation Time : Thu Jul 28 07:23:45 2011
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 5706314639 (2720.98 GiB 2921.63 GB)
     Array Size : 11412627456 (5441.96 GiB 5843.27 GB)
  Used Dev Size : 5706313728 (2720.98 GiB 2921.63 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9d3685e5:cbc37737:d8b864e4:452a5718

    Update Time : Thu Mar  1 19:11:53 2012
       Checksum : 249f6979 - correct
         Events : 794

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing)



---------
--john
