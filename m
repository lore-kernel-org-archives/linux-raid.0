From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid array not clean (its barely used and a few weeks old.. how can i find out what went wrong?)
Date: Wed, 10 Dec 2003 20:49:31 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200312110149.hBB1nZW27762@dns1.watkins-home.com>
References: <PPEOJEIEFLAONFNHJPOOKEHKGPAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PPEOJEIEFLAONFNHJPOOKEHKGPAA.jim@jimtreats.com>
To: 'James R Bamford' <jim@jimtreats.com>, 'Linux-raid maillist' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is normal, if...  Your system crashed.
The system is syncing the mirror.
Try this command to see the status:
cat /proc/mdstat

If your system resyncs each time you re-boot then some is wrong.
If you re-boot before it is done, it will start over from the beginning.

The default max speed if 10000K per second.

Issue this command to change the speed now.
echo 100000 > /proc/sys/dev/raid/speed_limit_max

If you want the change to be permanent, add these 2 lines to
/etc/sysctl.conf
# RAID rebuild max speed per device
dev.raid.speed_limit_max = 100000

The speed can be whatever you want.  I use 100000, which is much faster than
possible for my system.  Oh!  100000 is 100000K bytes per second per device.
So if you have 2 disks, they will attempt 100Meg per second each!

Based you the size of your disks, the resync will take just over 2 hours, at
10000K per second.  Your disks should be much faster.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of James R Bamford
Sent: Wednesday, December 10, 2003 8:03 PM
To: Linux-raid maillist
Subject: Raid array not clean (its barely used and a few weeks old.. how can
i find out what went wrong?)

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

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


