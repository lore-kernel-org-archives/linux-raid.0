From: Jeff Breidenbach <jeff@jab.org>
Subject: recovery speed on many-disk RAID 1
Date: Sat, 20 May 2006 19:16:33 -0700
Message-ID: <E1FhdUf-0002pr-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Consider the following setup, mainly designed for reading random small
files quickly. Normally, this a quintuply redundant RAID-1. 

# cat /proc/mdstat
Personalities : [raid1] 
md1 : active raid1 sdg1[6] sde1[1] sdb1[4] sdd1[3] sdc1[2]
      488383936 blocks [6/4] [_UUUU_]
      [>....................]  recovery =  3.7% (18245248/488383936) finish=725.7min speed=10794K/sec

# mount | grep backup
/dev/sdf1 on /backup type reiserfs (ro)

However, right now a backup operation is occuring. The backup strategy
is simply swapping a pair of drives between the RAID and /backup, and
letting linux-raid do all the work. Here we've just pulled sdf1 from
the RAID and inserted sdg1.

The interesting part here is the recovery rate. It seems to tightly
hug whatever is set in /proc/sys/dev/raid/speed_limit_min. I'm kind of
suprised about that, and suspect the recovery operation is getting
interrupted by seeks from read requests on the RAID. But that's not
really necessary; imagine if it instead went something like:

  sbb1 -> sbg1    # High bandwidth copy operation limited by drive speed
  sb[cde]1        # These guys handle read requests

I think that's more or less what happens anyway when I crank up
speed_limit_min. But I wonder if such a thing could happen
automatically? Isn't this generally the right way to go when dealing
with recovery and many-disk RAID-1?

Cheers,
Jeff


 
