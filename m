From: "James R Bamford" <jim@jimtreats.com>
Subject: Raid array not clean (its barely used and a few weeks old.. how can i find out what went wrong?)
Date: Thu, 11 Dec 2003 01:03:08 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOKEHKGPAA.jim@jimtreats.com>
References: <3FD7A643.7060602@hosttuls.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FD7A643.7060602@hosttuls.com>
To: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok,

I'm still trying to get this system actually setup and working and i noticed
this on my dmesg today..

md: autorun ...
md: considering hdg1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md: created md0
md: bind<hde1,1>
md: bind<hdg1,2>
md: running: <hdg1><hde1>
md: hdg1's event counter: 0000002d
md: hde1's event counter: 0000002d
md: md0: raid array is not clean -- starting background reconstruction
md: raid1 personality registered as nr 3
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device hdg1 operational as mirror 1
raid1: device hde1 operational as mirror 0
raid1: raid set md0 not clean; reconstructing mirrors
raid1: raid set md0 active with 2 out of 2 mirrors
md: updating md0 RAID superblock on device
md: hdg1 [events: 0000002e]<6>(write) hdg1's sb offset: 156288256
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 10000
KB/sec) for reconstruction.
md: using 124k window, over a total of 156288256 blocks.
md: hde1 [events: 0000002e]<6>(write) hde1's sb offset: 156288256
md: ... autorun DONE.


What does it mean, is it anythign to worry about?!? i've been trying to get
wake on lan to work and have been blindly powering off the machine, i am
pretty certain that this was done before it has a chance to boot into linux
(no monitor connected tho as its a backup server) .. anyways is this
indicative of any hdd errors? how can you get more info on what caused the
problems or can't you!?

With this reconstruction will i have all my files, some of them, none of
them!? does it choose one disk and basically the sync the other one up to
it!?

Cheers

Jim

