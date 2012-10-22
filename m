From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: 4x3TB raid5 - no autodetect
Date: Mon, 22 Oct 2012 15:55:07 +0200
Message-ID: <441614417.20121022155507@oudeis.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to create a RAID5 consisting of 4 3TB drives from scratch:

drives are western digital caviar green:

ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-8: WDC WD30EZRX-00MMMB0, 80.00A80, max UDMA/133
ata6.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/133

- GPT partitions created with gdisk, type=FD00 (all 4 drives)
GPT fdisk (gdisk) version 0.6.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): p
Disk /dev/sdb: 5860533168 sectors, 2.7 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): 6AA3BE6A-D2F1-4124-91C2-F6A940893912
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 5860533134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      5860533134   2.7 TiB     FD00  Linux RAID

- raid created using:
# mdadm --create /dev/md0 --level=5 --metadata=1.2 --raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
before that the raid was created without "--metadata=1.2", also didn't
work.

- on boot, dmesg says:
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sdb1
md: sdb1 has invalid sb, not importing!
md: invalid raid superblock magic on sdc1
md: sdc1 has invalid sb, not importing!
md: invalid raid superblock magic on sdd1
md: sdd1 has invalid sb, not importing!
md: invalid raid superblock magic on sde1
md: sde1 has invalid sb, not importing!
md: autorun ...
md: ... autorun DONE.

manually starting the array works:
# mdadm -A /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
 
distribution is CentOS 5
kernel is 2.6.18-308.13.1.el5 #1 SMP Tue Aug 21 17:10:18 EDT 2012 x86_64 x86_64 x86_64 GNU/Linux
mdadm - v2.6.9 - 10th March 2009

]# mdadm --misc --detail /dev/md0
/dev/md0:
        Version : 1.02
  Creation Time : Mon Oct 22 15:07:04 2012
     Raid Level : raid5
     Array Size : 8790796032 (8383.56 GiB 9001.78 GB)
  Used Dev Size : 2930265344 (2794.52 GiB 3000.59 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Oct 22 15:31:35 2012
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 1% complete

           Name : 0
           UUID : dae0c282:714e8425:18e57ac1:f66d33a8
         Events : 2

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       4       8       65        3      spare rebuilding   /dev/sde1

# mdadm --misc --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dae0c282:714e8425:18e57ac1:f66d33a8
           Name : 0
  Creation Time : Mon Oct 22 15:07:04 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860530815 (2794.52 GiB 3000.59 GB)
     Array Size : 17581592064 (8383.56 GiB 9001.78 GB)
  Used Dev Size : 5860530688 (2794.52 GiB 3000.59 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 52a595c7:6653dda4:552c9f60:18d599f2

    Update Time : Mon Oct 22 15:31:35 2012
       Checksum : d6779191 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 0 (0, 1, 2, failed, 3)
   Array State : Uuuu 1 failed

# mdadm --misc --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dae0c282:714e8425:18e57ac1:f66d33a8
           Name : 0
  Creation Time : Mon Oct 22 15:07:04 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860530815 (2794.52 GiB 3000.59 GB)
     Array Size : 17581592064 (8383.56 GiB 9001.78 GB)
  Used Dev Size : 5860530688 (2794.52 GiB 3000.59 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4123cbb0:d1277335:e3921bc6:364225d6

    Update Time : Mon Oct 22 15:31:35 2012
       Checksum : 994ab798 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 1 (0, 1, 2, failed, 3)
   Array State : uUuu 1 failed

# mdadm --misc --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dae0c282:714e8425:18e57ac1:f66d33a8
           Name : 0
  Creation Time : Mon Oct 22 15:07:04 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860530815 (2794.52 GiB 3000.59 GB)
     Array Size : 17581592064 (8383.56 GiB 9001.78 GB)
  Used Dev Size : 5860530688 (2794.52 GiB 3000.59 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5368012a:ec82ec5f:cdb40a87:b8532e7a

    Update Time : Mon Oct 22 15:31:35 2012
       Checksum : a1f28b31 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 2 (0, 1, 2, failed, 3)
   Array State : uuUu 1 failed

# mdadm --misc --examine /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : dae0c282:714e8425:18e57ac1:f66d33a8
           Name : 0
  Creation Time : Mon Oct 22 15:07:04 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860530815 (2794.52 GiB 3000.59 GB)
     Array Size : 17581592064 (8383.56 GiB 9001.78 GB)
  Used Dev Size : 5860530688 (2794.52 GiB 3000.59 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
Recovery Offset : 81916672 sectors
          State : clean
    Device UUID : a262c799:11903bf3:198e50f5:f978762b

    Update Time : Mon Oct 22 15:31:35 2012
       Checksum : c9778437 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 4 (0, 1, 2, failed, 3)
   Array State : uuuU 1 failed
# mdadm --misc --examine /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : dae0c282:714e8425:18e57ac1:f66d33a8
           Name : 0
  Creation Time : Mon Oct 22 15:07:04 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860530815 (2794.52 GiB 3000.59 GB)
     Array Size : 17581592064 (8383.56 GiB 9001.78 GB)
  Used Dev Size : 5860530688 (2794.52 GiB 3000.59 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
Recovery Offset : 81916672 sectors
          State : clean
    Device UUID : a262c799:11903bf3:198e50f5:f978762b

    Update Time : Mon Oct 22 15:31:35 2012
       Checksum : c9778437 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 4 (0, 1, 2, failed, 3)
   Array State : uuuU 1 failed
   

       
there's something I'm missing here - please advise.

thnx.

