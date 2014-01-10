From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: MD on raw device, use unallocated space anyway?
Date: Fri, 10 Jan 2014 17:36:53 +0000
Message-ID: <CADNH=7H2E5J3MPyGt4YHHK8wLzhizJLmdos0G60OE1qEwvBOKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I've a device that's part of an MD array:

fdisk
Disk /dev/sdg: 3000.6 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders, total 5860533168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

$ sudo mdadm -E /dev/sdg
/dev/sdg:
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

    Update Time : Fri Jan 10 17:28:31 2014
       Checksum : 53ea0170 - correct
         Events : 2668

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAA ('A' == active, '.' == missing)

As you can see, Used Dev Size is lower than Avail Dev Size. Can I use
the unallocated space by MD for storage somehow? As the devices in the
array are used fully (no partitions) I guess not, but perhaps there is
a way.

Regards,
Mathias
