From: Shaohua Li <shli@kernel.org>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on
 md_attr_store / raid5_make_request
Date: Wed, 24 May 2017 18:46:47 -0700
Message-ID: <20170525014647.vwauunwyizjpdl5i@kernel.org>
References: <87lgppz221.fsf@esperi.org.uk>
 <87a865jf9a.fsf@notabene.neil.brown.name>
 <87fufwy3lr.fsf@esperi.org.uk>
 <87poezhwsa.fsf@notabene.neil.brown.name>
 <20170524225735.555dpfe24mi6yxrb@kernel.org>
 <877f15iuzf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f15iuzf.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 25, 2017 at 11:30:12AM +1000, Neil Brown wrote:
> On Wed, May 24 2017, Shaohua Li wrote:
> 
> > On Wed, May 24, 2017 at 11:24:21AM +1000, Neil Brown wrote:
> >> 
> >> 
> >> 
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 10367ffe92e3..a7b9c0576479 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -324,8 +324,12 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
> >>  void mddev_suspend(struct mddev *mddev)
> >>  {
> >>  	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
> >> +
> >>  	if (mddev->suspended++)
> >>  		return;
> >> +#ifdef CONFIG_LOCKDEP
> >> +	WARN_ON_ONCE(debug_locks && lockdep_is_held(&mddev->reconfig_mutex));
> >> +#endif
> >>  	synchronize_rcu();
> >>  	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
> >>  	mddev->pers->quiesce(mddev, 1);
> >> @@ -3594,9 +3598,12 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
> >>  	if (slen == 0 || slen >= sizeof(clevel))
> >>  		return -EINVAL;
> >>  
> >> +	mddev_suspend(mddev);
> >>  	rv = mddev_lock(mddev);
> >> -	if (rv)
> >> +	if (rv) {
> >> +		mddev_resume(mddev);
> >>  		return rv;
> >> +	}
> >>  
> >>  	if (mddev->pers == NULL) {
> >>  		strncpy(mddev->clevel, buf, slen);
> >> @@ -3687,7 +3694,6 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
> >>  	}
> >>  
> >>  	/* Looks like we have a winner */
> >> -	mddev_suspend(mddev);
> >>  	mddev_detach(mddev);
> >>  
> >>  	spin_lock(&mddev->lock);
> >> @@ -3771,13 +3777,13 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
> >>  	blk_set_stacking_limits(&mddev->queue->limits);
> >>  	pers->run(mddev);
> >>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> >> -	mddev_resume(mddev);
> >>  	if (!mddev->thread)
> >>  		md_update_sb(mddev, 1);
> >>  	sysfs_notify(&mddev->kobj, NULL, "level");
> >>  	md_new_event(mddev);
> >>  	rv = len;
> >>  out_unlock:
> >> +	mddev_resume(mddev);
> >>  	mddev_unlock(mddev);
> >>  	return rv;
> >>  }
> >> @@ -4490,6 +4496,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
> >>  		int err;
> >>  		if (mddev->pers->start_reshape == NULL)
> >>  			return -EINVAL;
> >> +		mddev_suspend(mddev);
> >>  		err = mddev_lock(mddev);
> >>  		if (!err) {
> >>  			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> >> @@ -4500,6 +4507,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
> >>  			}
> >>  			mddev_unlock(mddev);
> >>  		}
> >> +		mddev_resume(mddev);
> >>  		if (err)
> >>  			return err;
> >>  		sysfs_notify(&mddev->kobj, NULL, "degraded");
> >
> > The analysis makes a lot of sense, thanks! The patch looks not solving the
> > problem though, because check_recovery will not write super if suspended isn't
> > 0.
> 
> Why does that matter?  In what case do you need the superblock to be
> written, but it doesn't happen.
> 
> check_recovery won't write the superblock while the mddev is locked
> either, and it is locked for most of level_store().
> When level_store() finished, it unlocks the device and that will trigger
> md_check_recovery() to be run, and the metadata will be written then.
> I don't think there is a particular need to update it before then.

I get confused. md_write_start is waiting for MD_SB_CHANGE_PENDING cleared,
which is done in check_recovery. Your previous email describes this too.

Thanks,
Shaohua
