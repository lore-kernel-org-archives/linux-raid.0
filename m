From: Shaohua Li <shli@kernel.org>
Subject: Re: Low RAID10 performance during resync
Date: Fri, 10 Jun 2016 09:33:37 -0700
Message-ID: <20160610163337.GB24001@kernel.org>
References: <20160609134555.GA9104@proton.igk.intel.com>
 <20160609173118.GA17207@kernel.org>
 <87k2hxmsgz.fsf@notabene.neil.brown.name>
 <20160610144549.GA4251@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160610144549.GA4251@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 10, 2016 at 04:45:49PM +0200, Tomasz Majchrzak wrote:
> On Fri, Jun 10, 2016 at 05:08:12PM +1000, NeilBrown wrote:
> > On Fri, Jun 10 2016, Shaohua Li wrote:
> > 
> > > On Thu, Jun 09, 2016 at 03:45:55PM +0200, Tomasz Majchrzak wrote:
> > >> A low performance of mkfs has been observed on RAID10 array during resync. It
> > >> is not so significant for NVMe drives but for my setup of RAID10 consisting
> > >> of 4 SATA drives format time has increased by 200%.
> > >> 
> > >> I have looked into the problem and I have found out it is caused by this
> > >> changeset:
> > >> 
> > >> commit 09314799e4f0589e52bafcd0ca3556c60468bc0e md: remove 'go_faster' option
> > >> from ->sync_request()
> > >> 
> > >> It seemed the code had been redundant and could be safely removed due to
> > >> barriers mechanism but it proved otherwise. The barriers don't provide enough
> > >> throttle to resync IOs. They only assure non-resync IOs and resync IOs are
> > >> not being executed at the same time. In result resync IOs take around 25% of
> > >> CPU time, mostly because there are many of them but only one at a time so a
> > >> lot of CPU time is simply wasted waiting for a single IO to complete.
> > >> 
> > >> The removed sleep call in resync IO had allowed a lot of non-resync activity
> > >> to be scheduled (nobody waiting for a barrier). Once sleep call had ended,
> > >> resync IO had to wait longer to raise a barrier as all non-resync activity
> > >> had to be completed first. It had nicely throttled a number of resync IOs in
> > >> favour of non-resync activity. Since we lack it now, the performance has
> > >> dropped badly.
> > >> 
> > >> I would like to revert the changeset. We don't have to put a resync IO to
> > >> sleep for a second though. I have done some testing and it seems even a delay
> > >> of 100ms is sufficient. It slows down resync IOs to the same extent as sleep
> > >> for a second - the sleep call ends sooner but the barrier cannot be raised
> > >> until non-resync IOs complete.
> > >
> > > Add Neil.
> > >
> > > I'd like to make sure I understand the situation. With the change reverted, we
> > > dispatch a lot of normal IO and then do a resync IO. Without it reverted, we
> > > dispatch few normal IO and then do a resync IO. In other words, we don't batch
> > > normal IO currently. Is this what you say?
> > >
> > > Agree the barrier doesn't throttle resync IOs, it only assures normal IO and
> > > resync IO run in different time.
> 
> Yes, precisely, resync is faster. The problem is performance drop from user
> perspective is too big.
> 
> > 
> > I think the barrier mechanism will mostly let large batches of IO
> > through as a match.  If there is a pending request, a new request will
> > always be let straight through.  Resync needs to wait for all pending
> > regular IO to complete before it gets a turn.
> > 
> > So I would only expect that patch to cause problems when IO is very
> > synchronous: write, wait, write, wait, etc.
> > 
> > I really didn't like the "go_faster" mechanism, but it might be OK to
> > have something like
> >   if (conf->nr_waiting)
> >       schedule_timeout_uninterruptible(1);
> > 
> > so it will wait one jiffie if there is normal IO.  This would batch this
> > a lot more.
> > 
> > It is very hard to know the exact consequences of this sort of change on
> > all different configurations, and the other commit you mentioned shows.
> > 
> > I keep thinking there must be a better way, but I haven't found it yet
> > :-(
> > 
> > NeilBrown
> > 
> > 
> > >
> > > On the other hand, the change makes resync faster. Did you try to revert this one:
> > > ac8fa4196d205ac8fff3f8932bddbad4f16e4110
> > > If resync is fast, reverting this one will throttle resync.
> > >
> > > Thanks,
> > > Shaohua
> 
> I reverted it and it brought performance to the initial level. It's not a
> solution though, isn't it?
> 
> I have incorrectly reported current performance drop. At the moment mkfs on my
> setup takes around 20 minutes. Before the change it used to take 1 min 20 secs.
> 
> I have checked Neil's proposal (schedule_timeout_uninterruptible for 1 jiffies)
> - it would bring formatting time to 2 mins 16 secs - so it's a valid solution to
> the problem.
> 
> I have also tried other approach. Neil has mentioned that pending requests will
> be let straight through if there are requests already in progress. Well, the
> code looks so, however current->bio_list is empty most of the time, even though
> the requests are being processed. I added an extra time window which allows
> requests to proceed, even though there is a barrier awaiting already. It brings
> mkfs performance to the initial level (1 min 20 secs).
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e3fd725..51caf87 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -916,6 +916,8 @@ static void raise_barrier(struct r10conf *conf, int force)
>  			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
>  			    conf->resync_lock);
>  
> +	conf->last_resync_time = jiffies;
> +
>  	spin_unlock_irq(&conf->resync_lock);
>  }
>  
> @@ -945,8 +947,9 @@ static void wait_barrier(struct r10conf *conf)
>  		wait_event_lock_irq(conf->wait_barrier,
>  				    !conf->barrier ||
>  				    (conf->nr_pending &&
> -				     current->bio_list &&
> -				     !bio_list_empty(current->bio_list)),
> +				     ((current->bio_list &&
> +				       !bio_list_empty(current->bio_list)) ||
> +				      (jiffies - conf->last_resync_time) < HZ / 20)),
>  				    conf->resync_lock);
>  		conf->nr_waiting--;
>  	}
> 
> Please tell me if you prefer Neil's or my solution.

Thanks for the testing. So we have several potential solutions:
revert ac8fa4196d205ac8fff3f8932bddbad4f16e4110
revert 09314799e4f0589e52bafcd0ca3556c60468bc0e
Neil's proposal and your proposal

either one will workaround this issue. In the long term, I'd like to fix the
ac8fa4196d20. but this is a hard problem, I don't have a clear picture of the
impact of those fixes. For an immediate solution, I'd prefer Neil's proposal,
which is simple and a kind of revert of original patch. Probably we should do
the same for raid1 too.

Thanks,
Shaohua
