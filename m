From: Fabio Bacigalupo <info1@open-haus.de>
Subject: Seeking help to get a failed RAID5 system back to life
Date: Fri, 29 Aug 2014 04:07:40 +0200
Message-ID: <CAGgRf0Qe1EU6wZm4BbWqs0diwwnBCeStiVAXaOdHV88Ttn=vfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have been trying all night to get my system back to work. One of the
two remaining hard-drives suddenly stopped working today. I read and
tried everything I could find that seemed to not make things worse
than they are. Finally I stumbled upon this page [1] on the Linux Raid
wiki which recommends to consult this mailing list.

I had a RAID 5 installation with three disks but disk 0 (I assume as
it was /dev/sda3) has been taken out for a while. The disks reside in
a remote server.

Sorry if this is obvious to you but I am totally stuck. I always run
into dead ends.

Your help is very much appreciated!

Thank you for any hints,
Fabio

I could gather the following information:

================================================================================

# mdadm --examine /dev/sd*3
mdadm: No md superblock detected on /dev/sda3.
/dev/sdb3:
    Magic : a92b4efc
    Version : 0.90.00
    UUID : f07f4bc6:36864b49:776c2c25:004bd7b2
    Creation Time : Wed May  4 08:18:11 2011
    Raid Level : raid5
    Used Dev Size : 1462766336 (1395.00 GiB 1497.87 GB)
    Array Size : 2925532672 (2790.01 GiB 2995.75 GB)
    Raid Devices : 3
    Total Devices : 1
    Preferred Minor : 127

    Update Time : Thu Aug 28 19:55:59 2014
    State : clean
    Active Devices : 1
    Working Devices : 1
    Failed Devices : 1
    Spare Devices : 0
    Checksum : 490fa722 - correct
    Events : 68856340

    Layout : left-symmetric
    Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

   0     0       0        0        0      removed
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       0        0        2      faulty removed
/dev/sdc3:
    Magic : a92b4efc
    Version : 0.90.00
    UUID : f07f4bc6:36864b49:776c2c25:004bd7b2
    Creation Time : Wed May  4 08:18:11 2011
    Raid Level : raid5
    Used Dev Size : 1462766336 (1395.00 GiB 1497.87 GB)
    Array Size : 2925532672 (2790.01 GiB 2995.75 GB)
    Raid Devices : 3
    Total Devices : 2
    Preferred Minor : 127

    Update Time : Thu Aug 28 19:22:19 2014
    State : active
    Active Devices : 2
    Working Devices : 2
    Failed Devices : 0
    Spare Devices : 0
    Checksum : 44f4f557 - correct
    Events : 68856326

    Layout : left-symmetric
    Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       35        2      active sync   /dev/sdc3

   0     0       0        0        0      removed
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8       35        2      active sync   /dev/sdc3


================================================================================

# mdadm --examine /dev/sd[b]
/dev/sdb:
   MBR Magic : aa55
Partition[0] :      4737024 sectors at         2048 (type 83)
Partition[2] :   2925532890 sectors at      4739175 (type fd)


================================================================================

Disk /dev/sdc has been replaced with a new hard drive as the old one
had input/output errors.

I assume this is weired and showed /dev/sdb3 before (changing things):

# cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>

I tried to copy the structure from /dev/sdb to /dev/sdc which assumably work:

# sgdisk -R /dev/sdc /dev/sdb

***************************************************************
Found invalid GPT and valid MBR; converting MBR to GPT format
in memory.
***************************************************************

The operation has completed successfully.

# sgdisk -G /dev/sdc

The operation has completed successfully.

# fdisk -l

-- Removed /dev/sda --

Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes, 2930277168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0005fb16

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     4739071     2368512   83  Linux
/dev/sdb3   *     4739175  2930272064  1462766445   fd  Linux raid autodetect
WARNING: fdisk GPT support is currently new, and therefore in an
experimental phase. Use at your own discretion.

Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes, 2930277168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: gpt

#         Start          End    Size  Type            Name
 1         2048      4739071    2.3G  Linux filesyste Linux filesystem
 3      4739175   2930272064    1.4T  Linux RAID      Linux RAID


# mdadm --assemble /dev/md127 /dev/sd[bc]3
mdadm: no RAID superblock on /dev/sdc3
mdadm: /dev/sdc3 has no superblock - assembly aborted

# mdadm --assemble /dev/md127 /dev/sd[b]3
mdadm: /dev/md127 assembled from 1 drive - not enough to start the array.

# mdadm --misc -QD /dev/sd[bc]3
mdadm: /dev/sdb3 does not appear to be an md device
mdadm: /dev/sdc3 does not appear to be an md device

# mdadm --detail /dev/md127
/dev/md127:
        Version :
     Raid Level : raid0
  Total Devices : 0

          State : inactive

    Number   Major   Minor   RaidDevice


[1] https://raid.wiki.kernel.org/index.php/RAID_Recovery
