From: Thomas <thomas@zimres.net>
Subject: 2.6.0-test1-bk2 ate my root raid
Date: Wed, 23 Jul 2003 13:34:25 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030723203425.GA22680@drunk.brewdrinkers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tested 2.6.0-test1-bk2 out, and it wouldn't boot using 
my devfs name. No real problem there, as I've seen the workaround--
use the huge ugly devfs name (or hex'ed numbers)--I've got a backup root
partition (I've got to learn to type one of these days if I play with
root). Boot using the backup partition, 
"2.6.0-test1-bk2 root=/dev/hdc1 init=/bin/bash" and notice that 
the new kernel doesn't see my promise controler (odd that, half
of the raid is on that "lost" drive"). 

Boot back into 2.4.21; I get a quick kernel panic (no root)
but can't tell why as once you've panic'ed you can't scroll up. I've
got a Knoppix cd, so all will be well. Boot that, and load the md 
modules and got the following, and here I'm a bit stumped :"
 [events: 0000001d]
md: bind<hda1,1>
 [events: 0000001c]
md: bind<hde1,2>
md: hde1's event counter: 0000001c
md: hda1's event counter: 0000001d
md: superblock update time inconsistency -- using the most recent one
md: freshest: hda1
md: bug in file md.c, line 1475

md:     **********************************
md:     * <COMPLETE RAID STATE PRINTOUT> *
md:     **********************************
md0: <hde1><hda1> array superblock:
md:  SB: (V:0.90.0) ID:<86ef0928.b64d0dea.a3d663ce.7cfe04e4> CT:3eff4d61
md:     L1 S01952768 ND:1 RD:2 md0 LO:0 CS:1048576
md:     UT:3f1edd18 ST:1 AD:1 WD:1 FD:0 SD:0 CSUM:8587c5f7 E:0000001d
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:8>
     D  1:  DISK<N:1,hda1(3,1),R:1,S:6>
md:     THIS:  DISK<N:1,hda1(3,1),R:1,S:6>
md: rdev hde1: O:hde1, SZ:00000000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<86ef0928.b64d0dea.a3d663ce.7cfe04e4> CT:3eff4d61
md:     L1 S01952768 ND:2 RD:2 md0 LO:0 CS:1048576
md:     UT:3f1e2837 ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:858711a4 E:0000001c
     D  0:  DISK<N:0,hda1(3,1),R:1,S:6>
     D  1:  DISK<N:1,hde1(33,1),R:0,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde1(33,1),R:0,S:6>
md: rdev hda1: O:hda1, SZ:00000000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<86ef0928.b64d0dea.a3d663ce.7cfe04e4> CT:3eff4d61
md:     L1 S01952768 ND:1 RD:2 md0 LO:0 CS:1048576
md:     UT:3f1edd18 ST:1 AD:1 WD:1 FD:0 SD:0 CSUM:8587c5f7 E:0000001d
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:8>
     D  1:  DISK<N:1,hda1(3,1),R:1,S:6>
md:     THIS:  DISK<N:1,hda1(3,1),R:1,S:6>
md:     **********************************

md: bug in file md.c, line 1639

md:     **********************************
md:     * <COMPLETE RAID STATE PRINTOUT> *
md:     **********************************
md0: <hde1><hda1> array superblock:
md:  SB: (V:0.90.0) ID:<86ef0928.b64d0dea.a3d663ce.7cfe04e4> CT:3eff4d61
md:     L1 S01952768 ND:1 RD:2 md0 LO:0 CS:1048576
md:     UT:3f1edd18 ST:1 AD:1 WD:1 FD:0 SD:0 CSUM:8587c5f7 E:0000001d
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:8>
     D  1:  DISK<N:1,hda1(3,1),R:1,S:6>
md:     THIS:  DISK<N:1,hda1(3,1),R:1,S:6>
md: rdev hde1: O:hde1, SZ:00000000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<86ef0928.b64d0dea.a3d663ce.7cfe04e4> CT:3eff4d61
md:     L1 S01952768 ND:2 RD:2 md0 LO:0 CS:1048576
md:     UT:3f1e2837 ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:858711a4 E:0000001c
     D  0:  DISK<N:0,hda1(3,1),R:1,S:6>
     D  1:  DISK<N:1,hde1(33,1),R:0,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,hde1(33,1),R:0,S:6>
md: rdev hda1: O:hda1, SZ:00000000 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<86ef0928.b64d0dea.a3d663ce.7cfe04e4> CT:3eff4d61
md:     L1 S01952768 ND:1 RD:2 md0 LO:0 CS:1048576
md:     UT:3f1edd18 ST:1 AD:1 WD:1 FD:0 SD:0 CSUM:8587c5f7 E:0000001d
     D  0:  DISK<N:0,[dev 00:00](0,0),R:0,S:8>
     D  1:  DISK<N:1,hda1(3,1),R:1,S:6>
md:     THIS:  DISK<N:1,hda1(3,1),R:1,S:6>
md:     **********************************

md: md0 stopped.
md: unbind<hde1,1>
md: export_rdev(hde1)
md: unbind<hda1,0>
md: export_rdev(hda1)
