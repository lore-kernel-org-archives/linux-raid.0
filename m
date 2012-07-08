From: Dietrich Heise <dh@dhde.de>
Subject: RAID5 faild while in degraded mode, need help
Date: Sun, 8 Jul 2012 21:05:02 +0200
Message-ID: <CACMY3vC=iAbKCssHH8CQ=msqNtmE1zF1muoZTusfRd989HvD_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

the following Problem,
One of four drives has S.M.A.R.T. errors, so I removed it and
replaced, with a new one.

In the time the drive was rebuilding, one of the three left devices
has an I/O error (sdd1) (sdc1 was the replaced drive an was syncing).

Now the following happends (two drives are spare drives :( )

p3 disks # mdadm -D /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Mon Feb 28 19:57:56 2011
     Raid Level : raid5
  Used Dev Size : 1465126400 (1397.25 GiB 1500.29 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sun Jul  8 20:37:12 2012
          State : active, FAILED, Not Started
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 512K

           Name : p3:0  (local to host p3)
           UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
         Events : 121205

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       65        1      active sync   /dev/sde1
       2       0        0        2      removed
       3       0        0        3      removed

       4       8       49        -      spare   /dev/sdd1
       5       8       33        -      spare   /dev/sdc1

here is more information:

p3 disks # mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
           Name : p3:0  (local to host p3)
  Creation Time : Mon Feb 28 19:57:56 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930275057 (1397.26 GiB 1500.30 GB)
     Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
  Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : caefb029:526187ef:2051f578:db2b82b7

    Update Time : Sun Jul  8 20:37:12 2012
       Checksum : 18e2bfe1 - correct
         Events : 121205

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AA.. ('A' == active, '.' == missing)
p3 disks # mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
           Name : p3:0  (local to host p3)
  Creation Time : Mon Feb 28 19:57:56 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
     Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
  Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4231e244:60e27ed4:eff405d0:2e615493

    Update Time : Sun Jul  8 20:37:12 2012
       Checksum : 4bec6e25 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AA.. ('A' == active, '.' == missing)
p3 disks # mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
           Name : p3:0  (local to host p3)
  Creation Time : Mon Feb 28 19:57:56 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930253889 (1397.25 GiB 1500.29 GB)
     Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
  Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 28b08f44:4cc24663:84d39337:94c35d67

    Update Time : Sun Jul  8 20:37:12 2012
       Checksum : 15faa8a1 - correct
         Events : 121205

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.. ('A' == active, '.' == missing)
p3 disks # mdadm -E /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6d4ebfd4:491bcb50:d98d5e67:f226f362
           Name : p3:0  (local to host p3)
  Creation Time : Mon Feb 28 19:57:56 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930269954 (1397.26 GiB 1500.30 GB)
     Array Size : 8790758400 (4191.76 GiB 4500.87 GB)
  Used Dev Size : 2930252800 (1397.25 GiB 1500.29 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 78d5600a:91927758:f78a1cea:3bfa3f5b

    Update Time : Sun Jul  8 20:37:12 2012
       Checksum : 7767cb10 - correct
         Events : 121205

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.. ('A' == active, '.' == missing)

Is there a way to repair the raid?

thanks!
Dietrich
