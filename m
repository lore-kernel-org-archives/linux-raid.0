From: Adam B <adam.backer@gmail.com>
Subject: Lost second disk during resync, can I recover?
Date: Sun, 16 Apr 2017 17:30:26 -0700
Message-ID: <CABM35JeXN_+coqggH4JDxCvvYAeqD4jt0FHHY=ykMMRofdQDJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a synology ds1812+
Could have sworn I did raid 6, but md says raid5 (dont recall
personalities pre-failure)
Lost disk 2, was rebuilding and disk 6 crashed.

Booting from a fresh machine, and attempting to discover the arrays
(md125 is the target)

root@ds:~# mdadm --assemble --scan
mdadm: /dev/md/DiskStation:2 assembled from 6 drives - not enough to
start the array.
mdadm: /dev/md/1_1 has been started with 7 drives (out of 8).
mdadm: /dev/md/0_1 has been started with 7 drives (out of 8).
mdadm: /dev/md/DiskStation:2 exists - ignoring
mdadm: /dev/md125 assembled from 6 drives - not enough to start the array.
root@ds:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md126 : active raid1 sda1[0] sdh1[7] sdg1[6] sde1[4] sdd1[3] sdc1[2] sdb1[1]
      2490176 blocks [8/7] [UUUUU_UU]

md127 : active raid1 sda2[0] sdb2[7] sdh2[6] sdg2[5] sde2[3] sdd2[2] sdc2[1]
      2097088 blocks [8/7] [UUUU_UUU]

md2 : active raid5 sdf3[5]
      20478809792 blocks super 1.2 level 5, 64k chunk, algorithm 2
[8/1] [_____U__]

md1 : active raid1 sdf2[0]
      2097088 blocks [8/1] [U_______]

md0 : active raid1 sdf1[0]
      2490176 blocks [8/1] [U_______]

Attempting to assemble gives the same error:
root@ds:~# mdadm --assemble --force /dev/md125 /dev/sda3 /dev/sdb3
/dev/sdc3 /dev/sdd3 /dev/sde3 /dev/sdg3 /dev/sdh3
mdadm: /dev/md125 assembled from 6 drives - not enough to start the array.

but also yields:
root@ds:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md125 : inactive sda3[8](S) sdh3[7](S) sdg3[6](S) sde3[4](S)
sdd3[3](S) sdc3[2](S) sdb3[9](S)
      20478810915 blocks super 1.2

but:

root@ds:~# mdadm --detail /dev/md125
mdadm: md device /dev/md125 does not appear to be active.

I attempt to run:
root@ds:~# mdadm --manage --run /dev/md125
mdadm: started /dev/md125
root@ds:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md125 : active raid5 sda3[8] sdh3[7] sdg3[6] sde3[4] sdd3[3] sdc3[2]
      20478809792 blocks super 1.2 level 5, 64k chunk, algorithm 2
[8/6] [U_UUU_UU]

Add back in the disk we were rebuilding (disk 2) before we lost disk 6:
root@ds:~# mdadm --manage /dev/md125 --add /dev/sdb3
mdadm: added /dev/sdb3
root@ds:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md125 : active raid5 sdb3[9](S) sda3[8] sdh3[7] sdg3[6] sde3[4] sdd3[3] sdc3[2]
      20478809792 blocks super 1.2 level 5, 64k chunk, algorithm 2
[8/6] [U_UUU_UU]

But nothing is happening, recovery-wise:

root@ds:~# mdadm -D /dev/md125
/dev/md125:
        Version : 1.2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
     Array Size : 20478809792 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 2925544256 (2790.02 GiB 2995.76 GB)
   Raid Devices : 8
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Sun Apr 16 16:22:16 2017
          State : clean, FAILED
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           Name : DiskStation:2
           UUID : e299685e:5842617d:6d90981b:8f7b91e4
         Events : 351742

    Number   Major   Minor   RaidDevice State
       8       8        3        0      active sync   /dev/hda3
       1       0        0        1      removed
       2       8       35        2      active sync   /dev/sdc3
       3       8       51        3      active sync   /dev/sdd3
       4       8       67        4      active sync   /dev/sde3
       5       0        0        5      removed
       6       8       99        6      active sync   /dev/sdg3
       7       8      115        7      active sync   /dev/sdh3

       9       8       19        -      spare   /dev/sdb3



Sooo.. how screwed am I?  Can I recover?  Detailed drive status from
--examine below:



root@ds:~# cat raid.status
/dev/sda3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e299685e:5842617d:6d90981b:8f7b91e4
           Name : DiskStation:2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 5851088833 (2790.02 GiB 2995.76 GB)
     Array Size : 40957619584 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 5851088512 (2790.02 GiB 2995.76 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f6be170f:999d3a14:0911df81:519c5544

    Update Time : Sun Apr 16 16:33:10 2017
       Checksum : eef101aa - correct
         Events : 351744

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : A.AAA.AA ('A' == active, '.' == missing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e299685e:5842617d:6d90981b:8f7b91e4
           Name : DiskStation:2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 5851088833 (2790.02 GiB 2995.76 GB)
     Array Size : 40957619584 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 5851088512 (2790.02 GiB 2995.76 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0f426e67:9501ed59:df7ecf80:36f1bc62

    Update Time : Sun Apr 16 16:33:10 2017
       Checksum : aa51ab8c - correct
         Events : 351744

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : spare
   Array State : A.AAA.AA ('A' == active, '.' == missing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e299685e:5842617d:6d90981b:8f7b91e4
           Name : DiskStation:2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 5851088833 (2790.02 GiB 2995.76 GB)
     Array Size : 40957619584 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 5851088512 (2790.02 GiB 2995.76 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 10494bba:5db57d5f:bbabfc26:7792e5ad

    Update Time : Sun Apr 16 16:33:10 2017
       Checksum : f415346b - correct
         Events : 351744

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : A.AAA.AA ('A' == active, '.' == missing)
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e299685e:5842617d:6d90981b:8f7b91e4
           Name : DiskStation:2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 5851088833 (2790.02 GiB 2995.76 GB)
     Array Size : 40957619584 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 5851088512 (2790.02 GiB 2995.76 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 253ec56c:8d4a1ffa:24abf930:a47b2c9e

    Update Time : Sun Apr 16 16:33:10 2017
       Checksum : 3b74a738 - correct
         Events : 351744

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : A.AAA.AA ('A' == active, '.' == missing)
/dev/sde3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e299685e:5842617d:6d90981b:8f7b91e4
           Name : DiskStation:2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 5851088833 (2790.02 GiB 2995.76 GB)
     Array Size : 40957619584 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 5851088512 (2790.02 GiB 2995.76 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c3e94c4f:10a5ff16:05fd1967:2fd44d38

    Update Time : Sun Apr 16 16:33:10 2017
       Checksum : b1e57c5 - correct
         Events : 351744

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : A.AAA.AA ('A' == active, '.' == missing)
/dev/sdg3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e299685e:5842617d:6d90981b:8f7b91e4
           Name : DiskStation:2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 5851088833 (2790.02 GiB 2995.76 GB)
     Array Size : 40957619584 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 5851088512 (2790.02 GiB 2995.76 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 8f0770d8:c3e6df4b:f2ab4b40:06c57ad1

    Update Time : Sun Apr 16 16:33:10 2017
       Checksum : 3b80570b - correct
         Events : 351744

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 6
   Array State : A.AAA.AA ('A' == active, '.' == missing)
/dev/sdh3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e299685e:5842617d:6d90981b:8f7b91e4
           Name : DiskStation:2
  Creation Time : Fri Oct 17 22:45:17 2014
     Raid Level : raid5
   Raid Devices : 8

 Avail Dev Size : 5851088833 (2790.02 GiB 2995.76 GB)
     Array Size : 40957619584 (19530.12 GiB 20970.30 GB)
  Used Dev Size : 5851088512 (2790.02 GiB 2995.76 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fba39acd:5df21885:b9a329c5:cffdf686

    Update Time : Sun Apr 16 16:33:10 2017
       Checksum : a43e2fa2 - correct
         Events : 351744

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 7
   Array State : A.AAA.AA ('A' == active, '.' == missing)
