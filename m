From: Rob Hagopian <rob@hagopian.net>
Subject: Re: raid bug in 2.4.20
Date: Thu, 10 Apr 2003 16:25:03 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304101623300.25209-100000@karma.hagopian.net>
References: <Pine.LNX.4.44.0304101555440.25209-100000@karma.hagopian.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0304101555440.25209-100000@karma.hagopian.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I hate to follow this up so soon, but I was able to add the new drive, 
write out a partition table, and raidhotadd the partitions again, but they 
won't resync:


Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md7 : active raid1 sdb6[2] sda6[0]
      1052160 blocks [2/1] [U_]
       
md0 : active raid1 sdb1[2] sda1[0]
      128384 blocks [2/1] [U_]
      [>....................]  recovery =  0.0% (0/128384) 
finish=3658.9min speed=0K/sec
md3 : active raid1 sdb2[2] sda2[0]
      1052160 blocks [2/1] [U_]
       
md2 : active raid1 sdb3[2] sda3[0]
      1052160 blocks [2/1] [U_]
       
md8 : active raid1 sdb5[2] sda5[0]
      1052160 blocks [2/1] [U_]
       
md1 : active raid1 sda7[0]
      1052160 blocks [2/1] [U_]
       
md4 : active raid1 sdb8[2] sda9[0]
      521984 blocks [2/1] [U_]
       
md6 : active raid1 sdb9[2] sda10[0]
      521984 blocks [2/1] [U_]
       
md5 : active raid1 sdb10[2] sda8[0]
      521984 blocks [2/1] [U_]
       
md9 : active raid1 sdb11[2] sda11[0]
      28603584 blocks [2/1] [U_]
       
unused devices: <none>


So close!!! Is the bug noted below perhaps interfering with the state of 
the md devices now?

-Rob



On Thu, 10 Apr 2003, Rob Hagopian wrote:

> I attempted to remove a drive from a running md device and got the
> following error. I gather after searching around that one should mark the
> disk as faulty first, but the driver did print out a bug report so I
> figured I'd forward it on along (esp since it may be related to the fact 
> that sdb had died, possibly triggering the "bug").
> 
> -Rob
> 
> md: trying to remove sda6 from md7 ...
> md: bug in file md.c, line 2341
> 
> md:^I**********************************
> md:^I* <COMPLETE RAID STATE PRINTOUT> *
> md:^I**********************************
> md0: <sdb1><sda1> array superblock:
> md:  SB: (V:0.90.0) ID:<12ea4748.9f03e2f4.39b57d14.cbda5fa7> CT:3d61f57e
> md:     L1 S00128384 ND:2 RD:2 md0 LO:0 CS:65536
> md:     UT:3e924a28 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:dba8f3ac E:0000000c
>      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
>      D  1:  DISK<N:1,sdb1(8,17),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
> md: rdev sdb1: O:sdb1, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda1: O:sda1, SZ:00128384 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<12ea4748.9f03e2f4.39b57d14.cbda5fa7> CT:3d61f57e
> md:     L1 S00128384 ND:2 RD:2 md0 LO:0 CS:65536
> md:     UT:3e924a28 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:dca08c27 E:0000000c
>      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
>      D  1:  DISK<N:1,sdb1(8,17),R:1,S:1>
> md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
> md3: <sdb2><sda2> array superblock:
> md:  SB: (V:0.90.0) ID:<5677597c.9ea3e3f3.8e431994.a7cb0053> CT:3d61f576
> md:     L1 S01052160 ND:2 RD:2 md3 LO:0 CS:65536
> md:     UT:3e92069a ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:4f625c8a E:0000000c
>      D  0:  DISK<N:0,sda2(8,2),R:0,S:6>
>      D  1:  DISK<N:1,sdb2(8,18),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb2(8,18),R:1,S:6>
> md: rdev sdb2: O:sdb2, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda2: O:sda2, SZ:01052160 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<5677597c.9ea3e3f3.8e431994.a7cb0053> CT:3d61f576
> md:     L1 S01052160 ND:2 RD:2 md3 LO:0 CS:65536
> md:     UT:3e92069a ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:5059b177 E:0000000c
>      D  0:  DISK<N:0,sda2(8,2),R:0,S:6>
>      D  1:  DISK<N:1,sdb2(8,18),R:1,S:1>
> md:     THIS:  DISK<N:0,sda2(8,2),R:0,S:6>
> md2: <sdb3><sda3> array superblock:
> md:  SB: (V:0.90.0) ID:<df455c0a.990d19bd.687b0474.5be4717e> CT:3d61f5a9
> md:     L1 S01052160 ND:2 RD:2 md2 LO:0 CS:65536
> md:     UT:3e920a1d ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:60eaf122 E:0000000c
>      D  0:  DISK<N:0,sda3(8,3),R:0,S:6>
>      D  1:  DISK<N:1,sdb3(8,19),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb3(8,19),R:1,S:6>
> md: rdev sdb3: O:sdb3, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda3: O:sda3, SZ:01052160 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<df455c0a.990d19bd.687b0474.5be4717e> CT:3d61f5a9
> md:     L1 S01052160 ND:2 RD:2 md2 LO:0 CS:65536
> md:     UT:3e920a1d ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:61e24992 E:0000000c
>      D  0:  DISK<N:0,sda3(8,3),R:0,S:6>
>      D  1:  DISK<N:1,sdb3(8,19),R:1,S:1>
> md:     THIS:  DISK<N:0,sda3(8,3),R:0,S:6>
> md8: <sdb5><sda5> array superblock:
> md:  SB: (V:0.90.0) ID:<58f6b5f6.471488c8.cceb5795.ac6675b7> CT:3d61f59b
> md:     L1 S01052160 ND:2 RD:2 md8 LO:0 CS:65536
> md:     UT:3e924b44 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:3d961171 E:0000000c
>      D  0:  DISK<N:0,sda5(8,5),R:0,S:6>
>      D  1:  DISK<N:1,sdb5(8,21),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb5(8,21),R:1,S:6>
> md: rdev sdb5: O:sdb5, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda5: O:sda5, SZ:01052160 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<58f6b5f6.471488c8.cceb5795.ac6675b7> CT:3d61f59b
> md:     L1 S01052160 ND:2 RD:2 md8 LO:0 CS:65536
> md:     UT:3e924b44 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:3e8dab08 E:0000000c
>      D  0:  DISK<N:0,sda5(8,5),R:0,S:6>
>      D  1:  DISK<N:1,sdb5(8,21),R:1,S:1>
> md:     THIS:  DISK<N:0,sda5(8,5),R:0,S:6>
> md7: <sdb6><sda6> array superblock:
> md:  SB: (V:0.90.0) ID:<04631263.84cbb6a7.adbfae01.5b59e2e0> CT:3d61f571
> md:     L1 S01052160 ND:2 RD:2 md7 LO:0 CS:65536
> md:     UT:3d9ac854 ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:b6815f27 E:00000009
>      D  0:  DISK<N:0,sda6(8,6),R:0,S:6>
>      D  1:  DISK<N:1,sdb6(8,22),R:1,S:6>
> md:     THIS:  DISK<N:1,sdb6(8,22),R:1,S:6>
> md: rdev sdb6: O:sdb6, SZ:01052160 F:0 DN:1 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<04631263.84cbb6a7.adbfae01.5b59e2e0> CT:3d61f571
> md:     L1 S01052160 ND:2 RD:2 md7 LO:0 CS:65536
> md:     UT:3d9ac854 ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:b68175e5 E:00000009
>      D  0:  DISK<N:0,sda6(8,6),R:0,S:6>
>      D  1:  DISK<N:1,sdb6(8,22),R:1,S:6>
> md:     THIS:  DISK<N:1,sdb6(8,22),R:1,S:6>
> md: rdev sda6: O:sda6, SZ:01052160 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<04631263.84cbb6a7.adbfae01.5b59e2e0> CT:3d61f571
> md:     L1 S01052160 ND:2 RD:2 md7 LO:0 CS:65536
> md:     UT:3d9ac854 ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:b68175d3 E:00000009
>      D  0:  DISK<N:0,sda6(8,6),R:0,S:6>
>      D  1:  DISK<N:1,sdb6(8,22),R:1,S:6>
> md:     THIS:  DISK<N:0,sda6(8,6),R:0,S:6>
> md1: <sdb7><sda7> array superblock:
> md:  SB: (V:0.90.0) ID:<cffda20a.7559a435.53337277.b3fdf45b> CT:3d61f56c
> md:     L1 S01052160 ND:2 RD:2 md1 LO:0 CS:65536
> md:     UT:3e95a3c9 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:70c1b246 E:0000000a
>      D  0:  DISK<N:0,sda7(8,7),R:0,S:6>
>      D  1:  DISK<N:1,sdb7(8,23),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb7(8,23),R:1,S:6>
> md: rdev sdb7: O:sdb7, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda7: O:sda7, SZ:01052160 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<cffda20a.7559a435.53337277.b3fdf45b> CT:3d61f56c
> md:     L1 S01052160 ND:2 RD:2 md1 LO:0 CS:65536
> md:     UT:3e95a3c9 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:71bca462 E:0000000a
>      D  0:  DISK<N:0,sda7(8,7),R:0,S:6>
>      D  1:  DISK<N:1,sdb7(8,23),R:1,S:1>
> md:     THIS:  DISK<N:0,sda7(8,7),R:0,S:6>
> md4: <sdb8><sda9> array superblock:
> md:  SB: (V:0.90.0) ID:<44216925.22869ac0.044668fa.83725de6> CT:3d61f5b0
> md:     L1 S00521984 ND:2 RD:2 md4 LO:0 CS:65536
> md:     UT:3e924a75 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:1291b946 E:0000000c
>      D  0:  DISK<N:0,sda9(8,9),R:0,S:6>
>      D  1:  DISK<N:1,sdb8(8,24),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb8(8,24),R:1,S:6>
> md: rdev sdb8: O:sdb8, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda9: O:sda9, SZ:00521984 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<44216925.22869ac0.044668fa.83725de6> CT:3d61f5b0
> md:     L1 S00521984 ND:2 RD:2 md4 LO:0 CS:65536
> md:     UT:3e924a75 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:1389520f E:0000000c
>      D  0:  DISK<N:0,sda9(8,9),R:0,S:6>
>      D  1:  DISK<N:1,sdb8(8,24),R:1,S:1>
> md:     THIS:  DISK<N:0,sda9(8,9),R:0,S:6>
> md6: <sdb9><sda10> array superblock:
> md:  SB: (V:0.90.0) ID:<1cca0afd.260be943.2e5cdc8b.03515c49> CT:3d61f5b7
> md:     L1 S00521984 ND:2 RD:2 md6 LO:0 CS:65536
> md:     UT:3e9207c8 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:98b51ba0 E:0000000c
>      D  0:  DISK<N:0,sda10(8,10),R:0,S:6>
>      D  1:  DISK<N:1,sdb9(8,25),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb9(8,25),R:1,S:6>
> md: rdev sdb9: O:sdb9, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda10: O:sda10, SZ:00521984 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<1cca0afd.260be943.2e5cdc8b.03515c49> CT:3d61f5b7
> md:     L1 S00521984 ND:2 RD:2 md6 LO:0 CS:65536
> md:     UT:3e9207c8 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:99ac71bc E:0000000c
>      D  0:  DISK<N:0,sda10(8,10),R:0,S:6>
>      D  1:  DISK<N:1,sdb9(8,25),R:1,S:1>
> md:     THIS:  DISK<N:0,sda10(8,10),R:0,S:6>
> md5: <sdb10><sda8> array superblock:
> md:  SB: (V:0.90.0) ID:<bb34b95a.b5a82a0f.cf0714e2.ec51f13e> CT:3d61f5a2
> md:     L1 S00521984 ND:2 RD:2 md5 LO:0 CS:65536
> md:     UT:3e9249f6 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:5066d802 E:0000000c
>      D  0:  DISK<N:0,sda8(8,8),R:0,S:6>
>      D  1:  DISK<N:1,sdb10(8,26),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb10(8,26),R:1,S:6>
> md: rdev sdb10: O:sdb10, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda8: O:sda8, SZ:00521984 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<bb34b95a.b5a82a0f.cf0714e2.ec51f13e> CT:3d61f5a2
> md:     L1 S00521984 ND:2 RD:2 md5 LO:0 CS:65536
> md:     UT:3e9249f6 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:515e7049 E:0000000c
>      D  0:  DISK<N:0,sda8(8,8),R:0,S:6>
>      D  1:  DISK<N:1,sdb10(8,26),R:1,S:1>
> md:     THIS:  DISK<N:0,sda8(8,8),R:0,S:6>
> md9: <sdb11><sda11> array superblock:
> md:  SB: (V:0.90.0) ID:<3473f87d.d5d00caa.17f77f81.2195b8cc> CT:3d61f583
> md:     L1 S28603584 ND:2 RD:2 md9 LO:0 CS:65536
> md:     UT:3e920eb9 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:69aea995 E:0000000c
>      D  0:  DISK<N:0,sda11(8,11),R:0,S:6>
>      D  1:  DISK<N:1,sdb11(8,27),R:1,S:1>
> md:     THIS:  DISK<N:1,sdb11(8,27),R:1,S:6>
> md: rdev sdb11: O:sdb11, SZ:00000000 F:1 DN:1 <6>md: no rdev superblock!
> md: rdev sda11: O:sda11, SZ:28603584 F:0 DN:0 <6>md: rdev superblock:
> md:  SB: (V:0.90.0) ID:<3473f87d.d5d00caa.17f77f81.2195b8cc> CT:3d61f583
> md:     L1 S28603584 ND:2 RD:2 md9 LO:0 CS:65536
> md:     UT:3e920eb9 ST:0 AD:1 WD:1 FD:1 SD:0 CSUM:6aa606a1 E:0000000c
>      D  0:  DISK<N:0,sda11(8,11),R:0,S:6>
>      D  1:  DISK<N:1,sdb11(8,27),R:1,S:1>
> md:     THIS:  DISK<N:0,sda11(8,11),R:0,S:6>
> md:^I**********************************
> 
> md: cannot remove active disk sda6 from md7 ...
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

