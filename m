From: Nicolas Meaux <nicolas.meaux@artabel.net>
Subject: Re: inactive raid scsi disks
Date: Mon, 29 Dec 2003 13:07:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF01911.5080809@artabel.net>
References: <3FEFFE2B.70206@artabel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FEFFE2B.70206@artabel.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have read in the FAQ of software RAID that i could make  : mkraid 
--force on my RAID partition. I have not changed /etc/raidtab since the 
problem occured but i am afraid to lose totally my RAID partition.

Thanks in advance.

PS : I have made backup on my partition 1 week ago, but according to the 
murphy's law my tape reader  died a few days ago ... :-(


Nicolas Meaux wrote:

> Hi,
>
> I have problems on my RAID 5 system, since a scsi problem occurred, 
> the disks have gone faulty one by one, and i dont know how recover the 
> RAID.
>
> Here are the logs :
> kernel: SCSI disk error : host 1 channel 0 id 5 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:50, sector 779528
> kernel: raid5: Disk failure on sdf, disabling device. Operation 
> continuing on 5 devices
> kernel: md: recovery thread got woken up ...
> kernel: md2: resyncing spare disk sdd to replace failed disk
> kernel: md: updating md2 RAID superblock on device
> kernel: md: sdd [events: 00000062]<6>(write) sdd's sb offset: 35843584
> kernel: RAID5 conf printout:
> kernel:  --- rd:6 wd:5 fd:1
> kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdh
> kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb
> kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc
> kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdg
> kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde
> kernel:  disk 5, s:0, o:0, n:5 rd:5 us:1 dev:sdf
> kernel: RAID5 conf printout:
> kernel:  --- rd:6 wd:5 fd:1
> kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdh
> kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb
> kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc
> kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdg
> kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde
> kernel:  disk 5, s:0, o:0, n:5 rd:5 us:1 dev:sdf
> kernel: md: syncing RAID array md2
> kernel: md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
> kernel: md: using maximum available idle IO bandwith (but not more 
> than 100000 KB/sec) for reconstruction.
> kernel: md: using 124k window, over a total of 35843584 blocks.
> kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:20, sector 779528
> kernel: raid5: Disk failure on sdc, disabling device. Operation 
> continuing on 4 devices
> kernel: SCSI disk error : host 1 channel 0 id 4 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:40, sector 19008320
> kernel: raid5: Disk failure on sde, disabling device. Operation 
> continuing on 3 devices
> kernel: SCSI disk error : host 1 channel 0 id 7 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:70, sector 19008320
> kernel: raid5: Disk failure on sdh, disabling device. Operation 
> continuing on 2 devices
> kernel: SCSI disk error : host 1 channel 0 id 3 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:30, sector 71687168
> kernel: md: write_disk_sb failed for device sdd
> kernel: md: (skipping faulty sdf )
> kernel: md: (skipping faulty sde )
> kernel: md: sdg [events: 00000062]<6>(write) sdg's sb offset: 35843584
> kernel: SCSI disk error : host 1 channel 0 id 6 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:60, sector 0
> kernel: raid5: Disk failure on sdg, disabling device. Operation 
> continuing on 1 devices
> kernel: SCSI disk error : host 1 channel 0 id 1 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:10, sector 8
> kernel: raid5: Disk failure on sdb, disabling device. Operation 
> continuing on 0 devices
> kernel: SCSI disk error : host 1 channel 0 id 2 lun 0 return code = 100ff
> kernel:  I/O error: dev 08:20, sector 0
> [...]
>
>
>
>
>
> I try to use mdadm ( 1.3.0-2 ) :
> # mdadm -A /dev/md2 /dev/sd[a-h]
> mdadm: /dev/md2 assembled from 1 drive - not enough to start the array.
>
> syslog :
> kernel:  [events: 00000061]
> kernel: md: bind<sda,1>
>
> /proc/mdstat :
> cat /proc/mdstat
> Personalities : [raid1] [raid5] [multipath]
> read_ahead 1024 sectors
> md2 : inactive sda[0]
>      0 blocks
>
> I also try mdadm (1.3.0 ), whit patch 001*, 002*, 003*, 004*.
> But same result.
>
>
>
> When i try raidstart :
> # raidstart /dev/md2
>
> syslog :
> kernel:  [events: 00000061]
> last message repeated 7 times
> kernel: md: autorun ...
> kernel: md: considering sdd ...
> kernel: md:  adding sdd ...
> kernel: md:  adding sdf ...
> kernel: md:  adding sde ...
> kernel: md:  adding sdg ...
> kernel: md:  adding sdc ...
> kernel: md:  adding sdb ...
> kernel: md:  adding sdh ...
> kernel: md:  adding sda ...
> kernel: md: created md2
> kernel: md: bind<sda,1>
> kernel: md: bind<sdh,2>
> kernel: md: bind<sdb,3>
> kernel: md: bind<sdc,4>
> kernel: md: bind<sdg,5>
> kernel: md: bind<sde,6>
> kernel: md: bind<sdf,7>
> kernel: md: bind<sdd,8>
> kernel: md: running: <sdd><sdf><sde><sdg><sdc><sdb><sdh><sda>
> kernel: md: sdd's event counter: 00000061
> kernel: md: sdf's event counter: 00000061
> kernel: md: sde's event counter: 00000061
> kernel: md: sdg's event counter: 00000061
> kernel: md: sdc's event counter: 00000061
> kernel: md: sdb's event counter: 00000061
> kernel: md: sdh's event counter: 00000061
> kernel: md: sda's event counter: 00000061
> kernel: md: device name has changed from sdh to sdd since last import!
> kernel: md: device name has changed from sdh to sdf since last import!
> kernel: md: bug in file md.c, line 1322
> kernel:
> kernel: md:^I**********************************
> kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
> kernel: md:^I**********************************
> kernel: md2: <sdd><sdf><sde><sdg><sdc><sdb><sdh><sda> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdd(8,48),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdd: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdd(8,48),R:0,S:6>
> kernel: md: rdev sdf: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sde: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdg: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdc: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdb: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdh: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sda: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md0: <hdc1><hda1> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<955383e0.86370e4f.39aa46a0.bf2bc4b8> 
> CT:3e8ae9e1
> kernel: md:     L1 S00015936 ND:2 RD:2 md0 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:3bfee687 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md: rdev hdc1: O:hdc1, SZ:00015936 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<955383e0.86370e4f.39aa46a0.bf2bc4b8> 
> CT:3e8ae9e1
> kernel: md:     L1 S00015936 ND:2 RD:2 md0 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:3bfee72e 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md: rdev hda1: O:hda1, SZ:00015936 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<955383e0.86370e4f.39aa46a0.bf2bc4b8> 
> CT:3e8ae9e1
> kernel: md:     L1 S00015936 ND:2 RD:2 md0 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:3bfee719 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel: md1: <hdc3><hda3> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<43c53ab2.79834067.c68d59a1.12a648f5> 
> CT:3e8aea06
> kernel: md:     L1 S00289088 ND:2 RD:2 md1 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:be1e91de 
> E:0000008d
> kernel:      D  0:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md: rdev hdc3: O:hdc3, SZ:00289088 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<43c53ab2.79834067.c68d59a1.12a648f5> 
> CT:3e8aea06
> kernel: md:     L1 S00289088 ND:2 RD:2 md1 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:be1e9283 
> E:0000008d
> kernel:      D  0:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md: rdev hda3: O:hda3, SZ:00289088 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<43c53ab2.79834067.c68d59a1.12a648f5> 
> CT:3e8aea06
> kernel: md:     L1 S00289088 ND:2 RD:2 md1 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:be1e926e 
> E:0000008d
> kernel:      D  0:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel: md3: <hdc5><hda5> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<e6d7be90.c0ce992f.fc8a803d.b445b026> 
> CT:3e8aea3c
> kernel: md:     L1 S00489856 ND:2 RD:2 md3 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:801c0ccd 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md: rdev hdc5: O:hdc5, SZ:00489856 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<e6d7be90.c0ce992f.fc8a803d.b445b026> 
> CT:3e8aea3c
> kernel: md:     L1 S00489856 ND:2 RD:2 md3 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:801c0d74 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md: rdev hda5: O:hda5, SZ:00489856 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<e6d7be90.c0ce992f.fc8a803d.b445b026> 
> CT:3e8aea3c
> kernel: md:     L1 S00489856 ND:2 RD:2 md3 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:801c0d5f 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel: md4: <hdc6><hda6> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<028810ac.bf418da6.91d5bf36.cfe39e04> 
> CT:3e8aea5f
> kernel: md:     L1 S03903680 ND:2 RD:2 md4 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:4b5c979c 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md: rdev hdc6: O:hdc6, SZ:03903680 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<028810ac.bf418da6.91d5bf36.cfe39e04> 
> CT:3e8aea5f
> kernel: md:     L1 S03903680 ND:2 RD:2 md4 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:4b5c9844 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md: rdev hda6: O:hda6, SZ:03903680 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<028810ac.bf418da6.91d5bf36.cfe39e04> 
> CT:3e8aea5f
> kernel: md:     L1 S03903680 ND:2 RD:2 md4 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:4b5c982f 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel: md5: <hdc7><hda7> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<9a62d1da.9602dd4d.2ebc91c0.880cd430> 
> CT:3e8aea86
> kernel: md:     L1 S02931712 ND:2 RD:2 md5 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:0ef9dc91 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md: rdev hdc7: O:hdc7, SZ:02931712 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<9a62d1da.9602dd4d.2ebc91c0.880cd430> 
> CT:3e8aea86
> kernel: md:     L1 S02931712 ND:2 RD:2 md5 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:0ef9dd38 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md: rdev hda7: O:hda7, SZ:02931712 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<9a62d1da.9602dd4d.2ebc91c0.880cd430> 
> CT:3e8aea86
> kernel: md:     L1 S02931712 ND:2 RD:2 md5 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:0ef9dd23 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel: md6: <hdc8><hda8> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<093d0114.2fd6d7b5.0743e000.c0f34135> 
> CT:3e8aeaa7
> kernel: md:     L1 S00979840 ND:2 RD:2 md6 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:28f7f91c 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md: rdev hdc8: O:hdc8, SZ:00979840 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<093d0114.2fd6d7b5.0743e000.c0f34135> 
> CT:3e8aeaa7
> kernel: md:     L1 S00979840 ND:2 RD:2 md6 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:28f7f9c3 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md: rdev hda8: O:hda8, SZ:00979840 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<093d0114.2fd6d7b5.0743e000.c0f34135> 
> CT:3e8aeaa7
> kernel: md:     L1 S00979840 ND:2 RD:2 md6 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:28f7f9ae 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel: md:^I**********************************
> kernel:
> kernel: md: bug in file md.c, line 1650
> kernel:
> kernel: md:^I**********************************
> kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
> kernel: md:^I**********************************
> kernel: md2: <sdd><sdf><sde><sdg><sdc><sdb><sdh><sda> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdd(8,48),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdd: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdd(8,48),R:0,S:6>
> kernel: md: rdev sdf: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sde: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdg: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdc: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdb: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sdh: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md: rdev sda: O:sdh, SZ:00000000 F:0 DN:0 <6>md: rdev superblock:
> kernel: md:  SB: (V:0.90.0) ID:<0b4aca71.e3c89c0a.e5cbd25a.22233366> 
> CT:3eeee171
> kernel: md:     L5 S35843584 ND:8 RD:6 md2 LO:2 CS:32768
> kernel: md:     UT:3fe01011 ST:0 AD:6 WD:8 FD:0 SD:2 CSUM:21201ed9 
> E:00000061
> kernel:      D  0:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel:      D  1:  DISK<N:1,sdb(8,16),R:1,S:6>
> kernel:      D  2:  DISK<N:2,sdc(8,32),R:2,S:6>
> kernel:      D  3:  DISK<N:3,sdg(8,96),R:3,S:6>
> kernel:      D  4:  DISK<N:4,sde(8,64),R:4,S:6>
> kernel:      D  5:  DISK<N:5,sdf(8,80),R:5,S:6>
> kernel:      D  6:  DISK<N:6,sdd(8,48),R:6,S:0>
> kernel:      D  7:  DISK<N:7,sda(8,0),R:7,S:0>
> kernel:      D  8:  DISK<N:8,[dev 00:00](0,0),R:8,S:9>
> kernel: md:     THIS:  DISK<N:0,sdh(8,112),R:0,S:6>
> kernel: md0: <hdc1><hda1> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<955383e0.86370e4f.39aa46a0.bf2bc4b8> 
> CT:3e8ae9e1
> kernel: md:     L1 S00015936 ND:2 RD:2 md0 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:3bfee687 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md: rdev hdc1: O:hdc1, SZ:00015936 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<955383e0.86370e4f.39aa46a0.bf2bc4b8> 
> CT:3e8ae9e1
> kernel: md:     L1 S00015936 ND:2 RD:2 md0 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:3bfee72e 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md: rdev hda1: O:hda1, SZ:00015936 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<955383e0.86370e4f.39aa46a0.bf2bc4b8> 
> CT:3e8ae9e1
> kernel: md:     L1 S00015936 ND:2 RD:2 md0 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:3bfee719 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc1(22,1),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda1(3,1),R:0,S:6>
> kernel: md1: <hdc3><hda3> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<43c53ab2.79834067.c68d59a1.12a648f5> 
> CT:3e8aea06
> kernel: md:     L1 S00289088 ND:2 RD:2 md1 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:be1e91de 
> E:0000008d
> kernel:      D  0:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md: rdev hdc3: O:hdc3, SZ:00289088 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<43c53ab2.79834067.c68d59a1.12a648f5> 
> CT:3e8aea06
> kernel: md:     L1 S00289088 ND:2 RD:2 md1 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:be1e9283 
> E:0000008d
> kernel:      D  0:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md: rdev hda3: O:hda3, SZ:00289088 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<43c53ab2.79834067.c68d59a1.12a648f5> 
> CT:3e8aea06
> kernel: md:     L1 S00289088 ND:2 RD:2 md1 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:be1e926e 
> E:0000008d
> kernel:      D  0:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc3(22,3),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda3(3,3),R:0,S:6>
> kernel: md3: <hdc5><hda5> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<e6d7be90.c0ce992f.fc8a803d.b445b026> 
> CT:3e8aea3c
> kernel: md:     L1 S00489856 ND:2 RD:2 md3 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:801c0ccd 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md: rdev hdc5: O:hdc5, SZ:00489856 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<e6d7be90.c0ce992f.fc8a803d.b445b026> 
> CT:3e8aea3c
> kernel: md:     L1 S00489856 ND:2 RD:2 md3 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:801c0d74 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md: rdev hda5: O:hda5, SZ:00489856 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<e6d7be90.c0ce992f.fc8a803d.b445b026> 
> CT:3e8aea3c
> kernel: md:     L1 S00489856 ND:2 RD:2 md3 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:801c0d5f 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc5(22,5),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda5(3,5),R:0,S:6>
> kernel: md4: <hdc6><hda6> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<028810ac.bf418da6.91d5bf36.cfe39e04> 
> CT:3e8aea5f
> kernel: md:     L1 S03903680 ND:2 RD:2 md4 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:4b5c979c 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md: rdev hdc6: O:hdc6, SZ:03903680 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<028810ac.bf418da6.91d5bf36.cfe39e04> 
> CT:3e8aea5f
> kernel: md:     L1 S03903680 ND:2 RD:2 md4 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:4b5c9844 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md: rdev hda6: O:hda6, SZ:03903680 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<028810ac.bf418da6.91d5bf36.cfe39e04> 
> CT:3e8aea5f
> kernel: md:     L1 S03903680 ND:2 RD:2 md4 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:4b5c982f 
> E:0000008b
> kernel:      D  0:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc6(22,6),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda6(3,6),R:0,S:6>
> kernel: md5: <hdc7><hda7> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<9a62d1da.9602dd4d.2ebc91c0.880cd430> 
> CT:3e8aea86
> kernel: md:     L1 S02931712 ND:2 RD:2 md5 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:0ef9dc91 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md: rdev hdc7: O:hdc7, SZ:02931712 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<9a62d1da.9602dd4d.2ebc91c0.880cd430> 
> CT:3e8aea86
> kernel: md:     L1 S02931712 ND:2 RD:2 md5 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:0ef9dd38 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md: rdev hda7: O:hda7, SZ:02931712 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<9a62d1da.9602dd4d.2ebc91c0.880cd430> 
> CT:3e8aea86
> kernel: md:     L1 S02931712 ND:2 RD:2 md5 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:0ef9dd23 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc7(22,7),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda7(3,7),R:0,S:6>
> kernel: md6: <hdc8><hda8> array superblock:
> kernel: md:  SB: (V:0.90.0) ID:<093d0114.2fd6d7b5.0743e000.c0f34135> 
> CT:3e8aeaa7
> kernel: md:     L1 S00979840 ND:2 RD:2 md6 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:28f7f91c 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md: rdev hdc8: O:hdc8, SZ:00979840 F:0 DN:1 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<093d0114.2fd6d7b5.0743e000.c0f34135> 
> CT:3e8aeaa7
> kernel: md:     L1 S00979840 ND:2 RD:2 md6 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:28f7f9c3 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md:     THIS:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md: rdev hda8: O:hda8, SZ:00979840 F:0 DN:0 <6>md: rdev 
> superblock:
> kernel: md:  SB: (V:0.90.0) ID:<093d0114.2fd6d7b5.0743e000.c0f34135> 
> CT:3e8aeaa7
> kernel: md:     L1 S00979840 ND:2 RD:2 md6 LO:0 CS:65536
> kernel: md:     UT:3fe6d0ed ST:0 AD:2 WD:2 FD:0 SD:0 CSUM:28f7f9ae 
> E:00000089
> kernel:      D  0:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel:      D  1:  DISK<N:1,hdc8(22,8),R:1,S:6>
> kernel: md:     THIS:  DISK<N:0,hda8(3,8),R:0,S:6>
> kernel: md:^I**********************************
> kernel:
> kernel: md :do_md_run() returned -22
> kernel: md: md2 stopped.
> kernel: md: unbind<sdd,7>
> kernel: md: export_rdev(sdd)
> kernel: md: unbind<sdf,6>
> kernel: md: export_rdev(sdf)
> kernel: md: unbind<sde,5>
> kernel: md: export_rdev(sde)
> kernel: md: unbind<sdg,4>
> kernel: md: export_rdev(sdg)
> kernel: md: unbind<sdc,3>
> kernel: md: export_rdev(sdc)
> kernel: md: unbind<sdb,2>
> kernel: md: export_rdev(sdb)
> kernel: md: unbind<sdh,1>
> kernel: md: export_rdev(sdh)
> kernel: md: unbind<sda,0>
> kernel: md: export_rdev(sda)
> kernel: md: ... autorun DONE.
>
>
> My /etc/raidtab :
> raiddev                         /dev/md2
>        raid-level              5
>        nr-raid-disks           6
>        nr-spare-disks          2
>        chunk-size              32
>        persistent-superblock   1
>        parity-algorithm        left-symmetric
>        device                  /dev/sda
>        raid-disk               0
>        device                  /dev/sdb
>        raid-disk               1
>        device                  /dev/sdc
>        raid-disk               2
>        device                  /dev/sdd
>        raid-disk               3
>        device                  /dev/sde
>        raid-disk               4
>        device                  /dev/sdf
>        raid-disk               5
>        device                  /dev/sdg
>        spare-disk              0
>        device                  /dev/sdh
>        spare-disk              1
>
>
>
> I use a Debian Woody r2, and kernel 2.4.23.
> How can i recover my data ?
>
> I would be very grateful if someone could help me.
>
>    Nicolas
>


