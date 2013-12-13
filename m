From: Alex <mysqlstudent@gmail.com>
Subject: Help with degraded array
Date: Fri, 13 Dec 2013 17:11:52 -0500
Message-ID: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have an RAID1 array that has entered a degraded state, and the disk
appears to have changed from sda to sdc during this process. I'm not
sure how this affects the array, and could really use some help to
keep me from screwing it up.

The system is an fc15 box with just one array, md0.

# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb2[1]
      148478904 blocks super 1.2 [2/1] [_U]
      bitmap: 1/2 pages [4KB], 65536KB chunk

# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed Mar 21 12:31:23 2012
     Raid Level : raid1
     Array Size : 148478904 (141.60 GiB 152.04 GB)
  Used Dev Size : 148478904 (141.60 GiB 152.04 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Dec 13 17:09:19 2013
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : hqmailrelay:0
           UUID : 99acf2a0:afa1266c:b870423d:f06e4009
         Events : 11504

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       18        1      active sync   /dev/sdb2

# fdisk -l /dev/sda /dev/sdb /dev/sdc

Disk /dev/sdb: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders, total 312581808 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e7781

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048        6143        2048   83  Linux
/dev/sdb2            6144   296966143   148480000   fd  Linux raid autodetect
/dev/sdb3       296966144   299014143     1024000   83  Linux
/dev/sdb4       299014144   312580095     6782976   82  Linux swap / Solaris

Disk /dev/sdc: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders, total 312581808 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000c0feb

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048        6143        2048   83  Linux
/dev/sdc2   *        6144     2054143     1024000   83  Linux
/dev/sdc3         2054144   299014143   148480000   fd  Linux raid autodetect
/dev/sdc4       299014144   312580095     6782976   82  Linux swap / Solaris

Here also is the relevant info from dmesg:

ata1: exception Emask 0x50 SAct 0x0 SErr 0x40d0800 action 0xe frozen
ata1: irq_stat 0x00400040, connection status changed
ata1: SError: { HostInt PHYRdyChg CommWake 10B8B DevExch }
ata1: hard resetting link
ata1: SATA link down (SStatus 0 SControl 300)
ata1: hard resetting link
ata1: SATA link down (SStatus 0 SControl 300)
ata1: limiting SATA link speed to 1.5 Gbps
ata1: hard resetting link
ata1: SATA link down (SStatus 0 SControl 310)
ata1.00: disabled
ata1: EH complete
sd 0:0:0:0: rejecting I/O to offline device
sd 0:0:0:0: [sda] killing request
sd 0:0:0:0: rejecting I/O to offline device
md: super_written gets error=-5, uptodate=0
md/raid1:md0: Disk failure on sda3, disabling device.
md/raid1:md0: Operation continuing on 1 devices.
ata1.00: detaching (SCSI 0:0:0:0)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda]
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:0:0: [sda] Stopping disk
sd 0:0:0:0: [sda] START_STOP FAILED
sd 0:0:0:0: [sda]
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Buffer I/O error on device sda2, logical block 65536
lost page write due to I/O error on sda2
JBD2: Error -5 detected when updating journal superblock for sda2-8.
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:0, dev:sda3
 disk 1, wo:0, o:1, dev:sdb2
RAID1 conf printout:
 --- wd:1 rd:2
 disk 1, wo:0, o:1, dev:sdb2
md: unbind<sda3>
md: export_rdev(sda3)
ata1: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata1: irq_stat 0x00000040, connection status changed
ata1: SError: { CommWake DevExch }
ata1: hard resetting link
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST3160316AS, JC4B, max UDMA/133
ata1.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      ST3160316AS      JC4B PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 0:0:0:0: [sdc] Write Protect is off
sd 0:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4
sd 0:0:0:0: [sdc] Attached SCSI disk

I'd really appreciate any guidance you could provide.

Thanks,
Alex
