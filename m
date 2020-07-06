From: Laurie Denness <laurie@denness.net>
Subject: upgrade from 0.9 to 1.0 metadata caused slight array shrink
Date: Mon, 6 Jul 2020 11:33:48 +0100
Message-ID: <CAGoQN1Bh0BX3BUZV-2MonU0gvGpAqLR_Cy2KvKCUMF7z9Uw4jQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!
I was happily swapping out my 2TB drives for 4TB in my 5 disk RAID 6
array, when I got bitten by the "0.9 metadata does not support drives
larger than 2TB" issue. The NAS had already run a --grow for me before
I realised this could be a problem.

After reading posts (and backing up my data), I attempted the
instructions as per
https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#Converting_between_superblock_versions
and ran:

mdadm --create /dev/md1 -l6 -n5 -c64 --layout=left-symmetric
--metadata=1.0 --assume-clean /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
/dev/sde2
(note I tried to be very careful specifying the defaults!)

Here's my mdadm --detail /dev/md1 from before:

root@127.0.0.1:/mnt# mdadm --detail /dev/md1
/dev/md1:
        Version : 0.90
  Creation Time : Fri Nov 26 21:03:23 2010
     Raid Level : raid6
     Array Size : 11714908416 (11172.21 GiB 11996.07 GB)
  Used Dev Size : -1
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sun Jul  5 13:00:24 2020
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 98493182:5d26fa6e:1c0a08b1:19765080
         Events : 0.729722

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2


And here's the output after the command was run:

root@127.0.0.1:/app/bin# mdadm --detail /dev/md1
/dev/md1:
        Version : 1.0
  Creation Time : Sun Jul  5 15:46:21 2020
     Raid Level : raid6
     Array Size : 11714908032 (11172.21 GiB 11996.07 GB)
  Used Dev Size : 3904969344 (3724.07 GiB 3998.69 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Mon Jul  6 10:57:31 2020
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : N5500:1  (local to host N5500)
           UUID : 5c5ee93c:b52b9bc1:d8cba3fd:802b54ac
         Events : 4

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2



I have LVM and then an XFS filesystem on top of md1, and I got hit by
the dreaded "too small for target":
device-mapper: table: 253:1: md1 too small for target: start=2097536,
len=23427719168, dev_size=23429816064

Which suddenly made sense when I paid attention to the size of the
array before and after:
     Array Size : 11714908416 (11172.21 GiB 11996.07 GB)
     Array Size : 11714908032 (11172.21 GiB 11996.07 GB)

I appear to have lost a tiny amount of space with the re-creation. If
I was not using XFS, I would shrug this off and resize the filesystem,
but since XFS cannot be shrunk, I am open to any advice about the best
course of action to go from here.


Things that crossed my mind:
1) Post here to figure out why I lost a few bytes - here I am! Maybe I
made an error in the re-creation? I did not zero superblocks before
the re-create.
2) The NAS this is hosted on places a 2GB partition that is used for a
5 disk RAID1 (md0) that is only used for swap, so resizing that down
on each drive, failing one by one and letting them resync, so I can
gain back a few megabytes of space and mount my XFS filesystem.


Here's an example of --examine on one of the drives too:

root@127.0.0.1:/app/bin# mdadm -Evvvv /dev/sda2
/dev/sda2:
             Magic : a92b4efc
           Version : 1.0
       Feature Map : 0x0
        Array UUID : 5c5ee93c:b52b9bc1:d8cba3fd:802b54ac
              Name : N5500:1  (local to host N5500)
     Creation Time : Sun Jul  5 15:46:21 2020
        Raid Level : raid6
      Raid Devices : 5

    Avail Dev Size : 7809938808 (3724.07 GiB 3998.69 GB)
        Array Size : 23429816064 (11172.21 GiB 11996.07 GB)
     Used Dev Size : 7809938688 (3724.07 GiB 3998.69 GB)
      Super Offset : 7809939064 sectors
             State : clean
       Device UUID : 3db4c62d:2e43ef6c:bf54eb23:ee928fa9

       Update Time : Mon Jul  6 11:16:51 2020
Update Time(Epoch) : 1594030611
          Checksum : 1ccda3df - correct
   Events(64bits) : 4

            Layout : left-symmetric
        Chunk Size : 64K

      Device Role : Active device 0
      Array State : AAAAA ('A' == active, '.' == missing)


Here's the layout of the drive:

root@127.0.0.1:/tmp# /sbin/sgdisk /dev/sda -p
Disk /dev/sda: 7814037168 sectors, 3.6 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): CCAAA40B-2375-48DA-A8DF-9C629F2E121D
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 7814037134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         4098047   2.0 GiB     FD00
   2         4098048      7814037134   3.6 TiB     FD00


I'm afraid the NAS does not have python available, so I cannot run lsdrv.


Many thanks in advance! Any thoughts welcome.
