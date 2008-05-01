From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md: add new / required locking for calls to
	blk_remove_plug and blk_plug_queue
Date: Thu, 1 May 2008 10:36:12 +1000
Message-ID: <18457.4220.20511.737042@notabene.brown>
References: <20080430011826.20468.93265.stgit@dwillia2-linux.ch.intel.com>
	<20080430011943.20468.71869.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday April 29
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 29, dan.j.williams@intel.com wrote:
> Now that queue flags are no longer atomic (commit:
> 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e)  we must protect calls to
> blk_remove_plug with spin_lock(q->queue_lock).

Can't we just do

  q->queue_lock = &conf->device_lock

and appropriate places in the various ->run functions?

It seems to be that we are doing appropriate locking, we just need to
convince queue_flag_set / queue_flag_clear that the correct lock is
locked.
??

NeilBrown


> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  drivers/md/md.c           |    3 +++
>  drivers/md/raid1.c        |   10 ++++++++--
>  drivers/md/raid10.c       |   10 ++++++++--
>  drivers/md/raid5.c        |   12 ++++++++++--
>  include/linux/raid/md_k.h |    3 +++
>  5 files changed, 32 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 606c8ee..e389978 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -283,6 +283,9 @@ static mddev_t * mddev_find(dev_t unit)
>  		kfree(new);
>  		return NULL;
>  	}
> +	spin_lock_init(&new->queue_lock);
> +	new->queue->queue_lock = &new->queue_lock;
> +
>  	/* Can be unlocked because the queue is new: no concurrency */
>  	queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, new->queue);
>  
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6778b7c..79f19b1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -603,9 +603,13 @@ static int flush_pending_writes(conf_t *conf)
>  	spin_lock_irq(&conf->device_lock);
>  
>  	if (conf->pending_bio_list.head) {
> +		struct request_queue *q = conf->mddev->queue;
>  		struct bio *bio;
> +
>  		bio = bio_list_get(&conf->pending_bio_list);
> -		blk_remove_plug(conf->mddev->queue);
> +		spin_lock(q->queue_lock);
> +		blk_remove_plug(q);
> +		spin_unlock(q->queue_lock);
>  		spin_unlock_irq(&conf->device_lock);
>  		/* flush any pending bitmap writes to
>  		 * disk before proceeding w/ I/O */
> @@ -964,7 +968,9 @@ static int make_request(struct request_queue *q, struct bio * bio)
>  	bio_list_merge(&conf->pending_bio_list, &bl);
>  	bio_list_init(&bl);
>  
> -	blk_plug_device(mddev->queue);
> +	spin_lock(q->queue_lock);
> +	blk_plug_device(q);
> +	spin_unlock(q->queue_lock);
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
>  
>  	/* In case raid1d snuck into freeze_array */
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5938fa9..3ecd437 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -646,9 +646,13 @@ static int flush_pending_writes(conf_t *conf)
>  	spin_lock_irq(&conf->device_lock);
>  
>  	if (conf->pending_bio_list.head) {
> +		struct request_queue *q = conf->mddev->queue;
>  		struct bio *bio;
> +
>  		bio = bio_list_get(&conf->pending_bio_list);
> -		blk_remove_plug(conf->mddev->queue);
> +		spin_lock(q->queue_lock);
> +		blk_remove_plug(q);
> +		spin_unlock(q->queue_lock);
>  		spin_unlock_irq(&conf->device_lock);
>  		/* flush any pending bitmap writes to disk
>  		 * before proceeding w/ I/O */
> @@ -955,7 +959,9 @@ static int make_request(struct request_queue *q, struct bio * bio)
>  	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
>  	spin_lock_irqsave(&conf->device_lock, flags);
>  	bio_list_merge(&conf->pending_bio_list, &bl);
> -	blk_plug_device(mddev->queue);
> +	spin_lock(q->queue_lock);
> +	blk_plug_device(q);
> +	spin_unlock(q->queue_lock);
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
>  
>  	/* In case raid10d snuck in to freeze_array */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e057944..b64a545 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -124,17 +124,23 @@ static void print_raid5_conf (raid5_conf_t *conf);
>  
>  static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
>  {
> +	struct request_queue *q = conf->mddev->queue;
> +
>  	if (atomic_dec_and_test(&sh->count)) {
>  		BUG_ON(!list_empty(&sh->lru));
>  		BUG_ON(atomic_read(&conf->active_stripes)==0);
>  		if (test_bit(STRIPE_HANDLE, &sh->state)) {
>  			if (test_bit(STRIPE_DELAYED, &sh->state)) {
>  				list_add_tail(&sh->lru, &conf->delayed_list);
> -				blk_plug_device(conf->mddev->queue);
> +				spin_lock(q->queue_lock);
> +				blk_plug_device(q);
> +				spin_unlock(q->queue_lock);
>  			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
>  				   sh->bm_seq - conf->seq_write > 0) {
>  				list_add_tail(&sh->lru, &conf->bitmap_list);
> -				blk_plug_device(conf->mddev->queue);
> +				spin_lock(q->queue_lock);
> +				blk_plug_device(q);
> +				spin_unlock(q->queue_lock);
>  			} else {
>  				clear_bit(STRIPE_BIT_DELAY, &sh->state);
>  				list_add_tail(&sh->lru, &conf->handle_list);
> @@ -3268,10 +3274,12 @@ static void raid5_unplug_device(struct request_queue *q)
>  
>  	spin_lock_irqsave(&conf->device_lock, flags);
>  
> +	spin_lock(q->queue_lock);
>  	if (blk_remove_plug(q)) {
>  		conf->seq_flush++;
>  		raid5_activate_delayed(conf);
>  	}
> +	spin_unlock(q->queue_lock);
>  	md_wakeup_thread(mddev->thread);
>  
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
> diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
> index 812ffa5..000a215 100644
> --- a/include/linux/raid/md_k.h
> +++ b/include/linux/raid/md_k.h
> @@ -240,6 +240,9 @@ struct mddev_s
>  	struct timer_list		safemode_timer;
>  	atomic_t			writes_pending; 
>  	struct request_queue		*queue;	/* for plugging ... */
> +	spinlock_t			queue_lock; /* we supply the lock
> +						     * for blk-core
> +						     */
>  
>  	atomic_t                        write_behind; /* outstanding async IO */
>  	unsigned int                    max_write_behind; /* 0 = sync */
