From: <c4c3m@oke.net.id>
Subject: raid 5 on linux --againnnn (sorryy it's big)
Date: Fri, 25 Jul 2003 11:53:12 +0700 (JAVT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <59553.202.158.96.2.1059108792.power.web.id@mail2.oke.net.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

this is the messages from faulty machine:
#mdadm.static -Eb /dev/sdc*

ARRAY /dev/md4 level=raid5 num-devices=3 UUID=12a3daa6:98bc6aca:98d38bed:
414bad01
devices=/dev/sdc9
ARRAY /dev/md3 level=raid5 num-devices=3 UUID=5c4fb8f2:7aad3154:83515188:
5945a00b
devices=/dev/sdc8
ARRAY /dev/md2 level=raid5 num-devices=3 UUID=31788297:ac6dab84:1dc952b3:
fec35535
devices=/dev/sdc7
ARRAY /dev/md1 level=raid5 num-devices=3 UUID=ed01ad73:e4a5e4d0:90eb9b59:
15e5c3c0
devices=/dev/sdc6
ARRAY /dev/md8 level=raid5 num-devices=3 UUID=1708a6d1:96874201:39d9f451:
bed35249
devices=/dev/sdc13
ARRAY /dev/md7 level=raid5 num-devices=3 UUID=f385575d:d3185f42:37e7d321:
4784a76c
devices=/dev/sdc12
ARRAY /dev/md6 level=raid5 num-devices=3 UUID=cdcae134:499035b2:e539a33a:
636fa315
devices=/dev/sdc11
ARRAY /dev/md5 level=raid5 num-devices=3 UUID=59f4a4fc:40471289:9d6e0430:
44f950a1
devices=/dev/sdc10
ARRAY /dev/md9 level=raid5 num-devices=3 UUID=3b2e48f6:efb0795d:6fa8e6c7:
18e6d984
devices=/dev/sdc1,/dev/sdc3,/dev/sdc4

#mdadm.static -E /dev/sdc*

/dev/sdc1:
Magic : a92b4efc
Version : 00.90.00
UUID : 3b2e48f6:efb0795d:6fa8e6c7:18e6d984
Creation Time : Mon Jan 15 23:27:23 2001
Raid Level : raid5
Device Size : 497920 (486.25 MiB 509.87 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 9

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : d6262aad - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1
0     0       8       33        0      active sync   /dev/sdc1
1     1       8       35        1      active sync   /dev/sdc3
2     2       8       36        2      active sync   /dev/sdc4
/dev/sdc10:
Magic : a92b4efc
Version : 00.90.00
UUID : 59f4a4fc:40471289:9d6e0430:44f950a1
Creation Time : Mon Jan 15 23:27:03 2001
Raid Level : raid5
Device Size : 1036096 (1011.81 MiB 1060.96 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 5

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 9f0d3745 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       42        2      active sync   /dev/sdc10
0     0       8       26        0      active sync   /dev/sdb10
1     1       8       10        1      active sync   /dev/sda10
2     2       8       42        2      active sync   /dev/sdc10
/dev/sdc11:
Magic : a92b4efc
Version : 00.90.00
UUID : cdcae134:499035b2:e539a33a:636fa315
Creation Time : Mon Jan 15 23:27:08 2001
Raid Level : raid5
Device Size : 546112 (533.31 MiB 559.22 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 6

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 82670e2f - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       43        2      active sync   /dev/sdc11
0     0       8       27        0      active sync   /dev/sdb11
1     1       8       11        1      active sync   /dev/sda11
2     2       8       43        2      active sync   /dev/sdc11
/dev/sdc12:
Magic : a92b4efc
Version : 00.90.00
UUID : f385575d:d3185f42:37e7d321:4784a76c
Creation Time : Mon Jan 15 23:27:13 2001
Raid Level : raid5
Device Size : 409536 (399.94 MiB 419.36 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 7

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 68c07feb - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       44        2      active sync   /dev/sdc12
0     0       8       28        0      active sync   /dev/sdb12
1     1       8       12        1      active sync   /dev/sda12
2     2       8       44        2      active sync   /dev/sdc12
/dev/sdc13:
Magic : a92b4efc
Version : 00.90.00
UUID : 1708a6d1:96874201:39d9f451:bed35249
Creation Time : Mon Jan 15 23:27:18 2001
Raid Level : raid5
Device Size : 634432 (619.56 MiB 649.66 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 8

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : c8f6ecb4 - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       45        2      active sync   /dev/sdc13
0     0       8       29        0      active sync   /dev/sdb13
1     1       8       13        1      active sync   /dev/sda13
2     2       8       45        2      active sync   /dev/sdc13
/dev/sdc3:
Magic : a92b4efc
Version : 00.90.00
UUID : 3b2e48f6:efb0795d:6fa8e6c7:18e6d984
Creation Time : Mon Jan 15 23:27:23 2001
Raid Level : raid5
Device Size : 497920 (486.25 MiB 509.87 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 9

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : d6262ab1 - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8       35        1      active sync   /dev/sdc3
0     0       8       33        0      active sync   /dev/sdc1
1     1       8       35        1      active sync   /dev/sdc3
2     2       8       36        2      active sync   /dev/sdc4
/dev/sdc4:
Magic : a92b4efc
Version : 00.90.00
UUID : 3b2e48f6:efb0795d:6fa8e6c7:18e6d984
Creation Time : Mon Jan 15 23:27:23 2001
Raid Level : raid5
Device Size : 497920 (486.25 MiB 509.87 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 9

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : d6262ab4 - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       36        2      active sync   /dev/sdc4
0     0       8       33        0      active sync   /dev/sdc1
1     1       8       35        1      active sync   /dev/sdc3
2     2       8       36        2      active sync   /dev/sdc4
/dev/sdc6:
Magic : a92b4efc
Version : 00.90.00
UUID : ed01ad73:e4a5e4d0:90eb9b59:15e5c3c0
Creation Time : Mon Jan 15 23:26:43 2001
Raid Level : raid5
Device Size : 915584 (894.13 MiB 937.56 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 1

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 9ae14564 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       38        2      active sync   /dev/sdc6
0     0       8       22        0      active sync   /dev/sdb6
1     1       8        6        1      active sync   /dev/sda6
2     2       8       38        2      active sync   /dev/sdc6
/dev/sdc7:
Magic : a92b4efc
Version : 00.90.00
UUID : 31788297:ac6dab84:1dc952b3:fec35535
Creation Time : Mon Jan 15 23:26:48 2001
Raid Level : raid5
Device Size : 521984 (509.75 MiB 534.51 MB)
Raid Devices : 3
Total Devices : 2
Preferred Minor : 2

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : 1d2adb92 - correct
Events : 0.272

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       39        2      active sync   /dev/sdc7
0     0       0        0        0      faulty removed
1     1       8        7        1      active sync   /dev/sda7
2     2       8       39        2      active sync   /dev/sdc7
/dev/sdc8:
Magic : a92b4efc
Version : 00.90.00
UUID : 5c4fb8f2:7aad3154:83515188:5945a00b
Creation Time : Mon Jan 15 23:26:53 2001
Raid Level : raid5
Device Size : 1686720 (1647.19 MiB 1727.20 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 3

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : d607f434 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       40        2      active sync   /dev/sdc8
0     0       8       24        0      active sync   /dev/sdb8
1     1       8        8        1      active sync   /dev/sda8
2     2       8       40        2      active sync   /dev/sdc8
/dev/sdc9:
Magic : a92b4efc
Version : 00.90.00
UUID : 12a3daa6:98bc6aca:98d38bed:414bad01
Creation Time : Mon Jan 15 23:26:58 2001
Raid Level : raid5
Device Size : 1044096 (1019.63 MiB 1069.15 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 4

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : a7e9c883 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     2       8       41        2      active sync   /dev/sdc9
0     0       8       25        0      active sync   /dev/sdb9
1     1       8        9        1      active sync   /dev/sda9
2     2       8       41        2      active sync   /dev/sdc9


#mdadm.static -Eb /dev/sdb*

ARRAY /dev/md4 level=raid5 num-devices=3 UUID=12a3daa6:98bc6aca:98d38bed:
414bad01
devices=/dev/sdb9
ARRAY /dev/md3 level=raid5 num-devices=3 UUID=5c4fb8f2:7aad3154:83515188:
5945a00b
devices=/dev/sdb8
ARRAY /dev/md2 level=raid5 num-devices=3 UUID=31788297:ac6dab84:1dc952b3:
fec35535
devices=/dev/sdb7
ARRAY /dev/md1 level=raid5 num-devices=3 UUID=ed01ad73:e4a5e4d0:90eb9b59:
15e5c3c0
devices=/dev/sdb6
ARRAY /dev/md8 level=raid5 num-devices=3 UUID=1708a6d1:96874201:39d9f451:
bed35249
devices=/dev/sdb13
ARRAY /dev/md7 level=raid5 num-devices=3 UUID=f385575d:d3185f42:37e7d321:
4784a76c
devices=/dev/sdb12
ARRAY /dev/md6 level=raid5 num-devices=3 UUID=cdcae134:499035b2:e539a33a:
636fa315
devices=/dev/sdb11
ARRAY /dev/md5 level=raid5 num-devices=3 UUID=59f4a4fc:40471289:9d6e0430:
44f950a1
devices=/dev/sdb10
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=be5bbd85:10d50fbf:6f2bf3dc:
88f7e433
devices=/dev/sdb1

#mdadm.static -E /dev/sdb*
/dev/sdb1:
Magic : a92b4efc
Version : 00.90.00
UUID : be5bbd85:10d50fbf:6f2bf3dc:88f7e433
Creation Time : Mon Jan 15 23:26:38 2001
Raid Level : raid1
Device Size : 1566208 (1529.50 MiB 1603.80 MB)
Raid Devices : 2
Total Devices : 2
Preferred Minor : 0

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : ea1c99b0 - correct
Events : 0.267


Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1
0     0       8       17        0      active sync   /dev/sdb1
1     1       8        1        1      active sync   /dev/sda1
/dev/sdb10:
Magic : a92b4efc
Version : 00.90.00
UUID : 59f4a4fc:40471289:9d6e0430:44f950a1
Creation Time : Mon Jan 15 23:27:03 2001
Raid Level : raid5
Device Size : 1036096 (1011.81 MiB 1060.96 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 5

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 9f0d3731 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       26        0      active sync   /dev/sdb10
0     0       8       26        0      active sync   /dev/sdb10
1     1       8       10        1      active sync   /dev/sda10
2     2       8       42        2      active sync   /dev/sdc10
/dev/sdb11:
Magic : a92b4efc
Version : 00.90.00
UUID : cdcae134:499035b2:e539a33a:636fa315
Creation Time : Mon Jan 15 23:27:08 2001
Raid Level : raid5
Device Size : 546112 (533.31 MiB 559.22 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 6

Update Time : Thu Jul 24 01:17:48 2003
State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 1
Spare Devices : 0
Checksum : 82baf99e - correct
Events : 0.201

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       27        0      active sync   /dev/sdb11
0     0       8       27        0      active sync   /dev/sdb11
1     1       8       11        1      active sync   /dev/sda11
2     2       8       43        2      faulty   /dev/sdc11
/dev/sdb12:
Magic : a92b4efc
Version : 00.90.00
UUID : f385575d:d3185f42:37e7d321:4784a76c
Creation Time : Mon Jan 15 23:27:13 2001
Raid Level : raid5
Device Size : 409536 (399.94 MiB 419.36 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 7

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 68c07fd7 - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       28        0      active sync   /dev/sdb12
0     0       8       28        0      active sync   /dev/sdb12
1     1       8       12        1      active sync   /dev/sda12
2     2       8       44        2      active sync   /dev/sdc12
/dev/sdb13:
Magic : a92b4efc
Version : 00.90.00
UUID : 1708a6d1:96874201:39d9f451:bed35249
Creation Time : Mon Jan 15 23:27:18 2001
Raid Level : raid5
Device Size : 634432 (619.56 MiB 649.66 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 8

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : c8f6eca0 - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       29        0      active sync   /dev/sdb13
0     0       8       29        0      active sync   /dev/sdb13
1     1       8       13        1      active sync   /dev/sda13
2     2       8       45        2      active sync   /dev/sdc13
/dev/sdb6:
Magic : a92b4efc
Version : 00.90.00
UUID : ed01ad73:e4a5e4d0:90eb9b59:15e5c3c0
Creation Time : Mon Jan 15 23:26:43 2001
Raid Level : raid5
Device Size : 915584 (894.13 MiB 937.56 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 1

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 9ae14550 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       22        0      active sync   /dev/sdb6
0     0       8       22        0      active sync   /dev/sdb6
1     1       8        6        1      active sync   /dev/sda6
2     2       8       38        2      active sync   /dev/sdc6
/dev/sdb7:
Magic : a92b4efc
Version : 00.90.00
UUID : 31788297:ac6dab84:1dc952b3:fec35535
Creation Time : Mon Jan 15 23:26:48 2001
Raid Level : raid5
Device Size : 521984 (509.75 MiB 534.51 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 2

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 1cd52881 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       23        0      active sync   /dev/sdb7
0     0       8       23        0      active sync   /dev/sdb7
1     1       8        7        1      active sync   /dev/sda7
2     2       8       39        2      active sync   /dev/sdc7
/dev/sdb8:
Magic : a92b4efc
Version : 00.90.00
UUID : 5c4fb8f2:7aad3154:83515188:5945a00b
Creation Time : Mon Jan 15 23:26:53 2001
Raid Level : raid5
Device Size : 1686720 (1647.19 MiB 1727.20 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 3

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : d607f420 - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       24        0      active sync   /dev/sdb8
0     0       8       24        0      active sync   /dev/sdb8
1     1       8        8        1      active sync   /dev/sda8
2     2       8       40        2      active sync   /dev/sdc8
/dev/sdb9:
Magic : a92b4efc
Version : 00.90.00
UUID : 12a3daa6:98bc6aca:98d38bed:414bad01
Creation Time : Mon Jan 15 23:26:58 2001
Raid Level : raid5
Device Size : 1044096 (1019.63 MiB 1069.15 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 4

Update Time : Wed May 21 09:34:44 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : a7e9c86f - correct
Events : 0.200

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     0       8       25        0      active sync   /dev/sdb9
0     0       8       25        0      active sync   /dev/sdb9
1     1       8        9        1      active sync   /dev/sda9
2     2       8       41        2      active sync   /dev/sdc9

#mdadm.static -Eb /dev/sda*

ARRAY /dev/md4 level=raid5 num-devices=3 UUID=12a3daa6:98bc6aca:98d38bed:
414bad01
devices=/dev/sda9
ARRAY /dev/md3 level=raid5 num-devices=3 UUID=5c4fb8f2:7aad3154:83515188:
5945a00b
devices=/dev/sda8
ARRAY /dev/md2 level=raid5 num-devices=3 UUID=31788297:ac6dab84:1dc952b3:
fec35535
devices=/dev/sda7
ARRAY /dev/md1 level=raid5 num-devices=3 UUID=ed01ad73:e4a5e4d0:90eb9b59:
15e5c3c0
devices=/dev/sda6
ARRAY /dev/md8 level=raid5 num-devices=3 UUID=1708a6d1:96874201:39d9f451:
bed35249
devices=/dev/sda13
ARRAY /dev/md7 level=raid5 num-devices=3 UUID=f385575d:d3185f42:37e7d321:
4784a76c
devices=/dev/sda12
ARRAY /dev/md6 level=raid5 num-devices=3 UUID=cdcae134:499035b2:e539a33a:
636fa315
devices=/dev/sda11
ARRAY /dev/md5 level=raid5 num-devices=3 UUID=59f4a4fc:40471289:9d6e0430:
44f950a1
devices=/dev/sda10
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=be5bbd85:10d50fbf:6f2bf3dc:
88f7e433
devices=/dev/sda1

#mdadm.static -E /dev/sda*
/dev/sda1:
Magic : a92b4efc
Version : 00.90.00
UUID : be5bbd85:10d50fbf:6f2bf3dc:88f7e433
Creation Time : Mon Jan 15 23:26:38 2001
Raid Level : raid1
Device Size : 1566208 (1529.50 MiB 1603.80 MB)
Raid Devices : 2
Total Devices : 2
Preferred Minor : 0

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : ea1c99a2 - correct
Events : 0.267


Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1
0     0       8       17        0      active sync   /dev/sdb1
1     1       8        1        1      active sync   /dev/sda1
/dev/sda10:
Magic : a92b4efc
Version : 00.90.00
UUID : 59f4a4fc:40471289:9d6e0430:44f950a1
Creation Time : Mon Jan 15 23:27:03 2001
Raid Level : raid5
Device Size : 1036096 (1011.81 MiB 1060.96 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 5

Update Time : Thu Jul 24 01:19:45 2003
State : dirty, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : 2
Spare Devices : 0
Checksum : 9f612316 - correct
Events : 0.202

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8       10        1      active sync   /dev/sda10
0     0       8       26        0      faulty   /dev/sdb10
1     1       8       10        1      active sync   /dev/sda10
2     2       8       42        2      faulty   /dev/sdc10
/dev/sda11:
Magic : a92b4efc
Version : 00.90.00
UUID : cdcae134:499035b2:e539a33a:636fa315
Creation Time : Mon Jan 15 23:27:08 2001
Raid Level : raid5
Device Size : 546112 (533.31 MiB 559.22 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 6

Update Time : Thu Jul 24 01:18:35 2003
State : dirty, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : 2
Spare Devices : 0
Checksum : 82baf9ba - correct
Events : 0.202

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8       11        1      active sync   /dev/sda11
0     0       8       27        0      faulty   /dev/sdb11
1     1       8       11        1      active sync   /dev/sda11
2     2       8       43        2      faulty   /dev/sdc11
/dev/sda12:
Magic : a92b4efc
Version : 00.90.00
UUID : f385575d:d3185f42:37e7d321:4784a76c
Creation Time : Mon Jan 15 23:27:13 2001
Raid Level : raid5
Device Size : 409536 (399.94 MiB 419.36 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 7

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : 68c07fc9 - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8       12        1      active sync   /dev/sda12
0     0       8       28        0      active sync   /dev/sdb12
1     1       8       12        1      active sync   /dev/sda12
2     2       8       44        2      active sync   /dev/sdc12
/dev/sda13:
Magic : a92b4efc
Version : 00.90.00
UUID : 1708a6d1:96874201:39d9f451:bed35249
Creation Time : Mon Jan 15 23:27:18 2001
Raid Level : raid5
Device Size : 634432 (619.56 MiB 649.66 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 8

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 3
Working Devices : 3
Failed Devices : 0
Spare Devices : 0
Checksum : c8f6ec92 - correct
Events : 0.267

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8       13        1      active sync   /dev/sda13
0     0       8       29        0      active sync   /dev/sdb13
1     1       8       13        1      active sync   /dev/sda13
2     2       8       45        2      active sync   /dev/sdc13
/dev/sda6:
Magic : a92b4efc
Version : 00.90.00
UUID : ed01ad73:e4a5e4d0:90eb9b59:15e5c3c0
Creation Time : Mon Jan 15 23:26:43 2001
Raid Level : raid5
Device Size : 915584 (894.13 MiB 937.56 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 1

Update Time : Thu Jul 24 01:23:39 2003
State : dirty, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : 2
Spare Devices : 0
Checksum : 9b35321f - correct
Events : 0.202

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8        6        1      active sync   /dev/sda6
0     0       8       22        0      faulty   /dev/sdb6
1     1       8        6        1      active sync   /dev/sda6
2     2       8       38        2      faulty   /dev/sdc6
/dev/sda7:
Magic : a92b4efc
Version : 00.90.00
UUID : 31788297:ac6dab84:1dc952b3:fec35535
Creation Time : Mon Jan 15 23:26:48 2001
Raid Level : raid5
Device Size : 521984 (509.75 MiB 534.51 MB)
Raid Devices : 3
Total Devices : 2
Preferred Minor : 2

Update Time : Fri Jul 25 09:41:00 2003
State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : 1d2adb70 - correct
Events : 0.272

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8        7        1      active sync   /dev/sda7
0     0       0        0        0      faulty removed
1     1       8        7        1      active sync   /dev/sda7
2     2       8       39        2      active sync   /dev/sdc7
/dev/sda8:
Magic : a92b4efc
Version : 00.90.00
UUID : 5c4fb8f2:7aad3154:83515188:5945a00b
Creation Time : Mon Jan 15 23:26:53 2001
Raid Level : raid5
Device Size : 1686720 (1647.19 MiB 1727.20 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 3

Update Time : Thu Jul 24 01:26:27 2003
State : dirty, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : 2
Spare Devices : 0
Checksum : d65be197 - correct
Events : 0.202

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8        8        1      active sync   /dev/sda8
0     0       8       24        0      faulty   /dev/sdb8
1     1       8        8        1      active sync   /dev/sda8
2     2       8       40        2      faulty   /dev/sdc8
/dev/sda9:
Magic : a92b4efc
Version : 00.90.00
UUID : 12a3daa6:98bc6aca:98d38bed:414bad01
Creation Time : Mon Jan 15 23:26:58 2001
Raid Level : raid5
Device Size : 1044096 (1019.63 MiB 1069.15 MB)
Raid Devices : 3
Total Devices : 3
Preferred Minor : 4

Update Time : Thu Jul 24 01:24:36 2003
State : dirty, no-errors
Active Devices : 1
Working Devices : 1
Failed Devices : 2
Spare Devices : 0
Checksum : a83db577 - correct
Events : 0.202

Layout : left-asymmetric
Chunk Size : 64K

Number   Major   Minor   RaidDevice State
this     1       8        9        1      active sync   /dev/sda9
0     0       8       25        0      faulty   /dev/sdb9
1     1       8        9        1      active sync   /dev/sda9
2     2       8       41        2      faulty   /dev/sdc9




-----------------------------------------
This email was sent using OkeMail.
 "Your Communication LifeStyle!"
      http://www.oke.net.id/


