From: Robert Washburne <hormel331@comcast.net>
Subject: How many RAID devices can you define?
Date: Wed, 28 Dec 2005 14:38:23 +0000 (UTC)
Message-ID: <loom.20051228T152300-30@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am setting up a file server using Gentoo 2005.1, kernel 2.6.14-r2

The installed system creates eight RAID devices - /dev/md[0-7], /dev/md/[0-7]

I wish to create nine RAIDs, so I used "mknod /dev/md/8 b 9 8" to create another
device (and its associated link, /dev/md8).

The hardware consists of a 650 MHz AMD Duron with 1 GB ram.  Four WD 250 GB IDE
drives are connected to the four IDE busses of two Promise Technologies IDE
ATA100 controlers.  The drives are all partitioned the same using partitions
[1-3, 5-12].

I used raidtools to define and create the RAIDs.

The first eight devices created and synced with no problem (seven RAID5 and one
RAID0).  But when I created the ninth RAID5, it got about 30% through the sync
and then the system hung.  Keyboard was dead.  I had to power-cycle.

The the system came back up, it continued to sync, but hung again after a minute
or two.

Is there a hard limit of only eight RAID devices?

If so, can this limit be readily increased?

If need be, I can repartition my drives and reduce the RAIDs to only eight, but
I would prefer to keep the nine, if possible.

Thanks in advance!

Bob W.

