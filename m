From: Stephan van Hienen <raid@a2000.nu>
Subject: md: bug in file raid5.c, line 540 (kernel 2.4.20)
Date: Mon, 14 Apr 2003 00:21:27 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0304140015310.24622@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

trying to do a raidsetfaulty on my hotspare disk (i was trying to see if i
would get any email from mdadm --monitor)

i can reproduce this bug

]# cat /proc/mdstat
Personalities : [raid0] [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdj1[13](F) sdo1[12] sdn1[11] sdi1[10] sdm1[9] sdl1[8]
sdk1[7] sdh1[6] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
      2109878784 blocks level 5, 128k chunk, algorithm 0 [13/13]
[UUUUUUUUUUUUU]

unused devices: <none>


dmesg output :

----------
md: bug in file raid5.c, line 540

md:     **********************************
md:     * <COMPLETE RAID STATE PRINTOUT> *
md:     **********************************
md0:
<sdj1><sdo1><sdn1><sdi1><sdm1><sdl1><sdk1><sdh1><sdg1><sdf1><sde1><sdd1><sd
c1><sdb1> array superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd079 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:13,sdj1(8,145),R:13,S:0>
md: rdev sdj1: O:sdj1, SZ:175823232 F:0 DN:13 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd14a E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:13,sdj1(8,145),R:13,S:0>
md: rdev sdo1: O:sdo1, SZ:175823232 F:0 DN:12 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd19e E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:12,sdo1(8,225),R:12,S:6>
md: rdev sdn1: O:sdn1, SZ:175823232 F:0 DN:11 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd18c E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:11,sdn1(8,209),R:11,S:6>
md: rdev sdi1: O:sdi1, SZ:175823232 F:0 DN:10 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd13a E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:10,sdi1(8,129),R:10,S:6>
md: rdev sdm1: O:sdm1, SZ:175823232 F:0 DN:9 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd178 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:9,sdm1(8,193),R:9,S:6>
md: rdev sdl1: O:sdl1, SZ:175823232 F:0 DN:8 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd166 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:8,sdl1(8,177),R:8,S:6>
md: rdev sdk1: O:sdk1, SZ:175823232 F:0 DN:7 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd154 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:7,sdk1(8,161),R:7,S:6>
md: rdev sdh1: O:sdh1, SZ:175823232 F:0 DN:6 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd122 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:6,sdh1(8,113),R:6,S:6>
md: rdev sdg1: O:sdg1, SZ:175823232 F:0 DN:5 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd110 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:5,sdg1(8,97),R:5,S:6>
md: rdev sdf1: O:sdf1, SZ:175823232 F:0 DN:4 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd0fe E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:4,sdf1(8,81),R:4,S:6>
md: rdev sde1: O:sde1, SZ:175823232 F:0 DN:3 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd0ec E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:3,sde1(8,65),R:3,S:6>
md: rdev sdd1: O:sdd1, SZ:175823232 F:0 DN:2 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd0da E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:2,sdd1(8,49),R:2,S:6>
md: rdev sdc1: O:sdc1, SZ:175823232 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd0c8 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:1,sdc1(8,33),R:1,S:6>
md: rdev sdb1: O:sdb1, SZ:175823232 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<1f645dc4.5abb183e.9dda5de2.68373dbb> CT:3e5a0d81
md:     L5 S175823232 ND:14 RD:13 md0 LO:0 CS:131072
md:     UT:3e997fdc ST:0 AD:13 WD:14 FD:0 SD:1 CSUM:b0ccd0b6 E:00000041
     D  0:  DISK<N:0,sdb1(8,17),R:0,S:6>
     D  1:  DISK<N:1,sdc1(8,33),R:1,S:6>
     D  2:  DISK<N:2,sdd1(8,49),R:2,S:6>
     D  3:  DISK<N:3,sde1(8,65),R:3,S:6>
     D  4:  DISK<N:4,sdf1(8,81),R:4,S:6>
     D  5:  DISK<N:5,sdg1(8,97),R:5,S:6>
     D  6:  DISK<N:6,sdh1(8,113),R:6,S:6>
     D  7:  DISK<N:7,sdk1(8,161),R:7,S:6>
     D  8:  DISK<N:8,sdl1(8,177),R:8,S:6>
     D  9:  DISK<N:9,sdm1(8,193),R:9,S:6>
     D 10:  DISK<N:10,sdi1(8,129),R:10,S:6>
     D 11:  DISK<N:11,sdn1(8,209),R:11,S:6>
     D 12:  DISK<N:12,sdo1(8,225),R:12,S:6>
     D 13:  DISK<N:13,sdj1(8,145),R:13,S:0>
md:     THIS:  DISK<N:0,sdb1(8,17),R:0,S:6>
md:     **********************************

md: recovery thread got woken up ...
md: recovery thread finished ...
----------

