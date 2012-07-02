From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 08/10 v3] raid5: make_request use batch stripe release
Date: Mon, 2 Jul 2012 10:59:50 +0800
Message-ID: <20120702025950.GA29770@kernel.org>
References: <20120625072447.268095276@kernel.org>
 <20120625072702.921605418@kernel.org>
 <20120702123112.795e1db3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120702123112.795e1db3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Mon, Jul 02, 2012 at 12:31:12PM +1000, NeilBrown wrote:
> On Mon, 25 Jun 2012 15:24:55 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > make_request() does stripe release for every stripe and the stripe usually has
> > count 1, which makes previous release_stripe() optimization not work. In my
> > test, this release_stripe() becomes the heaviest pleace to take
> > conf->device_lock after previous patches applied.
> > 
> > Below patch makes stripe release batch. All the stripes will be released in
> > unplug. The STRIPE_ON_UNPLUG_LIST bit is to protect concurrent access stripe
> > lru.
> > 
> 
> I've applied this patch, but I'm afraid I butchered it a bit first :-)
> 
> 
> > @@ -3984,6 +3985,51 @@ static struct stripe_head *__get_priorit
> >  	return sh;
> >  }
> >  
> > +#define raid5_unplug_list(mdcb) (struct list_head *)(mdcb + 1)
> 
> I really don't like this sort of construct.  It is much cleaner (I think) to
> add to a structure by embedding it in a larger structure, then using
> "container_of" to map from the inner to the outer structure.  So I have
> changed that.

Thanks.
 
> > @@ -4114,7 +4161,14 @@ static void make_request(struct mddev *m
> >  			if ((bi->bi_rw & REQ_SYNC) &&
> >  			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> >  				atomic_inc(&conf->preread_active_stripes);
> > -			release_stripe(sh);
> > +			/*
> > +			 * We must recheck here. schedule() might be called
> > +			 * above which makes unplug invoked already, so the old
> > +			 * mdcb is invalid
> > +			 */
> 
> I agree that this is an important check, but as a 'schedule()' can
> theoretically happen at any time that preempt isn't explicitly disabled, we
> really need to be even more careful.  So I have changed the md code to
> disable preempt, and require the caller to re-enable preempt after it has
> used the returned value.
> 
> The resulting serious should appear in my for-next shortly.  However for
> easier review I'll include two patches below.  The first change
> mddev_check_plugged to disable preemption.
> The second is a diff against your patch which changes it to use an embedded
> structure and container_of.
> I haven't actually tested this yet, so there may be further changes.
> 
> Thanks,
> NeilBrown
> 
> From 04b7dd7d0ad4a21622cad7c10821f914a8d9ccd3 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 2 Jul 2012 12:14:49 +1000
> Subject: [PATCH] md/plug: disable preempt when reported a plug is present.
> 
> As 'schedule' will unplug a queue, a plug added by
> mddev_check_plugged is only valid until the next schedule().
> So call preempt_disable before installing the plug, and require the
> called to call preempt_enable once the value has been used.
> 
> Signed-off-by: NeilBrown  <neilb@suse.de>
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1369c9d..63ea6d6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -512,6 +512,10 @@ static void plugger_unplug(struct blk_plug_cb *cb)
>  
>  /* Check that an unplug wakeup will come shortly.
>   * If not, wakeup the md thread immediately
> + * Note that the structure returned is only value until
> + * the next schedule(), so preemption is disabled when it
> + * is not NULL, and must be re-enabled after the value
> + * has been used.
>   */
>  struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
>  				       md_unplug_func_t unplug, size_t size)
> @@ -522,6 +526,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
>  	if (!plug)
>  		return NULL;
>  
> +	preempt_disable();
>  	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
>  		if (mdcb->cb.callback == plugger_unplug &&
>  		    mdcb->mddev == mddev) {
> @@ -533,6 +538,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
>  			return mdcb;
>  		}
>  	}
> +	preempt_enable();

preempt doesn't do unplug, only yield(schedule) does, so I don't like this,
just redoing mddev_check_plugged before checking the return value is fine to
me.

>  	/* Not currently on the callback list */
>  	if (size < sizeof(*mdcb))
>  		size = sizeof(*mdcb);
> @@ -540,6 +546,7 @@ struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
>  	if (!mdcb)
>  		return NULL;
>  
> +	preempt_disable();
>  	mdcb->mddev = mddev;
>  	mdcb->cb.callback = plugger_unplug;
>  	atomic_inc(&mddev->plug_cnt);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ebce488..2e19b68 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -883,7 +883,6 @@ static void make_request(struct mddev *mddev, struct bio * bio)
>  	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
>  	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
>  	struct md_rdev *blocked_rdev;
> -	int plugged;
>  	int first_clone;
>  	int sectors_handled;
>  	int max_sectors;
> @@ -1034,8 +1033,6 @@ read_again:
>  	 * the bad blocks.  Each set of writes gets it's own r1bio
>  	 * with a set of bios attached.
>  	 */
> -	plugged = !!mddev_check_plugged(mddev, NULL, 0);
> -
>  	disks = conf->raid_disks * 2;
>   retry_write:
>  	blocked_rdev = NULL;
> @@ -1214,8 +1211,11 @@ read_again:
>  	/* In case raid1d snuck in to freeze_array */
>  	wake_up(&conf->wait_barrier);
>  
> -	if (do_sync || !bitmap || !plugged)
> +	if (do_sync ||
> +	    !mddev_check_plugged(mddev, NULL, 0))
>  		md_wakeup_thread(mddev->thread);

Do we really bother to recheck here? just a wakeup.

Thanks,
Shaohua
