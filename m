From: Jeff Breidenbach <jeff@jab.org>
Subject: Re: Raid sync observations
Date: Tue, 20 Dec 2005 14:09:19 -0800
Message-ID: <E1Eopfb-0005R2-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>I'll just call it sync access pattern overhead then.

As another data point, I've been adding more and more
drives to a RAID-1 array. Yesterday I just added a fourth
disk which is still syncing.

       mdadm --grow /dev/md0 -n4
       mdadm --manage /dev/md0 --add /dev/sde

md0 : active raid1 sde1[4] sdc1[0] sdb1[2] sdd1[1]
      488383936 blocks [4/3] [UUU_]
      [=====>...............]  recovery = 27.6% (134963968/488383936) finish=1739.7min speed=3384K/sec

In general I'm seeing somewhere between 2 to 4 MB/s on the currently
running sync. Which is fine, no problem. The array is live and
currently handling some traffic. But these are pretty fast disks, and
running simple things like

	hdparm -tT /dev/sde
	nice dd_rescue /dev/md0 /dev/null

all show pretty big numbers. This provides some intuition that there
may be room for improvement in sync speed. Kernel 2.6.14, no fancy
RAID bitmaps involved.

Jeff



