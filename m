From: Robert Schultz <rob@schultzfamily.ca>
Subject: RAID 5 3-drive array inactive - no superblock - can anything be
 saved?
Date: Fri, 10 Mar 2017 10:18:19 -0500
Message-ID: <deec02c3-26fd-3297-ec0c-5497cbb9a9e7@schultzfamily.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Before I mess things up even worse.

I have a PC running BackupPC.

The system contains 4 disks:
boot & system: 1x WD 20GB IDE (9.3 years powered on)
backup data: RAID 5 array md0 containing 3 x Seagate 2TB SATA drives
     ST2000DM001-1ER164   /dev/sdb
     ST2000DM001-1CH164   /dev/sdc
     ST2000DM001-1CH164   /dev/sdd

Back around Christmas I was notified of disk errors on the oldest 2TB 
disk. I purchased a new one, failed out the old one, replaced it and 
everything seemed fine.

At some point I noticed that the system had stopped and I was getting 
XFS errors metadata I/O error: block 0x12910b88 
("xfs_trans_read_buf_map") error 117 ....
<snip>
Corruption of in-memory data detected. Shutting down filesystem.

I did a bit of searching and it appears this may have been a cable 
issue. I shutdown, reseated the SATA cables and restarted. I unmounted 
the filesystem, ran xfs_repair and everything seemed fine.

Then it repeated the issue a week or two later. Unfortunately at this 
time it failed one of the disks.

I shutdown, replaced the SATA cables and restarted. I had some issues on 
restart where it would go into recovery mode. I solved this by removing 
the md0 array from fstab and restarted.

At this point I am unable to restart, or re-assemble the array as mdadm 
can't find the superblocks.

 >cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : inactive sdd1[4](S) sdc1[3](S) sdb1[5](S)
       5860147464 blocks super 1.2

unused devices: <none>

 >sudo mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
      Raid Level : raid0
   Total Devices : 3
     Persistence : Superblock is persistent

           State : inactive

            Name : bkp1:0  (local to host bkp1)
            UUID : 77965a25:38a24b98:9ab5899c:7795ded7
          Events : 396761

     Number   Major   Minor   RaidDevice

        -       8       17        -        /dev/sdb1
        -       8       33        -        /dev/sdc1
        -       8       49        -        /dev/sdd1

Trying to reassemble the array:

 >sudo mdadm --assemble --force /dev/md0 /dev/sdb /dev/sdc /dev/sdd
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: /dev/sdb has no superblock - assembly aborted

Running the command with any of the disks says the same thing - no 
superblock.





Here is the mdadm examine for the three disks:
sudo mdadm --examine /dev/sdb1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 77965a25:38a24b98:9ab5899c:7795ded7
            Name : bkp1:0  (local to host bkp1)
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=1200 sectors
           State : clean
     Device UUID : f8a5b84c:6c63d9bf:1b930a93:55f12cb5

     Update Time : Tue Mar  7 08:01:31 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : dd687715 - correct
          Events : 396761

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : A.. ('A' == active, '.' == missing, 'R' == replacing)

---------------------------------------------------------------------
sudo mdadm --examine /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 77965a25:38a24b98:9ab5899c:7795ded7
            Name : bkp1:0  (local to host bkp1)
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=1200 sectors
           State : clean
     Device UUID : 2d4ade03:d6b7e7ce:3744b40b:21a3d17e

     Update Time : Tue Feb 21 23:26:13 2017
        Checksum : e5d43607 - correct
          Events : 396755

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

----------------------------------------------------------------------
  sudo mdadm --examine /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 77965a25:38a24b98:9ab5899c:7795ded7
            Name : bkp1:0  (local to host bkp1)
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=1200 sectors
           State : clean
     Device UUID : 97c3bfe9:8ed96f77:ef13ee6b:007874b3

     Update Time : Tue Feb 21 23:26:13 2017
        Checksum : 91a793b - correct
          Events : 396755

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
------------------------------------------------------------------------
Is the fact that the Array State on sdb only shows 'A..' significant?


fdisk -l shows:

sudo fdisk -l /dev/sd[b-d]
Disk /dev/sdb: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x5ebd3967

Device     Boot Start        End    Sectors  Size Id Type
/dev/sdb1        2048 3907029167 3907027120  1.8T fd Linux raid autodetect
Disk /dev/sdc: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x5ebd3967

Device     Boot Start        End    Sectors  Size Id Type
/dev/sdc1        2048 3907029167 3907027120  1.8T fd Linux raid autodetect
Disk /dev/sdd: 1.8 TiB, 2000398934016 bytes, 3907029168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0x00000000

Device     Boot Start        End    Sectors  Size Id Type
/dev/sdd1        2048 3907029167 3907027120  1.8T fd Linux raid autodetect

Any change of putting this thing back together?










