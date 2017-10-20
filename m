From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 1/5 v2] md: always hold reconfig_mutex when calling
 mddev_suspend()
Date: Thu, 19 Oct 2017 21:37:57 -0700
Message-ID: <20171020042820.iredht4f7lvatdst@kernel.org>
References: <150820826980.1646.6380214598725492144.stgit@noble>
 <150820840340.1646.12365558035859364361.stgit@noble>
 <20171018061107.42kpztc3nbnhbavi@kernel.org>
 <87efq0j4d2.fsf@notabene.neil.brown.name>
 <87lgk8gcmb.fsf@notabene.neil.brown.name>
 <20171019034420.sdxvirpv454vgx4h@kernel.org>
 <8760bbhcql.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8760bbhcql.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 19, 2017 at 05:29:22PM +1100, Neil Brown wrote:
> On Wed, Oct 18 2017, Shaohua Li wrote:
> 
> > On Thu, Oct 19, 2017 at 12:17:16PM +1100, Neil Brown wrote:
> >> 
> >> Most often mddev_suspend() is called with
> >> reconfig_mutex held.  Make this a requirement in
> >> preparation a subsequent patch.  Also require
> >> reconfig_mutex to be held for mddev_resume(),
> >> partly for symmetry and partly to guarantee
> >> no races with incr/decr of mddev->suspend.
> >> 
> >> Taking the mutex in r5c_disable_writeback_async() is
> >> a little tricky as this is called from a work queue
> >> via log->disable_writeback_work, and flush_work()
> >> is called on that while holding ->reconfig_mutex.
> >> If the work item hasn't run before flush_work()
> >> is called, the work function will not be able to
> >> get the mutex.
> >> 
> >> So we use mddev_trylock() inside the wait_event() call, and have that
> >> abort when conf->log is set to NULL, which happens before
> >> flush_work() is called.
> >> We wait in mddev->sb_wait and ensure this is woken
> >> when any of the conditions change.  This requires
> >> waking mddev->sb_wait in mddev_unlock().  This is only
> >> like to trigger extra wake_ups of threads that needn't
> >> be woken when metadata is being written, and that
> >> doesn't happen often enough that the cost would be
> >> noticeable.
> >> 
> >> Signed-off-by: NeilBrown <neilb@suse.com>
> >
> > --snip--
> >
> > Applied the other patches in the series including the 'remove quiesce(2)' one.
> 
> Thanks.
> 
> >
> >> index 0b7406ac8ce1..6a631dd21f0b 100644
> >> --- a/drivers/md/raid5-cache.c
> >> +++ b/drivers/md/raid5-cache.c
> >> @@ -693,6 +693,8 @@ static void r5c_disable_writeback_async(struct work_struct *work)
> >>  	struct r5l_log *log = container_of(work, struct r5l_log,
> >>  					   disable_writeback_work);
> >>  	struct mddev *mddev = log->rdev->mddev;
> >> +	struct r5conf *conf = mddev->private;
> >> +	int locked = 0;
> >>  
> >>  	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
> >>  		return;
> >> @@ -701,11 +703,15 @@ static void r5c_disable_writeback_async(struct work_struct *work)
> >>  
> >>  	/* wait superblock change before suspend */
> >>  	wait_event(mddev->sb_wait,
> >> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> >> -
> >> -	mddev_suspend(mddev);
> >> -	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> >> -	mddev_resume(mddev);
> >> +		   conf->log == NULL ||
> >> +		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
> >> +		    (locked = mddev_trylock(mddev))));
> >> +	if (locked) {
> >> +		mddev_suspend(mddev);
> >> +		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> >> +		mddev_resume(mddev);
> >> +		mddev_unlock(mddev);
> >> +	}
> >
> > For this one, my point is:
> >
> > 	wait_event(mddev->sb_wait, conf->log == NULL ||
> > 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> > 	if (conf->log == NULL)
> > 		return;
> >
> > 	mddev_suspend(mddev);
> > 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> > 	mddev_resume(mddev);
> >
> > does it work?
> 
> The
> 	lockdep_assert_held(&mddev->reconfig_mutex);
> in mddev_suspend() will complain.
> 
> If you put an mddev_lock() call in there to stop the complaint, and if
> the work item doesn't start before the reconfig_mutex is taken prior to
> stopping the array, then r5l_exit_log() can deadlock at
> 	flush_work(&log->disable_writeback_work);

Ok, got it now. But really don't like this patch. The mddev_unlock is strange,
r5c_disable_writeback_async could skip disabling writeback too. Could we add a
new callback like .prepare_free, and flush workqueue there. After we drop the
reconfig_mutex in do_md_stop, we call the prepare_free. We can probably set a
flag, so later r5c_disable_writeback_async will bail out doing nothing. I think
this should work, right?

Thanks,
Shaohua
