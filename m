From: Lucian Daniel Kafka <luci@conexim.com.au>
Subject: Hot remove issue
Date: Mon, 14 Apr 2003 11:40:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.2.0.9.0.20030414113355.06084be0@144.135.24.13>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

I am having the noted problem of hot removing a drive from a md1 array (see 
log below).

Also, the /etc/raidtab seems to be ignored. I have tried to set drives as 
failed-disk, hoping to remove them after the next reboot, but that didn't 
work. Also, I have tried to change the order in which the md devices are 
initialized (by swapping entries in /etc/raidtab), but that had no effect 
either.

Any ideas?

Apr 14 11:18:06 mason kernel: md: trying to remove hdc1 from md0 ...
Apr 14 11:18:06 mason kernel: md: bug in file md.c, line 2341
Apr 14 11:18:06 mason kernel:
Apr 14 11:18:06 mason kernel: md:^I**********************************
Apr 14 11:18:06 mason kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Apr 14 11:18:06 mason kernel: md:^I**********************************
Apr 14 11:18:06 mason kernel: md0: <hdc1><hda1> array superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<aed10f26.711bd718.721009dd.bc5eaa20> CT:3e989ba6
Apr 14 11:18:06 mason kernel: md:     L1 S00136448 ND:2 RD:2 md0 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:74bbc1cd E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hdc1: O:hdc1, SZ:00137984 F:0 DN:1 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<aed10f26.711bd718.721009dd.bc5eaa20> CT:3e989ba6
Apr 14 11:18:06 mason kernel: md:     L1 S00136448 ND:2 RD:2 md0 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:74bd1dac E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hda1: O:hda1, SZ:00136448 F:0 DN:0 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<aed10f26.711bd718.721009dd.bc5eaa20> CT:3e989ba6
Apr 14 11:18:06 mason kernel: md:     L1 S00136448 ND:2 RD:2 md0 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:74bd1d97 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:0,hda1(3,1),R:0,S:6>
Apr 14 11:18:06 mason kernel: md3: <hdc2><hda6> array superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<4a0bfdb5.598bf9f5.46595892.11f6b3fc> CT:3e989be0
Apr 14 11:18:06 mason kernel: md:     L1 S25005056 ND:2 RD:2 md3 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:23c3a30d E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc2(22,2),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hdc2: O:hdc2, SZ:26623680 F:0 DN:1 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<4a0bfdb5.598bf9f5.46595892.11f6b3fc> CT:3e989be0
Apr 14 11:18:06 mason kernel: md:     L1 S25005056 ND:2 RD:2 md3 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:23c4feec E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc2(22,2),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hda6: O:hda6, SZ:25005056 F:0 DN:0 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<4a0bfdb5.598bf9f5.46595892.11f6b3fc> CT:3e989be0
Apr 14 11:18:06 mason kernel: md:     L1 S25005056 ND:2 RD:2 md3 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:23c4fedb E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc2(22,2),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:0,hda6(3,6),R:0,S:6>
Apr 14 11:18:06 mason kernel: md2: <hdc3><hda5> array superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<1ec9d7e6.92f5e78a.b224c3a3.495cd392> CT:3e989bd7
Apr 14 11:18:06 mason kernel: md:     L1 S05004096 ND:2 RD:2 md2 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:d3ebc4b1 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc3(22,3),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hdc3: O:hdc3, SZ:05120064 F:0 DN:1 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<1ec9d7e6.92f5e78a.b224c3a3.495cd392> CT:3e989bd7
Apr 14 11:18:06 mason kernel: md:     L1 S05004096 ND:2 RD:2 md2 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:d3ed2090 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc3(22,3),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hda5: O:hda5, SZ:05004096 F:0 DN:0 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<1ec9d7e6.92f5e78a.b224c3a3.495cd392> CT:3e989bd7
Apr 14 11:18:06 mason kernel: md:     L1 S05004096 ND:2 RD:2 md2 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:d3ed207d E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:0,hda5(3,5),R:0,S:6>
Apr 14 11:18:06 mason kernel: md4: <hdc6><hda7> array superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<94850940.c8a1409d.8a33f869.abd7bc58> CT:3e989bab
Apr 14 11:18:06 mason kernel: md:     L1 S50010240 ND:2 RD:2 md4 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:bc8b29c9 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc6(22,6),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hdc6: O:hdc6, SZ:53248000 F:0 DN:1 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<94850940.c8a1409d.8a33f869.abd7bc58> CT:3e989bab
Apr 14 11:18:06 mason kernel: md:     L1 S50010240 ND:2 RD:2 md4 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:bc8c85a8 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc6(22,6),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hda7: O:hda7, SZ:50010240 F:0 DN:0 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<94850940.c8a1409d.8a33f869.abd7bc58> CT:3e989bab
Apr 14 11:18:06 mason kernel: md:     L1 S50010240 ND:2 RD:2 md4 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:bc8c8594 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:0,hda7(3,7),R:0,S:6>
Apr 14 11:18:06 mason kernel: md1: <hdc7><hda2> array superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<b5ad200f.d75cb6b6.9a11f0d7.f402b04f> CT:3e989ba0
Apr 14 11:18:06 mason kernel: md:     L1 S00256960 ND:2 RD:2 md1 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:41807646 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda2(3,2),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc7(22,7),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hdc7: O:hdc7, SZ:00276544 F:0 DN:1 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<b5ad200f.d75cb6b6.9a11f0d7.f402b04f> CT:3e989ba0
Apr 14 11:18:06 mason kernel: md:     L1 S00256960 ND:2 RD:2 md1 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:4181d225 E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda2(3,2),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:1,hdc7(22,7),R:1,S:6>
Apr 14 11:18:06 mason kernel: md: rdev hda2: O:hda2, SZ:00256960 F:0 DN:0 
<6>md: rdev superblock:
Apr 14 11:18:06 mason kernel: md:  SB: (V:0.90.0) 
ID:<b5ad200f.d75cb6b6.9a11f0d7.f402b04f> CT:3e989ba0
Apr 14 11:18:06 mason kernel: md:     L1 S00256960 ND:2 RD:2 md1 LO:0 CS:65536
Apr 14 11:18:06 mason kernel: md:     UT:3e9a82a5 ST:0 AD:2 WD:2 FD:0 SD:0 
CSUM:4181d20b E:00000018
Apr 14 11:18:06 mason kernel:      D  0:  DISK<N:0,hda2(3,2),R:0,S:6>
Apr 14 11:18:06 mason kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
Apr 14 11:18:06 mason kernel: md:     THIS:  DISK<N:0,hda2(3,2),R:0,S:6>
Apr 14 11:18:06 mason kernel: md:^I**********************************
Apr 14 11:18:06 mason kernel:
Apr 14 11:18:06 mason kernel: md: cannot remove active disk hdc1 from md0 ...

