From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: RAID-6 question.
Date: Mon, 10 Nov 2008 06:56:22 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811100653060.21263@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I ran a check on a RAID6 and my entire machine was timing out ssh 
connections etc until it was just about finished, I never experienced this 
with RAID5, any comments?

$ cat /sys/block/md3/md/sync_speed_min
1000 (system)
$ cat /sys/block/md3/md/sync_speed_max
200000 (system)

md3 : active raid6 sdl1[9] sdk1[8] sdj1[7] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
       2344263680 blocks level 6, 1024k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
       [===================>.]  resync = 96.5% (283046144/293032960) finish=2.3min speed=71092K/sec

# dd if=/dev/zero of=disk bs=1M # write to entire raid6 device
# then, run a check > on /sys/etc for all devices that support parity
# (do this on a regular basis w/raid1+5), never seen any slowdown etc like
# i experienced w/ RAID6: /app/jp-mystuff/bin/check_mdraid.sh
Mon Nov 10 06:00:54 EST 2008: Parity check(s) running, sleeping 10 minutes...

