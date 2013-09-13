From: Robert Schultz <rob@schultzfamily.ca>
Subject: RAID 5 3-drive array failed 2 disks at once - can anything be saved?
Date: Fri, 13 Sep 2013 10:55:31 -0400
Message-ID: <52332763.30901@schultzfamily.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Heeding the advice to ask questions before messing things up even worse, 
here goes.

I have a PC running BackupPC.

The system contains 4 disks:
boot & system: 1x WD 20GB IDE
backup data: RAID 5 array containing 3 x Seagate 2TB SATA drives
     ST32000542AS    /dev/sdb
     ST2000DM001     /dev/sdc
     ST32000542AS    /dev/sdd

Two days ago the system alerted me to a problem with the array:

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sdd1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid5 sdc1[3](F) sdd1[1](F) sdb1[0]
       3906763776 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/1] [U__]
       
unused devices: <none>

followed by:

A FailSpare event had been detected on md device /dev/md0.

It could be related to component device /dev/sdc1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid5 sdc1[3](F) sdd1[1](F) sdb1[0]
       3906763776 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/1] [U__]
       
unused devices: <none>


and then:

A Fail event had been detected on md device /dev/md0.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
md0 : active raid5 sdc1[3](F) sdd1[1](F) sdb1[0]
       3906763776 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/1] [U__]
       
unused devices: <none>

I rebooted the machine and the system dropped to busybox after throwing 
a bunch of errors like:

exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
BMDMA stat 0x64
failed command: READ DMA
cmd c8/00:08:08:08:00/00:00:00:00:00/f0 tag 0 dma 4096 in
res 51/40:00:0a:08:00/00:00:00:00:00/10 Emask 0x9 (media error)
status: { DRDY ERR }
error: { UNC }

I rebooted into Seatools and ran short tests. Drive sdd failed. I ran 
the long test and repaired the disk. I assume this disk is completely 
gone. It's under warranty and I'll have to open an RMA, even though at 
this point Seatools thinks it is in fine share :-(

Unfortunately, for some reason the array failed sdc and Seatools shows 
it as fine.

Here is the mdadm detail:
root@bkpr:~# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
   Used Dev Size : 1953381888 (1862.89 GiB 2000.26 GB)
    Raid Devices : 3
   Total Devices : 1
     Persistence : Superblock is persistent

     Update Time : Wed Sep 11 21:54:08 2013
           State : active, FAILED, Not Started
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : bkp1:0
            UUID : 77965a25:38a24b98:9ab5899c:7795ded7
          Events : 308470

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       0        0        1      removed
        2       0        0        2      removed
-----------------------------------------------------------------


Here is the mdadm examine for the three disks:
root@bkpr:~# mdadm --examine /dev/sdb1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 77965a25:38a24b98:9ab5899c:7795ded7
            Name : bkp1:0
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 16788208:ea47ea51:fbbd84d9:1a2b61c7

     Update Time : Wed Sep 11 21:54:08 2013
        Checksum : 7d57a8ae - correct
          Events : 308470

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : A.. ('A' == active, '.' == missing)
---------------------------------------------------------------------
root@bkpr:~# mdadm --examine /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 77965a25:38a24b98:9ab5899c:7795ded7
            Name : bkp1:0
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 1d29c79a:2a7c1bb3:130cbed5:9afce2e8

     Update Time : Wed Sep 11 03:34:39 2013
        Checksum : 8e8eabd9 - correct
----------------------------------------------------------------------
root@bkpr:~# mdadm --examine /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 77965a25:38a24b98:9ab5899c:7795ded7
            Name : bkp1:0
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 2d4ade03:d6b7e7ce:3744b40b:21a3d17e

     Update Time : Wed Sep 11 03:34:39 2013
        Checksum : df56e740 - correct
          Events : 308467

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAA ('A' == active, '.' == missing)

          Events : 308467

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAA ('A' == active, '.' == missing)

fdisk -l shows:

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x10197396

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048  3907029167  1953513560   fd  Linux raid autodetect

Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x08a89851

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048  3907029167  1953513560   fd  Linux raid autodetect

Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
18 heads, 63 sectors/track, 3445352 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x5ebd3967

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048  3907029167  1953513560   fd  Linux raid autodetect


Odd (to me anyways) is that lshw shows sdc as having an ext4 filesystem. The array was using xfs.

*-disk:0

                 description: ATA Disk

                 product: ST32000542AS

                 vendor: Seagate

                 physical id: 0

                 bus info:scsi@2:0.1.0

                 logical name: /dev/sdb

                 version: CC34

                 serial: 5XW21KAF

                 size: 1863Gi
B (2TB)

                 capabilities: partitioned partitioned:dos

                 configuration: ansiversion=5 signature=10197396

               *-volume

                    description: Linux raid autodetect partition

                    physical id: 1

                    bus info:scsi@2:0.1.0,1

                    logical name: /dev/sdb1

                    capacity: 1863GiB

                    capabilities: primary multi

            *-disk:1

                 description: ATA Disk

                 product: ST2000DM001-1CH1

                 vendor: Seagate

                 physical id: 0.0.0

                 bus info:scsi@3:0.0.0

                 logical name: /dev/sdc

                 version: CC24

                 serial: Z1E27DHL

                 size: 1863GiB (2TB)

                 capabilities: partitioned partitioned:dos

                 configuration: ansiversion=5 signature=5ebd3967

               *-volume

                    description: EXT4 volume

                    vendor: Linux

                    physical id: 1

                    bus info:scsi@3:0.0.0,1

                    logical name: /dev/sdc1

                    version: 1.0

                    serial: 7b6fdeb3-8632-450a-bc51-67c49ecc4ce9

                    size: 1863GiB

                    capacity: 1863GiB

                    capabilities: primary multi journaled extended_attributes large_files huge_files dir_nlink extents ext4 ext2 initialized

                    configuration: created=2013-05-17 11:56:52 filesystem=ext4 lastmountpoint=/mnt/2T modified=2013-06-15 21:52:50 mounted=2013-05-31 11:02:35 state=clean

            *-disk:2

                 
description: ATA Disk

                 product: ST32000542AS

                 vendor: Seagate

                 physical id: 1

                 bus info:scsi@3:0.1.0

                 logical name: /dev/sdd

                 version: CC34

                 serial: 5XW24A5V

                 size: 1863GiB (2TB)

                 capabilities: partitioned partitioned:dos

                 configuration: ansiversion=5 signature=08a89851

               *-volume

                    description: Linux raid autodetect partition

                    physical id: 1

                    bus info:scsi@3:0.1.0,1

                    logical name: /dev/sdd1

                    capacity: 1863GiB

                    capabilities: primary multi

         *-serial UNCLAIMED

              description: SMBus

              product: N10/ICH 7 Family SMBus Controller

              vendor: Intel Corporation

              physical id: 1f.3

              bus info:pci@0000:00:1f.3

              version: 01

              width: 32 bits

              clock: 33MHz

              configuration: latency=0

              resources: ioport:400(size=32)



         scd probably
     did have an ext 4 filesystem at one time since it was used to back
     up the RAID 1 array before converting to RAID 5.

     

     So is there anything I can do before I attempt reassembling the
     array?

     

     Rob

     

     

     
     

     

     

     

     

   


