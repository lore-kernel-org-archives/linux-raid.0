From: Lem <l3mming@iinet.net.au>
Subject: RAID5 producing fake partition table on single drive
Date: Sat, 19 Aug 2006 21:40:07 +1000
Message-ID: <1155987607.7207.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm having a problem with my RAID5 array, here's the deal:

System is an AMD Athlon 64 X2 4200+ on a Gigabyte K8NS-939-Ultra
(nForce3 Ultra). Linux 2.6.17.7, x86_64. Debian GNU/Linux Sid, GCC 4.1.1
(kernel configured and compiled by hand).

RAID5 array created using mdadm 2.5.2. All drives are 250Gb Seagate
SATAs, spread across three controllers: nForce3 Ultra (motherboard),
Silicon Image 3124 (motherboard) and Promise SATA TX300 (PCI).

/dev/sda: ST3250624NS
/dev/sdb: ST3250624NS
/dev/sdc: ST3250823AS
/dev/sdd: ST3250624NS
/dev/sde: ST3250823AS

The array assembles and runs perfectly at boot, and continues to operate
without errors, and has been for a few months. It is using a version
0.90 superblock. None of the devices were partitioned with fdisk, they
were just passed to mdadm when the array was created.

Recently (last week or two), I have noticed the following in dmesg:

SCSI device sde: 488397168 512-byte hdwr sectors (250059 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: drive cache: write back
SCSI device sde: 488397168 512-byte hdwr sectors (250059 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: drive cache: write back
 sde: sde1 sde3
sd 6:0:0:0: Attached scsi disk sde

Buffer I/O error on device sde3, logical block 1792
Buffer I/O error on device sde3, logical block 1793
Buffer I/O error on device sde3, logical block 1794
Buffer I/O error on device sde3, logical block 1795
Buffer I/O error on device sde3, logical block 1796
Buffer I/O error on device sde3, logical block 1797
Buffer I/O error on device sde3, logical block 1798
Buffer I/O error on device sde3, logical block 1799
Buffer I/O error on device sde3, logical block 1792
Buffer I/O error on device sde3, logical block 1793


/dev/sda appears to have a partition table as well, but no partitions
defined. /dev/sdb and /dev/sdc are "unknown partition tables".

Bearing in mind I did not create a partition table on /dev/sde, yet the
kernel reports one and also individual partitions, here's the output
from fdisk:

# fdisk /dev/sde
Command (m for help): p

Disk /dev/sde: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1           1         995+  c7  Syrinx
Partition 1 does not end on cylinder boundary.
/dev/sde2               1           1           0    0  Empty
Partition 2 does not end on cylinder boundary.
/dev/sde3          133675      133675         995+  c7  Syrinx
Partition 3 does not end on cylinder boundary.
/dev/sde4               1           1           0    0  Empty
Partition 4 does not end on cylinder boundary.


I'm not a software/kernel/RAID developer by any stretch of the
imagination, but my thoughts are that I've just been unlucky with my
array and that the data on there has somehow managed to look like a
partition table, and the kernel is trying to read it, resulting in the
buffer IO errors.

I believe a solution to this problem would be for me to create proper
partitions on my RAID disks (with type fd I suspect?), and possibly use
a version 1.x superblock rather than 0.90.

I would much appreciate some help with this as I want to preserve the
data on the array (naturally). Is it possible to fdisk one drive in the
array at a time, create a proper partition table and a type 'fd'
partition spanning the entire disk, then re-add it to the array?

If any more information about my system is required, let me know.

Thanks in advance,

Lem

P.S. Output from mdadm --examine /dev/sde

/dev/sde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 54485c92:a2b165f8:5f97d5ed:bbc54eaf
  Creation Time : Sat Jul  1 11:06:03 2006
     Raid Level : raid5
    Device Size : 244198400 (232.89 GiB 250.06 GB)
     Array Size : 976793600 (931.54 GiB 1000.24 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Sat Aug 19 19:56:48 2006
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 56205d7d - correct
         Events : 0.504412

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8       64        4      active sync   /dev/sde

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       16        1      active sync   /dev/sdb
   2     2       8       32        2      active sync   /dev/sdc
   3     3       8       48        3      active sync   /dev/sdd
   4     4       8       64        4      active sync   /dev/sde

