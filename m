From: Bryan Bush <bbushvt@gmail.com>
Subject: RAID6 grow failed
Date: Tue, 27 Mar 2012 22:44:18 -0400
Message-ID: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I hope this is the right place to ask this question.  I have at 8
drive RAID 6 array that I wanted to grow to 13 drives (adding 5 more).
 I issued the mdadm command and checked /proc/mdstat and all looked
well.  However at some point in time a disk failed and that hung my
system.  Upon reboot the array is inactive and I can't get it to
reassemble.

/proc/mdstat shows this

md1 : inactive sdp1[11](S) sdi1[3](S) sdd1[7](S) sdr1[13](S)
sdg1[1](S) sdc1[6](S) sdq1[12](S) sdn1[9](S) sdo1[10](S) sdh1[2](S)
sda1[4](S) sdf1[0](S) sdb1[8](S)
      25395674609 blocks super 1.2


If I look at mdadm -E /dev/sdX1 I see most are State active, while
some are State clean.


root@diamond:~# mdadm -E /dev/sd[abcdfghinopqr]1
mdadm: metadata format 01.02 unknown, ignored.
mdadm: metadata format 00.90 unknown, ignored.
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b7c75aff:703e77dd:8be71623:24cfd5c4

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : b892c40c - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 4 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuUuuuuuuuu 2 failed
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 73f50290:c36a95a1:99de8ad3:2a4e84c8

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : c17b9433 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 8 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuUuuuuuuu 2 failed
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : de927013:298f7906:5abdae1e:ccab9188

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : b4fe9263 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 6 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuuUuuuuuu 2 failed
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a258e2c3:e4abf94c:33be105e:fff62610

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : 72e7c0f0 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 7 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuuuUuuuuu 2 failed
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 14c53549:bd43ec01:794d70ff:3ea30a9d

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : db7100b9 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 0 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : U_uuuuuuuuuuu 2 failed
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 785b908f:e1392eb6:131a836d:4d554339

  Reshape pos'n : 1202143360 (1146.45 GiB 1230.99 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:41:43 2012
       Checksum : e051f831 - correct
         Events : 2768

     Chunk Size : 64K

    Array Slot : 1 (0, 1, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : uUuuuuuuuuuuu 1 failed
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : dd08d581:c542403f:33ab15bb:e5a7f122

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : 92f0a5ed - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 2 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_Uuuuuuuuuuu 2 failed
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 6efe22ba:87cc1ffb:a070dbd0:b9020b5e

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : d7fd4583 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 3 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uUuuuuuuuuu 2 failed
/dev/sdn1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : bf54f25f:3a82eb7e:4b852f91:6857c476

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : daa5bae6 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 9 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuuuuuuuuU 2 failed
/dev/sdo1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e239f08a:e56a2abd:18bd6e8d:6e614aa2

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : 6ba7ca89 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 10 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuuuuuuuUu 2 failed
/dev/sdp1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f04f830d:ffc3352f:443c92c0:b03ec412

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : 3e3961f - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 11 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuuuuuuUuu 2 failed
/dev/sdq1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 5f84b70f:1b8b607b:e2f2cfee:f1fe34f4

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : 61f1088b - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 12 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuuuuuUuuu 2 failed
/dev/sdr1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 74bb612c:34c2ddf6:4828ed5c:22ea7b38

  Reshape pos'n : 1202473536 (1146.77 GiB 1231.33 GB)
  Delta Devices : 5 (8->13)

    Update Time : Tue Mar 27 20:42:37 2012
       Checksum : ac7c9750 - correct
         Events : 2771

     Chunk Size : 64K

    Array Slot : 13 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9, 8)
   Array State : u_uuuuuuUuuuu 2 failed
root@diamond:~#


Is there anything I can do to get the array back up?
Thanks
-Bryan
