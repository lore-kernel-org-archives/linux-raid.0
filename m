From: "David F." <df7729@gmail.com>
Subject: RAID header in XFS area?
Date: Sat, 4 Nov 2017 11:10:18 -0700
Message-ID: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Question,  We had a customer remove a drive from a NAS device that as
mirrored using mdadm, the file system id for the partitions were 0xFD
(linux raid automount). The put it on a USB port and booted Linux
which attempts to mount any RAID devices.  The XFS had some issues, so
looking at it I see some type of RAID header for MyBook:2 at offset
4K.   Searching Internet on mdadm found:

Version 1.2: The superblock is 4 KiB after the beginning of the device.

I wouldn't think the RAID area would be available to the file system,
but assuming so, there must be some type of way to find out where the
real data for that went?   Or perhaps mdadm messed it up when trying
to mount and the other drive didn't exist.  Here details of it.

Output of 'fdisk -l' (using fdisk v2.25.2 from util-linux for GPT support)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Disk /dev/sda: 223.6 GiB, 240057409536 bytes, 468862128 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x6212a1ca

Device     Boot Start       End   Sectors   Size Id Type
/dev/sda1  *       63 468857024 468856962 223.6G  7 HPFS/NTFS/exFAT

Disk /dev/sdb: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00000300

Device     Boot   Start        End    Sectors   Size Id Type
/dev/sdb1         64320    3984191    3919872   1.9G fd Linux raid autodetect
/dev/sdb2       3984192    4498175     513984   251M fd Linux raid autodetect
/dev/sdb3       4498176    6474175    1976000 964.9M fd Linux raid autodetect
/dev/sdb4       6474176 1953520064 1947045889 928.4G fd Linux raid autodetect

Disk /dev/sdd: 1.9 GiB, 2038431744 bytes, 3981312 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc3072e18

Device     Boot Start     End Sectors  Size Id Type
/dev/sdd1  *       64 3981311 3981248  1.9G  c W95 FAT32 (LBA)

Disk /dev/sdc: 465.8 GiB, 500107862016 bytes, 976773168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x09b2e054




Contents of /proc/mdstat (Linux software RAID status):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md2 : inactive sdb4[1](S)
      973522808 blocks super 1.2

md3 : inactive sdb3[1](S)
      987904 blocks

md1 : inactive sdb2[1](S)
      256896 blocks

md0 : inactive sdb1[1](S)
      1959872 blocks

unused devices: <none>

Contents of /run/mdadm/map (Linux software RAID arrays):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md2 1.2 8cc3c938:cd679958:86493280:2ae3f5f1 /dev/md/2
md1 0.90 5972f4e9:22fa2576:3b6d8c49:0838e6b9 /dev/md1
md0 0.90 06ba2d0c:8282ab7e:3b6d8c49:0838e6b9 /dev/md0
md3 0.90 f18a5702:7247eda1:3b6d8c49:0838e6b9 /dev/md3

Contents of /etc/mdadm/mdadm.conf (Linux software RAID config file):
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

ARRAY /dev/md0 UUID=06ba2d0c:8282ab7e:3b6d8c49:0838e6b9
ARRAY /dev/md1 UUID=5972f4e9:22fa2576:3b6d8c49:0838e6b9
ARRAY /dev/md3 UUID=f18a5702:7247eda1:3b6d8c49:0838e6b9
ARRAY /dev/md/2  metadata=1.2 UUID=38c9c38c:589967cd:80324986:f1f5e32a
name=MyBook:2

Contents of mdadm.txt (mdadm troubleshooting data captured when
'start-md' is executed):
mdadm - v3.4 - 28th January 2016
Output of 'mdadm --examine --scan'
ARRAY /dev/md0 UUID=06ba2d0c:8282ab7e:3b6d8c49:0838e6b9
ARRAY /dev/md1 UUID=5972f4e9:22fa2576:3b6d8c49:0838e6b9
ARRAY /dev/md3 UUID=f18a5702:7247eda1:3b6d8c49:0838e6b9
ARRAY /dev/md/2  metadata=1.2 UUID=38c9c38c:589967cd:80324986:f1f5e32a
name=MyBook:2
Output of 'mdadm --assemble --scan --no-degraded -v'
mdadm: looking for devices for /dev/md0
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: Cannot assemble mbr metadata on /dev/sdd1
mdadm: Cannot assemble mbr metadata on /dev/sdd
mdadm: /dev/sdb4 has wrong uuid.
mdadm: /dev/sdb3 has wrong uuid.
mdadm: /dev/sdb2 has wrong uuid.
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sdb
mdadm: No super block found on /dev/sr0 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sr0
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sda1
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: /dev/md0 assembled from 1 drive (out of 2), but not started.
mdadm: looking for devices for /dev/md1
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: Cannot assemble mbr metadata on /dev/sdd1
mdadm: Cannot assemble mbr metadata on /dev/sdd
mdadm: /dev/sdb4 has wrong uuid.
mdadm: /dev/sdb3 has wrong uuid.
mdadm: /dev/sdb1 has wrong uuid.
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sdb
mdadm: No super block found on /dev/sr0 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sr0
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sda1
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdb2 is identified as a member of /dev/md1, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md1
mdadm: added /dev/sdb2 to /dev/md1 as 1
mdadm: /dev/md1 assembled from 1 drive (out of 2), but not started.
mdadm: looking for devices for /dev/md3
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: Cannot assemble mbr metadata on /dev/sdd1
mdadm: Cannot assemble mbr metadata on /dev/sdd
mdadm: /dev/sdb4 has wrong uuid.
mdadm: /dev/sdb2 has wrong uuid.
mdadm: /dev/sdb1 has wrong uuid.
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sdb
mdadm: No super block found on /dev/sr0 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sr0
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sda1
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdb3 is identified as a member of /dev/md3, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md3
mdadm: added /dev/sdb3 to /dev/md3 as 1
mdadm: /dev/md3 assembled from 1 drive (out of 2), but not started.
mdadm: looking for devices for /dev/md/2
mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sdc
mdadm: No super block found on /dev/sdd1 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sdd1
mdadm: No super block found on /dev/sdd (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sdd
mdadm: No super block found on /dev/sdb3 (Expected magic a92b4efc, got 0000003e)
mdadm: no RAID superblock on /dev/sdb3
mdadm: No super block found on /dev/sdb2 (Expected magic a92b4efc, got 37383333)
mdadm: no RAID superblock on /dev/sdb2
mdadm: No super block found on /dev/sdb1 (Expected magic a92b4efc, got 00000002)
mdadm: no RAID superblock on /dev/sdb1
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 45300000)
mdadm: no RAID superblock on /dev/sdb
mdadm: No super block found on /dev/sr0 (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sr0
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 000014b9)
mdadm: no RAID superblock on /dev/sda1
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/sda
mdadm: /dev/sdb4 is identified as a member of /dev/md/2, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md/2
mdadm: added /dev/sdb4 to /dev/md/2 as 1
mdadm: /dev/md/2 assembled from 1 drive (out of 2), but not started.
Output of 'dmesg | grep md:'
md: md0 stopped.
md: md1 stopped.
md: md3 stopped.
md: md2 stopped.


Output of 'mdadm --examine /dev/sda'
/dev/sda:
   MBR Magic : aa55
Partition[0] :    468856962 sectors at           63 (type 07)


Output of 'mdadm --examine /dev/sdb'
/dev/sdb:
   MBR Magic : aa55
Partition[0] :      3919872 sectors at        64320 (type fd)
Partition[1] :       513984 sectors at      3984192 (type fd)
Partition[2] :      1976000 sectors at      4498176 (type fd)
Partition[3] :   1947045889 sectors at      6474176 (type fd)


Output of 'mdadm --examine /dev/sdc'
/dev/sdc:
   MBR Magic : aa55


Output of 'mdadm --examine /dev/sdd'
/dev/sdd:
   MBR Magic : aa55
Partition[0] :      3981248 sectors at           64 (type 0c)


Output of 'mdadm --detail /dev/md*', if any:
/dev/md0:
        Version : 0.90
     Raid Level : raid0
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

          State : inactive

           UUID : 06ba2d0c:8282ab7e:3b6d8c49:0838e6b9
         Events : 0.6876

    Number   Major   Minor   RaidDevice

       -       8       17        -        /dev/sdb1
/dev/md1:
        Version : 0.90
     Raid Level : raid0
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

          State : inactive

           UUID : 5972f4e9:22fa2576:3b6d8c49:0838e6b9
         Events : 0.2

    Number   Major   Minor   RaidDevice

       -       8       18        -        /dev/sdb2
/dev/md2:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 1
    Persistence : Superblock is persistent

          State : inactive

           Name : MyBook:2
           UUID : 38c9c38c:589967cd:80324986:f1f5e32a
         Events : 2

    Number   Major   Minor   RaidDevice

       -       8       20        -        /dev/sdb4
/dev/md3:
        Version : 0.90
     Raid Level : raid0
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

          State : inactive

           UUID : f18a5702:7247eda1:3b6d8c49:0838e6b9
         Events : 0.1200

    Number   Major   Minor   RaidDevice

       -       8       19        -        /dev/sdb3

Contents of /dev/mapper directory:
crw------T    1 root     root       10, 236 Jul  8 11:50 control
