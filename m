From: Emmanuel Michon <emmanuel_michon@realmagic.fr>
Subject: trying to force usage of spare disk with raidhotremove causes bad logs
Date: 22 Oct 2002 15:50:33 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7wy98qrsue.fsf@achille.soft.sdesigns.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

my configuration is a default RH8.0:
[root@frogproject root]#  rpm -qa |grep raid
raidtools-1.00.2-3.3
[root@frogproject root]# uname -a
Linux frogproject.soft.sdesigns.com 2.4.18-14 #1 Wed Sep 4 13:35:50 EDT 2002 i686 i686 i386 GNU/Linux
[root@frogproject root]# 

I have setup a RAID5 software on five identical IDE drives hdb, hdc, hde, hdf, hdg

Starting with:
0:hdf 1:hdc 2:hde 3:hdg spare:hdb
without recovery thread running, I just wanted to remove hde from the array to see the
recovery thread using the spare hdb. Unfortunately this causes:

# raidhotremove /dev/md0 /dev/hde1
/dev/md0: can not hot-remove disk: disk busy!

Even if user operation is bad, I should not get this log:

Oct 22 15:40:34 frogproject kernel: md: bug in file md.c, line 2341
Oct 22 15:40:34 frogproject kernel: 
Oct 22 15:40:34 frogproject kernel: md:^I**********************************
Oct 22 15:40:34 frogproject kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Oct 22 15:40:34 frogproject kernel: md:^I**********************************
Oct 22 15:40:34 frogproject kernel: md0: <hdb1><hdc1><hde1><hdf1><hdg1> array superblock:
Oct 22 15:40:34 frogproject kernel: md:  SB: (V:0.90.0) ID:<3da9462e.51bae484.3ce93a37.a4af326e> CT:3db517fa
Oct 22 15:40:34 frogproject kernel: md:     L5 S80035712 ND:5 RD:4 md0 LO:0 CS:65536
Oct 22 15:40:34 frogproject kernel: md:     UT:3db5d2ff ST:0 AD:4 WD:5 FD:0 SD:1 CSUM:9a5912ec E:00000016
Oct 22 15:40:34 frogproject kernel:      D  0:  DISK<N:0,hdf1(33,65),R:0,S:6>
Oct 22 15:40:34 frogproject kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Oct 22 15:40:34 frogproject kernel:      D  2:  DISK<N:2,hde1(33,1),R:2,S:6>
Oct 22 15:40:34 frogproject kernel:      D  3:  DISK<N:3,hdg1(34,1),R:3,S:6>
Oct 22 15:40:34 frogproject kernel:      D  4:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md:     THIS:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md: rdev hdb1: O:hdb1, SZ:80043136 F:0 DN:4 <6>md: rdev superblock:
Oct 22 15:40:34 frogproject kernel: md:  SB: (V:0.90.0) ID:<3da9462e.51bae484.3ce93a37.a4af326e> CT:3db517fa
Oct 22 15:40:34 frogproject kernel: md:     L5 S80035712 ND:5 RD:4 md0 LO:0 CS:65536
Oct 22 15:40:34 frogproject kernel: md:     UT:3db5d2ff ST:0 AD:4 WD:5 FD:0 SD:1 CSUM:9a591328 E:00000016
Oct 22 15:40:34 frogproject kernel:      D  0:  DISK<N:0,hdf1(33,65),R:0,S:6>
Oct 22 15:40:34 frogproject kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Oct 22 15:40:34 frogproject kernel:      D  2:  DISK<N:2,hde1(33,1),R:2,S:6>
Oct 22 15:40:34 frogproject kernel:      D  3:  DISK<N:3,hdg1(34,1),R:3,S:6>
Oct 22 15:40:34 frogproject kernel:      D  4:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md:     THIS:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md: rdev hdc1: O:hdc1, SZ:80043136 F:0 DN:1 <6>md: rdev superblock:
Oct 22 15:40:34 frogproject kernel: md:  SB: (V:0.90.0) ID:<3da9462e.51bae484.3ce93a37.a4af326e> CT:3db517fa
Oct 22 15:40:34 frogproject kernel: md:     L5 S80035712 ND:5 RD:4 md0 LO:0 CS:65536
Oct 22 15:40:34 frogproject kernel: md:     UT:3db5d2ff ST:0 AD:4 WD:5 FD:0 SD:1 CSUM:9a5912fb E:00000016
Oct 22 15:40:34 frogproject kernel:      D  0:  DISK<N:0,hdf1(33,65),R:0,S:6>
Oct 22 15:40:34 frogproject kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Oct 22 15:40:34 frogproject kernel:      D  2:  DISK<N:2,hde1(33,1),R:2,S:6>
Oct 22 15:40:34 frogproject kernel:      D  3:  DISK<N:3,hdg1(34,1),R:3,S:6>
Oct 22 15:40:34 frogproject kernel:      D  4:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
Oct 22 15:40:34 frogproject kernel: md: rdev hde1: O:hde1, SZ:80043136 F:0 DN:2 <6>md: rdev superblock:
Oct 22 15:40:34 frogproject kernel: md:  SB: (V:0.90.0) ID:<3da9462e.51bae484.3ce93a37.a4af326e> CT:3db517fa
Oct 22 15:40:34 frogproject kernel: md:     L5 S80035712 ND:5 RD:4 md0 LO:0 CS:65536
Oct 22 15:40:34 frogproject kernel: md:     UT:3db5d2ff ST:0 AD:4 WD:5 FD:0 SD:1 CSUM:9a591308 E:00000016
Oct 22 15:40:34 frogproject kernel:      D  0:  DISK<N:0,hdf1(33,65),R:0,S:6>
Oct 22 15:40:34 frogproject kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Oct 22 15:40:34 frogproject kernel:      D  2:  DISK<N:2,hde1(33,1),R:2,S:6>
Oct 22 15:40:34 frogproject kernel:      D  3:  DISK<N:3,hdg1(34,1),R:3,S:6>
Oct 22 15:40:34 frogproject kernel:      D  4:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md:     THIS:  DISK<N:2,hde1(33,1),R:2,S:6>
Oct 22 15:40:34 frogproject kernel: md: rdev hdf1: O:hdf1, SZ:80043136 F:0 DN:0 <6>md: rdev superblock:
Oct 22 15:40:34 frogproject kernel: md:  SB: (V:0.90.0) ID:<3da9462e.51bae484.3ce93a37.a4af326e> CT:3db517fa
Oct 22 15:40:34 frogproject kernel: md:     L5 S80035712 ND:5 RD:4 md0 LO:0 CS:65536
Oct 22 15:40:34 frogproject kernel: md:     UT:3db5d2ff ST:0 AD:4 WD:5 FD:0 SD:1 CSUM:9a591344 E:00000016
Oct 22 15:40:34 frogproject kernel:      D  0:  DISK<N:0,hdf1(33,65),R:0,S:6>
Oct 22 15:40:34 frogproject kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Oct 22 15:40:34 frogproject kernel:      D  2:  DISK<N:2,hde1(33,1),R:2,S:6>
Oct 22 15:40:34 frogproject kernel:      D  3:  DISK<N:3,hdg1(34,1),R:3,S:6>
Oct 22 15:40:34 frogproject kernel:      D  4:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md:     THIS:  DISK<N:0,hdf1(33,65),R:0,S:6>
Oct 22 15:40:34 frogproject kernel: md: rdev hdg1: O:hdg1, SZ:80043136 F:0 DN:3 <6>md: rdev superblock:
Oct 22 15:40:34 frogproject kernel: md:  SB: (V:0.90.0) ID:<3da9462e.51bae484.3ce93a37.a4af326e> CT:3db517fa
Oct 22 15:40:34 frogproject kernel: md:     L5 S80035712 ND:5 RD:4 md0 LO:0 CS:65536
Oct 22 15:40:34 frogproject kernel: md:     UT:3db5d2ff ST:0 AD:4 WD:5 FD:0 SD:1 CSUM:9a59130b E:00000016
Oct 22 15:40:34 frogproject kernel:      D  0:  DISK<N:0,hdf1(33,65),R:0,S:6>
Oct 22 15:40:34 frogproject kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
Oct 22 15:40:34 frogproject kernel:      D  2:  DISK<N:2,hde1(33,1),R:2,S:6>
Oct 22 15:40:34 frogproject kernel:      D  3:  DISK<N:3,hdg1(34,1),R:3,S:6>
Oct 22 15:40:34 frogproject kernel:      D  4:  DISK<N:4,hdb1(3,65),R:4,S:0>
Oct 22 15:40:34 frogproject kernel: md:     THIS:  DISK<N:3,hdg1(34,1),R:3,S:6>
Oct 22 15:40:34 frogproject kernel: md:^I**********************************
Oct 22 15:40:34 frogproject kernel: 
Oct 22 15:40:34 frogproject kernel: md: cannot remove active disk hde1 from md0 ... 

Do you have an advise about this?

-- 
Emmanuel Michon
Chef de projet
REALmagic France SAS
Mobile: 0614372733 GPGkeyID: D2997E42  
