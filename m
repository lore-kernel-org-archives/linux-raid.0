From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md: add new / required locking for calls to blk_remove_plug and blk_plug_queue
Date: Thu, 1 May 2008 12:33:52 +1000
Message-ID: <18457.11280.523036.345047@notabene.brown>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
	<20080430011943.20468.71869.stgit@dwillia2-linux.ch.intel.com>
	<18457.4220.20511.737042@notabene.brown>
	<e9c3a7c20804301750o7621a5c5i4c2d92bc83ae0772@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday April 30
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 30, dan.j.williams@intel.com wrote:
> On Wed, Apr 30, 2008 at 5:36 PM, Neil Brown <neilb@suse.de> wrote:
> > On Tuesday April 29, dan.j.williams@intel.com wrote:
> >  > Now that queue flags are no longer atomic (commit:
> >  > 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e)  we must protect calls to
> >  > blk_remove_plug with spin_lock(q->queue_lock).
> >
> >  Can't we just do
> >
> >   q->queue_lock = &conf->device_lock
> >
> >  and appropriate places in the various ->run functions?
> >
> >  It seems to be that we are doing appropriate locking, we just need to
> >  convince queue_flag_set / queue_flag_clear that the correct lock is
> >  locked.
> >  ??
> >
> 
> That's much simpler.  Hmm... as an additional cleanup should
> device_lock then move to mddev_t since it really is a mddev-level
> lock?  There seem to be more than a few places that cast
> mddev->private just to get conf->device_lock.  Then all this lock
> initialization is centralized.

Conversely, there seem to be plenty of places where we access
conf->device_lock and don't have an 'mddev' handy.
They could of course become
      conf->mddev->device_lock
but I'm not sure that is an improvement.

I think you would need to actually do the change, then decide if the
benefits outweigh the costs.

It's probably best to find a minimal solution to the current problem
and just add the assignments to q->queue_lock for now.  We can then
explore whether there are cleanup opportunities.

Thanks,
NeilBrown
