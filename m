From: Farkas Levente <lfarkas@bppiac.hu>
Subject: bug in raid5 in rhel 3
Date: Mon, 31 May 2004 16:09:19 +0200
Sender: redhat-list-bounces@redhat.com
Message-ID: <40BB3C8F.9070306@bppiac.hu>
Reply-To: General Red Hat Linux discussion list <redhat-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <redhat-list-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/redhat-list>,
	<mailto:redhat-list-request@redhat.com?subject=unsubscribe>
List-Archive: </archives/redhat-list>
List-Post: <mailto:redhat-list@redhat.com>
List-Help: <mailto:redhat-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/redhat-list>,
	<mailto:redhat-list-request@redhat.com?subject=subscribe>
Errors-To: redhat-list-bounces@redhat.com
To: linux-raid@vger.kernel.org, redhat-list@redhat.com
List-Id: linux-raid.ids

hi,
here is a cut from my messages files, what can I do:
------------------------------
# uname -a; mdadm -V
Linux kek.int.mkk.hu 2.4.21-15.EL.c0 #1 Thu May 13 04:18:33 BST 2004 
i686 i686 i386 GNU/Linux
mdadm - v1.5.0 - 22 Jan 2004
------------------------------
------------------------------
May 31 15:37:36 kek kernel: md: bug in file raid5.c, line 540
May 31 15:37:36 kek kernel:
May 31 15:37:36 kek kernel: md:^I**********************************
May 31 15:37:36 kek kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
May 31 15:37:36 kek kernel: md:^I**********************************
May 31 15:37:36 kek kernel: md0: <hda2><hdc2> array superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<d4d9847a.f1a64699.d69d2216.3813cab1> CT:3fcf1da2
May 31 15:37:36 kek kernel: md:     L1 S39097664 ND:2 RD:2 md0 LO:0 CS:65536
May 31 15:37:36 kek kernel: md:     UT:40bb33a7 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:013bec78 E:00000066
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,hda2(3,2),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:0,hda2(3,2),R:0,S:6>
May 31 15:37:36 kek kernel: md: rdev hda2: O:hda2, SZ:39097728 F:0 DN:0 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<d4d9847a.f1a64699.d69d2216.3813cab1> CT:3fcf1da2
May 31 15:37:36 kek kernel: md:     L1 S39097664 ND:2 RD:2 md0 LO:0 CS:65536
May 31 15:37:36 kek kernel: md:     UT:40bb33a7 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:013beecf E:00000066
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,hda2(3,2),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:0,hda2(3,2),R:0,S:6>
May 31 15:37:36 kek kernel: md: rdev hdc2: O:hdc2, SZ:39097728 F:0 DN:1 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<d4d9847a.f1a64699.d69d2216.3813cab1> CT:3fcf1da2
May 31 15:37:36 kek kernel: md:     L1 S39097664 ND:2 RD:2 md0 LO:0 CS:65536
May 31 15:37:36 kek kernel: md:     UT:40bb33a7 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:013beee4 E:00000066
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,hda2(3,2),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:1,hdc2(22,2),R:1,S:6>
May 31 15:37:36 kek kernel: md1: <hda1><hdc1> array superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<59a6cca4.c0cbadca.10fe0c88.5c977bdb> CT:3fcf2752
May 31 15:37:36 kek kernel: md:     L1 S01048704 ND:2 RD:2 md1 LO:0 CS:0
May 31 15:37:36 kek kernel: md:     UT:40bb33a7 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:b1cdac47 E:0000005b
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:0,hda1(3,1),R:0,S:6>
May 31 15:37:36 kek kernel: md: rdev hda1: O:hda1, SZ:01048704 F:0 DN:0 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<59a6cca4.c0cbadca.10fe0c88.5c977bdb> CT:3fcf2752
May 31 15:37:36 kek kernel: md:     L1 S01048704 ND:2 RD:2 md1 LO:0 CS:0
May 31 15:37:36 kek kernel: md:     UT:40bb33a7 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:b1cdae9e E:0000005b
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:0,hda1(3,1),R:0,S:6>
May 31 15:37:36 kek kernel: md: rdev hdc1: O:hdc1, SZ:01048704 F:0 DN:1 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<59a6cca4.c0cbadca.10fe0c88.5c977bdb> CT:3fcf2752
May 31 15:37:36 kek kernel: md:     L1 S01048704 ND:2 RD:2 md1 LO:0 CS:0
May 31 15:37:36 kek kernel: md:     UT:40bb33a7 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:b1cdaeb3 E:0000005b
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
May 31 15:37:36 kek kernel: md2: <sde1><sdf1><sdd1><sdc1><sdb1><sda1> 
array superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<7fda241f.5a683e6e.4f22e751.036cd66e> CT:40b225bb
May 31 15:37:36 kek kernel: md:     L5 S120053632 ND:6 RD:7 md2 LO:2 
CS:131072
May 31 15:37:36 kek kernel: md:     UT:40bb34fa ST:0 AD:5 WD:6 FD:0 SD:1 
CSUM:5e94ac92 E:000000d7
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel:      D  3:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel:      D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
May 31 15:37:36 kek kernel:      D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>
May 31 15:37:36 kek kernel:      D  6:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel:      D  7:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:6,sdg1(8,97),R:6,S:6>
May 31 15:37:36 kek kernel: md: rdev sde1: O:sde1, SZ:120053632 F:0 DN:7 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<7fda241f.5a683e6e.4f22e751.036cd66e> CT:40b225bb
May 31 15:37:36 kek kernel: md:     L5 S120053632 ND:6 RD:7 md2 LO:2 
CS:131072
May 31 15:37:36 kek kernel: md:     UT:40bb34fa ST:0 AD:5 WD:6 FD:0 SD:1 
CSUM:5e94ad18 E:000000d7
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel:      D  3:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel:      D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
May 31 15:37:36 kek kernel:      D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>
May 31 15:37:36 kek kernel:      D  6:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel:      D  7:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel: md: rdev sdf1: O:sdg1, SZ:120053632 F:0 DN:6 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<7fda241f.5a683e6e.4f22e751.036cd66e> CT:40b225bb
May 31 15:37:36 kek kernel: md:     L5 S120053632 ND:6 RD:7 md2 LO:2 
CS:131072
May 31 15:37:36 kek kernel: md:     UT:40bb34fa ST:0 AD:5 WD:6 FD:0 SD:1 
CSUM:5e94ad2c E:000000d7
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel:      D  3:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel:      D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
May 31 15:37:36 kek kernel:      D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>
May 31 15:37:36 kek kernel:      D  6:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel:      D  7:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel: md: rdev sdd1: O:sdd1, SZ:120053632 F:0 DN:3 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<7fda241f.5a683e6e.4f22e751.036cd66e> CT:40b225bb
May 31 15:37:36 kek kernel: md:     L5 S120053632 ND:6 RD:7 md2 LO:2 
CS:131072
May 31 15:37:36 kek kernel: md:     UT:40bb34fa ST:0 AD:5 WD:6 FD:0 SD:1 
CSUM:5e94ad06 E:000000d7
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel:      D  3:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel:      D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
May 31 15:37:36 kek kernel:      D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>
May 31 15:37:36 kek kernel:      D  6:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel:      D  7:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel: md: rdev sdc1: O:sdc1, SZ:120053632 F:0 DN:2 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<7fda241f.5a683e6e.4f22e751.036cd66e> CT:40b225bb
May 31 15:37:36 kek kernel: md:     L5 S120053632 ND:6 RD:7 md2 LO:2 
CS:131072
May 31 15:37:36 kek kernel: md:     UT:40bb34fa ST:0 AD:5 WD:6 FD:0 SD:1 
CSUM:5e94acf4 E:000000d7
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel:      D  3:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel:      D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
May 31 15:37:36 kek kernel:      D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>
May 31 15:37:36 kek kernel:      D  6:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel:      D  7:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel: md: rdev sdb1: O:sdb1, SZ:120053632 F:0 DN:1 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<7fda241f.5a683e6e.4f22e751.036cd66e> CT:40b225bb
May 31 15:37:36 kek kernel: md:     L5 S120053632 ND:6 RD:7 md2 LO:2 
CS:131072
May 31 15:37:36 kek kernel: md:     UT:40bb34fa ST:0 AD:5 WD:6 FD:0 SD:1 
CSUM:5e94ace2 E:000000d7
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel:      D  3:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel:      D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
May 31 15:37:36 kek kernel:      D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>
May 31 15:37:36 kek kernel:      D  6:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel:      D  7:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel: md: rdev sda1: O:sda1, SZ:120053632 F:0 DN:0 
<6>md: rdev superblock:
May 31 15:37:36 kek kernel: md:  SB: (V:0.90.0) 
ID:<7fda241f.5a683e6e.4f22e751.036cd66e> CT:40b225bb
May 31 15:37:36 kek kernel: md:     L5 S120053632 ND:6 RD:7 md2 LO:2 
CS:131072
May 31 15:37:36 kek kernel: md:     UT:40bb34fa ST:0 AD:5 WD:6 FD:0 SD:1 
CSUM:5e94acd0 E:000000d7
May 31 15:37:36 kek kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
May 31 15:37:36 kek kernel:      D  2:  DISK<N:2,sdc1(8,33),R:2,S:6>
May 31 15:37:36 kek kernel:      D  3:  DISK<N:3,sdd1(8,49),R:3,S:6>
May 31 15:37:36 kek kernel:      D  4:  DISK<N:4,[dev 00:00](0,0),R:4,S:9>
May 31 15:37:36 kek kernel:      D  5:  DISK<N:5,[dev 00:00](0,0),R:5,S:9>
May 31 15:37:36 kek kernel:      D  6:  DISK<N:6,sdf1(8,81),R:6,S:6>
May 31 15:37:36 kek kernel:      D  7:  DISK<N:7,sde1(8,65),R:7,S:0>
May 31 15:37:36 kek kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
May 31 15:37:36 kek kernel: md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
May 31 15:37:36 kek kernel: md:^I**********************************
May 31 15:37:36 kek kernel:
May 31 15:37:36 kek kernel: md: trying to remove sde1 from md2 ...
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:36 kek kernel: md: unbind<sde1,5>
May 31 15:37:36 kek kernel: md: export_rdev(sde1)
May 31 15:37:36 kek kernel: md: trying to hot-add sde1 to md2 ...
May 31 15:37:36 kek kernel: md: bind<sde1,6>
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:36 kek kernel: md2: resyncing spare disk sde1 to replace 
failed disk
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:36 kek kernel: md: syncing RAID array md2
May 31 15:37:36 kek kernel: md: minimum _guaranteed_ reconstruction 
speed: 100 KB/sec/disc.
May 31 15:37:36 kek kernel: md: using maximum available idle IO bandwith 
(but not more than 10000 KB/sec) for reconstruction.
May 31 15:37:36 kek kernel: md: using 124k window, over a total of 
120053632 blocks.
May 31 15:37:36 kek kernel: md: md_do_sync() got signal ... exiting
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:36 kek kernel: RAID5 conf printout:
May 31 15:37:36 kek kernel:  --- rd:7 wd:5 fd:2
May 31 15:37:36 kek kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
May 31 15:37:36 kek kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
May 31 15:37:36 kek kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
May 31 15:37:36 kek kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
May 31 15:37:36 kek kernel:  disk 4, s:0, o:0, n:4 rd:4 us:1 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 5, s:0, o:0, n:5 rd:5 us:0 dev:[dev 00:00]
May 31 15:37:36 kek kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdf1
May 31 15:37:47 kek kernel: md: trying to hot-add sde1 to md2 ...
May 31 15:48:13 kek kernel: md: trying to hot-add sdg1 to md2 ...
May 31 15:48:13 kek kernel: md: could not lock sdg1, zero-size? Marking 
faulty.
May 31 15:48:13 kek kernel: md: error, md_import_device() returned -22
------------------------------

-- 
   Levente                               "Si vis pacem para bellum!"


-- 
redhat-list mailing list
unsubscribe mailto:redhat-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/redhat-list
