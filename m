From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/8] md/raid5: Ensure a batch member is not handled
 prematurely.
Date: Tue, 26 May 2015 16:21:57 -0700
Message-ID: <20150526232157.GA77226@kernel.org>
References: <20150522052802.2117.40527.stgit@notabene.brown>
 <20150522053058.2117.29026.stgit@notabene.brown>
 <20150522234402.GA86128@kernel.org>
 <20150523102640.20be3fca@notabene.brown>
 <20150526181647.GA38853@kernel.org>
 <20150527083532.32486e08@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150527083532.32486e08@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 27, 2015 at 08:35:32AM +1000, NeilBrown wrote:
> On Tue, 26 May 2015 11:16:47 -0700 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Sat, May 23, 2015 at 10:26:40AM +1000, NeilBrown wrote:
> > > On Fri, 22 May 2015 16:44:02 -0700 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > On Fri, May 22, 2015 at 03:30:58PM +1000, NeilBrown wrote:
> > > > > If a stripe is a member of a batch, but not the head, it must
> > > > > not be handled separately from the rest of the batch.
> > > > > 
> > > > > 'clear_batch_ready()' handles this requirement to some
> > > > > extent but not completely.  If a member is passed to handle_stripe()
> > > > > a second time it returns '0' indicating the stripe can be handled,
> > > > > which is wrong.
> > > > > So add an extra test.
> > > > > 
> > > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > > ---
> > > > >  drivers/md/raid5.c |    6 +++++-
> > > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > > index c3ccefbd4fe7..9a803b735848 100644
> > > > > --- a/drivers/md/raid5.c
> > > > > +++ b/drivers/md/raid5.c
> > > > > @@ -4192,9 +4192,13 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
> > > > >  
> > > > >  static int clear_batch_ready(struct stripe_head *sh)
> > > > >  {
> > > > > +	/* Return '1' if this is a member of batch, or
> > > > > +	 * '0' if it is a lone stripe or a head which can now be
> > > > > +	 * handled.
> > > > > +	 */
> > > > >  	struct stripe_head *tmp;
> > > > >  	if (!test_and_clear_bit(STRIPE_BATCH_READY, &sh->state))
> > > > > -		return 0;
> > > > > +		return (sh->batch_head && sh->batch_head != sh);
> > > > >  	spin_lock(&sh->stripe_lock);
> > > > >  	if (!sh->batch_head) {
> > > > >  		spin_unlock(&sh->stripe_lock);
> > > > 
> > > > which case can this happen in?
> > > 
> > > It definitely happens as I had reliable problems until I added this fix.
> > > 'retry_aligned_read()' can call handle_stripe() on any stripe at any time,
> > > but I doubt that would apply.  I might try putting a warn-on there and see if
> > > it provides any hints.
> > > 
> > > > 
> > > > Patches look good. But I'm not in Fusionio any more, so can't check the
> > > > performance in big raid array with fast flash cards. I'm doing some tests here.
> > > > I hit a warning in break_stripe_batch_list, STRIPE_BIT_DELAY is set in the
> > > > stripe state. I'm checking the reason, but if you have thoughts I can try
> > > > immediately, please let me know.
> > > 
> > > I got STRIPE_BIT_DELAY a few times.  That was the main reason for
> > > 
> > >   md/raid5: ensure whole batch is delayed for all required bitmap updates.
> > > 
> > > and they went away after I got that patch right.
> > > 
> > > Maybe there is a race in there..
> > > 
> > > If you can reproduce it, maybe WARN whenever STRIPE_BIT_DELAY gets set on a
> > > stripe with ->batch_head.
> > 
> > Ok, there is a race in add_stripe_bio(). We unlocked the stripe_lock to set the
> > BIT_DELAY. After the unlock, the stripe might be added to a batch,
> > stripe_add_to_batch_list didn't clear the bit. Holding the lock in
> > add_stripe_bio and checking ->batch_head again when we set the bit should fix
> > the issue.
> 
> We can't hold a spin_lock over bitmap_startwrite(), and we really need to
> make sure the write doesn't start until bitmap_startwrite has completed.
> So we need to keep the stripe_head out of any batch during that time.
> So I've added an extra state bit.
> 
> Could you please review and possibly test the patch below?
> 
> > 
> > And STRIPE_ON_UNPLUG_LIST and STRIPE_ON_RELEASE_LIST are set is legit in
> > break_stripe_batch_list(), they should be removed from the WARN_ON_ONCE().
> 
> Yes, you are right.  Thanks.
> 
> > 
> > Thanks,
> > Shaohua
> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 041341c66ae5..89d6faafffda 100644
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
> @@ -3007,14 +3008,18 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
>  		(unsigned long long)(*bip)->bi_iter.bi_sector,
>  		(unsigned long long)sh->sector, dd_idx);
> -	spin_unlock_irq(&sh->stripe_lock);
>  
>  	if (conf->mddev->bitmap && firstwrite) {
> +		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
> +		spin_unlock_irq(&sh->stripe_lock);
>  		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
>  				  STRIPE_SECTORS, 0);
> +		spin_lock_irq(&sh->stripe_lock);
> +		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
>  		sh->bm_seq = conf->seq_flush+1;
>  		set_bit(STRIPE_BIT_DELAY, &sh->state);
>  	}
> +	spin_lock_irq(&sh->stripe_lock);

should be unlock here. I'll report back if anything is wrong.

Thanks,
Shaohua
