From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Can't start array and Negative "Used Dev Size"
Date: Tue, 28 Jun 2011 21:29:37 -0700
Message-ID: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Problem 1: "Used Dev Size"
====================
Note: the system is a Gentoo box, so perhaps I have missed a kernel
configuration option or use flag to deal with large hard drives.

A week or two ago, I resized a raid1 array using 2x3TB drives. I went
through the usual routine: failed one drive, installed and partitioned
(with gdisk) the new 3TB drive, added it to the array, waited for it
to sync, then did the same for the other drive. Finally, I grew the
array to max size and resized the filesystem to its maximum size.
However, after a reboot, I got many errors such as:
EXT3-fs error (device md5): ext3_get_inode_loc: unable to read inode
block - inode=150568961, block=301137922

I tracked this down to the array being the wrong size (too small), so
I unmounted the filesystem grew the array (again) to its max size and
remounted. It seems to be working now, however, it is still syncing:
md5 : active raid1 sdd2[0] sdc2[1]
      2773437376 blocks [2/2] [UU]
      [=======>.............]  resync = 38.2% (1060384320/2773437376)
finish=357.9min speed=79766K/sec

Investigating further, both sdc2 and sdd2 show a negative "Used Dev Size":
mdadm --examine /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 5e21499a:f5562ae2:3b3bf1a1:6e290ac2
  Creation Time : Tue May 15 16:33:14 2007
     Raid Level : raid1
  Used Dev Size : -1521529920 (2644.96 GiB 2840.00 GB)      <<<<<<< WTF???
     Array Size : 2773437376 (2644.96 GiB 2840.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 5

    Update Time : Tue Jun 28 21:01:14 2011
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : dfcdddaf - correct
         Events : 2222657


      Number   Major   Minor   RaidDevice State
this     1       8       34        1      active sync   /dev/sdc2

   0     0       8       50        0      active sync   /dev/sdd2
   1     1       8       34        1      active sync   /dev/sdc2

--detail shows a negative dev size also:
mdadm --detail /dev/md5
/dev/md5:
        Version : 0.90
  Creation Time : Tue May 15 16:33:14 2007
     Raid Level : raid1
     Array Size : 2773437376 (2644.96 GiB 2840.00 GB)
  Used Dev Size : -1
  <<<<<< WTF?
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Tue Jun 28 21:01:14 2011
          State : active, resyncing
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

 Rebuild Status : 38% complete

           UUID : 5e21499a:f5562ae2:3b3bf1a1:6e290ac2
         Events : 0.2222657

    Number   Major   Minor   RaidDevice State
       0       8       50        0      active sync   /dev/sdd2
       1       8       34        1      active sync   /dev/sdc2

Since, I obviously don't want the array to shrink again and this looks
dangerous, I would appreciate advice on how to handle this problem.

Problem 2: Can't start array
====================
Whatever I do, I can't start md4:
mdadm /dev/md4 --assemble
mdadm: /dev/md4 is already in use.

/proc/mdadm:
md4 : inactive sdc1[0](S)
      58591232 blocks super 1.2

 mdadm --detail /dev/md4
mdadm: md device /dev/md4 does not appear to be active.

# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6b67311b:9732e436:07da8ce8:61e8af9c
           Name : server2:4  (local to host server2)
  Creation Time : Fri Jun 10 20:41:23 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 117182464 (55.88 GiB 60.00 GB)
     Array Size : 117182320 (55.88 GiB 60.00 GB)
  Used Dev Size : 117182320 (55.88 GiB 60.00 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f8d1f97e:b15f2e09:a7d55392:b193991a

    Update Time : Tue Jun 28 19:20:08 2011
       Checksum : f6fb6a5 - correct
         Events : 53


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)

 # mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6b67311b:9732e436:07da8ce8:61e8af9c
           Name : server2:4  (local to host server2)
  Creation Time : Fri Jun 10 20:41:23 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 117182464 (55.88 GiB 60.00 GB)
     Array Size : 117182320 (55.88 GiB 60.00 GB)
  Used Dev Size : 117182320 (55.88 GiB 60.00 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 44d1af39:96641daa:ee077d7b:d244ef54

    Update Time : Tue Jun 28 19:20:08 2011
       Checksum : 8e939e3f - correct
         Events : 53


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)


Thanks!
Simon
