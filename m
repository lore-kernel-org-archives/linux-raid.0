From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 1/5 v2] md: always hold reconfig_mutex when calling
 mddev_suspend()
Date: Wed, 18 Oct 2017 20:45:38 -0700
Message-ID: <20171019034420.sdxvirpv454vgx4h@kernel.org>
References: <150820826980.1646.6380214598725492144.stgit@noble>
 <150820840340.1646.12365558035859364361.stgit@noble>
 <20171018061107.42kpztc3nbnhbavi@kernel.org>
 <87efq0j4d2.fsf@notabene.neil.brown.name>
 <87lgk8gcmb.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgk8gcmb.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 19, 2017 at 12:17:16PM +1100, Neil Brown wrote:
> 
> Most often mddev_suspend() is called with
> reconfig_mutex held.  Make this a requirement in
> preparation a subsequent patch.  Also require
> reconfig_mutex to be held for mddev_resume(),
> partly for symmetry and partly to guarantee
> no races with incr/decr of mddev->suspend.
> 
> Taking the mutex in r5c_disable_writeback_async() is
> a little tricky as this is called from a work queue
> via log->disable_writeback_work, and flush_work()
> is called on that while holding ->reconfig_mutex.
> If the work item hasn't run before flush_work()
> is called, the work function will not be able to
> get the mutex.
> 
> So we use mddev_trylock() inside the wait_event() call, and have that
> abort when conf->log is set to NULL, which happens before
> flush_work() is called.
> We wait in mddev->sb_wait and ensure this is woken
> when any of the conditions change.  This requires
> waking mddev->sb_wait in mddev_unlock().  This is only
> like to trigger extra wake_ups of threads that needn't
> be woken when metadata is being written, and that
> doesn't happen often enough that the cost would be
> noticeable.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>

--snip--

Applied the other patches in the series including the 'remove quiesce(2)' one.

> index 0b7406ac8ce1..6a631dd21f0b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -693,6 +693,8 @@ static void r5c_disable_writeback_async(struct work_struct *work)
>  	struct r5l_log *log = container_of(work, struct r5l_log,
>  					   disable_writeback_work);
>  	struct mddev *mddev = log->rdev->mddev;
> +	struct r5conf *conf = mddev->private;
> +	int locked = 0;
>  
>  	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
>  		return;
> @@ -701,11 +703,15 @@ static void r5c_disable_writeback_async(struct work_struct *work)
>  
>  	/* wait superblock change before suspend */
>  	wait_event(mddev->sb_wait,
> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> -
> -	mddev_suspend(mddev);
> -	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> -	mddev_resume(mddev);
> +		   conf->log == NULL ||
> +		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
> +		    (locked = mddev_trylock(mddev))));
> +	if (locked) {
> +		mddev_suspend(mddev);
> +		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> +		mddev_resume(mddev);
> +		mddev_unlock(mddev);
> +	}

For this one, my point is:

	wait_event(mddev->sb_wait, conf->log == NULL ||
		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
	if (conf->log == NULL)
		return;

	mddev_suspend(mddev);
	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
	mddev_resume(mddev);

does it work?

>  }
>  
>  static void r5l_submit_current_io(struct r5l_log *log)
> @@ -3165,6 +3171,8 @@ void r5l_exit_log(struct r5conf *conf)
>  	conf->log = NULL;
>  	synchronize_rcu();
>  
> +	/* Ensure disable_writeback_work wakes up and exits */
> +	wake_up(&conf->mddev->sb_wait);
>  	flush_work(&log->disable_writeback_work);
>  	md_unregister_thread(&log->reclaim_thread);
>  	mempool_destroy(log->meta_pool);
> -- 
> 2.14.0.rc0.dirty
> 


