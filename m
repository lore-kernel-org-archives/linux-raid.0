From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: mdadm -D shows incorrect working devices ?
Date: Sun, 5 Jan 2003 21:09:00 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.51.0301052106080.31131@ddx.a2000.nu>
References: <Pine.LNX.4.50.0212172214130.25725-100000@ddx.a2000.nu>
 <Pine.LNX.4.50.0212182153120.4838-100000@ddx.a2000.nu>
 <Pine.LNX.4.50.0212221112050.24883-100000@ddx.a2000.nu>
 <Pine.LNX.4.51.0301021611450.11876@ddx.a2000.nu> <002701c2b320$4da3c8e0$6401a8c0@cfl.rr.com>
 <Pine.LNX.4.51.0301032202420.18601@ddx.a2000.nu> <021801c2b3fb$0c341be0$6401a8c0@cfl.rr.com>
 <Pine.LNX.4.51.0301050216270.23409@ddx.a2000.nu> <011b01c2b4cf$f0b4b5c0$6401a8c0@cfl.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <011b01c2b4cf$f0b4b5c0$6401a8c0@cfl.rr.com>
To: Mike Black <mblack@csi-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 5 Jan 2003, Mike Black wrote:

> What do your boot messages show?  They're probably wrong too as that
> should be the same info as mdadm is asking for.
dmesg shows :

md: autorun ...
md: considering sdg1 ...
md:  adding sdg1 ...
md:  adding sdi1 ...
md:  adding sdh1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1,1>
md: bind<sdc1,2>
md: bind<sdd1,3>
md: bind<sde1,4>
md: bind<sdf1,5>
md: bind<sdh1,6>
md: bind<sdi1,7>
md: bind<sdg1,8>
md: running: <sdg1><sdi1><sdh1><sdf1><sde1><sdd1><sdc1><sdb1>
md: sdg1's event counter: 0000003a
md: sdi1's event counter: 0000003a
md: sdh1's event counter: 0000003a
md: sdf1's event counter: 0000003a
md: sde1's event counter: 0000003a
md: sdd1's event counter: 0000003a
md: sdc1's event counter: 0000003a
md: sdb1's event counter: 0000003a
md0: max total readahead window set to 1792k
md0: 7 data-disks, max readahead per data-disk: 256k
raid5: device sdg1 operational as raid disk 7
raid5: device sdi1 operational as raid disk 6
raid5: device sdh1 operational as raid disk 5
raid5: device sdf1 operational as raid disk 4
raid5: device sde1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: device sdb1 operational as raid disk 0
raid5: allocated 8531kB for md0
raid5: raid level 5 set md0 active with 8 out of 8 devices, algorithm 0
RAID5 conf printout:
 --- rd:8 wd:8 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdh1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdi1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdg1
RAID5 conf printout:
 --- rd:8 wd:8 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdh1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdi1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdg1
md: updating md0 RAID superblock on device
md: sdg1 [events: 0000003b]<6>(write) sdg1's sb offset: 117218176
md: sdi1 [events: 0000003b]<6>(write) sdi1's sb offset: 117218176
md: sdh1 [events: 0000003b]<6>(write) sdh1's sb offset: 117218176
md: sdf1 [events: 0000003b]<6>(write) sdf1's sb offset: 117218176
md: sde1 [events: 0000003b]<6>(write) sde1's sb offset: 117218176
md: sdd1 [events: 0000003b]<6>(write) sdd1's sb offset: 117218176
md: sdc1 [events: 0000003b]<6>(write) sdc1's sb offset: 117218176
md: sdb1 [events: 0000003b]<6>(write) sdb1's sb offset: 117218176
md: ... autorun DONE.


> I don't want to reboot my system right now to check.
don't think rebooting will fix the problem at your computer also (here it
doesn't)
