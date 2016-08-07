From: Wols Lists <antlists@youngman.org.uk>
Subject: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Sun, 7 Aug 2016 02:34:10 +0100
Message-ID: <57A69012.1010406@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes I know this is a common occurrence, but it's bitten my test system.

I've now got an array converting from raid1 to raid5, that will build
but won't run, and won't grow.

I suspect it's a similar problem to the one that bit Fedora - in that
"mdadm --grow --continue" comes back with no error messages, but I can
find no evidence that a background mdadm is actually running. As
mentioned earlier, AppArmor is disabled, so I don't know why it won't
work. Any ideas?

I also can't run the array :-(

Note that it's a test vm specifically for playing with raid, so no data
is at stake, but equally, these things shouldn't fail and land you with
a non-working array (and yes, I have downloaded the latest mdadm -
unfortunately I have been mix-n-matching the distro and bleeding-edge
versions).

Cheers,
Wol


/dev/md127:
        Version : 1.2
  Creation Time : Fri Aug  5 18:16:24 2016
     Raid Level : raid5
  Used Dev Size : 8380416 (7.99 GiB 8.58 GB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sun Aug  7 01:20:23 2016
          State : active, Not Started
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

  Delta Devices : 1, (2->3)

           Name : kanga:testarray  (local to host kanga)
           UUID : cf52ebc0:886a35cd:688274b4:3f16096c
         Events : 157

    Number   Major   Minor   RaidDevice State
       4       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       3       8       64        2      active sync   /dev/sde

       2       8       48        -      spare   /dev/sdd



/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x44
     Array UUID : cf52ebc0:886a35cd:688274b4:3f16096c
           Name : kanga:testarray  (local to host kanga)
  Creation Time : Fri Aug  5 18:16:24 2016
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 16760832 (7.99 GiB 8.58 GB)
     Array Size : 16760832 (15.98 GiB 17.16 GB)
    Data Offset : 16384 sectors
     New Offset : 16128 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e9e6426d:d33b9c14:b8bce7e8:780f848e

  Reshape pos'n : 0
  Delta Devices : 1 (2->3)

    Update Time : Sun Aug  7 01:20:23 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 41eb0fd7 - correct
         Events : 157

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x44
     Array UUID : cf52ebc0:886a35cd:688274b4:3f16096c
           Name : kanga:testarray  (local to host kanga)
  Creation Time : Fri Aug  5 18:16:24 2016
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 16760832 (7.99 GiB 8.58 GB)
     Array Size : 16760832 (15.98 GiB 17.16 GB)
    Data Offset : 16384 sectors
     New Offset : 16128 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9566866f:cc4cca0d:d8b54faf:f44e2e97

  Reshape pos'n : 0
  Delta Devices : 1 (2->3)

    Update Time : Sun Aug  7 01:20:23 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c6ed915 - correct
         Events : 157

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x44
     Array UUID : cf52ebc0:886a35cd:688274b4:3f16096c
           Name : kanga:testarray  (local to host kanga)
  Creation Time : Fri Aug  5 18:16:24 2016
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 16760832 (7.99 GiB 8.58 GB)
     Array Size : 16760832 (15.98 GiB 17.16 GB)
    Data Offset : 16384 sectors
     New Offset : 16128 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fed79c82:8510d13a:496617f5:c1381778

  Reshape pos'n : 0
  Delta Devices : 1 (2->3)

    Update Time : Sun Aug  7 01:20:23 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 733ca876 - correct
         Events : 157

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : cf52ebc0:886a35cd:688274b4:3f16096c
           Name : kanga:testarray  (local to host kanga)
  Creation Time : Fri Aug  5 18:16:24 2016
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 16760832 (7.99 GiB 8.58 GB)
     Array Size : 16760832 (15.98 GiB 17.16 GB)
    Data Offset : 16384 sectors
   Super Offset : 8 sectors
   Unused Space : before=16296 sectors, after=0 sectors
          State : clean
    Device UUID : 51271324:1b29e46a:521658dd:5747e61e

  Reshape pos'n : 0
  Delta Devices : 1 (2->3)

    Update Time : Sun Aug  7 01:20:23 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : d3d5cfbd - correct
         Events : 157

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

