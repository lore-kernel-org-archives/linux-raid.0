From: "John Stoffel" <john@stoffel.org>
Subject: RAID design decisions
Date: Fri, 16 Dec 2005 20:28:56 -0500
Message-ID: <17315.27096.325885.788363@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Guys,

It's been at least a couple of years now that I've had the following
setup on my main machine, a Debian machine which is heavily upgraded
all the time, and runs fairly bleeding edge kernels.  

Basically, I have a pair of 120gb disks.  They're partitioned, each
with just one large partition.  These two partitions are then mirrored
into a single RAID1 device called md0. 

On top of that I have LVM2 running, which makes md0 into a pv, which
holds a vg called 'data_vg', which holds a pair of partitions called
'local_lv' and 'home_lv'.  They are then mounted as /home and /local.
Works well.  To summarize:

  disk -> partition -> md -> pv -> vg -> lv -> fs -> mount point

But I'm wondering if I'm being a) too complex here or b) inverted in
how I want this setup so the LVM is under MD, or c) just fine overall.
Should I be using LVM2 to build my RAID1 devices directly?  Should I
be using MD instead to build my resizeable volumes to hold my
filesystems?

When I first set this up, MD was pretty new, as was LVM and there was
no really easy way to do what I wanted, which was to setup mirrored
volumes which I could re-size at needed.  Not that I resize them often
since they're ext3.  And no, I don't want reiserfs3, xfs, or any other
filesystem on there.  I don't trust them.  

Basically, I'm looking for reliabilty of my data, and then speed.  

My next goals are to:

1. setup MD bitmaps for speedier recoveries
2. mirror my /, swap and /boot partitions for reliability
	- requires mkinitrd to work well and easily for new kernels.
	- requires I don't screw up my current setup when I try this.


Thanks,
John
