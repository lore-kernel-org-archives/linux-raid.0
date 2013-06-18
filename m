From: Mark Knecht <markknecht@gmail.com>
Subject: Proper way to delete an old RAID1?
Date: Tue, 18 Jun 2013 10:36:08 -0700
Message-ID: <CAK2H+ecYLbMystsvf8-onp9+v2SqBpn-usGHGk2HZATt2dC55g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm in the process of trying to clean up my home server. When I first
built the machine the main RAID was a partition-based 0.90 RAID1 which
is no longer used. I would like to get rid of this RAID (/dev/md127)
completely. What's the right way to do this?

mark@c2RAID6 ~ $ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md6 : active raid5 sdd6[2] sdb6[0] sdc6[1]
      494833664 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 0/2 pages [0KB], 65536KB chunk

md7 : active raid6 sdd7[2] sdc7[1] sdb7[0] sdf2[4] sde2[3]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]

md127 : active (auto-read-only) raid1 sdc5[1] sdd5[2] sdb5[0]
      52436032 blocks [3/3] [UUU]

md3 : active raid6 sdb3[0] sdf3[5] sde3[3] sdd3[2] sdc3[1]
      157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]

unused devices: <none>
mark@c2RAID6 ~ $

To I need to do anything more than:

mdadm --stop /dev/md127
mdadm --remove /dev/md127

to remove the raid1? Should I do something to zero out the partitions?
I expect to delete the partitions when this is complete and then grown
one of the other RAIDs to fill the area available.

My eventual goal is to also get rid of the raid5 /dev/md6 and then
possibly combine md3 & md7 into a single raid6 partition. I just don't
want to take the whole machine down to do it where doing reshaping,
even if slow, works fine for me.

Thanks,
Mark
