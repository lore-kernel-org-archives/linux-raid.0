From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/8] md/raid5: Ensure a batch member is not handled
 prematurely.
Date: Tue, 26 May 2015 17:10:05 -0700
Message-ID: <20150527001005.GA106894@kernel.org>
References: <20150522052802.2117.40527.stgit@notabene.brown>
 <20150522053058.2117.29026.stgit@notabene.brown>
 <20150522234402.GA86128@kernel.org>
 <20150523102640.20be3fca@notabene.brown>
 <20150526181647.GA38853@kernel.org>
 <20150527083532.32486e08@notabene.brown>
 <20150527093451.0c83be44@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150527093451.0c83be44@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 27, 2015 at 09:34:51AM +1000, NeilBrown wrote:
> On Wed, 27 May 2015 08:35:32 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > Could you please review and possibly test the patch below?
> > 
> 
> well... that patch had a fairly obvious double-lock bug.
> Try this one.
> (oh, just saw your email that you spotted the lock bug :-)
> 
> 
> NeilBrown
> 
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 27 May 2015 08:43:45 +1000
> Subject: [PATCH] md/raid5: close race between STRIPE_BIT_DELAY and batching.
> 
> The first time a write is added to a stripe, we need to set the
> bitmap bits (if a bitmap is active).
> While doing that the stripe is not locked and other writes could
> be added and then the stripe could be added to a batch.
> Once it has entered the batch it is too large to set STRIPE_BIT_DELAY
> as the batch head has taken over when the stripe will be written.
> 
> We cannot hold the spinlock while adding the bitmap bit,
> so introduce a new stripe_head flag 'STRIPE_BITMAP_PENDING' which
> indicates that adding to the bitmap is pending.  This prevents
> the stripe from being added to a batch.
> 
> Only the first thread to add a write to a stripe can set this bit,
> so it is safe for it to clear it again when it is done.
> 
> Reported-by: Shaohua Li <shli@kernel.org>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 73b5376dad3b..dae587ecdf71 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -760,6 +760,7 @@ static void unlock_two_stripes(struct stripe_head *sh1, struct stripe_head *sh2)
>  static bool stripe_can_batch(struct stripe_head *sh)
>  {
>  	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
> +		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
>  		is_full_stripe_write(sh);
>  }
>  
> @@ -3007,14 +3008,27 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
>  		(unsigned long long)(*bip)->bi_iter.bi_sector,
>  		(unsigned long long)sh->sector, dd_idx);
> -	spin_unlock_irq(&sh->stripe_lock);
>  
>  	if (conf->mddev->bitmap && firstwrite) {
> +		/* Cannot hold spinlock over bitmap_startwrite,
> +		 * but must ensure this isn't added to a batch until
> +		 * we have added to the bitmap and set bm_seq.
> +		 * So set STRIPE_BITMAP_PENDING to prevent
> +		 * batching.
> +		 * Only the first thread to add a write to a stripe
> +		 * can set this bit, so we "own" it.
> +		 */
> +		WARN_ON(test_bit(STRIPE_BITMAP_PENDING, &sh->state));
I keep hitting this. the firstwrite is set for every device.

Thanks,
Shaohua
