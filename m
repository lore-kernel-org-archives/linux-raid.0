From: Nick Lindsell <nick@nexnix.co.uk>
Subject: Am I dead?
Date: Mon, 02 Dec 2002 12:21:30 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.0.20021202114409.06af4530@core>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings list,
	My server died last night while copying 4Gb data over the network to
it's IDE raid5 array. While trying to boot it cannot mount root as the 
superblock
is bad for that raid device.
	I've moved the array to another machine with it's own disk so I may be
able to effect a repair by running the raidtools.
	I recreated /etc/raidtab and tried to start the arrays but I get this
in the syslog:

Dec 2 12:41:18 nexnix-192 kernel: [events: 00000018]
Dec 2 12:41:18 nexnix-192 kernel: [events: 0000001d]
Dec 2 12:41:18 nexnix-192 kernel: [events: 0000001c]
Dec 2 12:41:18 nexnix-192 kernel: md: autorun ...
Dec 2 12:41:18 nexnix-192 kernel: md: considering sdc2 ...
Dec 2 12:41:18 nexnix-192 kernel: md: adding sdc2 ...
Dec 2 12:41:18 nexnix-192 kernel: md: adding sdb2 ...
Dec 2 12:41:18 nexnix-192 kernel: md: adding sda2 ...
Dec 2 12:41:18 nexnix-192 kernel: md: created md2
Dec 2 12:41:18 nexnix-192 kernel: md: bind<sda2,1>
Dec 2 12:41:18 nexnix-192 kernel: md: bind<sdb2,2>
Dec 2 12:41:18 nexnix-192 kernel: md: bind<sdc2,3>
Dec 2 12:41:18 nexnix-192 kernel: md: running: <sdc2><sdb2><sda2>
Dec 2 12:41:18 nexnix-192 kernel: md: sdc2's event counter: 0000001c
Dec 2 12:41:18 nexnix-192 kernel: md: sdb2's event counter: 0000001d
Dec 2 12:41:18 nexnix-192 kernel: md: sda2's event counter: 00000018
Dec 2 12:41:18 nexnix-192 kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 2 12:41:18 nexnix-192 kernel: md: freshest: sdb2
Dec 2 12:41:18 nexnix-192 kernel: md: kicking non-fresh sda2 from array!
Dec 2 12:41:18 nexnix-192 kernel: md: unbind<sda2,2>
Dec 2 12:41:18 nexnix-192 kernel: md: export_rdev(sda2)
Dec 2 12:41:18 nexnix-192 kernel: md2: kicking faulty sdc2!
Dec 2 12:41:18 nexnix-192 kernel: md: unbind<sdc2,1>
Dec 2 12:41:18 nexnix-192 kernel: md: export_rdev(sdc2)
Dec 2 12:41:18 nexnix-192 kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Dec 2 12:41:18 nexnix-192 kernel: md2: max total readahead window set to 512k
Dec 2 12:41:18 nexnix-192 kernel: md2: 2 data-disks, max readahead per 
data-disk: 256k
Dec 2 12:41:18 nexnix-192 kernel: raid5: device sdb2 operational as raid 
disk 1
Dec 2 12:41:18 nexnix-192 kernel: raid5: not enough operational devices for 
md2 (2/3 failed)
Dec 2 12:41:18 nexnix-192 kernel: RAID5 conf printout:
Dec 2 12:41:18 nexnix-192 kernel: --- rd:3 wd:1 fd:2
Dec 2 12:41:18 nexnix-192 kernel: disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 
00:00]
Dec 2 12:41:18 nexnix-192 kernel: disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb2
Dec 2 12:41:18 nexnix-192 kernel: disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 
00:00]
Dec 2 12:41:18 nexnix-192 kernel: raid5: failed to run raid set md2
Dec 2 12:41:18 nexnix-192 kernel: md: pers->run() failed ...
Dec 2 12:41:18 nexnix-192 kernel: md :do_md_run() returned -22
Dec 2 12:41:18 nexnix-192 kernel: md: md2 stopped.
Dec 2 12:41:18 nexnix-192 kernel: md: unbind<sdb2,0>
Dec 2 12:41:18 nexnix-192 kernel: md: export_rdev(sdb2)
Dec 2 12:41:18 nexnix-192 kernel: md: ... autorun DONE.

Am I dead or can I "freshen" sda2 so I can at least have 2 devices in my 
array and therefore
have a chance of either backing off the data or rebulding with a new sdc ?

tia
nick

