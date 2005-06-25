From: David Wuertele <dave-gnus@bfnet.com>
Subject: 6 drives (out of 7) and 1 spare
Date: 25 Jun 2005 16:23:04 -0700
Message-ID: <m3acle2f8n.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My raid 5 array is down and I'm trying to figure out why.  Here's what
I see:

  # mdadm -S /dev/md0
  # mdadm -A /dev/md0 /dev/hdm4 /dev/hdg2 /dev/hdf2 /dev/hdh2 /dev/hdo2 /dev/hde2 /dev/hdp2
  mdadm: /dev/dm0 has been started with 6 drives (out of 7) and 1 spare
  # 

What does "6 drives (out of 7) and 1 spare" mean?  Is that what I
should expect from a healthy array?  The reiserfs superblock is gone,
so I suspect that this message from mdadm should be telling me
something, but I can't figure out what.

Can I go ahead and tell fsck.reiserfs to re-create a superblock in
this state?  Or should I do something else to my array to get it
running healthy?

Thanks,
Dave

