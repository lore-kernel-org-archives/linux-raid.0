From: Erkki Seppala <flux@modeemi.fi>
Subject: Md says 'bug' to kernel log
Date: Sat, 12 Oct 2002 09:54:58 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021012065457.GA26887@modeemi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I run kernel version 2.4.18 and Debian version 0.90.20010914-17 of
raidtools2.

I recently used this configuration to create a md-device:

--8<--
raiddev                 /dev/md/2
raid-level              1

persistent-superblock   1

chunk-size              32

nr-raid-disks           2
nr-spare-disks          0

device                  /dev/ide/host0/bus1/target0/lun0/part1
raid-disk               0

device                  /dev/ide/host0/bus0/target1/lun0/part1
#raid-disk              1
failed-disk             1
--8<--

After moving the data from the 'failed disk' to the raid, I tried to
raidhotadd the failed device, however the operation failed as the disk was
too small. A little bit of a surprise to me, because the disks were the same
model, but the geometry was different, hence there was a few blocks
difference..

While trying to do that, I accidently added the whole disk to the raid. Of
course I tried to raidhotremove it, but that couldn't be done anymore, I
assumed due to the fact that it was already rebuilding the disk.

But I couldn't raithotremove it 800 minutes later either, which led me to
read the kernel logs, where I discovered the bug-statement.

Here follows a ~50-line exerpt from the log. The complete log is available
at http://www.modeemi.fi/~flux/kern.log . The time (19:31) fits nicely to
the time I started the raid and then tried to remove it. This can be seen in
the full log.

md: bug in file md.c, line 2351

md:^I**********************************
md:^I* <COMPLETE RAID STATE PRINTOUT> *
md:^I**********************************
md2: <ide/host0/bus0/target1/lun0/disc><ide/host0/bus1/target0/lun0/part1> array superblock:
md:  SB: (V:0.90.0) ID:<876d4f10.4ce89914.770fd445.ecf7ba69> CT:3da5c118
md:     L1 S120060736 ND:3 RD:2 md2 LO:0 CS:32768
md:     UT:3da6fcb7 ST:0 AD:1 WD:2 FD:1 SD:1 CSUM:265702ca E:00000002
     D  0:  DISK<N:0,ide/host0/bus1/target0/lun0/part1(22,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:1>
     D  2:  DISK<N:2,ide/host0/bus0/target1/lun0/disc(3,64),R:2,S:0>
md:     THIS:  DISK<N:0,ide/host0/bus1/target0/lun0/part1(22,1),R:0,S:6>
md: rdev ide/host0/bus0/target1/lun0/disc: O:ide/host0/bus0/target1/lun0/disc, SZ:120060800 F:0 DN:2 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<876d4f10.4ce89914.770fd445.ecf7ba69> CT:3da5c118
md:     L1 S120060736 ND:3 RD:2 md2 LO:0 CS:32768
md:     UT:3da6fcb7 ST:0 AD:1 WD:2 FD:1 SD:1 CSUM:63fe0057 E:00000002
     D  0:  DISK<N:0,ide/host0/bus1/target0/lun0/part1(22,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:1>
     D  2:  DISK<N:2,ide/host0/bus0/target1/lun0/disc(3,64),R:2,S:0>
md:     THIS:  DISK<N:2,ide/host0/bus0/target1/lun0/disc(3,64),R:2,S:0>
md: rdev ide/host0/bus1/target0/lun0/part1: O:ide/host0/bus1/target0/lun0/part1, SZ:120060736 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<876d4f10.4ce89914.770fd445.ecf7ba69> CT:3da5c118
md:     L1 S120060736 ND:3 RD:2 md2 LO:0 CS:32768
md:     UT:3da6fcb7 ST:0 AD:1 WD:2 FD:1 SD:1 CSUM:63fe002d E:00000002
     D  0:  DISK<N:0,ide/host0/bus1/target0/lun0/part1(22,1),R:0,S:6>
     D  1:  DISK<N:1,[dev 00:00](0,0),R:1,S:1>
     D  2:  DISK<N:2,ide/host0/bus0/target1/lun0/disc(3,64),R:2,S:0>
md:     THIS:  DISK<N:0,ide/host0/bus1/target0/lun0/part1(22,1),R:0,S:6>
md1: <ide/host0/bus1/target1/lun0/part1><ide/host0/bus0/target0/lun0/part1> array superblock:
md:  SB: (V:0.90.0) ID:<5adf3dbd.58ba5b53.810e410e.9446badf> CT:3c6a45cc
md:     L1 S58633216 ND:2 RD:2 md1 LO:0 CS:32768
md:     UT:3da59cfa ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:efa8e78d E:00000051
     D  0:  DISK<N:0,ide/host0/bus0/target0/lun0/part1(3,1),R:0,S:6>
     D  1:  DISK<N:1,ide/host0/bus1/target1/lun0/part1(22,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,ide/host0/bus1/target1/lun0/part1(22,65),R:1,S:6>
md: rdev ide/host0/bus1/target1/lun0/part1: O:ide/host0/bus1/target1/lun0/part1, SZ:58633216 F:0 DN:1 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<5adf3dbd.58ba5b53.810e410e.9446badf> CT:3c6a45cc
md:     L1 S58633216 ND:2 RD:2 md1 LO:0 CS:32768
md:     UT:3da59cfa ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:efa8f4ab E:00000051
     D  0:  DISK<N:0,ide/host0/bus0/target0/lun0/part1(3,1),R:0,S:6>
     D  1:  DISK<N:1,ide/host0/bus1/target1/lun0/part1(22,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:1,ide/host0/bus1/target1/lun0/part1(22,65),R:1,S:6>
md: rdev ide/host0/bus0/target0/lun0/part1: O:ide/host0/bus0/target0/lun0/part1, SZ:58633216 F:0 DN:0 <6>md: rdev superblock:
md:  SB: (V:0.90.0) ID:<5adf3dbd.58ba5b53.810e410e.9446badf> CT:3c6a45cc
md:     L1 S58633216 ND:2 RD:2 md1 LO:0 CS:32768
md:     UT:3da59cfa ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:efa8f456 E:00000051
     D  0:  DISK<N:0,ide/host0/bus0/target0/lun0/part1(3,1),R:0,S:6>
     D  1:  DISK<N:1,ide/host0/bus1/target1/lun0/part1(22,65),R:1,S:6>
     D  2:  DISK<N:2,[dev 00:00](0,0),R:2,S:9>
md:     THIS:  DISK<N:0,ide/host0/bus0/target0/lun0/part1(3,1),R:0,S:6>
md:^I**********************************

md: cannot remove active disk ide/host0/bus0/target1/lun0/disc from md2 ... 

I imagine I'll try rebooting the machine some day now, perhaps during this
weekend, repartition the 'failed' device, make a new raid there, copy data
oveer, sync the other one with it.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.inside.org/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@inside.org                                  \/
