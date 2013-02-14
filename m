From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Thu, 14 Feb 2013 22:00:29 +0100
Message-ID: <20130214210029.203940@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

the 40TB are in an filecluster and this machine is part of this. the system consists of 6x3tb in sw raid5. there are four partions on each machine. one with 100mb for the efi bios, one for the os in raid1, one for the swap in raid5 and one for the files in raid5. the machine was opened and the disk layed beside, i moved two disks slightly and in this moment both spinded for a second down and the raid was gone. there was no filetransfer but the raid couldnt rebuild because of missing two disks.

sda4
 mdadm -E /dev/sda4
/dev/sda4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e84f0346:3f5ff3f1:507b6f9c:0fa02c63
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Feb  5 17:44:45 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213772800 (13930.21 GiB 14957.45 GB)
  Used Dev Size : 5842754560 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4f8851b4:001bf0c0:3aab60e0:b2c5558f

    Update Time : Tue Feb  5 17:44:45 2013
       Checksum : c0376a50 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA. ('A' == active, '.' == missing)
---------------
mdadm -E /dev/sdb4
/dev/sdb4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e84f0346:3f5ff3f1:507b6f9c:0fa02c63
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Feb  5 17:44:45 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213772800 (13930.21 GiB 14957.45 GB)
  Used Dev Size : 5842754560 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c2f63fa7:768e9945:64826929:6f1f68c2

    Update Time : Tue Feb  5 17:44:45 2013
       Checksum : b3ea7d20 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA. ('A' == active, '.' == missing)
---------------------
mdadm -E /dev/sdc4
/dev/sdc4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e84f0346:3f5ff3f1:507b6f9c:0fa02c63
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Feb  5 17:44:45 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213772800 (13930.21 GiB 14957.45 GB)
  Used Dev Size : 5842754560 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e9861f3e:4de4d0ce:7d4b6dd7:e1215fc7

    Update Time : Tue Feb  5 17:44:45 2013
       Checksum : 86fc2eab - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA. ('A' == active, '.' == missing)
-----------------------
mdadm -E /dev/sdd4
/dev/sdd4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7b99380e:51d754cf:921c68e9:7b830d6a
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Feb  5 17:06:37 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842757597 (2786.04 GiB 2991.49 GB)
     Array Size : 29213772800 (13930.21 GiB 14957.45 GB)
  Used Dev Size : 5842754560 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0da58625:14ed8675:6a7c4ba4:337d8c4b

    Update Time : Tue Feb  5 17:06:37 2013
       Checksum : 5f97164a - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAA.AA ('A' == active, '.' == missing)
-------------------
mdadm -E /dev/sde4
/dev/sde4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e84f0346:3f5ff3f1:507b6f9c:0fa02c63
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Feb  5 17:44:45 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842755584 (2786.04 GiB 2991.49 GB)
     Array Size : 29213772800 (13930.21 GiB 14957.45 GB)
  Used Dev Size : 5842754560 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b70cd4f6:1594cc29:b4346929:89a5ed34

    Update Time : Tue Feb  5 17:44:45 2013
       Checksum : 5a36c944 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA. ('A' == active, '.' == missing)
-------------------
 mdadm -E /dev/sdf4
/dev/sdf4:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e84f0346:3f5ff3f1:507b6f9c:0fa02c63
           Name : mfsnode1:2  (local to host mfsnode1)
  Creation Time : Tue Feb  5 17:44:45 2013
     Raid Level : raid5
   Raid Devices : 6

 Avail Dev Size : 5842755584 (2786.04 GiB 2991.49 GB)
     Array Size : 29213772800 (13930.21 GiB 14957.45 GB)
  Used Dev Size : 5842754560 (2786.04 GiB 2991.49 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 06202661:79792af2:6c8d02ae:769bdded

    Update Time : Tue Feb  5 17:44:45 2013
       Checksum : ca70109c - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA. ('A' == active, '.' == missing)

hope you guys can help
