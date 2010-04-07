From: Phillip Susi <psusi@cfl.rr.com>
Subject: Two degraded mirror segments recombined out of sync for massive data
 loss
Date: Wed, 7 Apr 2010 16:45:32 -0400
Message-ID: <4BBCEEEC.4030606@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The gist of the problem is this: after booting a mirror in degraded mode
with only the first disk, then doing the same with only the second disk,
then booting with both disks again, mdadm happily recombines the two
disks out of sync, causing two divergent filesystems to become munged
together.

The problem was initially discovered testing the coming lucid release of
Ubuntu doing clean installs in a virtualization environment, and I have
reproduced it manually activating and deactivating the array built out
of two lvm logical volumes under Karmic.  What seems to be happening is
that when you activate in degraded mode ( mdadm --assemble --run ), the
metadata on the first disk is changed to indicate that the second disk
was faulty and removed.  When you activate with only the second disk,
you would think it would say the first disk was faulty, removed, but for
some reason it ends up only marking it as removed, but not faulty.  Now
both disks are degraded.

When mdadm --incrmental is run by udev on the first disk, it happily
activates it since the array is degraded, but has one out of one active
member present, with the second member faulty,removed.  When mdadm
--incremental is run by udev on the second disk, it happily slips the
disk into the active array, WITHOUT SYNCING.

My two questions are:

1) When doing mdadm --assemble --run with only the second disk present,
shouldn't it mark the first disk as faulty, removed instead of only removed?

2) When mdadm --incremental is run on the second disk, shouldn't it
refuse to use it since the array says the second disk is faulty, removed?

The bug report related to this can be found at:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/557429

