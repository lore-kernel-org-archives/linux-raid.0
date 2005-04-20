From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: 2.4.30: bug in file md.c, line 2473
Date: Wed, 20 Apr 2005 00:42:51 -0700 (PDT)
Message-ID: <Pine.LNX.4.62.0504200035590.1382@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i got the following bug from 2.4.30 while trying to hot add a device 
tonight...

i was trying to replace a disk in a 3-way raid1 -- the existing disks are 
sda, sdb, and i was replacing sdc.  each of these disks has 3 partitions, 
each with a raid1.

due to an improper shutdown the raids were being sync'd... specifically:

Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 sdb1[2] sda1[0]
      7823552 blocks [3/2] [U_U]
        resync=DELAYED
md1 : active raid1 sdb2[2] sda2[0]
      3911744 blocks [3/2] [U_U]
        resync=DELAYED
md2 : active raid1 sdb3[1] sda3[0]
      108318144 blocks [3/2] [UU_]
      [==>..................]  resync = 13.3% (14415248/108318144) finish=59.3min speed=26366K/sec
md3 : active raid1 sde1[1] sdd1[0]
      199141632 blocks [3/2] [UU_]
      [=>...................]  resync =  6.0% (12045888/199141632) finish=145.1min speed=21480K/sec

and then i tried:

# mdadm /dev/md1 -a /dev/sdc2
mdadm: hot add failed for /dev/sdc2: Invalid argument

and the dmesg bug output is pasted below.

let me know if there's more info you'd like ... or if i did something dumb 
:)

thanks
-dean

md: trying to hot-add sdc2 to md1 ... 
md: bind<sdc2,3>
md: bug in file md.c, line 2473

md:	**********************************
md:	* <COMPLETE RAID STATE PRINTOUT> *
md:	**********************************
md0: <sdb1><sda1> array superblock:
md:  SB: (V:0.90.0) ID:<54a41317.8d4ba606.7dd1ac2d.43c65883> CT:42621381
md:     L1 S07823552 ND:4 RD:3 md0 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:d1f282a0 E:00000024
     D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:9>
     D  2:  DISK<N:2,sdb1(8,17),R:2,S:6>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:1>
md:     THIS:  DISK<N:2,sdb1(8,17),R:2,S:6>
md: rdev sdb1: O:sdb1, SZ:07823552 F:0 DN:2 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<54a41317.8d4ba606.7dd1ac2d.43c65883> CT:42621381
md:     L1 S07823552 ND:4 RD:3 md0 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:d1f28438 E:00000024
     D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:9>
     D  2:  DISK<N:2,sdb1(8,17),R:2,S:6>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:1>
md:     THIS:  DISK<N:2,sdb1(8,17),R:2,S:6>
md: rdev sda1: O:sda1, SZ:07823552 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<54a41317.8d4ba606.7dd1ac2d.43c65883> CT:42621381
md:     L1 S07823552 ND:4 RD:3 md0 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:d1f28424 E:00000024
     D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:9>
     D  2:  DISK<N:2,sdb1(8,17),R:2,S:6>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:1>
md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
md1: <sdc2><sdb2><sda2> array superblock:
md:  SB: (V:0.90.0) ID:<94d6f5e3.ce487a3a.fb358d6f.375e923c> CT:4262138d
md:     L1 S03911744 ND:4 RD:3 md1 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:c3e2a424 E:0000001c
     D  0:  DISK<N:0,sda2(8,2),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:9>
     D  2:  DISK<N:2,sdb2(8,18),R:2,S:6>
     D  3:  DISK<N:3,sdc2(8,34),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:1>
md:     THIS:  DISK<N:2,sdb2(8,18),R:2,S:6>
md: rdev sdc2: O:sdc2, SZ:03911744 F:0 DN:-1 <6>md: rdev superblock:
md:  SB: (V:1.-150761216.0) ID:<00000000.f6b49250.f6ab2d80.00000000> CT:00000000
md:     L-156056320 S-156594432 ND:0 RD:-156573696 md0 LO:0 CS:0
md:     UT:f6ab2a80 ST:0 AD:-156573696 WD:0 FD:0 SD:-155937712 CSUM:00000000 E:00000000
     D 20:  DISK<N:483,[dev e3:e3](4194787,8389091),R:12583395,S:16777699>
     D 21:  DISK<N:134218211,[dev e3:e3](138412515,142606819),R:146801123,S:150995427>
     D 22:  DISK<N:268435939,[dev e3:e3](272630243,276824547),R:281018851,S:285213155>
     D 23:  DISK<N:402653667,[dev e3:e3](406847971,411042275),R:415236579,S:419430883>
     D 24:  DISK<N:536871395,[dev e3:e3](541065699,545260003),R:549454307,S:553648611>
     D 25:  DISK<N:671089123,[dev e3:e3](675283427,679477731),R:683672035,S:687866339>
     D 26:  DISK<N:805306851,[dev e3:e3](809501155,813695459),R:817889763,S:822084067>
md:     THIS:  DISK<N:0,[dev 20:67](0,935010407),R:921989223,S:0>
md: rdev sdb2: O:sdb2, SZ:03911744 F:0 DN:2 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<94d6f5e3.ce487a3a.fb358d6f.375e923c> CT:4262138d
md:     L1 S03911744 ND:4 RD:3 md1 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:c3e2a5bc E:0000001c
     D  0:  DISK<N:0,sda2(8,2),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:9>
     D  2:  DISK<N:2,sdb2(8,18),R:2,S:6>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:1>
md:     THIS:  DISK<N:2,sdb2(8,18),R:2,S:6>
md: rdev sda2: O:sda2, SZ:03911744 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<94d6f5e3.ce487a3a.fb358d6f.375e923c> CT:4262138d
md:     L1 S03911744 ND:4 RD:3 md1 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:c3e2a5a8 E:0000001c
     D  0:  DISK<N:0,sda2(8,2),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:9>
     D  2:  DISK<N:2,sdb2(8,18),R:2,S:6>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:1>
md:     THIS:  DISK<N:0,sda2(8,2),R:0,S:6>
md2: <sdb3><sda3> array superblock:
md:  SB: (V:0.90.0) ID:<43ad447b.1be99cfd.979fe6fc.02a406b4> CT:42621396
md:     L1 S108318144 ND:4 RD:3 md2 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:2e43010c E:0000001b
     D  0:  DISK<N:0,sda3(8,3),R:0,S:6>
     D  1:  DISK<N:1,sdb3(8,19),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:1>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
md:     THIS:  DISK<N:1,sdb3(8,19),R:1,S:6>
md: rdev sdb3: O:sdb3, SZ:108318144 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<43ad447b.1be99cfd.979fe6fc.02a406b4> CT:42621396
md:     L1 S108318144 ND:4 RD:3 md2 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:2e4302a5 E:0000001b
     D  0:  DISK<N:0,sda3(8,3),R:0,S:6>
     D  1:  DISK<N:1,sdb3(8,19),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:1>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
md:     THIS:  DISK<N:1,sdb3(8,19),R:1,S:6>
md: rdev sda3: O:sda3, SZ:108318144 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<43ad447b.1be99cfd.979fe6fc.02a406b4> CT:42621396
md:     L1 S108318144 ND:4 RD:3 md2 LO:0 CS:0
md:     UT:426601d8 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:2e430293 E:0000001b
     D  0:  DISK<N:0,sda3(8,3),R:0,S:6>
     D  1:  DISK<N:1,sdb3(8,19),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:1>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
     D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
md:     THIS:  DISK<N:0,sda3(8,3),R:0,S:6>
md3: <sde1><sdd1> array superblock:
md:  SB: (V:0.90.0) ID:<c59bab99.d8d0b619.f9b4fcc4.15fc374f> CT:4260b3ef
md:     L1 S199141632 ND:4 RD:3 md3 LO:0 CS:0
md:     UT:426601d7 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:e7ee43c7 E:00000021
     D  0:  DISK<N:0,sdd1(8,49),R:0,S:6>
     D  1:  DISK<N:1,sde1(8,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:1>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
md:     THIS:  DISK<N:1,sde1(8,65),R:1,S:6>
md: rdev sde1: O:sde1, SZ:199141632 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<c59bab99.d8d0b619.f9b4fcc4.15fc374f> CT:4260b3ef
md:     L1 S199141632 ND:4 RD:3 md3 LO:0 CS:0
md:     UT:426601d7 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:e7ee455f E:00000021
     D  0:  DISK<N:0,sdd1(8,49),R:0,S:6>
     D  1:  DISK<N:1,sde1(8,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:1>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
md:     THIS:  DISK<N:1,sde1(8,65),R:1,S:6>
md: rdev sdd1: O:sdd1, SZ:199141632 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<c59bab99.d8d0b619.f9b4fcc4.15fc374f> CT:4260b3ef
md:     L1 S199141632 ND:4 RD:3 md3 LO:0 CS:0
md:     UT:426601d7 ST:0 AD:2 WD:2 FD:2 SD:0 CSUM:e7ee454d E:00000021
     D  0:  DISK<N:0,sdd1(8,49),R:0,S:6>
     D  1:  DISK<N:1,sde1(8,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:1>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:1>
md:     THIS:  DISK<N:0,sdd1(8,49),R:0,S:6>
md:	**********************************

md: unbind<sdc2,2>
md: export_rdev(sdc2)
