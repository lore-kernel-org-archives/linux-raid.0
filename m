From: "Alain Spineux" <Alain.Spineux@keysource.be>
Subject: No md super block found ! How to forge a super block, to force a raid to start
Date: Wed, 14 Jan 2004 20:23:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A88D5F1FF5BEAF4D9B9B7DD216271D550AB039@ks-sw-exch.keysource.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I setup a software raid 5 device, everything was fine until 2 disk
failed 
at the same time, probably the ide cable of the 2 drives got
disconected.


[root@storage root]# mdadm -Q --examine /dev/hd[ij]3
mdadm: No super block found on /dev/hdi3 (Expected magic a92b4efc, got
a82b4efc)
mdadm: No super block found on /dev/hdj3 (Expected magic a92b4efc, got
a82b4efc)

I don't know how these information get lost, I was not the first to try
to repair the raid !

I already try :

# mdadm --assemble --run  --force /dev/md0  /dev/hd[aefghijkl]3
mdadm: no RAID superblock on /dev/hdi3
mdadm: /dev/hdi3 has no superblock - assembly aborted

I tried all relevant switch to force the raid to start but nothing
append !
Is it a wait to go throught the "/dev/hdi3 has no superblock"

If not, I want to forge a new super bloc using the information from
other disk, and see what append !


Here follow some information :

# fdisk -l
# cat /proc/mdstat
# cat /etc/raidtab
# mdadm -Q --examine /dev/hd[aefghijkl]3
# mdadm -Q --examine /dev/hd[aefghijkl]4
# mdadm -Q --examine /dev/hd[fhjl]1


For your information /dev/hda was a spare disk, but one failed and had
took its place.



[root@storage root]# fdisk -l

Disk /dev/hda: 255 heads, 63 sectors, 7473 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1             1       128   1028128+  83  Linux
/dev/hda2           129       145    136552+  82  Linux swap
/dev/hda3           146      3809  29431080   fd  Linux raid autodetect
/dev/hda4          3810      7473  29431080   fd  Linux raid autodetect

Disk /dev/hde: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hde1             1      2040   1028128+  83  Linux
/dev/hde2          2041      2311    136584   82  Linux swap
/dev/hde3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hde4         60711    119112  29434608   fd  Linux raid autodetect

Disk /dev/hdf: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdf1             1      2040   1028128+  83  Linux
/dev/hdf2          2041      2311    136584   82  Linux swap
/dev/hdf3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hdf4         60711    119112  29434608   fd  Linux raid autodetect

Disk /dev/hdg: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdg1             1      2040   1028128+  83  Linux
/dev/hdg2          2041      2311    136584   82  Linux swap
/dev/hdg3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hdg4         60711    119112  29434608   fd  Linux raid autodetect

Disk /dev/hdh: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdh1             1      2040   1028128+  83  Linux
/dev/hdh2          2041      2311    136584   82  Linux swap
/dev/hdh3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hdh4         60711    119112  29434608   fd  Linux raid autodetect

Disk /dev/hdi: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdi1             1      2040   1028128+  83  Linux
/dev/hdi2          2041      2311    136584   83  Linux
/dev/hdi3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hdi4         60711    119112  29434608   fd  Linux raid autodetect

Disk /dev/hdj: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdj1             1      2040   1028128+  83  Linux
/dev/hdj2          2041      2311    136584   83  Linux
/dev/hdj3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hdj4         60711    119112  29434608   fd  Linux raid autodetect

Disk /dev/hdk: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdk1             1      2040   1028128+  83  Linux
/dev/hdk2          2041      2311    136584   82  Linux swap
/dev/hdk3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hdk4         60711    119112  29434608   fd  Linux raid autodetect

Disk /dev/hdl: 16 heads, 63 sectors, 119112 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdl1             1      2040   1028128+  83  Linux
/dev/hdl2          2041      2311    136584   82  Linux swap
/dev/hdl3          2312     60710  29433096   fd  Linux raid autodetect
/dev/hdl4         60711    119112  29434608   fd  Linux raid autodetect
[root@storage root]#
[root@storage root]#
[root@storage root]# cat /proc/mdstat
Personalities : [raid0] [raid5]
read_ahead 1024 sectors
md2 : active raid0 hdk1[3] hdi1[2] hdg1[1] hde1[0]
      4112128 blocks 4k chunks

unused devices: <none>
[root@storage root]# cat /etc/raidtab
raidtab   raidtab~
[root@storage root]# cat /etc/raidtab
raiddev /dev/md0
          raid-level      5
          nr-raid-disks   8
          nr-spare-disks  1
          persistent-superblock 1
          parity-algorithm        left-symmetric
          chunk-size      32
          device          /dev/hde3
          raid-disk       0
          device          /dev/hdf3
          raid-disk       1
          device          /dev/hdg3
          raid-disk       2
          device          /dev/hdh3
          raid-disk       3
          device          /dev/hdi3
          raid-disk       4
          device          /dev/hdj3
          raid-disk       5
          device          /dev/hdk3
          raid-disk       6
          device          /dev/hdl3
          raid-disk       7

          device         /dev/hda3
          spare-disk     0

raiddev /dev/md1
          raid-level      5
          nr-raid-disks   8
          nr-spare-disks  1
          persistent-superblock 1
          parity-algorithm        left-symmetric
          chunk-size      32
          device          /dev/hde4
          raid-disk       0
          device          /dev/hdf4
          raid-disk       1
          device          /dev/hdg4
          raid-disk       2
          device          /dev/hdh4
          raid-disk       3
          device          /dev/hdi4
          raid-disk       4
          device          /dev/hdj4
          raid-disk       5
          device          /dev/hdk4
          raid-disk       6
          device          /dev/hdl4
          raid-disk       7

          device         /dev/hda4
          spare-disk     0

raiddev /dev/md2
          raid-level      0
          nr-raid-disks   4
          persistent-superblock 1
          chunk-size      4
          device          /dev/hde1
          raid-disk       0
          device          /dev/hdg1
          raid-disk       1
          device          /dev/hdi1
          raid-disk       2
          device          /dev/hdk1
          raid-disk       3

#raiddev /dev/md3
#          raid-level      5
#          nr-raid-disks   4
#         nr-spare-disks  0
#         parity-algorithm        left-symmetric
#          persistent-superblock 1
#          chunk-size      4
#          device          /dev/hdf1
#          raid-disk       0
#          device          /dev/hdh1
#          raid-disk       1
#          device          /dev/hdj1
#          raid-disk       2
#          device          /dev/hdl1
#          raid-disk       3

[root@storage root]#
[root@storage root]# mdadm -Q --examine /dev/hd[aefghijkl]3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb2b - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     7       3        3        7      active sync   /dev/hda3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hde3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb3b - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0      33        3        0      active sync   /dev/hde3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdf3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Oct  1 17:23:54 2003
          State : clean, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 25456626 - correct
         Events : 0.81

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1      33       67        1      active sync   /dev/hdf3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      33       67        1      active sync   /dev/hdf3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdg3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb40 - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2      34        3        2      active sync   /dev/hdg3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdh3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb82 - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3      34       67        3      active sync   /dev/hdh3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
mdadm: No super block found on /dev/hdi3 (Expected magic a92b4efc, got
a82b4efc)
mdadm: No super block found on /dev/hdj3 (Expected magic a92b4efc, got
a82b4efc)
/dev/hdk3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb5f - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     6      57        3        6      active sync   /dev/hdk3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdl3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb95 - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1      57       67        1      active sync   /dev/hdl3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
[root@storage root]#
[root@storage root]#
[root@storage root]#
[root@storage root]# mdadm -Q --examine /dev/hd[aefghijkl]3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb2b - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     7       3        3        7      active sync   /dev/hda3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hde3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb3b - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0      33        3        0      active sync   /dev/hde3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdf3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Oct  1 17:23:54 2003
          State : clean, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 25456626 - correct
         Events : 0.81

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1      33       67        1      active sync   /dev/hdf3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      33       67        1      active sync   /dev/hdf3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdg3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb40 - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2      34        3        2      active sync   /dev/hdg3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdh3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb82 - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3      34       67        3      active sync   /dev/hdh3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
mdadm: No super block found on /dev/hdi3 (Expected magic a92b4efc, got
a82b4efc)
mdadm: No super block found on /dev/hdj3 (Expected magic a92b4efc, got
a82b4efc)
/dev/hdk3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb5f - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     6      57        3        6      active sync   /dev/hdk3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3
/dev/hdl3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af9023d1:d3110374:4d54f819:2f393aaf
  Creation Time : Sun Sep 23 21:06:15 2001
     Raid Level : raid5
    Device Size : 29430976 (28.07 GiB 30.14 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sat Dec  6 04:02:16 2003
          State : dirty, no-errors
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 259bbb95 - correct
         Events : 0.99

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1      57       67        1      active sync   /dev/hdl3
   0     0      33        3        0      active sync   /dev/hde3
   1     1      57       67        1      active sync   /dev/hdl3
   2     2      34        3        2      active sync   /dev/hdg3
   3     3      34       67        3      active sync   /dev/hdh3
   4     4      56        3        4      active sync   /dev/hdi3
   5     5      56       67        5      active sync   /dev/hdj3
   6     6      57        3        6      active sync   /dev/hdk3
   7     7       3        3        7      active sync   /dev/hda3

[root@storage root]# mdadm -Q --examine /dev/hd[fhjl]1
/dev/hdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e2b5f75f:d823083c:c60d7693:1cd9cf46
  Creation Time : Sun Sep 23 21:50:03 2001
     Raid Level : raid5
    Device Size : 1028032 (1003.94 MiB 1052.70 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3

    Update Time : Wed Oct  1 17:23:54 2003
          State : clean, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c22485f6 - correct
         Events : 0.57

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     0      33       65        0      active sync   /dev/hdf1
   0     0      33       65        0      active sync   /dev/hdf1
   1     1      34       65        1      active sync   /dev/hdh1
   2     2      56       65        2      active sync   /dev/hdj1
   3     3      57       65        3      active sync   /dev/hdl1
/dev/hdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e2b5f75f:d823083c:c60d7693:1cd9cf46
  Creation Time : Sun Sep 23 21:50:03 2001
     Raid Level : raid5
    Device Size : 1028032 (1003.94 MiB 1052.70 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3

    Update Time : Wed Oct  1 17:23:54 2003
          State : clean, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c22485f9 - correct
         Events : 0.57

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     1      34       65        1      active sync   /dev/hdh1
   0     0      33       65        0      active sync   /dev/hdf1
   1     1      34       65        1      active sync   /dev/hdh1
   2     2      56       65        2      active sync   /dev/hdj1
   3     3      57       65        3      active sync   /dev/hdl1
/dev/hdj1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e2b5f75f:d823083c:c60d7693:1cd9cf46
  Creation Time : Sun Sep 23 21:50:03 2001
     Raid Level : raid5
    Device Size : 1028032 (1003.94 MiB 1052.70 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3

    Update Time : Wed Oct  1 17:23:54 2003
          State : clean, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c2248611 - correct
         Events : 0.57

         Layout : left-symmetric
     Chunk Size : 4K

      Number   Major   Minor   RaidDevice State
this     2      56       65        2      active sync   /dev/hdj1
   0     0      33       65        0      active sync   /dev/hdf1
   1     1      34       65        1      active sync   /dev/hdh1
   2     2      56       65        2      active sync   /dev/hdj1
   3     3      57       65        3      active sync   /dev/hdl1
mdadm: No super block found on /dev/hdl1 (Expected magic a92b4efc, got
0d939e35)




--
Alain Spineux
Linux System Engineer
KeySource
Avenue de la Couronne 480
1050 Brussels ( Belgium )
Tel. +32-2-644.96.53 * Fax. +32-2-649.18.11
