From: Alessandro Bono <a.bono@libero.it>
Subject: bugs in md.c
Date: Mon, 08 Sep 2003 23:01:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <pan.2003.09.08.21.01.07.571395@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi 

I'm trying to recover a lvm1 volume on a raid5 device
starting mdadm i receive this message
any idea how to solve this problem?

mdadm 1.3.0
kernel 2.4.22-ac1
Gnu C                  3.3.2
Gnu make               3.80
util-linux             2.11z
mount                  2.11z
modutils               2.4.21
e2fsprogs              1.35-WIP
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 3.1.11
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.0.90


md: hdd1's event counter: 00000086
md: hdc1's event counter: 00000085
md: superblock update time inconsistency -- using the most recent one
md: freshest: hdd1
md: device name has changed from [dev 21:01] to hdd1 since last import!
md: device name has changed from [dev 22:01] to hdc1 since last import!
md: bug in file md.c, line 1322

md:     **********************************
md:     * <COMPLETE RAID STATE PRINTOUT> *
md:     **********************************
md2: <hdd1><hdc1> array superblock:
md:  SB: (V:0.90.0) ID:<65dd03d3.d5c2f2df.656f6d51.06407e38> CT:3ddce973
md:     L1 S00048768 ND:1 RD:2 md2 LO:0 CS:4096
md:     UT:3f5cc7a3 ST:0 AD:1 WD:1 FD:0 SD:0 CSUM:cdb5b221 E:00000086
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdd1(22,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,[dev 21:01](33,1),R:1,S:6>
md: rdev hdd1: O:[dev 21:01], SZ:00000000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65dd03d3.d5c2f2df.656f6d51.06407e38> CT:3ddce973
md:     L1 S00048768 ND:1 RD:2 md2 LO:0 CS:4096
md:     UT:3f5cc7a3 ST:0 AD:1 WD:1 FD:0 SD:0 CSUM:cdb5b221 E:00000086
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,[dev 21:01](33,1),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hdd1(22,65),R:1,S:6>
md: rdev hdc1: O:[dev 22:01], SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65dd03d3.d5c2f2df.656f6d51.06407e38> CT:3ddce973
md:     L1 S00048768 ND:2 RD:2 md2 LO:0 CS:4096
md:     UT:3f5caa61 ST:1 AD:2 WD:2 FD:0 SD:0 CSUM:cdb59561 E:00000085
     D  0:  DISK<N:0,[dev 22:01](34,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 21:01](33,1),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:0,[dev 22:01](34,1),R:0,S:6>
md1: <hdd2><hdc2> array superblock:
md:  SB: (V:0.90.0) ID:<ee62cfb3.a8c65c9a.e2ff5166.06b29804> CT:3ddce972
md:     L5 S00499904 ND:2 RD:3 md1 LO:2 CS:32768
md:     UT:3f5ce94e ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:a7485958 E:0000008b
     D  0:  DISK<N:0,hdd2(22,66),R:0,S:6>
     D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:9>
md:     THIS:  DISK<N:0,hdd2(22,66),R:0,S:6>
md: rdev hdd2: O:hdd2, SZ:00499904 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<ee62cfb3.a8c65c9a.e2ff5166.06b29804> CT:3ddce972
md:     L5 S00499904 ND:2 RD:3 md1 LO:2 CS:32768
md:     UT:3f5ce94e ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:a7485a80 E:0000008b
     D  0:  DISK<N:0,hdd2(22,66),R:0,S:6>
     D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:9>
md:     THIS:  DISK<N:0,hdd2(22,66),R:0,S:6>
md: rdev hdc2: O:hdc2, SZ:00499904 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<ee62cfb3.a8c65c9a.e2ff5166.06b29804> CT:3ddce972
md:     L5 S00499904 ND:2 RD:3 md1 LO:2 CS:32768
md:     UT:3f5ce94e ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:a7485a42 E:0000008b
     D  0:  DISK<N:0,hdd2(22,66),R:0,S:6>
     D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:9>
md:     THIS:  DISK<N:1,hdc2(22,2),R:1,S:6>
md0: <hdc><hdd> array superblock:
md:  SB: (V:0.90.0) ID:<8fbe4dfc.11f5978b.cd254a97.3b179e9d> CT:3dd27920
md:     L5 S80043200 ND:2 RD:3 md0 LO:2 CS:32768
md:     UT:3f5ce94d ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:d5115cd8 E:0000000b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdc(22,0),R:1,S:6>
     D  2:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     THIS:  DISK<N:1,hdc(22,0),R:1,S:6>
md: rdev hdc: O:hdc, SZ:80043200 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<8fbe4dfc.11f5978b.cd254a97.3b179e9d> CT:3dd27920
md:     L5 S80043200 ND:2 RD:3 md0 LO:2 CS:32768
md:     UT:3f5ce94d ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:d5115e00 E:0000000b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdc(22,0),R:1,S:6>
     D  2:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     THIS:  DISK<N:1,hdc(22,0),R:1,S:6>
md: rdev hdd: O:hdd, SZ:80043200 F:0 DN:2 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<8fbe4dfc.11f5978b.cd254a97.3b179e9d> CT:3dd27920
md:     L5 S80043200 ND:2 RD:3 md0 LO:2 CS:32768
md:     UT:3f5ce94d ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:d5115e42 E:0000000b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdc(22,0),R:1,S:6>
     D  2:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     THIS:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     **********************************

md: bug in file md.c, line 1650

md:     **********************************
md:     * <COMPLETE RAID STATE PRINTOUT> *
md:     **********************************
md2: <hdd1><hdc1> array superblock:
md:  SB: (V:0.90.0) ID:<65dd03d3.d5c2f2df.656f6d51.06407e38> CT:3ddce973
md:     L1 S00048768 ND:1 RD:2 md2 LO:0 CS:4096
md:     UT:3f5cc7a3 ST:0 AD:1 WD:1 FD:0 SD:0 CSUM:cdb5b221 E:00000086
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdd1(22,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,[dev 21:01](33,1),R:1,S:6>
md: rdev hdd1: O:[dev 21:01], SZ:00000000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65dd03d3.d5c2f2df.656f6d51.06407e38> CT:3ddce973
md:     L1 S00048768 ND:1 RD:2 md2 LO:0 CS:4096
md:     UT:3f5cc7a3 ST:0 AD:1 WD:1 FD:0 SD:0 CSUM:cdb5b221 E:00000086
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,[dev 21:01](33,1),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hdd1(22,65),R:1,S:6>
md: rdev hdc1: O:[dev 22:01], SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65dd03d3.d5c2f2df.656f6d51.06407e38> CT:3ddce973
md:     L1 S00048768 ND:2 RD:2 md2 LO:0 CS:4096
md:     UT:3f5caa61 ST:1 AD:2 WD:2 FD:0 SD:0 CSUM:cdb59561 E:00000085
     D  0:  DISK<N:0,[dev 22:01](34,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 21:01](33,1),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:0,[dev 22:01](34,1),R:0,S:6>
md1: <hdd2><hdc2> array superblock:
md:  SB: (V:0.90.0) ID:<ee62cfb3.a8c65c9a.e2ff5166.06b29804> CT:3ddce972
md:     L5 S00499904 ND:2 RD:3 md1 LO:2 CS:32768
md:     UT:3f5ce94e ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:a7485958 E:0000008b
     D  0:  DISK<N:0,hdd2(22,66),R:0,S:6>
     D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:9>
md:     THIS:  DISK<N:0,hdd2(22,66),R:0,S:6>
md: rdev hdd2: O:hdd2, SZ:00499904 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<ee62cfb3.a8c65c9a.e2ff5166.06b29804> CT:3ddce972
md:     L5 S00499904 ND:2 RD:3 md1 LO:2 CS:32768
md:     UT:3f5ce94e ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:a7485a80 E:0000008b
     D  0:  DISK<N:0,hdd2(22,66),R:0,S:6>
     D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:9>
md:     THIS:  DISK<N:0,hdd2(22,66),R:0,S:6>
md: rdev hdc2: O:hdc2, SZ:00499904 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<ee62cfb3.a8c65c9a.e2ff5166.06b29804> CT:3ddce972
md:     L5 S00499904 ND:2 RD:3 md1 LO:2 CS:32768
md:     UT:3f5ce94e ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:a7485a42 E:0000008b
     D  0:  DISK<N:0,hdd2(22,66),R:0,S:6>
     D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
     D  3:  DISK<N:3,[dev 00:00](0,0),R:3,S:9>
md:     THIS:  DISK<N:1,hdc2(22,2),R:1,S:6>
md0: <hdc><hdd> array superblock:
md:  SB: (V:0.90.0) ID:<8fbe4dfc.11f5978b.cd254a97.3b179e9d> CT:3dd27920
md:     L5 S80043200 ND:2 RD:3 md0 LO:2 CS:32768
md:     UT:3f5ce94d ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:d5115cd8 E:0000000b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdc(22,0),R:1,S:6>
     D  2:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     THIS:  DISK<N:1,hdc(22,0),R:1,S:6>
md: rdev hdc: O:hdc, SZ:80043200 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<8fbe4dfc.11f5978b.cd254a97.3b179e9d> CT:3dd27920
md:     L5 S80043200 ND:2 RD:3 md0 LO:2 CS:32768
md:     UT:3f5ce94d ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:d5115e00 E:0000000b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdc(22,0),R:1,S:6>
     D  2:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     THIS:  DISK<N:1,hdc(22,0),R:1,S:6>
md: rdev hdd: O:hdd, SZ:80043200 F:0 DN:2 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<8fbe4dfc.11f5978b.cd254a97.3b179e9d> CT:3dd27920
md:     L5 S80043200 ND:2 RD:3 md0 LO:2 CS:32768
md:     UT:3f5ce94d ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:d5115e42 E:0000000b
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:9>
     D  1:  DISK<N:1,hdc(22,0),R:1,S:6>
     D  2:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     THIS:  DISK<N:2,hdd(22,64),R:2,S:6>
md:     **********************************

md: md2 stopped.
md: unbind<hdd1,1>
md: export_rdev(hdd1)
md: unbind<hdc1,0>
md: export_rdev(hdc1)
 [events: 00000089]
md: bind<hdc3,1>
 [events: 00000089]
md: bind<hdd3,2>


thanks

