From: Tim Small <tim@semantico.com>
Subject: MD_BUG() reports - RAID5 rebuild failure causes confusion
Date: Wed, 07 Apr 2004 14:24:58 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4074012A.8060303@semantico.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've had some bug reports in the kernel output on a server that I have 
been commisioning.  The box is a Dual Opteron, running 2.6.5rc3 (64 bit 
build), with 4 250G WD SATA drives, via libata (sata_sil driver).

I had previously seen a kernel panic on the box during file I/O whilst a 
RAID5 array was being resynced - I didn't manage to get any backtrace 
out of it, but had been trying to make it fall over since (by loading 
disk and/or CPU during a RAID rebuild).

To force a resync, I manually removed, and then re-added /dev/sdd3 from 
md4, but during the resync, there appears to have been a bad sector on 
/dev/sdc3, and the rebuild stopped.  I then used mdadm to stop, and 
recreate md4, and afterwards, things seemed to go slightly haywire.

Here is the output of /proc/mdstat for the box now (also as it was then):

brie:/tmp/fah$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md1 : active raid1 sdb1[1] sda1[0]
      9775424 blocks [2/2] [UU]

md2 : active raid1 sdd1[1] sdc1[0]
      3911680 blocks [2/2] [UU]

md3 : active raid1 sdd2[1] sdc2[0]
      5863616 blocks [2/2] [UU]

md4 : active raid5 sdd3[3] sdc3[2] sdb3[1] sda3[0]
      703261248 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>



I'll paste in a portion of /var/log/kern.log with [annotations]..

Apr  5 13:14:18 brie kernel: raid5: Disk failure on sdd3, disabling 
device. Operation continuing on 3 devices

[this was manual with mdadm -f]

Apr  5 13:14:18 brie kernel: RAID5 conf printout:
Apr  5 13:14:18 brie kernel:  --- rd:4 wd:3 fd:1
Apr  5 13:14:18 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 13:14:18 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 13:14:18 brie kernel:  disk 2, o:1, dev:sdc3
Apr  5 13:14:18 brie kernel:  disk 3, o:0, dev:sdd3
Apr  5 13:14:18 brie kernel: RAID5 conf printout:
Apr  5 13:14:18 brie kernel:  --- rd:4 wd:3 fd:1
Apr  5 13:14:18 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 13:14:18 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 13:14:18 brie kernel:  disk 2, o:1, dev:sdc3
Apr  5 13:14:44 brie kernel: md: trying to remove sdd3 from md4 ...
Apr  5 13:14:44 brie kernel: md: unbind<sdd3>
Apr  5 13:14:44 brie kernel: md: export_rdev(sdd3)
Apr  5 13:15:05 brie kernel: md: trying to hot-add sdd3 to md4 ...
Apr  5 13:15:05 brie kernel: md: bind<sdd3>

[again remove / re-add with mdadm]

Apr  5 13:15:14 brie kernel: RAID5 conf printout:
Apr  5 13:15:14 brie kernel:  --- rd:4 wd:3 fd:1
Apr  5 13:15:14 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 13:15:14 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 13:15:14 brie kernel:  disk 2, o:1, dev:sdc3
Apr  5 13:15:14 brie kernel:  disk 3, o:1, dev:sdd3
Apr  5 13:15:14 brie kernel: md: syncing RAID array md4
Apr  5 13:15:14 brie kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Apr  5 13:15:14 brie kernel: md: using maximum available idle IO 
bandwith (but not more than 200000 KB/sec) for reconstruction.
Apr  5 13:15:14 brie kernel: md: using 128k window, over a total of 
234420416 blocks.
Apr  5 16:00:08 brie kernel: scsi2: ERROR on channel 0, id 0, lun 0, 
CDB: Read (10) 00 13 87 3a 89 00 00 c8 00
Apr  5 16:00:08 brie kernel: Current sdc: sense key Medium Error
Apr  5 16:00:08 brie kernel: Additional sense: Unrecovered read error - 
auto reallocate failed
Apr  5 16:00:08 brie kernel: end_request: I/O error, dev sdc, sector 
327629449

[/dev/sdc has a bad time during the rebuild - I've snipped some of these]

Apr  5 16:00:25 brie kernel: scsi2: ERROR on channel 0, id 0, lun 0, 
CDB: Read (10) 00 13 87 3a 9d 00 00 b4 00
Apr  5 16:00:25 brie kernel: Current sdc: sense key Medium Error
Apr  5 16:00:25 brie kernel: Additional sense: Unrecovered read error - 
auto reallocate failed
Apr  5 16:00:25 brie kernel: end_request: I/O error, dev sdc, sector 
327629469
Apr  5 16:00:26 brie kernel: scsi2: ERROR on channel 0, id 0, lun 0, 
CDB: Read (10) 00 13 87 3a 9e 00 00 b3 00
Apr  5 16:00:26 brie kernel: Current sdc: sense key Medium Error
Apr  5 16:00:26 brie kernel: Additional sense: Unrecovered read error - 
auto reallocate failed
Apr  5 16:00:26 brie kernel: end_request: I/O error, dev sdc, sector 
327629470
Apr  5 16:00:27 brie kernel: scsi2: ERROR on channel 0, id 0, lun 0, 
CDB: Read (10) 00 13 87 3a 9f 00 00 b2 00
Apr  5 16:00:27 brie kernel: Current sdc: sense key Medium Error
Apr  5 16:00:27 brie kernel: Additional sense: Unrecovered read error - 
auto reallocate failed
Apr  5 16:00:27 brie kernel: end_request: I/O error, dev sdc, sector 
327629471

[md seems to get confused now, and reports the sync is finished]

Apr  5 16:00:27 brie kernel: md: md4: sync done.
Apr  5 16:00:27 brie kernel: RAID5 conf printout:
Apr  5 16:00:27 brie kernel:  --- rd:4 wd:2 fd:2
Apr  5 16:00:27 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 16:00:27 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 16:00:27 brie kernel:  disk 2, o:0, dev:sdc3
Apr  5 16:00:27 brie kernel:  disk 3, o:1, dev:sdd3
Apr  5 16:00:27 brie kernel: RAID5 conf printout:
Apr  5 16:00:27 brie kernel:  --- rd:4 wd:2 fd:2
Apr  5 16:00:27 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 16:00:27 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 16:00:27 brie kernel:  disk 3, o:1, dev:sdd3
Apr  5 16:00:27 brie kernel: md: syncing RAID array md4
Apr  5 16:00:27 brie kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Apr  5 16:00:27 brie kernel: md: using maximum available idle IO 
bandwith (but not more than 2000000 KB/sec) for reconstruction.
Apr  5 16:00:27 brie kernel: md: using 128k window, over a total of 
234420416 blocks.
Apr  5 16:00:27 brie kernel: md: md4: sync done.
Apr  5 16:00:27 brie kernel: md: syncing RAID array md4
Apr  5 16:00:27 brie kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Apr  5 16:00:27 brie kernel: md: using maximum available idle IO 
bandwith (but not more than 2000000 KB/sec) for reconstruction.
Apr  5 16:00:27 brie kernel: md: using 128k window, over a total of 
234420416 blocks.
Apr  5 16:00:27 brie kernel: md: md4: sync done.
Apr  5 16:00:27 brie kernel: md: syncing RAID array md4

[snip]

Apr  5 17:02:25 brie kernel: md: syncing RAID array md4
Apr  5 17:02:25 brie kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Apr  5 17:02:25 brie kernel: md: using maximum available idle IO 
bandwith (but not more than 2000000 KB/sec) for reconstruction.
Apr  5 17:02:25 brie kernel: md: using 128k window, over a total of 
234420416 blocks.
Apr  5 17:02:25 brie kernel: md: md4: sync done.
Apr  5 17:02:25 brie kernel: md: syncing RAID array md4
Apr  5 17:02:25 brie kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Apr  5 17:02:25 brie kernel: md: using maximum available idle IO 
bandwith (but not more than 2000000 KB/sec) for reconstruction.
Apr  5 17:02:25 brie kernel: md: using 128k window, over a total of 
234420416 blocks.
Apr  5 17:02:25 brie kernel: md: md4: sync done.
Apr  5 17:02:25 brie kernel: md: syncing RAID array md4
Apr  5 17:02:25 brie kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Apr  5 17:02:25 brie kernel: md: using maximum available idle IO 
bandwith (but not more than 2000000 KB/sec) for reconstruction.
Apr  5 17:02:25 brie kernel: md: using 128k window, over a total of 
234420416 blocks.
Apr  5 17:02:25 brie kernel: md: md4: sync done.

[ There seem to have been approx 120 of these messages per second - for 
this hour, until I manually stop the array using mdadm.  At this point I 
try to restart the array, before giving up, and recreating it.  The 
resync then appeared to go OK, and I've just done a read check on 
/dev/sdc with no errors, so I suppose the drive had a temporary hiccup.]


Apr  5 17:02:25 brie kernel: md: md4 stopped.
Apr  5 17:02:25 brie kernel: md: unbind<sdc3>
Apr  5 17:02:25 brie kernel: md: export_rdev(sdc3)
Apr  5 17:02:25 brie kernel: md: unbind<sdd3>
Apr  5 17:02:25 brie kernel: md: export_rdev(sdd3)
Apr  5 17:02:25 brie kernel: md: unbind<sdb3>
Apr  5 17:02:25 brie kernel: md: export_rdev(sdb3)
Apr  5 17:02:25 brie kernel: md: unbind<sda3>
Apr  5 17:02:25 brie kernel: md: export_rdev(sda3)
Apr  5 17:02:27 brie kernel: md: md4 stopped.
Apr  5 17:02:35 brie kernel: md: bug in file drivers/md/md.c, line 1512
Apr  5 17:02:35 brie kernel:
Apr  5 17:02:35 brie kernel: md:^I**********************************
Apr  5 17:02:35 brie kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Apr  5 17:02:35 brie kernel: md:^I**********************************
Apr  5 17:02:35 brie kernel: md1: <sdb1><sda1>
Apr  5 17:02:35 brie kernel: md: rdev sdb1, SZ:09775424 F:0 S:1 DN:1
Apr  5 17:02:35 brie kernel: md: rdev superblock:
Apr  5 17:02:35 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:02:35 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:02:35 brie kernel: md:     UT:40719127 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577957 E:00004f2a
Apr  5 17:02:35 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:02:35 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:02:35 brie kernel: md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:02:35 brie kernel: md: rdev sda1, SZ:09775424 F:0 S:1 DN:0
Apr  5 17:02:35 brie kernel: md: rdev superblock:
Apr  5 17:02:35 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:02:35 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:02:35 brie kernel: md:     UT:40719127 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577945 E:00004f2a
Apr  5 17:02:35 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:02:35 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:02:35 brie kernel: md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:02:35 brie kernel: md2: <sdd1><sdc1>
Apr  5 17:02:35 brie kernel: md: rdev sdd1, SZ:03911680 F:0 S:1 DN:1
Apr  5 17:02:35 brie kernel: md: rdev superblock:
Apr  5 17:02:35 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:02:35 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:02:35 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10f8 E:00000004
Apr  5 17:02:35 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:02:35 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:02:35 brie kernel: md:     THIS:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:02:35 brie kernel: md: rdev sdc1, SZ:03911680 F:0 S:1 DN:0
Apr  5 17:02:35 brie kernel: md: rdev superblock:
Apr  5 17:02:35 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:02:35 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:02:35 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10e6 E:00000004
Apr  5 17:02:35 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:02:35 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:02:35 brie kernel: md:     THIS:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:02:35 brie kernel: md3: <sdd2><sdc2>
Apr  5 17:02:35 brie kernel: md: rdev sdd2, SZ:05863616 F:0 S:1 DN:1
Apr  5 17:02:35 brie kernel: md: rdev superblock:
Apr  5 17:02:35 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:02:35 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:02:35 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961c7 E:0000001c
Apr  5 17:02:35 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:02:35 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:02:35 brie kernel: md:     THIS:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:02:35 brie kernel: md: rdev sdc2, SZ:05863616 F:0 S:1 DN:0
Apr  5 17:02:35 brie kernel: md: rdev superblock:
Apr  5 17:02:35 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:02:35 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:02:35 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961b5 E:0000001c
Apr  5 17:02:35 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:02:35 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:02:35 brie kernel: md:     THIS:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:02:35 brie kernel: md4:
Apr  5 17:02:35 brie kernel: md0:
Apr  5 17:02:35 brie kernel: md:^I**********************************
Apr  5 17:02:35 brie kernel:
Apr  5 17:09:08 brie kernel: md: bug in file drivers/md/md.c, line 1512
Apr  5 17:09:08 brie kernel:
Apr  5 17:09:08 brie kernel: md:^I**********************************
Apr  5 17:09:08 brie kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Apr  5 17:09:08 brie kernel: md:^I**********************************
Apr  5 17:09:08 brie kernel: md1: <sdb1><sda1>
Apr  5 17:09:08 brie kernel: md: rdev sdb1, SZ:09775424 F:0 S:1 DN:1
Apr  5 17:09:08 brie kernel: md: rdev superblock:
Apr  5 17:09:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:09:08 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:09:08 brie kernel: md:     UT:407192ae ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577b3e E:00004f5a
Apr  5 17:09:08 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:09:08 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:09:08 brie kernel: md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:09:08 brie kernel: md: rdev sda1, SZ:09775424 F:0 S:1 DN:0
Apr  5 17:09:08 brie kernel: md: rdev superblock:
Apr  5 17:09:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:09:08 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:09:08 brie kernel: md:     UT:407192ae ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577b2c E:00004f5a
Apr  5 17:09:08 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:09:08 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:09:08 brie kernel: md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:09:08 brie kernel: md2: <sdd1><sdc1>
Apr  5 17:09:08 brie kernel: md: rdev sdd1, SZ:03911680 F:0 S:1 DN:1
Apr  5 17:09:08 brie kernel: md: rdev superblock:
Apr  5 17:09:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:09:08 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:09:08 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10f8 E:00000004
Apr  5 17:09:08 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:09:08 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:09:08 brie kernel: md:     THIS:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:09:08 brie kernel: md: rdev sdc1, SZ:03911680 F:0 S:1 DN:0
Apr  5 17:09:08 brie kernel: md: rdev superblock:
Apr  5 17:09:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:09:08 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:09:08 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10e6 E:00000004
Apr  5 17:09:08 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:09:08 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:09:08 brie kernel: md:     THIS:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:09:08 brie kernel: md3: <sdd2><sdc2>
Apr  5 17:09:08 brie kernel: md: rdev sdd2, SZ:05863616 F:0 S:1 DN:1
Apr  5 17:09:08 brie kernel: md: rdev superblock:
Apr  5 17:09:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:09:08 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:09:08 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961c7 E:0000001c
Apr  5 17:09:08 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:09:08 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:09:08 brie kernel: md:     THIS:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:09:08 brie kernel: md: rdev sdc2, SZ:05863616 F:0 S:1 DN:0
Apr  5 17:09:08 brie kernel: md: rdev superblock:
Apr  5 17:09:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:09:08 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:09:08 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961b5 E:0000001c
Apr  5 17:09:08 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:09:08 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:09:08 brie kernel: md:     THIS:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:09:08 brie kernel: md4:
Apr  5 17:09:08 brie kernel: md0:
Apr  5 17:09:08 brie kernel: md:^I**********************************
Apr  5 17:09:08 brie kernel:
Apr  5 17:11:08 brie kernel: md: bug in file drivers/md/md.c, line 1512
Apr  5 17:11:08 brie kernel:
Apr  5 17:11:08 brie kernel: md:^I**********************************
Apr  5 17:11:08 brie kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Apr  5 17:11:08 brie kernel: md:^I**********************************
Apr  5 17:11:08 brie kernel: md1: <sdb1><sda1>
Apr  5 17:11:08 brie kernel: md: rdev sdb1, SZ:09775424 F:0 S:1 DN:1
Apr  5 17:11:08 brie kernel: md: rdev superblock:
Apr  5 17:11:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:11:08 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:11:08 brie kernel: md:     UT:40719324 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577bd0 E:00004f68
Apr  5 17:11:08 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:11:08 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:11:08 brie kernel: md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:11:08 brie kernel: md: rdev sda1, SZ:09775424 F:0 S:1 DN:0
Apr  5 17:11:08 brie kernel: md: rdev superblock:
Apr  5 17:11:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:11:08 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:11:08 brie kernel: md:     UT:40719324 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577bbe E:00004f68
Apr  5 17:11:08 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:11:08 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:11:08 brie kernel: md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:11:08 brie kernel: md2: <sdd1><sdc1>
Apr  5 17:11:08 brie kernel: md: rdev sdd1, SZ:03911680 F:0 S:1 DN:1
Apr  5 17:11:08 brie kernel: md: rdev superblock:
Apr  5 17:11:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:11:08 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:11:08 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10f8 E:00000004
Apr  5 17:11:08 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:11:08 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:11:08 brie kernel: md:     THIS:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:11:08 brie kernel: md: rdev sdc1, SZ:03911680 F:0 S:1 DN:0
Apr  5 17:11:08 brie kernel: md: rdev superblock:
Apr  5 17:11:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:11:08 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:11:08 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10e6 E:00000004
Apr  5 17:11:08 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:11:08 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:11:08 brie kernel: md:     THIS:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:11:08 brie kernel: md3: <sdd2><sdc2>
Apr  5 17:11:08 brie kernel: md: rdev sdd2, SZ:05863616 F:0 S:1 DN:1
Apr  5 17:11:08 brie kernel: md: rdev superblock:
Apr  5 17:11:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:11:08 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:11:08 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961c7 E:0000001c
Apr  5 17:11:08 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:11:08 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:11:08 brie kernel: md:     THIS:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:11:08 brie kernel: md: rdev sdc2, SZ:05863616 F:0 S:1 DN:0
Apr  5 17:11:08 brie kernel: md: rdev superblock:
Apr  5 17:11:08 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:11:08 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:11:08 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961b5 E:0000001c
Apr  5 17:11:08 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:11:08 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:11:08 brie kernel: md:     THIS:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:11:08 brie kernel: md4:
Apr  5 17:11:08 brie kernel: md0:
Apr  5 17:11:08 brie kernel: md:^I**********************************
Apr  5 17:11:08 brie kernel:
Apr  5 17:11:26 brie kernel: md: bug in file drivers/md/md.c, line 1512
Apr  5 17:11:26 brie kernel:
Apr  5 17:11:26 brie kernel: md:^I**********************************
Apr  5 17:11:26 brie kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Apr  5 17:11:26 brie kernel: md:^I**********************************
Apr  5 17:11:26 brie kernel: md1: <sdb1><sda1>
Apr  5 17:11:26 brie kernel: md: rdev sdb1, SZ:09775424 F:0 S:1 DN:1
Apr  5 17:11:26 brie kernel: md: rdev superblock:
Apr  5 17:11:26 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:11:26 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:11:26 brie kernel: md:     UT:40719331 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577be1 E:00004f6a
Apr  5 17:11:26 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:11:26 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:11:26 brie kernel: md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:11:26 brie kernel: md: rdev sda1, SZ:09775424 F:0 S:1 DN:0
Apr  5 17:11:26 brie kernel: md: rdev superblock:
Apr  5 17:11:26 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:11:26 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:11:26 brie kernel: md:     UT:40719331 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577bcf E:00004f6a
Apr  5 17:11:26 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:11:26 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:11:26 brie kernel: md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:11:26 brie kernel: md2: <sdd1><sdc1>
Apr  5 17:11:26 brie kernel: md: rdev sdd1, SZ:03911680 F:0 S:1 DN:1
Apr  5 17:11:26 brie kernel: md: rdev superblock:
Apr  5 17:11:26 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:11:26 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:11:26 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10f8 E:00000004
Apr  5 17:11:26 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:11:26 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:11:26 brie kernel: md:     THIS:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:11:26 brie kernel: md: rdev sdc1, SZ:03911680 F:0 S:1 DN:0
Apr  5 17:11:26 brie kernel: md: rdev superblock:
Apr  5 17:11:26 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:11:26 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:11:26 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10e6 E:00000004
Apr  5 17:11:26 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:11:26 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:11:26 brie kernel: md:     THIS:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:11:26 brie kernel: md3: <sdd2><sdc2>
Apr  5 17:11:26 brie kernel: md: rdev sdd2, SZ:05863616 F:0 S:1 DN:1
Apr  5 17:11:26 brie kernel: md: rdev superblock:
Apr  5 17:11:26 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:11:26 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:11:26 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961c7 E:0000001c
Apr  5 17:11:26 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:11:26 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:11:26 brie kernel: md:     THIS:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:11:26 brie kernel: md: rdev sdc2, SZ:05863616 F:0 S:1 DN:0
Apr  5 17:11:26 brie kernel: md: rdev superblock:
Apr  5 17:11:26 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:11:26 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:11:26 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961b5 E:0000001c
Apr  5 17:11:26 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:11:26 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:11:26 brie kernel: md:     THIS:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:11:26 brie kernel: md4:
Apr  5 17:11:26 brie kernel: md0:
Apr  5 17:11:26 brie kernel: md:^I**********************************
Apr  5 17:11:26 brie kernel:
Apr  5 17:12:36 brie kernel: md: bug in file drivers/md/md.c, line 1512
Apr  5 17:12:36 brie kernel:
Apr  5 17:12:36 brie kernel: md:^I**********************************
Apr  5 17:12:36 brie kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Apr  5 17:12:36 brie kernel: md:^I**********************************
Apr  5 17:12:36 brie kernel: md1: <sdb1><sda1>
Apr  5 17:12:36 brie kernel: md: rdev sdb1, SZ:09775424 F:0 S:1 DN:1
Apr  5 17:12:36 brie kernel: md: rdev superblock:
Apr  5 17:12:36 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:12:36 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:12:36 brie kernel: md:     UT:4071937f ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577c4f E:00004f7a
Apr  5 17:12:36 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:12:36 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:12:36 brie kernel: md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:12:36 brie kernel: md: rdev sda1, SZ:09775424 F:0 S:1 DN:0
Apr  5 17:12:36 brie kernel: md: rdev superblock:
Apr  5 17:12:36 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:12:36 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:12:36 brie kernel: md:     UT:4071937f ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577c3d E:00004f7a
Apr  5 17:12:36 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:12:36 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:12:36 brie kernel: md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:12:36 brie kernel: md2: <sdd1><sdc1>
Apr  5 17:12:36 brie kernel: md: rdev sdd1, SZ:03911680 F:0 S:1 DN:1
Apr  5 17:12:36 brie kernel: md: rdev superblock:
Apr  5 17:12:36 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:12:36 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:12:36 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10f8 E:00000004
Apr  5 17:12:36 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:12:36 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:12:36 brie kernel: md:     THIS:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:12:36 brie kernel: md: rdev sdc1, SZ:03911680 F:0 S:1 DN:0
Apr  5 17:12:36 brie kernel: md: rdev superblock:
Apr  5 17:12:36 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:12:36 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:12:36 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10e6 E:00000004
Apr  5 17:12:36 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:12:36 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:12:36 brie kernel: md:     THIS:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:12:36 brie kernel: md3: <sdd2><sdc2>
Apr  5 17:12:36 brie kernel: md: rdev sdd2, SZ:05863616 F:0 S:1 DN:1
Apr  5 17:12:36 brie kernel: md: rdev superblock:
Apr  5 17:12:36 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:12:36 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:12:36 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961c7 E:0000001c
Apr  5 17:12:36 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:12:36 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:12:36 brie kernel: md:     THIS:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:12:36 brie kernel: md: rdev sdc2, SZ:05863616 F:0 S:1 DN:0
Apr  5 17:12:36 brie kernel: md: rdev superblock:
Apr  5 17:12:36 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:12:36 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:12:36 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961b5 E:0000001c
Apr  5 17:12:36 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:12:36 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:12:36 brie kernel: md:     THIS:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:12:36 brie kernel: md4:
Apr  5 17:12:36 brie kernel: md0:
Apr  5 17:12:36 brie kernel: md:^I**********************************
Apr  5 17:12:36 brie kernel:
Apr  5 17:12:40 brie kernel: md: bug in file drivers/md/md.c, line 1512
Apr  5 17:12:40 brie kernel:
Apr  5 17:12:40 brie kernel: md:^I**********************************
Apr  5 17:12:40 brie kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
Apr  5 17:12:40 brie kernel: md:^I**********************************
Apr  5 17:12:40 brie kernel: md1: <sdb1><sda1>
Apr  5 17:12:40 brie kernel: md: rdev sdb1, SZ:09775424 F:0 S:1 DN:1
Apr  5 17:12:40 brie kernel: md: rdev superblock:
Apr  5 17:12:40 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:12:40 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:12:40 brie kernel: md:     UT:40719385 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577c59 E:00004f7c
Apr  5 17:12:40 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:12:40 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:12:40 brie kernel: md:     THIS:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:12:40 brie kernel: md: rdev sda1, SZ:09775424 F:0 S:1 DN:0
Apr  5 17:12:40 brie kernel: md: rdev superblock:
Apr  5 17:12:40 brie kernel: md:  SB: (V:0.90.0) 
ID:<d44327a8.dbd5990a.fb968f13.d1097520> CT:406c0c01
Apr  5 17:12:40 brie kernel: md:     L1 S09775424 ND:2 RD:2 md1 LO:0 CS:0
Apr  5 17:12:40 brie kernel: md:     UT:40719385 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:a7577c47 E:00004f7c
Apr  5 17:12:40 brie kernel:      D  0:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:12:40 brie kernel:      D  1:  DISK<N:1,sdb1(8,17),R:1,S:6>
Apr  5 17:12:40 brie kernel: md:     THIS:  DISK<N:0,sda1(8,1),R:0,S:6>
Apr  5 17:12:40 brie kernel: md2: <sdd1><sdc1>
Apr  5 17:12:40 brie kernel: md: rdev sdd1, SZ:03911680 F:0 S:1 DN:1
Apr  5 17:12:40 brie kernel: md: rdev superblock:
Apr  5 17:12:40 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:12:40 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:12:40 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10f8 E:00000004
Apr  5 17:12:40 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:12:40 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:12:40 brie kernel: md:     THIS:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:12:40 brie kernel: md: rdev sdc1, SZ:03911680 F:0 S:1 DN:0
Apr  5 17:12:40 brie kernel: md: rdev superblock:
Apr  5 17:12:40 brie kernel: md:  SB: (V:0.90.0) 
ID:<98852297.946558cf.d04920f4.5eb95580> CT:406c0c11
Apr  5 17:12:40 brie kernel: md:     L1 S03911680 ND:2 RD:2 md2 LO:0 CS:0
Apr  5 17:12:40 brie kernel: md:     UT:406c12ef ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:862c10e6 E:00000004
Apr  5 17:12:40 brie kernel:      D  0:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:12:40 brie kernel:      D  1:  DISK<N:1,sdd1(8,49),R:1,S:6>
Apr  5 17:12:40 brie kernel: md:     THIS:  DISK<N:0,sdc1(8,33),R:0,S:6>
Apr  5 17:12:40 brie kernel: md3: <sdd2><sdc2>
Apr  5 17:12:40 brie kernel: md: rdev sdd2, SZ:05863616 F:0 S:1 DN:1
Apr  5 17:12:40 brie kernel: md: rdev superblock:
Apr  5 17:12:40 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:12:40 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:12:40 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961c7 E:0000001c
Apr  5 17:12:40 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:12:40 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:12:40 brie kernel: md:     THIS:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:12:40 brie kernel: md: rdev sdc2, SZ:05863616 F:0 S:1 DN:0
Apr  5 17:12:40 brie kernel: md: rdev superblock:
Apr  5 17:12:40 brie kernel: md:  SB: (V:0.90.0) 
ID:<4267cdb1.4748249d.d90dd073.5cad47e6> CT:406c0c1d
Apr  5 17:12:40 brie kernel: md:     L1 S05863616 ND:2 RD:2 md3 LO:0 CS:0
Apr  5 17:12:40 brie kernel: md:     UT:406d81f2 ST:1 AD:2 WD:2 FD:0 
SD:0 CSUM:e9c961b5 E:0000001c
Apr  5 17:12:40 brie kernel:      D  0:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:12:40 brie kernel:      D  1:  DISK<N:1,sdd2(8,50),R:1,S:6>
Apr  5 17:12:40 brie kernel: md:     THIS:  DISK<N:0,sdc2(8,34),R:0,S:6>
Apr  5 17:12:40 brie kernel: md4:
Apr  5 17:12:40 brie kernel: md0:
Apr  5 17:12:40 brie kernel: md:^I**********************************
Apr  5 17:12:40 brie kernel:
Apr  5 17:13:22 brie kernel: md: bind<sda3>
Apr  5 17:13:22 brie kernel: md: bind<sdb3>
Apr  5 17:13:22 brie kernel: md: bind<sdc3>
Apr  5 17:13:22 brie kernel: md: bind<sdd3>
Apr  5 17:13:22 brie kernel: raid5: device sdc3 operational as raid disk 2
Apr  5 17:13:22 brie kernel: raid5: device sdb3 operational as raid disk 1
Apr  5 17:13:22 brie kernel: raid5: device sda3 operational as raid disk 0
Apr  5 17:13:22 brie kernel: raid5: allocated 4250kB for md4
Apr  5 17:13:22 brie kernel: raid5: raid level 5 set md4 active with 3 
out of 4 devices, algorithm 2
Apr  5 17:13:22 brie kernel: RAID5 conf printout:
Apr  5 17:13:22 brie kernel:  --- rd:4 wd:3 fd:1
Apr  5 17:13:22 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 17:13:22 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 17:13:22 brie kernel:  disk 2, o:1, dev:sdc3
Apr  5 17:13:22 brie kernel: RAID5 conf printout:
Apr  5 17:13:22 brie kernel:  --- rd:4 wd:3 fd:1
Apr  5 17:13:22 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 17:13:22 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 17:13:22 brie kernel:  disk 2, o:1, dev:sdc3
Apr  5 17:13:22 brie kernel:  disk 3, o:1, dev:sdd3
Apr  5 17:13:22 brie kernel: md: syncing RAID array md4
Apr  5 17:13:22 brie kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Apr  5 17:13:22 brie kernel: md: using maximum available idle IO 
bandwith (but not more than 2000000 KB/sec) for reconstruction.
Apr  5 17:13:22 brie kernel: md: using 128k window, over a total of 
234420416 blocks.
Apr  5 17:13:35 brie kernel: (fs/jbd/recovery.c, 255): journal_recover: 
JBD: recovery, exit status 0, recovered transactions 2080 to 2581
Apr  5 17:13:35 brie kernel: (fs/jbd/recovery.c, 257): journal_recover: 
JBD: Replayed 1699 and revoked 566/567 blocks
Apr  5 17:13:42 brie kernel: kjournald starting.  Commit interval 5 seconds
Apr  5 17:13:42 brie kernel: EXT3 FS on md4, internal journal
Apr  5 17:13:42 brie kernel: EXT3-fs: recovery complete.
Apr  5 17:13:42 brie kernel: EXT3-fs: mounted filesystem with ordered 
data mode.
Apr  5 17:36:06 brie kernel: kjournald starting.  Commit interval 5 seconds
Apr  5 17:36:06 brie kernel: EXT3 FS on md4, internal journal
Apr  5 17:36:06 brie kernel: EXT3-fs: mounted filesystem with ordered 
data mode.
Apr  5 18:09:48 brie kernel: device eth1 entered promiscuous mode
Apr  5 18:09:48 brie kernel: device eth1 left promiscuous mode
Apr  5 18:09:52 brie kernel: device eth1 entered promiscuous mode
Apr  5 18:11:02 brie kernel: device eth1 left promiscuous mode
Apr  5 18:22:36 brie kernel: device eth1 entered promiscuous mode
Apr  5 18:23:47 brie kernel: device eth1 left promiscuous mode
Apr  5 18:23:50 brie kernel: device eth1 entered promiscuous mode
Apr  5 18:24:08 brie kernel: device eth1 left promiscuous mode
Apr  5 18:24:10 brie kernel: device eth1 entered promiscuous mode
Apr  5 18:24:30 brie kernel: device eth1 left promiscuous mode
Apr  5 21:16:54 brie kernel: md: md4: sync done.
Apr  5 21:16:54 brie kernel: RAID5 conf printout:
Apr  5 21:16:54 brie kernel:  --- rd:4 wd:4 fd:0
Apr  5 21:16:54 brie kernel:  disk 0, o:1, dev:sda3
Apr  5 21:16:54 brie kernel:  disk 1, o:1, dev:sdb3
Apr  5 21:16:54 brie kernel:  disk 2, o:1, dev:sdc3
Apr  5 21:16:54 brie kernel:  disk 3, o:1, dev:sdd3

