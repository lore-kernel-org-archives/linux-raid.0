From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Docs and operation of RAID10, size limitations on 0.90
Date: Mon, 28 Jul 2008 10:35:53 -0400
Message-ID: <20080728143553.GE30681@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I'm building a new system with 8 disks, in two RAID5 arrays of 4 disks
each, and a RAID1 array across them.  (Then LVM2 on top of the RAID1
array.)

I approached it this way for two reasons:

1/ It feels "cleanest"; in the sense that it's not a special case, it's
just RAID1 with two devices, which happen to be RAID5.

2/ I have a particular usage in mind: I need to be able to split the
mirror and remove half; return it later and resync.  Therefore, I want
to know which disks comprise which halves.

However, I'm rethinking toward RAID10.  However, I can't find much
documentation about layout, etc.  I believe this was recently discussed
on the list.


Can someone with RAID10 experience enlighten me?  Can it be cleaned
split, half moved to another host, or rejoined with the first half, etc.
How about performance?  (Not a huge issue, but it is better than nested
arrays as I first considered?)


Aside, I'd like it to be bootable.  I was told grub only supports
booting from 0.90 superblocks, but that 0.90 has a 2TB limitation?
Meaning, I need /boot with 0.90 and another partition (LVM) with a 1.0
superblocks?



Thanks,
Richard
