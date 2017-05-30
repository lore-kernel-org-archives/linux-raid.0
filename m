From: Shaohua Li <shli@kernel.org>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on
 md_attr_store / raid5_make_request
Date: Tue, 30 May 2017 10:41:33 -0700
Message-ID: <20170530174133.qdj2qsopwug2opp6@kernel.org>
References: <87lgppz221.fsf@esperi.org.uk>
 <87a865jf9a.fsf@notabene.neil.brown.name>
 <87fufwy3lr.fsf@esperi.org.uk>
 <87poezhwsa.fsf@notabene.neil.brown.name>
 <20170524225735.555dpfe24mi6yxrb@kernel.org>
 <871sr8h8qx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871sr8h8qx.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 29, 2017 at 09:17:10AM +1000, Neil Brown wrote:
> On Wed, May 24 2017, Shaohua Li wrote:
> 
> > On Wed, May 24, 2017 at 11:24:21AM +1000, Neil Brown wrote:
> >> On Mon, May 22 2017, Nix wrote:
> >> 
> >> > On 22 May 2017, NeilBrown told this:
> >> >
> >> >> Probably something like this:
> >> >>
> >> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> >> index f6ae1d67bcd0..dbca31be22a1 100644
> >> >> --- a/drivers/md/md.c
> >> >> +++ b/drivers/md/md.c
> >> >> @@ -8364,8 +8364,6 @@ static void md_start_sync(struct work_struct *ws)
> >> >>   */
> >> >>  void md_check_recovery(struct mddev *mddev)
> >> >>  {
> >> >> -	if (mddev->suspended)
> >> >> -		return;
> >> >>  
> >> >>  	if (mddev->bitmap)
> >> >>  		bitmap_daemon_work(mddev);
> >> >> @@ -8484,6 +8482,7 @@ void md_check_recovery(struct mddev *mddev)
> >> >>  		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
> >> >>  
> >> >>  		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> >> >> +		    mddev->suspended ||
> >> >>  		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
> >> >>  			goto not_running;
> >> >>  		/* no recovery is running.
> >> >>
> >> >> though it's late so don't trust anything I write.
> >> >>
> >> >> If you try again it will almost certainly succeed.  I suspect this is a
> >> >> hard race to hit - well done!!!
> >> >
> >> > Definitely not a hard race to hit :( I just hit it again with this
> >> > patch.
> >> >
> >> > Absolutely identical hang:
> >> >
> >> > [  495.833520] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> > [  495.840618] mdadm           D    0  2700   2537 0x00000000
> >> > [  495.847762] Call Trace:
> >> > [  495.854825]  __schedule+0x290/0x810
> >> > [  495.861905]  schedule+0x36/0x80
> >> > [  495.868934]  mddev_suspend+0xb3/0xe0
> >> > [  495.875926]  ? wake_atomic_t_function+0x60/0x60
> >> > [  495.882976]  level_store+0x1a7/0x6c0
> >> > [  495.889953]  ? md_ioctl+0xb7/0x1c10
> >> > [  495.896901]  ? putname+0x53/0x60
> >> > [  495.903807]  md_attr_store+0x83/0xc0
> >> > [  495.910684]  sysfs_kf_write+0x37/0x40
> >> > [  495.917547]  kernfs_fop_write+0x110/0x1a0
> >> > [  495.924429]  __vfs_write+0x28/0x120
> >> > [  495.931270]  ? kernfs_iop_get_link+0x172/0x1e0
> >> > [  495.938126]  ? __alloc_fd+0x3f/0x170
> >> > [  495.944906]  vfs_write+0xb6/0x1d0
> >> > [  495.951646]  SyS_write+0x46/0xb0
> >> > [  495.958338]  entry_SYSCALL_64_fastpath+0x13/0x94
> >> >
> >> > Everything else hangs the same way, too. This was surprising enough that
> >> > I double-checked to be sure the patch was applied: it was. I suspect the
> >> > deadlock is somewhat different than you supposed... (and quite possibly
> >> > not a race at all, or I wouldn't be hitting it so consistently, every
> >> > time. I mean, I only need to miss it *once* and I'll have reshaped... :) )
> >> >
> >> > It seems I can reproduce this on demand, so if you want to throw a patch
> >> > with piles of extra printks my way, feel free.
> >> 
> >> Did you have md_write_start being called by syslog-ng again?
> >> I wonder what syslog is logging - presumably something about the reshape
> >> starting.
> >> If you kill syslog-ng, can you start the reshape?
> >> 
> >> Alternately, this might do it.
> >> I think the root problem is that it isn't safe to call mddev_suspend()
> >> while holding the reconfig_mutex.
> >> For complete safety I probably need to move the request_module() call
> >> earlier, as that could block if a device was suspended (no memory
> >> allocation allowed while device is suspended).
> >> 
> >> Thanks,
> >> NeilBrown
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
> >
> > I'm thinking of alternative wayt to fix this issue. A request which stalls in
> > md_write_start reallys isn't an active IO. We could add another counter in
> > md_write_start to record stalled request there. Then in mddev_suspend, wait
> > event will wait for atomic_read(&mddev->active_io) == the_new_counter.
> >
> 
> Sorry I didn't respond to this suggestion earlier.
> 
> It is important that
>    mddev_suspend(mddev)
>    mddev_detach(mddev)
> 
> results in the personality module being unused so it can be removed, as
> module_put() will soon be called.
> If a thread is stuck in md_write_start(), then when it is released it
> will return to the personality's make_request function and will execute
> code in the module.  So we cannot safely remove call module_put() while
> code is blocked in md_write_start().

Ok, I thought md_suspend is only suspending the array. This makes sense,
thanks!

> We could possibly move the md_write_start() call into md_make_request(),
> so the personality code will never block.
> Maybe something like this?
> We probably also need to change all md_write_start() call is modules to
> md_write_inc().

Like this idea very much.

Thanks,
Shaohua
 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 10367ffe92e3..3e45bb429a22 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -277,6 +277,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>  		bio_endio(bio);
>  		return BLK_QC_T_NONE;
>  	}
> +check_suspended:
>  	smp_rmb(); /* Ensure implications of  'active' are visible */
>  	rcu_read_lock();
>  	if (mddev->suspended) {
> @@ -294,6 +295,13 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>  	}
>  	atomic_inc(&mddev->active_io);
>  	rcu_read_unlock();
> +	if (rw == WRITE) {
> +		md_write_start(mddev, bio);
> +		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
> +			md_write_end(mddev);
> +			goto check_suspended;
> +		}
> +	}
>  
>  	/*
>  	 * save the sectors now since our bio can
> @@ -309,6 +317,8 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
>  	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw], sectors);
>  	part_stat_unlock();
>  
> +	md_write_end(mddev);
> +
>  	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
>  		wake_up(&mddev->sb_wait);
>  
> @@ -327,6 +337,7 @@ void mddev_suspend(struct mddev *mddev)
>  	if (mddev->suspended++)
>  		return;
>  	synchronize_rcu();
> +	wake_up(&mddev->sb_wait);
>  	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
>  	mddev->pers->quiesce(mddev, 1);
>  
> @@ -7979,7 +7990,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
>  	if (did_change)
>  		sysfs_notify_dirent_safe(mddev->sysfs_state);
>  	wait_event(mddev->sb_wait,
> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> +		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) && !mddev->suspended);
>  }
>  EXPORT_SYMBOL(md_write_start);
>  


