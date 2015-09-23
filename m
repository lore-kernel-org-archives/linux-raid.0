From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 2/2] raid5: update analysis state for failed stripe
Date: Tue, 22 Sep 2015 23:34:25 -0700
Message-ID: <20150923063425.GA2813864@devbig084.prn1.facebook.com>
References: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com>
 <0fc9dd19baf6f214a112b040401a4cf3d6313942.1442596586.git.shli@fb.com>
 <87bncty7sp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bncty7sp.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, Sep 23, 2015 at 04:21:58PM +1000, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> 
> > handle_failed_stripe() makes the stripe fail, eg, all IO will return
> > with a failure, but it doesn't update stripe_head_state. Later
> > handle_stripe() has special handling for raid6 for handle_stripe_fill().
> > That check before handle_stripe_fill() doesn't skip the failed stripe
> > and we get a kernel crash in need_this_block.  This patch clear the
> > analysis state to make sure no functions wrongly called after
> > handle_failed_stripe()
> >
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/raid5.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 394cdf8..8e4fb89a 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3155,6 +3155,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
> >  			spin_unlock_irq(&sh->stripe_lock);
> >  			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
> >  				wake_up(&conf->wait_for_overlap);
> > +			if (bi)
> > +				s->to_read--;
> >  			while (bi && bi->bi_iter.bi_sector <
> >  			       sh->dev[i].sector + STRIPE_SECTORS) {
> >  				struct bio *nextbi =
> > @@ -3173,6 +3175,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
> >  		 */
> >  		clear_bit(R5_LOCKED, &sh->dev[i].flags);
> >  	}
> > +	s->to_write = 0;
> > +	s->written = 0;
> >  
> >  	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
> >  		if (atomic_dec_and_test(&conf->pending_full_writes))
> > -- 
> > 1.8.1
> 
> Again, this probably is a sensible fix, but I would like to be certain.
> Where exactly in need_this_block does the kernel crash?  I cannot see
> anything that could cause an invalid address....


>>for (i = 0; i < s->failed; i++) {
>>                if (fdev[i]->towrite &&
the fdev[i]->towrite. because s->failed >=2 (it's 3 in my case), while
the array size is 2.

Thanks,
Shaohua
