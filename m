From: Neil Brown <neilb@suse.de>
Subject: RE: [PATCH RFC 3/4] md: writeback caching policy for raid5 [experimental]
Date: Thu, 12 Apr 2007 16:21:32 +1000
Message-ID: <17949.53228.365167.89832@notabene.brown>
References: <Pine.LNX.4.64.0704111837410.5557@coffee.psychology.mcmaster.ca>
	<0C7297FA1D2D244A9C7F6959C0BF1E5201AE23CF@azsmsx413.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Williams, Dan J on Wednesday April 11
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Mark Hahn <hahn@mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 11, dan.j.williams@intel.com wrote:
> > From: Mark Hahn [mailto:hahn@mcmaster.ca]
> > 
> > > In its current implementation write-back mode acknowledges writes
> before
> > > they have reached non-volatile media.
> > 
> > which is basically normal for unix, no?
> I am referring to when bi_end_io is called on the bio submitted to MD.
> Normally it is not called until after the bi_end_io event for the bio
> submitted to the backing disk.
> 
> > 
> > are you planning to support barriers?  (which are the block system's
> way
> > of supporting filesystem atomicity).
> Not as a part of these performance experiments.  But, I have wondered
> what the underlying issues are behind raid5 not supporting barriers.
> Currently in raid5.c:make_request:
> 
> 	if (unlikely(bio_barrier(bi))) {
> 		bio_endio(bi, bi->bi_size, -EOPNOTSUPP);
> 		return 0;
> 	}

I should be getting this explanation down to a fine art.  I seem to be
delivering it in multiple forums.

My position is that for a virtual device that stores some blocks on
some devices and other blocks on other devices (e.g. raid0, raid5,
linear, LVM, but not raid1) barrier support in the individual devices
is unusable, and that to achieve the goal it is just as easy for the
filesystem to order requests and to use blkdev_issue_flush to force
sync-to-disk. 

The semantics of a barrier (as I understand it) is that all writes
prior to the barrier are safe before the barrier write is commenced,
and that write itself is safe before any subsequence write is
commenced. (I think those semantics are stronger than we should be
exporting - just the first half should be enough - but such is life).

On a single drive, this is achieved by not re-ordering requests around
a barrier, and asking the device to not re-order requests either.
When you have multiple devices, you cannot ask them not to re-order
requests with respect to each other, so the same mechanism cannot be
used.

Instead, you would have to plug the meta-device, unplug all the lower
level queues, wait for all writes to complete, call blkdev_issue_flush
to make sure the data is safe, issue the barrier write and wait for it
to complete, call blkdev_issue_flush again (Well, maybe the barrier
write could have been sent with BIO_RW_BARRIER for the same effect)
then unplug the queue.

And the thing is that all of that complexity ALREADY needs to be in the
filesystem.  Because if a device doesn't support barriers, the
filesystem should wait for all dependant writes to complete and then
issue the 'barrier' write (and probably call blkdev_issue_flush as
well).

And the filesystem is positioned to do this BETTER because it can know
which writes are really dependant and which might be incidental.

Ext3 gets this right except that it never bothers with
blkdev_issue_flush.  XFS doesn't even bother trying (it's designed to
be used with reliable drives).  reiserfs might actually get it
completely right as it does have a call to blkdev_issue_flush in what
looks like the right place, but I cannot be sure without lots of code
review. 

dm/stripe currently gets this wrong.  If it gets a barrier request it
just passes it down to the one target drive thus failing to ensure any
ordering wrt other drives.

All that said:  raid5 is probably in a better position than most to
implement a barrier as it keeps careful track of everything that is
happening, and could easily wait for all prior writes to complete.
This might mesH well with the write-behind approach to caching.  But I
would still rather than the filesystem just got it right for us.
With a single drive, the drive can implement a barrier more
efficiently than the filesystem.  With multiple drives, the
meta-device can at best be as efficient as the filesystem.

NeilBrown
