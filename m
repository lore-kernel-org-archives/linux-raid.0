From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: introduce new personality funciton start()
Date: Thu, 16 Nov 2017 08:35:44 -0800
Message-ID: <20171116163544.z3kf23tybcvjbsqi@kernel.org>
References: <20171114230010.1593130-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171114230010.1593130-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, kernel-team@fb.com, neilb@suse.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

On Tue, Nov 14, 2017 at 03:00:10PM -0800, Song Liu wrote:
> In do_md_run(), md threads should not wake up until the array is fully
> initialized in md_run(). However, in raid5_run(), raid5-cache may wake
> up mddev->thread to flush stripes that need to be written back. This
> design doesn't break badly right now. But it could lead to bad bug in
> the future.
> 
> This patch tries to resolve this problem by splitting start up work
> into two personality functions, run() and start(). Tasks that do not
> require the md threads should go into run(), while task that require
> the md threads go into start().
> 
> r5l_load_log() is moved to raid5_start(), so it is not called until
> the md threads are started in do_md_run().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/md.c          | 14 +++++++++-----
>  drivers/md/md.h          |  5 +++++
>  drivers/md/raid5-cache.c | 22 +++++++++++++++++-----
>  drivers/md/raid5-log.h   |  1 +
>  drivers/md/raid5.c       | 10 ++++++++++
>  5 files changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e014d39..6e816db 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5561,11 +5561,6 @@ int md_run(struct mddev *mddev)
>  	if (start_readonly && mddev->ro == 0)
>  		mddev->ro = 2; /* read-only, but switch on first write */
>  
> -	/*
> -	 * NOTE: some pers->run(), for example r5l_recovery_log(), wakes
> -	 * up mddev->thread. It is important to initialize critical
> -	 * resources for mddev->thread BEFORE calling pers->run().
> -	 */
>  	err = pers->run(mddev);
>  	if (err)
>  		pr_warn("md: pers->run() failed ...\n");
> @@ -5682,6 +5677,15 @@ static int do_md_run(struct mddev *mddev)
>  	md_wakeup_thread(mddev->thread);
>  	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */

I think we should prevent reshape/recovery run at current stage, because log
isn't recovered yet.
 
> +	/* run start up tasks that require md threads */
> +	if (mddev->pers->start) {
> +		err = mddev->pers->start(mddev);
> +		if (err) {
> +			bitmap_destroy(mddev);
> +			goto out;
> +		}
> +	}
> +
>  	set_capacity(mddev->gendisk, mddev->array_sectors);
>  	revalidate_disk(mddev->gendisk);
>  	mddev->changed = 1;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 7d6bcf0..34fefcb 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -523,7 +523,12 @@ struct md_personality
>  	struct list_head list;
>  	struct module *owner;
>  	bool (*make_request)(struct mddev *mddev, struct bio *bio);
> +	/* start up works that do NOT require md threads. tasks that
> +	 * requires md threads should go into start()
> +	 */
>  	int (*run)(struct mddev *mddev);
> +	/* start up works that require md threads */
> +	int (*start)(struct mddev *mddev);
>  	void (*free)(struct mddev *mddev, void *priv);
>  	void (*status)(struct seq_file *seq, struct mddev *mddev);
>  	/* error_handler must set ->faulty and clear ->in_sync
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index f1c86d9..6e28adc 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2448,7 +2448,6 @@ static void r5c_recovery_flush_data_only_stripes(struct r5l_log *log,
>  		raid5_release_stripe(sh);
>  	}
>  
> -	md_wakeup_thread(conf->mddev->thread);
>  	/* reuse conf->wait_for_quiescent in recovery */
>  	wait_event(conf->wait_for_quiescent,
>  		   atomic_read(&conf->active_stripes) == 0);
> @@ -3040,6 +3039,23 @@ static int r5l_load_log(struct r5l_log *log)
>  	return ret;
>  }
>  
> +int r5l_start(struct r5l_log *log)
> +{
> +	int ret;
> +
> +	if (!log)
> +		return 0;
> +
> +	ret = r5l_load_log(log);
> +	if (ret) {
> +		struct mddev *mddev = log->rdev->mddev;
> +		struct r5conf *conf = mddev->private;
> +
> +		r5l_exit_log(conf);
> +	}
> +	return ret;
> +}
> +
>  void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev)
>  {
>  	struct r5conf *conf = mddev->private;
> @@ -3142,13 +3158,9 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
>  
>  	rcu_assign_pointer(conf->log, log);
>  
> -	if (r5l_load_log(log))
> -		goto error;
> -
>  	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
>  	return 0;
>  
> -error:
>  	rcu_assign_pointer(conf->log, NULL);
>  	md_unregister_thread(&log->reclaim_thread);
>  reclaim_thread:
> diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
> index c3596a2..d8577b0 100644
> --- a/drivers/md/raid5-log.h
> +++ b/drivers/md/raid5-log.h
> @@ -31,6 +31,7 @@ extern struct md_sysfs_entry r5c_journal_mode;
>  extern void r5c_update_on_rdev_error(struct mddev *mddev,
>  				     struct md_rdev *rdev);
>  extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
> +extern int r5l_start(struct r5l_log *log);
>  
>  extern struct dma_async_tx_descriptor *
>  ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 1649e82..39cdd78 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8364,6 +8364,13 @@ static int raid5_change_consistency_policy(struct mddev *mddev, const char *buf)
>  	return err;
>  }
>  
> +static int raid5_start(struct mddev *mddev)
> +{
> +	struct r5conf *conf = mddev->private;
> +
> +	return r5l_start(conf->log);
> +}

Cc: Artur, do we need this for raid5-ppl?

>  static struct md_personality raid6_personality =
>  {
>  	.name		= "raid6",
> @@ -8371,6 +8378,7 @@ static struct md_personality raid6_personality =
>  	.owner		= THIS_MODULE,
>  	.make_request	= raid5_make_request,
>  	.run		= raid5_run,
> +	.start		= raid5_start,
>  	.free		= raid5_free,
>  	.status		= raid5_status,
>  	.error_handler	= raid5_error,
> @@ -8395,6 +8403,7 @@ static struct md_personality raid5_personality =
>  	.owner		= THIS_MODULE,
>  	.make_request	= raid5_make_request,
>  	.run		= raid5_run,
> +	.start		= raid5_start,
>  	.free		= raid5_free,
>  	.status		= raid5_status,
>  	.error_handler	= raid5_error,
> @@ -8420,6 +8429,7 @@ static struct md_personality raid4_personality =
>  	.owner		= THIS_MODULE,
>  	.make_request	= raid5_make_request,
>  	.run		= raid5_run,
> +	.start		= raid5_start,
>  	.free		= raid5_free,
>  	.status		= raid5_status,
>  	.error_handler	= raid5_error,
> -- 
> 2.9.5
> 
