From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] raid5-cache: free I/O units earlier
Date: Thu, 17 Sep 2015 03:50:45 +0200
Message-ID: <20150917015045.GB22809@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <1442038638-6947-3-git-send-email-hch@lst.de> <87d1xk6ub4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d1xk6ub4.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Tue, Sep 15, 2015 at 09:00:31AM +0200, Neil Brown wrote:
> This only saves the allocation for two I/O units doesn't it?  So not a
> big saveding, but still a good clean-up.

Yes.

> > r5l_do_reclaim as a side effect: previous if took the last unit which
> > isn't checkpointed into account.
> 
> It took me a while to see that - so just to be sure I understand.
> 
> There is a list of I/O units which have been completely written to the
> log and to the RAID.  The last one of these is used as a marker for the
> start of the log, so it cannot be freed yet.  All the earlier ones can
> be freed.
> The previous code added up the sizes of all of the units in this list,
> so it incorrectly included that last unit.
> Your new code calculates the difference between the start of the first
> unit and the start of the last unit, and so correctly excluded the last
> unit from the free space calculation.
> 
> Did I get that right?

You did - or at very least your understanding matches my understanding of
the old code.

> > +		md_wakeup_thread(log->rdev->mddev->thread);
> > +		wait_event_lock_irq(log->iounit_wait,
> > +				    r5l_reclaimable_space(log) > reclaimable,
> > +				    log->io_list_lock);
> >  	}
> 
> This is ringing warning bells....  I'm not sure it's wrong, but I'm not
> sure it is right.
> I feel that if the thread gets woken and finds that
> r5l_reclaimable_space is still too low, it should wake up the thread
> again, just in case.
> Also, it should test against reclaim_target, not reclaimable, shouldn't
> it?
> 
> Instead of a wait_event_lock_irq inside a loop, could we just have a
> wake_event_*??
> 
> wait_event_lock_irq_cmd(log->iounit_wait,
>                         r5l_reclaimable_space(log) >= reclaim_target ||
>                         (list_empty() && .... list_empty()),
>                         log->io_list_lock,
>                         md_wakeup_thread(log->rdev->mddev->thread));
> 
> ??
> 
> 
> Otherwise I like it.  Thanks.

I agree with a lot of your points, but I tried to match the old behavior
as close as possible.  I can change it to something closer to your
suggestion if Shaohua agrees.
