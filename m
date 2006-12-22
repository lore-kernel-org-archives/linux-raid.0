From: Don Hiatt <Don_Hiatt@pmc-sierra.com>
Subject: list of devices that belong to an array
Date: Fri, 22 Dec 2006 14:43:04 -0800
Message-ID: <5C1FD43E5F1B824E83985A74F396286E03EA2B03@bby1exm08.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Don Hiatt <Don_Hiatt@pmc-sierra.com>
List-Id: linux-raid.ids

First off, Merry Christmas everyone! :)

Secondly, given a device that is part of an array, is there a way to figure out
all the other components if you are using the 1.2 superblock?

With SB=0.90, you could issue a "--examine"  and it would report all the other
devices (in the following example, that would be /dev/sata[1-4]). However, with
SB=1.2 (included below) you aren't so lucky. :)

Cheers,

don


0) Using 0.90 superblock
mdadm --create /dev/md0 -e0.90 --level=5 --raid-devices=4 /dev/sata[1-4] ...
mdadm --examine /dev/sata1
...
snip
....
      Number   Major   Minor   RaidDevice State
this     0       8       32        0      active sync   /dev/sata1

   0     0       8       32        0      active sync   /dev/sata1
   1     1       8        0        1      active sync   /dev/sata2
   2     2       8       16        2      active sync   /dev/sata3
   3     3       0        0        3      faulty
   4     4       8       48        4      spare   /dev/sata4  



1) Using 1.2 superblock
mdadm --create /dev/md0 -e1.2  --level=5 --raid-devices=4 /dev/sata[1-4] mdadm --examine /dev/sata1
/dev/sata1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : efe9708d:c0fd30c2:53f83f15:ad0ac1bc
           Name : 0
  Creation Time : Fri Dec 22 19:54:27 2006
     Raid Level : raid5
   Raid Devices : 4

    Device Size : 17882270235826847744 (5581842.00 TiB 6137300.18 T
     Array Size : 482508672 (230.08 GiB 247.04 GB)
      Used Size : 160836224 (76.69 GiB 82.35 GB)
    Data Offset : 136 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 49891598:1b3fa1af:8f8da6d6:6bcf4eff

    Update Time : Fri Dec 22 19:54:27 2006
       Checksum : 85bf273c - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 0 (0, 1, 2, 65279)
   Array State : Uuu_  
