From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Enlarging device of linear array again (Thank you Stan!)
Date: Tue, 20 Sep 2016 21:34:42 +0200
Message-ID: <20160920213442.1559310f@hoferr-X240.hofer.rummelring>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

In 2012 this list - especially Stan Hoeppner - helped me setting up a
linear RAID containing four RAID5. Thank you so much again! It is still
working amazingly well :-D

Now I am at the point where I want to add more storage but have no more
slots. As discussed in 2013 I will replace four discs with partitions
from a larger HDD and add the remaining space to a new RAID5.

md2 should be replaced:

$ sudo mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Sun Jun 17 20:08:48 2012
     Raid Level : raid5
     Array Size : 4395412224 (4191.79 GiB 4500.90 GB)
  Used Dev Size : 1465137408 (1397.26 GiB 1500.30 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Sep 20 09:12:16 2016
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : media-server:2  (local to host media-server)
           UUID : 1c74447b:33070712:cfcfa5af:cbfea660
         Events : 2449

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde
       1       8       80        1      active sync   /dev/sdf
       2       8       96        2      active sync   /dev/sdg
       4       8      112        3      active sync   /dev/sdh


$ sudo fdisk -l /dev/sd[efgh]

Disk /dev/sde: 1.4 TiB, 1500301910016 bytes, 2930277168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x00097014


Disk /dev/sdf: 1.4 TiB, 1500301910016 bytes, 2930277168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x0007694c


Disk /dev/sdg: 1.4 TiB, 1500301910016 bytes, 2930277168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000da169


Disk /dev/sdh: 1.4 TiB, 1500301910016 bytes, 2930277168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000beebc


$ sudo mdadm --examine /dev/sd[efgh]
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1c74447b:33070712:cfcfa5af:cbfea660
           Name : media-server:2  (local to host media-server)
  Creation Time : Sun Jun 17 20:08:48 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 4395412224 (4191.79 GiB 4500.90 GB)
  Used Dev Size : 2930274816 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=304 sectors
          State : clean
    Device UUID : 270f29c9:0a36cd7a:27324b70:7f4e929b

    Update Time : Tue Sep 20 09:12:16 2016
       Checksum : dc24915c - correct
         Events : 2449

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1c74447b:33070712:cfcfa5af:cbfea660
           Name : media-server:2  (local to host media-server)
  Creation Time : Sun Jun 17 20:08:48 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 4395412224 (4191.79 GiB 4500.90 GB)
  Used Dev Size : 2930274816 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=304 sectors
          State : clean
    Device UUID : fe2fffdc:6d072a9d:87757913:ae7365db

    Update Time : Tue Sep 20 09:12:16 2016
       Checksum : f558ec26 - correct
         Events : 2449

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1c74447b:33070712:cfcfa5af:cbfea660
           Name : media-server:2  (local to host media-server)
  Creation Time : Sun Jun 17 20:08:48 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 4395412224 (4191.79 GiB 4500.90 GB)
  Used Dev Size : 2930274816 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=304 sectors
          State : clean
    Device UUID : f27f55c2:f66f5fe9:02943932:2cf47cca

    Update Time : Tue Sep 20 09:12:16 2016
       Checksum : 34bc439e - correct
         Events : 2449

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1c74447b:33070712:cfcfa5af:cbfea660
           Name : media-server:2  (local to host media-server)
  Creation Time : Sun Jun 17 20:08:48 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 4395412224 (4191.79 GiB 4500.90 GB)
  Used Dev Size : 2930274816 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=304 sectors
          State : clean
    Device UUID : 642511df:7f5d1022:a1b40e7b:6ebd37c6

    Update Time : Tue Sep 20 09:12:16 2016
       Checksum : ceb8c19b - correct
         Events : 2449

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)




I hope to simply do the following steps:

## Replace old disk with new partitions

# Step 1: Create partitions on disk
$ sudo fdisk /dev/sde
create 1465137408 (1397.26 GiB 1500.30 GB) partition and a second on
with the rest

# Step 2: Replace old disk with new partition
$ sudo mdadm --manage /dev/md4 --add /dev/sde1

# Step 3: Wait until rebuilt

# Step 4: Repeat steps 1-3 for /dev/sd[fgh]


## Add new partitions

# Step 5: Create new Raid5
sudo mdadm -C /dev/md5 -c 128 -n4 -l5 /dev/sd[efgh]2

# Step 6: Add new Raid5 to linear
sudo mdadm --grow /dev/md0 --add /dev/md5

# Step 7: Grow filesystem
sudo xfs_growfs /mnt/media-raid



I am using 4 TB WD red to replace the 1.5 TB disks.

Do you think this could work?
Are there any pitfalls?
Should I unmount the array to perform all these steps? It might be
safer since there is no redundancy during the replacement?

I just wanted to check first before making any mistakes. Instead of
maybe afterwards asking for help recovering my data :-P


Best regards,
Ramon
