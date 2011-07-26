From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 11/34] md/raid5: add some more fields to
 stripe_head_state
Date: Tue, 26 Jul 2011 11:35:08 +1000
Message-ID: <20110726113508.2126800f@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.40465.stgit@notabene.brown>
	<874o2eev94.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874o2eev94.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 14:31:51 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > Adding these three fields will allow more common code to be moved
> > to handle_stripe()
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Reviewed-by: Namhyung Kim <namhyung@gmail.com> 
> 
> and nitpick below.
> 
> 
> > ---
> >
> >  drivers/md/raid5.c |   54 +++++++++++++++++++++++-----------------------------
> >  drivers/md/raid5.h |    4 ++++
> >  2 files changed, 28 insertions(+), 30 deletions(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index c32ffb5..3327e82 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3003,12 +3003,9 @@ static void handle_stripe5(struct stripe_head *sh)
> >  {
> >  	raid5_conf_t *conf = sh->raid_conf;
> >  	int disks = sh->disks, i;
> > -	struct bio *return_bi = NULL;
> >  	struct stripe_head_state s;
> >  	struct r5dev *dev;
> > -	mdk_rdev_t *blocked_rdev = NULL;
> >  	int prexor;
> > -	int dec_preread_active = 0;
> >  
> >  	memset(&s, 0, sizeof(s));
> >  	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d check:%d "
> > @@ -3058,9 +3055,9 @@ static void handle_stripe5(struct stripe_head *sh)
> >  		if (dev->written)
> >  			s.written++;
> >  		rdev = rcu_dereference(conf->disks[i].rdev);
> > -		if (blocked_rdev == NULL &&
> > +		if (s.blocked_rdev == NULL &&
> >  		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
> > -			blocked_rdev = rdev;
> > +			s.blocked_rdev = rdev;
> >  			atomic_inc(&rdev->nr_pending);
> >  		}
> >  		clear_bit(R5_Insync, &dev->flags);
> > @@ -3088,15 +3085,15 @@ static void handle_stripe5(struct stripe_head *sh)
> >  	spin_unlock_irq(&conf->device_lock);
> >  	rcu_read_unlock();
> >  
> > -	if (unlikely(blocked_rdev)) {
> > +	if (unlikely(s.blocked_rdev)) {
> >  		if (s.syncing || s.expanding || s.expanded ||
> >  		    s.to_write || s.written) {
> >  			set_bit(STRIPE_HANDLE, &sh->state);
> >  			goto unlock;
> >  		}
> >  		/* There is nothing for the blocked_rdev to block */
> > -		rdev_dec_pending(blocked_rdev, conf->mddev);
> > -		blocked_rdev = NULL;
> > +		rdev_dec_pending(s.blocked_rdev, conf->mddev);
> > +		s.blocked_rdev = NULL;
> >  	}
> >  
> >  	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
> > @@ -3112,7 +3109,7 @@ static void handle_stripe5(struct stripe_head *sh)
> >  	 * need to be failed
> >  	 */
> >  	if (s.failed > 1 && s.to_read+s.to_write+s.written)
> > -		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
> > +		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
> >  	if (s.failed > 1 && s.syncing) {
> >  		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
> >  		clear_bit(STRIPE_SYNCING, &sh->state);
> > @@ -3128,7 +3125,7 @@ static void handle_stripe5(struct stripe_head *sh)
> >  	       !test_bit(R5_LOCKED, &dev->flags) &&
> >  	       test_bit(R5_UPTODATE, &dev->flags)) ||
> >  	       (s.failed == 1 && s.failed_num[0] == sh->pd_idx)))
> > -		handle_stripe_clean_event(conf, sh, disks, &return_bi);
> > +		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
> >  
> >  	/* Now we might consider reading some blocks, either to check/generate
> >  	 * parity, or to satisfy requests
> > @@ -3166,7 +3163,7 @@ static void handle_stripe5(struct stripe_head *sh)
> >  			}
> >  		}
> >  		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> > -			dec_preread_active = 1;
> > +			s.dec_preread_active = 1;
> >  	}
> >  
> >  	/* Now to consider new write requests and what else, if anything
> > @@ -3264,15 +3261,15 @@ static void handle_stripe5(struct stripe_head *sh)
> >   unlock:
> >  
> >  	/* wait for this device to become unblocked */
> > -	if (unlikely(blocked_rdev))
> > -		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
> > +	if (unlikely(s.blocked_rdev))
> > +		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
> >  
> >  	if (s.ops_request)
> >  		raid_run_ops(sh, s.ops_request);
> >  
> >  	ops_run_io(sh, &s);
> >  
> > -	if (dec_preread_active) {
> > +	if (s.dec_preread_active) {
> >  		/* We delay this until after ops_run_io so that if make_request
> >  		 * is waiting on a flush, it won't continue until the writes
> >  		 * have actually been submitted.
> > @@ -3282,19 +3279,16 @@ static void handle_stripe5(struct stripe_head *sh)
> >  		    IO_THRESHOLD)
> >  			md_wakeup_thread(conf->mddev->thread);
> >  	}
> > -	return_io(return_bi);
> > +	return_io(s.return_bi);
> >  }
> >  
> >  static void handle_stripe6(struct stripe_head *sh)
> >  {
> >  	raid5_conf_t *conf = sh->raid_conf;
> >  	int disks = sh->disks;
> > -	struct bio *return_bi = NULL;
> >  	int i, pd_idx = sh->pd_idx, qd_idx = sh->qd_idx;
> >  	struct stripe_head_state s;
> >  	struct r5dev *dev, *pdev, *qdev;
> > -	mdk_rdev_t *blocked_rdev = NULL;
> > -	int dec_preread_active = 0;
> >  
> >  	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
> >  		"pd_idx=%d, qd_idx=%d\n, check:%d, reconstruct:%d\n",
> > @@ -3345,9 +3339,9 @@ static void handle_stripe6(struct stripe_head *sh)
> >  		if (dev->written)
> >  			s.written++;
> >  		rdev = rcu_dereference(conf->disks[i].rdev);
> > -		if (blocked_rdev == NULL &&
> > +		if (s.blocked_rdev == NULL &&
> >  		    rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
> > -			blocked_rdev = rdev;
> > +			s.blocked_rdev = rdev;
> >  			atomic_inc(&rdev->nr_pending);
> >  		}
> >  		clear_bit(R5_Insync, &dev->flags);
> > @@ -3376,15 +3370,15 @@ static void handle_stripe6(struct stripe_head *sh)
> >  	spin_unlock_irq(&conf->device_lock);
> >  	rcu_read_unlock();
> >  
> > -	if (unlikely(blocked_rdev)) {
> > +	if (unlikely(s.blocked_rdev)) {
> >  		if (s.syncing || s.expanding || s.expanded ||
> >  		    s.to_write || s.written) {
> >  			set_bit(STRIPE_HANDLE, &sh->state);
> >  			goto unlock;
> >  		}
> >  		/* There is nothing for the blocked_rdev to block */
> > -		rdev_dec_pending(blocked_rdev, conf->mddev);
> > -		blocked_rdev = NULL;
> > +		rdev_dec_pending(s.blocked_rdev, conf->mddev);
> > +		s.blocked_rdev = NULL;
> >  	}
> >  
> >  	if (s.to_fill && !test_bit(STRIPE_BIOFILL_RUN, &sh->state)) {
> > @@ -3400,7 +3394,7 @@ static void handle_stripe6(struct stripe_head *sh)
> >  	 * might need to be failed
> >  	 */
> >  	if (s.failed > 2 && s.to_read+s.to_write+s.written)
> > -		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
> > +		handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
> >  	if (s.failed > 2 && s.syncing) {
> >  		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
> >  		clear_bit(STRIPE_SYNCING, &sh->state);
> > @@ -3425,7 +3419,7 @@ static void handle_stripe6(struct stripe_head *sh)
> >  	    (s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
> >  			     && !test_bit(R5_LOCKED, &qdev->flags)
> >  			     && test_bit(R5_UPTODATE, &qdev->flags)))))
> > -		handle_stripe_clean_event(conf, sh, disks, &return_bi);
> > +		handle_stripe_clean_event(conf, sh, disks, &s.return_bi);
> >  
> >  	/* Now we might consider reading some blocks, either to check/generate
> >  	 * parity, or to satisfy requests
> > @@ -3461,7 +3455,7 @@ static void handle_stripe6(struct stripe_head *sh)
> >  			}
> >  		}
> >  		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> > -			dec_preread_active = 1;
> > +			s.dec_preread_active = 1;
> >  	}
> >  
> >  	/* Now to consider new write requests and what else, if anything
> > @@ -3561,8 +3555,8 @@ static void handle_stripe6(struct stripe_head *sh)
> >   unlock:
> >  
> >  	/* wait for this device to become unblocked */
> > -	if (unlikely(blocked_rdev))
> > -		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
> > +	if (unlikely(s.blocked_rdev))
> > +		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
> >  
> >  	if (s.ops_request)
> >  		raid_run_ops(sh, s.ops_request);
> > @@ -3570,7 +3564,7 @@ static void handle_stripe6(struct stripe_head *sh)
> >  	ops_run_io(sh, &s);
> >  
> >  
> > -	if (dec_preread_active) {
> > +	if (s.dec_preread_active) {
> >  		/* We delay this until after ops_run_io so that if make_request
> >  		 * is waiting on a flush, it won't continue until the writes
> >  		 * have actually been submitted.
> > @@ -3581,7 +3575,7 @@ static void handle_stripe6(struct stripe_head *sh)
> >  			md_wakeup_thread(conf->mddev->thread);
> >  	}
> >  
> > -	return_io(return_bi);
> > +	return_io(s.return_bi);
> >  }
> >  
> >  static void handle_stripe(struct stripe_head *sh)
> > diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> > index d3c61d3..9ceb574 100644
> > --- a/drivers/md/raid5.h
> > +++ b/drivers/md/raid5.h
> > @@ -248,6 +248,10 @@ struct stripe_head_state {
> >  	int failed_num[2];
> >  	unsigned long ops_request;
> >  	int p_failed, q_failed;
> > +
> > +	struct bio *return_bi;
> > +	mdk_rdev_t *blocked_rdev;
> > +	int dec_preread_active;
> >  };
> 
> I'd rather rearrange the struct to reduce paddings on 64-bit:
> 
> /* stripe_head_state - collects and tracks the dynamic state of a stripe_head
>  *     for handle_stripe.  It is only valid under spin_lock(sh->lock);
>  */
> struct stripe_head_state {
> 	int syncing, expanding, expanded;
> 	int locked, uptodate, to_read, to_write, failed, written;
> 	int to_fill, compute, req_compute, non_overwrite;
> 	int failed_num[2];
>         int p_failed, q_failed;
>         int dec_preread_active;
> 	unsigned long ops_request;
> 
>         struct bio *return_bi;
>         mdk_rdev_t *blocked_rdev;
> };

I've made that change, thanks.


> 
> BTW, comment above mentions sh->lock which is disappeared in previous
> patch. It should be fixed as well (in patch 08/34?).

True ... and there are lots of other mentions made of the stripe lock in all
those comments.
I have fixed some of them up but I really need to review all of that
commentary.

Thanks,
NeilBrown


> 
> Thanks.
> 
> 
> >  
> >  /* Flags */
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

