From: Neil Brown <neilb@suse.de>
Subject: Re: Deleting mdadm RAID arrays
Date: Thu, 7 Feb 2008 13:36:31 +1100
Message-ID: <18346.28335.256479.27397@notabene.brown>
References: <200802051142.19625.admin@domeny.pl>
	<200802061055.03979.admin@domeny.pl>
	<18345.36672.51070.986289@notabene.brown>
	<200802061303.50017.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marcin Krol on Wednesday February 6
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 6, admin@domeny.pl wrote:
> 
> % cat /proc/partitions
> major minor  #blocks  name
> 
>    8     0  390711384 sda
>    8     1  390708801 sda1
>    8    16  390711384 sdb
>    8    17  390708801 sdb1
>    8    32  390711384 sdc
>    8    33  390708801 sdc1
>    8    48  390710327 sdd
>    8    49  390708801 sdd1
>    8    64  390711384 sde
>    8    65  390708801 sde1
>    8    80  390711384 sdf
>    8    81  390708801 sdf1
>    3    64   78150744 hdb
>    3    65    1951866 hdb1
>    3    66    7815622 hdb2
>    3    67    4883760 hdb3
>    3    68          1 hdb4
>    3    69     979933 hdb5
>    3    70     979933 hdb6
>    3    71   61536951 hdb7
>    9     1  781417472 md1
>    9     0  781417472 md0

So all the expected partitions are known to the kernel - good.

> 
> /etc/udev/rules.d % cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md0 : active(auto-read-only) raid5 sdc1[0] sde1[3](S) sdd1[1]
>       781417472 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
> 
> md1 : active(auto-read-only) raid5 sdf1[0] sdb1[3](S) sda1[1]
>       781417472 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
> 
> md0 consists of sdc1, sde1 and sdd1 even though when creating I asked it to 
> use d_1, d_2 and d_3 (this is probably written on the particular disk/partition itself,
> but I have no idea how to clean this up - mdadm --zero-superblock /dev/d_1
> again produces "mdadm: Couldn't open /dev/d_1 for write - not zeroing")
> 

I suspect it is related to the (auto-read-only).
The array is degraded and has a spare, so it wants to do a recovery to
the spare.  But it won't start the recovery until the array is not
read-only.

But the recovery process has partly started (you'll see an md1_resync
thread) so it won't let go of any fail devices at the moment.
If you 
  mdadm -w /dev/md0

the recovery will start.
Then
  mdadm /dev/md0 -f /dev/d_1

will fail d_1, abort the recovery, and release d_1.

Then
  mdadm --zero-superblock /dev/d_1

should work.

It is currently failing with EBUSY - --zero-superblock opens the
device with O_EXCL to ensure that it isn't currently in use, and as
long as it is part of an md array, O_EXCL will fail.
I should make that more explicit in the error message.

NeilBrown
