From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 08/34] md/raid5: replace sh->lock with an 'active' flag.
Date: Fri, 22 Jul 2011 13:27:36 +0900
Message-ID: <87hb6fdjnr.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.96772.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023225.6728.96772.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:25 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> sh->lock is now mainly used to ensure that two threads aren't running
> in the locked part of handle_stripe[56] at the same time.
>
> That can more neatly be achieved with an 'active' flag which we set
> while running handle_stripe.  If we find the flag is set, we simply
> requeue the stripe for later by setting STRIPE_HANDLE.
>
> For safety we take ->device_lock while examining the state of the
> stripe and creating a summary in 'stripe_head_state / r6_state'.
> This possibly isn't needed but as shared fields like ->toread,
> ->towrite are checked it is safer for now at least.
>
> We leave the label after the old 'unlock' called "unlock" because it
> will disappear in a few patches, so renaming seems pointless.
>
> This leaves the stripe 'locked' for longer as we clear STRIPE_ACTIVE
> later, but that is not a problem.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

But I have a question, please see below.


> ---
>
>  drivers/md/raid5.c |   26 +++++++++++++-------------
>  drivers/md/raid5.h |    2 +-
>  2 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9985138..f8275b5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1020,14 +1020,12 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
>  		if (test_and_clear_bit(R5_Wantdrain, &dev->flags)) {
>  			struct bio *wbi;
>  
> -			spin_lock(&sh->lock);
>  			spin_lock_irq(&sh->raid_conf->device_lock);
>  			chosen = dev->towrite;
>  			dev->towrite = NULL;
>  			BUG_ON(dev->written);
>  			wbi = dev->written = chosen;
>  			spin_unlock_irq(&sh->raid_conf->device_lock);
> -			spin_unlock(&sh->lock);
>  
>  			while (wbi && wbi->bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
> @@ -1322,7 +1320,6 @@ static int grow_one_stripe(raid5_conf_t *conf)
>  		return 0;
>  
>  	sh->raid_conf = conf;
> -	spin_lock_init(&sh->lock);
>  	#ifdef CONFIG_MULTICORE_RAID456
>  	init_waitqueue_head(&sh->ops.wait_for_ops);
>  	#endif
> @@ -1442,7 +1439,6 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
>  			break;
>  
>  		nsh->raid_conf = conf;
> -		spin_lock_init(&nsh->lock);
>  		#ifdef CONFIG_MULTICORE_RAID456
>  		init_waitqueue_head(&nsh->ops.wait_for_ops);
>  		#endif
> @@ -2148,7 +2144,6 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
>  		(unsigned long long)sh->sector);
>  
>  
> -	spin_lock(&sh->lock);
>  	spin_lock_irq(&conf->device_lock);
>  	if (forwrite) {
>  		bip = &sh->dev[dd_idx].towrite;
> @@ -2184,7 +2179,6 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
>  			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
>  	}
>  	spin_unlock_irq(&conf->device_lock);
> -	spin_unlock(&sh->lock);
>  
>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
>  		(unsigned long long)(*bip)->bi_sector,
> @@ -2201,7 +2195,6 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
>   overlap:
>  	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
>  	spin_unlock_irq(&conf->device_lock);
> -	spin_unlock(&sh->lock);
>  	return 0;
>  }
>  
> @@ -3023,12 +3016,10 @@ static void handle_stripe5(struct stripe_head *sh)
>  		 atomic_read(&sh->count), sh->pd_idx, sh->check_state,
>  		 sh->reconstruct_state);
>  
> -	spin_lock(&sh->lock);
>  	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
>  		set_bit(STRIPE_SYNCING, &sh->state);
>  		clear_bit(STRIPE_INSYNC, &sh->state);
>  	}
> -	clear_bit(STRIPE_HANDLE, &sh->state);
>  	clear_bit(STRIPE_DELAYED, &sh->state);
>  
>  	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
> @@ -3037,6 +3028,7 @@ static void handle_stripe5(struct stripe_head *sh)
>  
>  	/* Now to look around and see what can be done */
>  	rcu_read_lock();
> +	spin_lock_irq(&conf->device_lock);

Do we still need rcu_read_lock()? AFAIK rcu_read_lock() only prevents
task from preemption but spin_lock does same thing as well.

I know it's been already there under sh->lock before this patch, and
it doesn't hurt anything, but I'm not sure it is really needed.


>  	for (i=disks; i--; ) {
>  		mdk_rdev_t *rdev;
>  
> @@ -3099,6 +3091,7 @@ static void handle_stripe5(struct stripe_head *sh)
>  			s.failed_num = i;
>  		}
>  	}
> +	spin_unlock_irq(&conf->device_lock);
>  	rcu_read_unlock();
>  
>  	if (unlikely(blocked_rdev)) {
> @@ -3275,7 +3268,6 @@ static void handle_stripe5(struct stripe_head *sh)
>  		handle_stripe_expansion(conf, sh, NULL);
>  
>   unlock:
> -	spin_unlock(&sh->lock);
>  
>  	/* wait for this device to become unblocked */
>  	if (unlikely(blocked_rdev))
> @@ -3318,12 +3310,10 @@ static void handle_stripe6(struct stripe_head *sh)
>  	       sh->check_state, sh->reconstruct_state);
>  	memset(&s, 0, sizeof(s));
>  
> -	spin_lock(&sh->lock);
>  	if (test_and_clear_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
>  		set_bit(STRIPE_SYNCING, &sh->state);
>  		clear_bit(STRIPE_INSYNC, &sh->state);
>  	}
> -	clear_bit(STRIPE_HANDLE, &sh->state);
>  	clear_bit(STRIPE_DELAYED, &sh->state);
>  
>  	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
> @@ -3332,6 +3322,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  	/* Now to look around and see what can be done */
>  
>  	rcu_read_lock();
> +	spin_lock_irq(&conf->device_lock);

Same here.


>  	for (i=disks; i--; ) {
>  		mdk_rdev_t *rdev;
>  		dev = &sh->dev[i];
> @@ -3395,6 +3386,7 @@ static void handle_stripe6(struct stripe_head *sh)
>  			s.failed++;
>  		}
>  	}
> +	spin_unlock_irq(&conf->device_lock);
>  	rcu_read_unlock();
>  
>  	if (unlikely(blocked_rdev)) {
> @@ -3580,7 +3572,6 @@ static void handle_stripe6(struct stripe_head *sh)
>  		handle_stripe_expansion(conf, sh, &r6s);
>  
>   unlock:
> -	spin_unlock(&sh->lock);
>  
>  	/* wait for this device to become unblocked */
>  	if (unlikely(blocked_rdev))
> @@ -3608,10 +3599,19 @@ static void handle_stripe6(struct stripe_head *sh)
>  
>  static void handle_stripe(struct stripe_head *sh)
>  {
> +	clear_bit(STRIPE_HANDLE, &sh->state);
> +	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
> +		/* already being handled, ensure it gets handled
> +		 * again when current action finishes */
> +		set_bit(STRIPE_HANDLE, &sh->state);
> +		return;
> +	}
> +
>  	if (sh->raid_conf->level == 6)
>  		handle_stripe6(sh);
>  	else
>  		handle_stripe5(sh);
> +	clear_bit(STRIPE_ACTIVE, &sh->state);
>  }
>  
>  static void raid5_activate_delayed(raid5_conf_t *conf)
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index a330011..217a9d4 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -209,7 +209,6 @@ struct stripe_head {
>  	short			ddf_layout;/* use DDF ordering to calculate Q */
>  	unsigned long		state;		/* state flags */
>  	atomic_t		count;	      /* nr of active thread/requests */
> -	spinlock_t		lock;
>  	int			bm_seq;	/* sequence number for bitmap flushes */
>  	int			disks;		/* disks in stripe */
>  	enum check_states	check_state;
> @@ -290,6 +289,7 @@ struct r6_state {
>   * Stripe state
>   */
>  enum {
> +	STRIPE_ACTIVE,
>  	STRIPE_HANDLE,
>  	STRIPE_SYNC_REQUESTED,
>  	STRIPE_SYNCING,
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
