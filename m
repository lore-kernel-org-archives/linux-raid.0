From: "George Spelvin" <linux@horizon.com>
Subject: want-replacement got stuck?
Date: 20 Nov 2012 17:11:45 -0500
Message-ID: <20121120221145.9905.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

I have a RAID10 array with 4 active + 1 spare.
Kernel is 3.6.5, x86-64 but running 32-bit unserland.

After a recent failure on sdd2, the spare sdc2 was
activated and things looked something like (manual edit,
may not be perfectly faithful):

md5 : active raid10 sdd2[4](F) sdb2[1] sde2[2] sdc2[3] sda2[0]
      725591552 blocks 256K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 50/173 pages [200KB], 2048KB chunk

smartctl -A showed 1 pending sector, but badblocks didn't
find it, so I decided to play with moving things back:

# badblocks -s -v /dev/sdd2
# mdadm /dev/md5 -r /dev/sdd2 -a /dev/sdd2
# echo want_replacement >  /sys/block/md5/md/dev-sdc2/state

This ran for a while, but now it has stopped, with the following
configuration:

md5 : active raid10 sdd2[3](R) sdb2[1] sde2[2] sdc2[4](F) sda2[0]
      725591552 blocks 256K chunks 2 near-copies [4/4] [UUU_]
      bitmap: 50/173 pages [200KB], 2048KB chunk

# [530]# cat /sys/block/md5/md/dev-sd?2/state
in_sync
in_sync
faulty,want_replacement
in_sync,replacement
in_sync

I'm not quite sure how to interpret this state, and why it is showing
"4/4" good drives but [UUU_].

Unlike the failures which caused sdd2 to drop out, that are quite verbose
in the syslog, I can't see what cause the resync to stop.

Here's the initial failover:

Nov 20 11:49:06 science kernel: ata4: EH complete
Nov 20 11:49:06 science kernel: md/raid10:md5: read error corrected (8 sectors at 40 on sdd2)
Nov 20 11:49:06 science kernel: md/raid10:md5: sdd2: Raid device exceeded read_error threshold [cur 21:max 20]
Nov 20 11:49:06 science kernel: md/raid10:md5: sdd2: Failing raid device
Nov 20 11:49:06 science kernel: md/raid10:md5: Disk failure on sdd2, disabling device.
Nov 20 11:49:06 science kernel: md/raid10:md5: Operation continuing on 3 devices.
Nov 20 11:49:06 science kernel: RAID10 conf printout:
Nov 20 11:49:06 science kernel: --- wd:3 rd:4
Nov 20 11:49:06 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 11:49:06 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 11:49:06 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 11:49:06 science kernel: disk 3, wo:1, o:0, dev:sdd2
Nov 20 11:49:06 science kernel: RAID10 conf printout:
Nov 20 11:49:06 science kernel: --- wd:3 rd:4
Nov 20 11:49:06 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 11:49:06 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 11:49:06 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 11:49:06 science kernel: disk 3, wo:1, o:0, dev:sdd2
Nov 20 11:49:06 science kernel: RAID10 conf printout:
Nov 20 11:49:06 science kernel: --- wd:3 rd:4
Nov 20 11:49:06 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 11:49:06 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 11:49:06 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 11:49:06 science kernel: RAID10 conf printout:
Nov 20 11:49:06 science kernel: --- wd:3 rd:4
Nov 20 11:49:06 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 11:49:06 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 11:49:06 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 11:49:06 science kernel: disk 3, wo:1, o:1, dev:sdc2
Nov 20 11:49:06 science kernel: md: recovery of RAID array md5
Nov 20 11:49:06 science kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Nov 20 11:49:06 science kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Nov 20 11:49:06 science kernel: md: using 128k window, over a total of 362795776k.
u

And its completion:
Nov 20 13:50:47 science kernel: md: md5: recovery done.
Nov 20 13:50:47 science kernel: RAID10 conf printout:
Nov 20 13:50:47 science kernel: --- wd:4 rd:4
Nov 20 13:50:47 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 13:50:47 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 13:50:47 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 13:50:47 science kernel: disk 3, wo:0, o:1, dev:sdc2

Here's where I remove and re-add sdd2:
Nov 20 16:34:01 science kernel: md: unbind<sdd2>
Nov 20 16:34:01 science kernel: md: export_rdev(sdd2)
Nov 20 16:34:11 science kernel: md: bind<sdd2>
Nov 20 16:34:12 science kernel: RAID10 conf printout:
Nov 20 16:34:12 science kernel: --- wd:4 rd:4
Nov 20 16:34:12 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 16:34:12 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 16:34:12 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 16:34:12 science kernel: disk 3, wo:0, o:1, dev:sdc2

And do the want_replacement:
Nov 20 16:38:07 science kernel: RAID10 conf printout:
Nov 20 16:38:07 science kernel: --- wd:4 rd:4
Nov 20 16:38:07 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 16:38:07 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 16:38:07 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 16:38:07 science kernel: disk 3, wo:0, o:1, dev:sdc2
Nov 20 16:38:07 science kernel: md: recovery of RAID array md5
Nov 20 16:38:07 science kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Nov 20 16:38:07 science kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Nov 20 16:38:07 science kernel: md: using 128k window, over a total of 362795776k.

It appears to have completed:
Nov 20 18:40:01 science kernel: md: md5: recovery done.
Nov 20 18:40:01 science kernel: RAID10 conf printout:
Nov 20 18:40:01 science kernel: --- wd:4 rd:4
Nov 20 18:40:01 science kernel: disk 0, wo:0, o:1, dev:sda2
Nov 20 18:40:01 science kernel: disk 1, wo:0, o:1, dev:sdb2
Nov 20 18:40:01 science kernel: disk 2, wo:0, o:1, dev:sde2
Nov 20 18:40:01 science kernel: disk 3, wo:1, o:0, dev:sdc2

But as mentioned, the RAID state is a bit odd.  sdc2 is still in the
array and sdd2 is not.

Can anyone suggest what is going on?  Thank you!
