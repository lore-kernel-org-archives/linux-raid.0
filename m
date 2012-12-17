From: Alex Pientka <alex.pientka@gmail.com>
Subject: strange partition table and slow speeds
Date: Mon, 17 Dec 2012 09:17:28 -0500
Message-ID: <CA+Z7oPgjAsj3f571ocN9zS2sGjgdMsK97_H6qR20o1GPUJYVKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Afternoon,

my 6x 2tb raid5 got moved into a different server. Before the move the
system was using an intel sata2 ahci on board controller. Nothing
special. Instead of creating a partition I pointed to the entire
device aka /dev/sdc instead of /dev/sdc1. Running an fdisk against the
drive doesn't come back with anything, but that is expected

The new system uses a promise 16300 sata pci-x controller. Slower, but
that system has more slots for drives. The drives got presented as a
jbod through the raid controller bios. Right away on the boot up the
linux system identified all the drives and put the /dev/md0 device
together.

Currently mdadm adjusted every partition table. Running fdisk against
any of the volumes comes back with this:

Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes, 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xffffffff

This doesn't look like a partition table
Probably you selected the wrong device.

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1   ?  4294967295  8589934589  2147483647+  ff  BBT
/dev/sdd2   ?  4294967295  8589934589  2147483647+  ff  BBT
/dev/sdd3   ?  4294967295  8589934589  2147483647+  ff  BBT
/dev/sdd4   ?  4294967295  8589934589  2147483647+  ff  BBT


Yesterday for testing purposes I failed a drive, cleaned the partition
table and then re-added it. The Disk identified got reset back to
0xffffffff and the partition table looks the same again.

/dev/md0:
        Version : 1.1
  Creation Time : Sat Apr 17 13:39:21 2010
     Raid Level : raid5
     Array Size : 9767567360 (9315.08 GiB 10001.99 GB)
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Thu Dec 13 09:33:38 2012
          State : clean, degraded, recovering
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 256K

 Rebuild Status : 35% complete

           Name : amy:0
           UUID : d64bd5fc:be602828:04c0c8c0:312502d9
         Events : 2919684

    Number   Major   Minor   RaidDevice State
       6       8       32        0      active sync   /dev/sdc
       7       8      112        1      active sync   /dev/sdh
       8       8       64        2      active sync   /dev/sde
       9       8       48        3      active sync   /dev/sdd
       5       8       80        4      active sync   /dev/sdf
      10       8       96        5      spare rebuilding   /dev/sdg

The reason why I stared this work was to identify why my raid is so
unbelievable slow at writing. After some adjustments dd can write a
file around 52mb/s. hdparm does reads at 378mb/s. I should have used
dd to do the read, but currently I am unable to do so.

Currently I am rebuilding my block size from 256k down to 4k. A
co-worker has the same setup as I do and his reads and writes are
twice almost three times as fast. The difference is he has 4k size,
uses 750gb and 500 gb drives (two different md devicse) and his
partition table doesn't look like my table.



Alex
