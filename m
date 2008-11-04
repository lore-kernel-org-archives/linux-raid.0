From: Brad Campbell <brad@wasp.net.au>
Subject: Time to ask for help. Raid-5 Dual drive failure
Date: Wed, 05 Nov 2008 01:18:06 +0400
Message-ID: <4910BC0E.9000307@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok, so it finally died.

I was doing a large copy to an ext3 filesystem on md0 when one drive dropped out (SATA error). 3 
minutes later a second drive dropped out (SATA error).

I've tried to re-assemble the array with
mdadm --assemble --force /dev/md0 but it errors out with

mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

I'm guessing that I'll have to re-create the array with --assume-clean and the 9 freshest drives and 
hope for the best. I've included pretty much all the information I guess might be relevant. Please 
let me know if I've forgotten something. I'm not sure of the best action to take next to ensure I do 
the least amount of damage.

None of the data on there is really unrecoverable, but it would be a significant effort to 
re-compile it from its various sources. If I can get most or all of it back (and I was doing a very 
large sequential write at the time which ext3 seems to cope with quite well in cases of drive 
b0rkage) I'd be pretty happy.

I've tried absolutely nothing other than --assemble --force. (Several times after reboots)

root@srv:~# uname -a
Linux srv 2.6.27.4 #10 SMP Mon Oct 27 08:59:56 GST 2008 x86_64 GNU/Linux

root@srv:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : inactive sdk1[1] sdg[9] sdf1[8] sdi1[7] sdh1[6] sdn1[5] sdo1[4] sdm1[3] sdl[2]
       2204177664 blocks

md2 : active raid5 sdc[0] sde[2] sdd[1]
       1465148928 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md5 : active raid1 sda4[0] sdb4[1]
       200217984 blocks [2/2] [UU]

md4 : active (auto-read-only) raid1 sda3[0] sdb3[1]
       4891712 blocks [2/2] [UU]

md3 : active raid1 sda2[0] sdb2[1]
       19542976 blocks [2/2] [UU]

md1 : active raid1 sdb1[0] sda1[1]
       19542976 blocks [2/2] [UU]
       bitmap: 1/150 pages [4KB], 64KB chunk

unused devices: <none>

(Tried with both)

root@srv:~# mdadm --version
mdadm - v2.6.4 - 19th October 2007
root@srv:~# ./mdadm --version
mdadm - v2.6.7 - 6th June 2008


root@srv:~# ./mdadm -Av --force /dev/md0
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/md2: Device or resource busy
mdadm: /dev/md2 has wrong uuid.
mdadm: cannot open device /dev/md5: Device or resource busy
mdadm: /dev/md5 has wrong uuid.
mdadm: cannot open device /dev/md4: Device or resource busy
mdadm: /dev/md4 has wrong uuid.
mdadm: cannot open device /dev/md3: Device or resource busy
mdadm: /dev/md3 has wrong uuid.
mdadm: cannot open device /dev/md1: Device or resource busy
mdadm: /dev/md1 has wrong uuid.
mdadm: no RAID superblock on /dev/sdo
mdadm: /dev/sdo has wrong uuid.
mdadm: no RAID superblock on /dev/sdn
mdadm: /dev/sdn has wrong uuid.
mdadm: no RAID superblock on /dev/sdm
mdadm: /dev/sdm has wrong uuid.
mdadm: no RAID superblock on /dev/sdk
mdadm: /dev/sdk has wrong uuid.
mdadm: no RAID superblock on /dev/sdj
mdadm: /dev/sdj has wrong uuid.
mdadm: no RAID superblock on /dev/sdi
mdadm: /dev/sdi has wrong uuid.
mdadm: no RAID superblock on /dev/sdh
mdadm: /dev/sdh has wrong uuid.
mdadm: no RAID superblock on /dev/sdf
mdadm: /dev/sdf has wrong uuid.
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: /dev/sde has wrong uuid.
mdadm: cannot open device /dev/sdd: Device or resource busy
mdadm: /dev/sdd has wrong uuid.
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device /dev/sdb4: Device or resource busy
mdadm: /dev/sdb4 has wrong uuid.
mdadm: cannot open device /dev/sdb3: Device or resource busy
mdadm: /dev/sdb3 has wrong uuid.
mdadm: cannot open device /dev/sdb2: Device or resource busy
mdadm: /dev/sdb2 has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda4: Device or resource busy
mdadm: /dev/sda4 has wrong uuid.
mdadm: cannot open device /dev/sda3: Device or resource busy
mdadm: /dev/sda3 has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdo1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdn1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdm1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdl is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdk1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdg is identified as a member of /dev/md0, slot 9.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 8.
mdadm: added /dev/sdj1 to /dev/md0 as 0
mdadm: added /dev/sdl to /dev/md0 as 2
mdadm: added /dev/sdm1 to /dev/md0 as 3
mdadm: added /dev/sdo1 to /dev/md0 as 4
mdadm: added /dev/sdn1 to /dev/md0 as 5
mdadm: added /dev/sdh1 to /dev/md0 as 6
mdadm: added /dev/sdi1 to /dev/md0 as 7
mdadm: added /dev/sdf1 to /dev/md0 as 8
mdadm: added /dev/sdg to /dev/md0 as 9
mdadm: added /dev/sdk1 to /dev/md0 as 1
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

for i in sdj1 sdl sdm1 sdo1 sdn1 sdh1 sdi1 sdf1 sdg sdk1 ; do mdadm --examine /dev/$i ; done

/dev/sdj1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:23:33 2008
           State : active
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 210701c1 - correct
          Events : 0.1338267

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     0       8      145        0      active sync   /dev/sdj1

    0     0       8      145        0      active sync   /dev/sdj1
    1     1       8      161        1      active sync   /dev/sdk1
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdl:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b6ffb - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     2       8      176        2      active sync   /dev/sdl

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdm1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b700e - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     3       8      193        3      active sync   /dev/sdm1

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdo1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b7030 - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     4       8      225        4      active sync   /dev/sdo1

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdn1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b7022 - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     5       8      209        5      active sync   /dev/sdn1

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdh1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b6fc4 - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     6       8      113        6      active sync   /dev/sdh1

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdi1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b6fd6 - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     7       8      129        7      active sync   /dev/sdi1

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdf1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b6fa8 - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     8       8       81        8      active sync   /dev/sdf1

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdg:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:32:56 2008
           State : clean
  Active Devices : 8
Working Devices : 8
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 211b6fb9 - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     9       8       96        9      active sync   /dev/sdg

    0     0       0        0        0      removed
    1     1       0        0        1      faulty removed
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg
/dev/sdk1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 05cc3f43:de1ecfa4:83a51293:78015f1e
   Creation Time : Sun May  2 18:02:14 2004
      Raid Level : raid5
   Used Dev Size : 244198400 (232.89 GiB 250.06 GB)
      Array Size : 2197785600 (2095.97 GiB 2250.53 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 0

     Update Time : Tue Nov  4 22:27:34 2008
           State : active
  Active Devices : 9
Working Devices : 9
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 210702e6 - correct
          Events : 0.1338280

          Layout : left-asymmetric
      Chunk Size : 128K

       Number   Major   Minor   RaidDevice State
this     1       8      161        1      active sync   /dev/sdk1

    0     0       0        0        0      removed
    1     1       8      161        1      active sync   /dev/sdk1
    2     2       8      176        2      active sync   /dev/sdl
    3     3       8      193        3      active sync   /dev/sdm1
    4     4       8      225        4      active sync   /dev/sdo1
    5     5       8      209        5      active sync   /dev/sdn1
    6     6       8      113        6      active sync   /dev/sdh1
    7     7       8      129        7      active sync   /dev/sdi1
    8     8       8       81        8      active sync   /dev/sdf1
    9     9       8       96        9      active sync   /dev/sdg


< mdadm failure E-mail 1 >

This is an automatically generated mail message from mdadm
running on srv

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sdj1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdm1[3] sdj1[10](F) sdg[9] sdf1[8] sdi1[7] sdh1[6] sdn1[5] sdo1[4] sdl[2] sdk1[1]
       2197785600 blocks level 5, 128k chunk, algorithm 0 [10/9] [_UUUUUUUUU]

md2 : active raid5 sdc[0] sde[2] sdd[1]
       1465148928 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md5 : active raid1 sda4[0] sdb4[1]
       200217984 blocks [2/2] [UU]

md4 : active raid1 sda3[0] sdb3[1]
       4891712 blocks [2/2] [UU]

md3 : active raid1 sda2[0] sdb2[1]
       19542976 blocks [2/2] [UU]

md1 : active raid1 sdb1[0] sda1[1]
       19542976 blocks [2/2] [UU]
       bitmap: 9/150 pages [36KB], 64KB chunk

unused devices: <none>


< mdadm failure E-mail 2 >

This is an automatically generated mail message from mdadm
running on srv

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sdj1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdm1[3] sdj1[10](F) sdg[9] sdf1[8] sdi1[7] sdh1[6] sdn1[5] sdo1[4] sdl[2] sdk1[1]
       2197785600 blocks level 5, 128k chunk, algorithm 0 [10/9] [_UUUUUUUUU]

md2 : active raid5 sdc[0] sde[2] sdd[1]
       1465148928 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md5 : active raid1 sda4[0] sdb4[1]
       200217984 blocks [2/2] [UU]

md4 : active raid1 sda3[0] sdb3[1]
       4891712 blocks [2/2] [UU]

md3 : active raid1 sda2[0] sdb2[1]
       19542976 blocks [2/2] [UU]

md1 : active raid1 sdb1[0] sda1[1]
       19542976 blocks [2/2] [UU]
       bitmap: 9/150 pages [36KB], 64KB chunk

unused devices: <none>

< Dmesg from a latter attempt at  --assemble --force >

[  611.436668] md: md0 still in use.
[  611.495356] md: bind<sdj1>
[  611.495983] md: bind<sdl>
[  611.496452] md: bind<sdm1>
[  611.496977] md: bind<sdo1>
[  611.497394] md: bind<sdn1>
[  611.497883] md: bind<sdh1>
[  611.498340] md: bind<sdi1>
[  611.498792] md: bind<sdf1>
[  611.499204] md: bind<sdg>
[  611.499671] md: bind<sdk1>
[  611.499982] md: kicking non-fresh sdj1 from array!
[  611.500068] md: unbind<sdj1>
[  611.522556] md: export_rdev(sdj1)
[  611.522631] md: md0: raid array is not clean -- starting background reconstruction
[  611.529874] raid5: device sdk1 operational as raid disk 1
[  611.529926] raid5: device sdg operational as raid disk 9
[  611.529967] raid5: device sdf1 operational as raid disk 8
[  611.530008] raid5: device sdi1 operational as raid disk 7
[  611.530048] raid5: device sdh1 operational as raid disk 6
[  611.530087] raid5: device sdn1 operational as raid disk 5
[  611.530126] raid5: device sdo1 operational as raid disk 4
[  611.530165] raid5: device sdm1 operational as raid disk 3
[  611.530203] raid5: device sdl operational as raid disk 2
[  611.530242] raid5: cannot start dirty degraded array for md0
[  611.530282] RAID5 conf printout:
[  611.530311]  --- rd:10 wd:9
[  611.530339]  disk 1, o:1, dev:sdk1
[  611.530370]  disk 2, o:1, dev:sdl
[  611.530404]  disk 3, o:1, dev:sdm1
[  611.530435]  disk 4, o:1, dev:sdo1
[  611.530465]  disk 5, o:1, dev:sdn1
[  611.530496]  disk 6, o:1, dev:sdh1
[  611.530526]  disk 7, o:1, dev:sdi1
[  611.530557]  disk 8, o:1, dev:sdf1
[  611.530587]  disk 9, o:1, dev:sdg
[  611.530617] raid5: failed to run raid set md0
[  611.530651] md: pers->run() failed ...

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
