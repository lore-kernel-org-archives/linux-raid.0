From: Jim Paris <jim@jtan.com>
Subject: Re: Call for RAID-6 users
Date: Tue, 27 Jul 2004 14:48:36 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040727184836.GA28494@jim.sh>
References: <20040727021209.GA19205@jim.sh> <Pine.GSO.4.33.0407271238490.25702-100000@sweetums.bluetronic.net> <20040727172028.GA27240@jim.sh> <20040727181938.GA28181@jim.sh>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040727181938.GA28181@jim.sh>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Attached is another trace that shows this corruption on a single
> regular file copied with "cp" onto a fresh filesystem.

And here's a trace showing problems even without a filesystem.
Writing data near the end is fatal.  This does not happen if I write
to the first 1G of the array.

-jim

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=typescript

Script started on Tue Jul 27 14:44:26 2004
bucket:~# mdadm --stop /dev/md1
bucket:~# mdadm --zero-superblock /dev/hd[gikmo]2
bucket:~# for i in /dev/hd[gikmo]2 ; do dd if=/dev/zero of=$i bs=1M count=1 ; done
1+0 records in
1+0 records out
1048576 bytes transferred in 0.032001 seconds (32766876 bytes/sec)
1+0 records in
1+0 records out
1048576 bytes transferred in 0.032197 seconds (32567587 bytes/sec)
1+0 records in
1+0 records out
1048576 bytes transferred in 0.032125 seconds (32640483 bytes/sec)
1+0 records in
1+0 records out
1048576 bytes transferred in 0.032064 seconds (32702568 bytes/sec)
1+0 records in
1+0 records out
1048576 bytes transferred in 0.032315 seconds (32448665 bytes/sec)
bucket:~# mdadm --create /dev/md1 --level=6 --chunk=128 --raid-devices=6 missing /dev/hd[gikmo]2
mdadm: array /dev/md1 started.
bucket:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6] 
md1 : active raid6 hdo2[5] hdm2[4] hdk2[3] hdi2[2] hdg2[1]
      976269312 blocks level 6, 128k chunk, algorithm 2 [6/5] [_UUUUU]
      
md0 : active raid1 hdo1[5] hdm1[4] hdk1[3] hdi1[2] hdg1[1]
      128384 blocks [6/5] [_UUUUU]
      
unused devices: <none>
bucket:~# dd if=/dev/urandom of=/dev/md1 bs=1M count=100 seek=900000
100+0 records in
100+0 records out
104857600 bytes transferred in 19.095634 seconds (5491182 bytes/sec)
bucket:~# mdadm --stop /dev/md1
bucket:~# mdadm --run /dev/md1
mdadm: failed to run array /dev/md1: Invalid argument
bucket:~# dmesg
md: bind<hdg2>
md: bind<hdi2>
md: bind<hdk2>
md: bind<hdm2>
md: bind<hdo2>
raid6: device hdo2 operational as raid disk 5
raid6: device hdm2 operational as raid disk 4
raid6: device hdk2 operational as raid disk 3
raid6: device hdi2 operational as raid disk 2
raid6: device hdg2 operational as raid disk 1
raid6: allocated 6269kB for md1
raid6: raid level 6 set md1 active with 5 out of 6 devices, algorithm 2
RAID6 conf printout:
 --- rd:6 wd:5 fd:1
 disk 1, o:1, dev:hdg2
 disk 2, o:1, dev:hdi2
 disk 3, o:1, dev:hdk2
 disk 4, o:1, dev:hdm2
 disk 5, o:1, dev:hdo2
md: md1 stopped.
md: unbind<hdo2>
md: export_rdev(hdo2)
md: unbind<hdm2>
md: export_rdev(hdm2)
md: unbind<hdk2>
md: export_rdev(hdk2)
md: unbind<hdi2>
md: export_rdev(hdi2)
md: unbind<hdg2>
md: export_rdev(hdg2)
md: bug in file drivers/md/md.c, line 1513

md:	**********************************
md:	* <COMPLETE RAID STATE PRINTOUT> *
md:	**********************************
md1: 
md0: <hdo1><hdm1><hdk1><hdi1><hdg1>
md: rdev hdo1, SZ:00128384 F:0 S:1 DN:5
md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65daa413.7da47b48.1e1593ff.5a0a11c8> CT:410564ab
md:     L1 S00128384 ND:5 RD:6 md0 LO:0 CS:0
md:     UT:410567ad ST:1 AD:5 WD:5 FD:0 SD:0 CSUM:86d6d898 E:0000001c
     D  0:  DISK<N:0,unknown-block(0,0)(0,0),R:0,S:8>
     D  1:  DISK<N:1,hdg1(34,1),R:1,S:6>
     D  2:  DISK<N:2,hdi1(56,1),R:2,S:6>
     D  3:  DISK<N:3,hdk1(57,1),R:3,S:6>
     D  4:  DISK<N:4,hdm1(88,1),R:4,S:6>
     D  5:  DISK<N:5,hdo1(89,1),R:5,S:6>
md:     THIS:  DISK<N:5,hdo1(89,1),R:5,S:6>
md: rdev hdm1, SZ:00128384 F:0 S:1 DN:4
md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65daa413.7da47b48.1e1593ff.5a0a11c8> CT:410564ab
md:     L1 S00128384 ND:5 RD:6 md0 LO:0 CS:0
md:     UT:410567ad ST:1 AD:5 WD:5 FD:0 SD:0 CSUM:86d6d895 E:0000001c
     D  0:  DISK<N:0,unknown-block(0,0)(0,0),R:0,S:8>
     D  1:  DISK<N:1,hdg1(34,1),R:1,S:6>
     D  2:  DISK<N:2,hdi1(56,1),R:2,S:6>
     D  3:  DISK<N:3,hdk1(57,1),R:3,S:6>
     D  4:  DISK<N:4,hdm1(88,1),R:4,S:6>
     D  5:  DISK<N:5,hdo1(89,1),R:5,S:6>
md:     THIS:  DISK<N:4,hdm1(88,1),R:4,S:6>
md: rdev hdk1, SZ:00128384 F:0 S:1 DN:3
md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65daa413.7da47b48.1e1593ff.5a0a11c8> CT:410564ab
md:     L1 S00128384 ND:5 RD:6 md0 LO:0 CS:0
md:     UT:410567ad ST:1 AD:5 WD:5 FD:0 SD:0 CSUM:86d6d874 E:0000001c
     D  0:  DISK<N:0,unknown-block(0,0)(0,0),R:0,S:8>
     D  1:  DISK<N:1,hdg1(34,1),R:1,S:6>
     D  2:  DISK<N:2,hdi1(56,1),R:2,S:6>
     D  3:  DISK<N:3,hdk1(57,1),R:3,S:6>
     D  4:  DISK<N:4,hdm1(88,1),R:4,S:6>
     D  5:  DISK<N:5,hdo1(89,1),R:5,S:6>
md:     THIS:  DISK<N:3,hdk1(57,1),R:3,S:6>
md: rdev hdi1, SZ:00128384 F:0 S:1 DN:2
md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65daa413.7da47b48.1e1593ff.5a0a11c8> CT:410564ab
md:     L1 S00128384 ND:5 RD:6 md0 LO:0 CS:0
md:     UT:410567ad ST:1 AD:5 WD:5 FD:0 SD:0 CSUM:86d6d871 E:0000001c
     D  0:  DISK<N:0,unknown-block(0,0)(0,0),R:0,S:8>
     D  1:  DISK<N:1,hdg1(34,1),R:1,S:6>
     D  2:  DISK<N:2,hdi1(56,1),R:2,S:6>
     D  3:  DISK<N:3,hdk1(57,1),R:3,S:6>
     D  4:  DISK<N:4,hdm1(88,1),R:4,S:6>
     D  5:  DISK<N:5,hdo1(89,1),R:5,S:6>
md:     THIS:  DISK<N:2,hdi1(56,1),R:2,S:6>
md: rdev hdg1, SZ:00128384 F:0 S:1 DN:1
md: rdev superblock:
md:  SB: (V:0.90.0) ID:<65daa413.7da47b48.1e1593ff.5a0a11c8> CT:410564ab
md:     L1 S00128384 ND:5 RD:6 md0 LO:0 CS:0
md:     UT:410567ad ST:1 AD:5 WD:5 FD:0 SD:0 CSUM:86d6d859 E:0000001c
     D  0:  DISK<N:0,unknown-block(0,0)(0,0),R:0,S:8>
     D  1:  DISK<N:1,hdg1(34,1),R:1,S:6>
     D  2:  DISK<N:2,hdi1(56,1),R:2,S:6>
     D  3:  DISK<N:3,hdk1(57,1),R:3,S:6>
     D  4:  DISK<N:4,hdm1(88,1),R:4,S:6>
     D  5:  DISK<N:5,hdo1(89,1),R:5,S:6>
md:     THIS:  DISK<N:1,hdg1(34,1),R:1,S:6>
md:	**********************************

bucket:~# exit

Script done on Tue Jul 27 14:44:51 2004

--6c2NcOVqGQ03X4Wi--
