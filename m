From: Neil Brown <neilb@suse.de>
Subject: Re: Two degraded mirror segments recombined out of sync for massive
 data loss
Date: Thu, 8 Apr 2010 09:49:09 +1000
Message-ID: <20100408094909.2339c330@notabene.brown>
References: <4BBCEEEC.4030606@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBCEEEC.4030606@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 7 Apr 2010 16:45:32 -0400
Phillip Susi <psusi@cfl.rr.com> wrote:

> The gist of the problem is this: after booting a mirror in degraded mode
> with only the first disk, then doing the same with only the second disk,
> then booting with both disks again, mdadm happily recombines the two
> disks out of sync, causing two divergent filesystems to become munged
> together.

I can only imagine two circumstances in which this could happen.
1/ You have a write-intent-bitmap configured.
2/ The event count on the two devices incremented by exactly the same
   about while they were in use separately.

The second seems very improbably, but is certainly possible.

Please confirm whether or not you had a bitmap configured.

> 
> The problem was initially discovered testing the coming lucid release of
> Ubuntu doing clean installs in a virtualization environment, and I have
> reproduced it manually activating and deactivating the array built out
> of two lvm logical volumes under Karmic.  What seems to be happening is
> that when you activate in degraded mode ( mdadm --assemble --run ), the
> metadata on the first disk is changed to indicate that the second disk
> was faulty and removed.  When you activate with only the second disk,
> you would think it would say the first disk was faulty, removed, but for
> some reason it ends up only marking it as removed, but not faulty.  Now
> both disks are degraded.
> 
> When mdadm --incrmental is run by udev on the first disk, it happily
> activates it since the array is degraded, but has one out of one active
> member present, with the second member faulty,removed.  When mdadm
> --incremental is run by udev on the second disk, it happily slips the
> disk into the active array, WITHOUT SYNCING.
> 
> My two questions are:
> 
> 1) When doing mdadm --assemble --run with only the second disk present,
> shouldn't it mark the first disk as faulty, removed instead of only removed?

There is no important difference between "missing" and "faulty".  If md
cannot access a device there is no way for it to know whether you, the admin,
considers that device to have failed or to simply have been removed
temporarily (e.g. as part of some backup regime).

> 
> 2) When mdadm --incremental is run on the second disk, shouldn't it
> refuse to use it since the array says the second disk is faulty, removed?
> 

No.  Just because the device was removed from the array doesn't mean you
don't want to to be part of the array any more.  And seeing the device is
still plugged in...

mdadm --incremental should only included both disks in the array if
1/ their event counts are the same, or +/- 1, or
2/ there is a write-intent bitmap and the older event count is within
   the range recorded in the write-intent bitmap.

You should understand that what you have done is at least undefined.
If you break a mirror, change both halves, then put it together again there
is no clearly "right" answer as to what will appear.

Given that you have changed both halves, you have implicitly said that both
halves are still "good".  If they are different, you need to explicitly tell
md which one you want and which one you don't.
The easiest way to do this is to use --zero-superblock on the "bad" device.

I don't think there is anything practical that could be changed in md or
mdadm to make it possible to catch this behaviour and refuse the assemble the
array...  Maybe mdadm could check that the bitmap on the 'old' device is a
subset of the bitmap on the 'new' device - that might be enough.
But if the devices just happen to have the same event count then as far as md
is concerned, they do contain the same data.

NeilBrown


> The bug report related to this can be found at:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/557429
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

