From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re-assemble RAID6 from SW to HW RAID
Date: Mon, 17 Nov 2014 22:14:24 +0000
Message-ID: <CADNH=7H=ge5P9rm5hRjO3GhOFF-jAqFZrNMjNeEGVDwe=BOARw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I've a 6 disk RAID6 array, with 1 missing disk. I moved 2 of the HDDs
from the on-board SATA controller to a LSI MegaRAID controller where I
created them as individual RAID0's. The data in the array isn't
important, but it'd be nice if I can reassemble it.

This is what it looks like:

$ for I in /dev/sd?;do sudo mdadm -E $I;done


/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
           Name : ion:md0  (local to host ion)
  Creation Time : Tue Feb  5 17:33:27 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 78df2586:cb5649aa:e0b6d211:d92dc224

    Update Time : Tue Nov  4 21:43:49 2014
       Checksum : 50c95b7c - correct
         Events : 97557

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AA.AAA ('A' == active, '.' == missing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
           Name : ion:md0  (local to host ion)
  Creation Time : Tue Feb  5 17:33:27 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 41712f8c:255b0f3e:0e345f7b:e1504e42

    Update Time : Tue Nov  4 21:43:49 2014
       Checksum : 71b191d6 - correct
         Events : 97557

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.AAA ('A' == active, '.' == missing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
           Name : ion:md0  (local to host ion)
  Creation Time : Tue Feb  5 17:33:27 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a09fc60d:5c4a27a5:4b89bc33:29b01582

    Update Time : Tue Nov  4 21:43:49 2014
       Checksum : 528563ee - correct
         Events : 97557

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AA.AAA ('A' == active, '.' == missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
           Name : ion:md0  (local to host ion)
  Creation Time : Tue Feb  5 17:33:27 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 39c0b717:a9ca1dd7:bcba618f:caed0879

    Update Time : Tue Nov  4 21:43:49 2014
       Checksum : 55758eeb - correct
         Events : 97557

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AA.AAA ('A' == active, '.' == missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
           Name : ion:md0  (local to host ion)
  Creation Time : Tue Feb  5 17:33:27 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 93568b01:632395bf:7d0082a5:db9b6ff9

    Update Time : Tue Nov  4 21:43:49 2014
       Checksum : 49d756ca - correct
         Events : 97557

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.AAA ('A' == active, '.' == missing)

$ ls -la /dev/disk/by-id/ | grep -v Cors | grep -v dm

lrwxrwxrwx 1 root root   9 Nov 17 22:04
ata-SAMSUNG_HD204UI_S2H7JR0B501861 -> ../../sdb
lrwxrwxrwx 1 root root   9 Nov 17 22:04
ata-WDC_WD20EARS-00J99B0_WD-WCAWZ2036074 -> ../../sdc
lrwxrwxrwx 1 root root   9 Nov 17 22:04
ata-WDC_WD20EARS-00MVWB0_WD-WMAZA6473013 -> ../../sdd
lrwxrwxrwx 1 root root   9 Nov 17 22:04
scsi-3600605b0025eff501bfd2d550b74a2d5 -> ../../sde
lrwxrwxrwx 1 root root   9 Nov 17 22:04
scsi-3600605b0025eff501bfd2d5709c4a486 -> ../../sdf
lrwxrwxrwx 1 root root   9 Nov 17 22:04 wwn-0x50000f00500b6118 -> ../../sdb
lrwxrwxrwx 1 root root   9 Nov 17 22:04 wwn-0x50014ee0030a1204 -> ../../sdd
lrwxrwxrwx 1 root root   9 Nov 17 22:04 wwn-0x50014ee206d9cbd2 -> ../../sdc
lrwxrwxrwx 1 root root 9 Nov 17 22:04
wwn-0x600605b0025eff501bfd2d550b74a2d5 -> ../../sde
lrwxrwxrwx 1 root root   9 Nov 17 22:04
wwn-0x600605b0025eff501bfd2d5709c4a486 -> ../../sdf

Any idea if this is rescuable?

Thanks
