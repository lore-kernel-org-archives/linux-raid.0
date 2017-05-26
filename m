From: Shaohua Li <shli@fb.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on
 md_attr_store / raid5_make_request
Date: Fri, 26 May 2017 09:40:48 -0700
Message-ID: <20170526164048.sua3i46mlcidud2e@kernel.org>
References: <87lgppz221.fsf@esperi.org.uk>
 <87a865jf9a.fsf@notabene.neil.brown.name>
 <87fufwy3lr.fsf@esperi.org.uk>
 <87poezhwsa.fsf@notabene.neil.brown.name>
 <20170524225735.555dpfe24mi6yxrb@kernel.org>
 <877f15iuzf.fsf@notabene.neil.brown.name>
 <20170525014647.vwauunwyizjpdl5i@kernel.org>
 <87inkogv39.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87inkogv39.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 26, 2017 at 01:23:06PM +1000, Neil Brown wrote:
> On Wed, May 24 2017, Shaohua Li wrote:
> 
> > On Thu, May 25, 2017 at 11:30:12AM +1000, Neil Brown wrote:
> >> On Wed, May 24 2017, Shaohua Li wrote:
> >> 
> >> > On Wed, May 24, 2017 at 11:24:21AM +1000, Neil Brown wrote:
> >> >> 
> >> >> 
> >> >> 
> >> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> >> index 10367ffe92e3..a7b9c0576479 100644
> >> >> --- a/drivers/md/md.c
> >> >> +++ b/drivers/md/md.c
> >> >> @@ -324,8 +324,12 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
> >> >>  void mddev_suspend(struct mddev *mddev)
> >> >>  {
> >> >>  	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
> >> >> +
> >> >>  	if (mddev->suspended++)
> >> >>  		return;
> >> >> +#ifdef CONFIG_LOCKDEP
> >> >> +	WARN_ON_ONCE(debug_locks && lockdep_is_held(&mddev->reconfig_mutex));
> >> >> +#endif
> >> >>  	synchronize_rcu();
> >> >>  	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
> >> >>  	mddev->pers->quiesce(mddev, 1);
> >> >> @@ -3594,9 +3598,12 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
> >> >>  	if (slen == 0 || slen >= sizeof(clevel))
> >> >>  		return -EINVAL;
> >> >>  
> >> >> +	mddev_suspend(mddev);
> >> >>  	rv = mddev_lock(mddev);
> >> >> -	if (rv)
> >> >> +	if (rv) {
> >> >> +		mddev_resume(mddev);
> >> >>  		return rv;
> >> >> +	}
> >> >>  
> >> >>  	if (mddev->pers == NULL) {
> >> >>  		strncpy(mddev->clevel, buf, slen);
> >> >> @@ -3687,7 +3694,6 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
> >> >>  	}
> >> >>  
> >> >>  	/* Looks like we have a winner */
> >> >> -	mddev_suspend(mddev);
> >> >>  	mddev_detach(mddev);
> >> >>  
> >> >>  	spin_lock(&mddev->lock);
> >> >> @@ -3771,13 +3777,13 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
> >> >>  	blk_set_stacking_limits(&mddev->queue->limits);
> >> >>  	pers->run(mddev);
> >> >>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> >> >> -	mddev_resume(mddev);
> >> >>  	if (!mddev->thread)
> >> >>  		md_update_sb(mddev, 1);
> >> >>  	sysfs_notify(&mddev->kobj, NULL, "level");
> >> >>  	md_new_event(mddev);
> >> >>  	rv = len;
> >> >>  out_unlock:
> >> >> +	mddev_resume(mddev);
> >> >>  	mddev_unlock(mddev);
> >> >>  	return rv;
> >> >>  }
> >> >> @@ -4490,6 +4496,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
> >> >>  		int err;
> >> >>  		if (mddev->pers->start_reshape == NULL)
> >> >>  			return -EINVAL;
> >> >> +		mddev_suspend(mddev);
> >> >>  		err = mddev_lock(mddev);
> >> >>  		if (!err) {
> >> >>  			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> >> >> @@ -4500,6 +4507,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
> >> >>  			}
> >> >>  			mddev_unlock(mddev);
> >> >>  		}
> >> >> +		mddev_resume(mddev);
> >> >>  		if (err)
> >> >>  			return err;
> >> >>  		sysfs_notify(&mddev->kobj, NULL, "degraded");
> >> >
> >> > The analysis makes a lot of sense, thanks! The patch looks not solving the
> >> > problem though, because check_recovery will not write super if suspended isn't
> >> > 0.
> >> 
> >> Why does that matter?  In what case do you need the superblock to be
> >> written, but it doesn't happen.
> >> 
> >> check_recovery won't write the superblock while the mddev is locked
> >> either, and it is locked for most of level_store().
> >> When level_store() finished, it unlocks the device and that will trigger
> >> md_check_recovery() to be run, and the metadata will be written then.
> >> I don't think there is a particular need to update it before then.
> >
> > I get confused. md_write_start is waiting for MD_SB_CHANGE_PENDING cleared,
> > which is done in check_recovery. Your previous email describes this too.
> 
> Uhmm.... yes.  I see your point now.  Maybe we need might first patch as
> well, so md_check_recovery() can still update the superblock after
> ->suspended is set.
> 
> However, I starting looking at making sure mddev_suspend() was never
> called with mddev_lock() held, and that isn't straight forward.
> Most callers of mddev_suspend() do hold the lock.
> The only exceptions I found were:
>   dm-raid.c in raid_postsuspend()
>   raid5-cache.c in r5c_disable_writeback_async() and
>   r5c_journal_mode_set().
> 
> It might be easiest to change all of those to lock the mddev, then
> do the md_update_sb in mddev_suspend, when needed.
> 
> i.e. something like the following.  Thoughts?

Looks reasonable. why not hold the lock for mddev_resume too for dm-raid.c, at
least it protects ->suspended. The dm-raid.c is a little unformatable though,
other places always do lock, suspend, resume, unlock. The dm-raid is an
exception. Not quite sure if this is a problem though.

While this fix should work well, did you consider my previous proposal, which
should work I think and looks simplier.

Thanks,
Shaohua

> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 7d893228c40f..db79bd22418b 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3607,8 +3607,11 @@ static void raid_postsuspend(struct dm_target *ti)
>  {
>  	struct raid_set *rs = ti->private;
>  
> -	if (!rs->md.suspended)
> +	if (!rs->md.suspended) {
> +		mddev_lock_nointr(&rs->md);
>  		mddev_suspend(&rs->md);
> +		mddev_unlock(&rs->md);
> +	}
>  
>  	rs->md.ro = 1;
>  }
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 10367ffe92e3..6cbb37a7d445 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -320,14 +320,22 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>   * are completely handled.
>   * Once mddev_detach() is called and completes, the module will be
>   * completely unused.
> + * The caller must hold the mddev_lock.
> + * mddev_suspend() will update the superblock if it
> + * turns out that something is waiting in md_write_start().
>   */
>  void mddev_suspend(struct mddev *mddev)
>  {
>  	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
>  	if (mddev->suspended++)
>  		return;
> +	lockdep_assert_held(&mddev->reconfig_mutex);
> +
>  	synchronize_rcu();
> -	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
> +	wait_event_cmd(mddev->sb_wait, atomic_read(&mddev->active_io) == 0,
> +		       if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
> +			       md_update_sb(mddev, 0),
> +		);
>  	mddev->pers->quiesce(mddev, 1);
>  
>  	del_timer_sync(&mddev->safemode_timer);
> @@ -7971,6 +7979,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
>  			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>  			set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>  			md_wakeup_thread(mddev->thread);
> +			wake_up(&mddev->sb_wait);
>  			did_change = 1;
>  		}
>  		spin_unlock(&mddev->lock);
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 4c00bc248287..c231c4a29903 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -682,13 +682,11 @@ static void r5c_disable_writeback_async(struct work_struct *work)
>  	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
>  		mdname(mddev));
>  
> -	/* wait superblock change before suspend */
> -	wait_event(mddev->sb_wait,
> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> -
> +	mddev_lock_nointr(mddev);
>  	mddev_suspend(mddev);
>  	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
>  	mddev_resume(mddev);
> +	mddev_unlock(mddev);
>  }
>  
>  static void r5l_submit_current_io(struct r5l_log *log)
> @@ -2542,6 +2540,7 @@ int r5c_journal_mode_set(struct mddev *mddev, int mode)
>  {
>  	struct r5conf *conf = mddev->private;
>  	struct r5l_log *log = conf->log;
> +	int ret = 0;
>  
>  	if (!log)
>  		return -ENODEV;
> @@ -2550,17 +2549,20 @@ int r5c_journal_mode_set(struct mddev *mddev, int mode)
>  	    mode > R5C_JOURNAL_MODE_WRITE_BACK)
>  		return -EINVAL;
>  
> +	mddev_lock_nointr(mddev);
>  	if (raid5_calc_degraded(conf) > 0 &&
>  	    mode == R5C_JOURNAL_MODE_WRITE_BACK)
> -		return -EINVAL;
> -
> -	mddev_suspend(mddev);
> -	conf->log->r5c_journal_mode = mode;
> -	mddev_resume(mddev);
> +		ret = -EINVAL;
> +	else {
> +		mddev_suspend(mddev);
> +		conf->log->r5c_journal_mode = mode;
> +		mddev_resume(mddev);
>  
> -	pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
> -		 mdname(mddev), mode, r5c_journal_mode_str[mode]);
> -	return 0;
> +		pr_debug("md/raid:%s: setting r5c cache mode to %d: %s\n",
> +			 mdname(mddev), mode, r5c_journal_mode_str[mode]);
> +	}
> +	mddev_unlock(mddev);
> +	return ret;
>  }
>  EXPORT_SYMBOL(r5c_journal_mode_set);
>  


