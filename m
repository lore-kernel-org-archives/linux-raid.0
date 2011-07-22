From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 13/34] md/raid5: Move code for finishing a reconstruction into handle_stripe.
Date: Fri, 22 Jul 2011 16:09:10 +0900
Message-ID: <87vcuudc6h.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.17250.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023226.6728.17250.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:26 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> Prior to commit ab69ae12ceef7 the code in handle_stripe5 and
> handle_stripe6 to "Finish reconstruct operations initiated by the
> expansion process" was identical.
> That commit added an identical stanza of code to each function, but in
> different places.  That was careless.
>
> The raid5 code was correct, so move that out into handle_stripe and
> remove raid6 version.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

and nitpick below..


> ---
>
>  drivers/md/raid5.c |  153 +++++++++++++++++++---------------------------------
>  1 files changed, 57 insertions(+), 96 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ce1c291..7b562fc 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2999,7 +2999,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
>   *
>   */
>  
> -static void handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
> +static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
>  {
>  	raid5_conf_t *conf = sh->raid_conf;
>  	int disks = sh->disks, i;
> @@ -3081,7 +3081,7 @@ static void handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
>  		if (s->syncing || s->expanding || s->expanded ||
>  		    s->to_write || s->written) {
>  			set_bit(STRIPE_HANDLE, &sh->state);
> -			return;
> +			return 1;
>  		}
>  		/* There is nothing for the blocked_rdev to block */
>  		rdev_dec_pending(s->blocked_rdev, conf->mddev);
> @@ -3205,54 +3205,10 @@ static void handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
>  			s->locked++;
>  		}
>  	}
> -
> -	/* Finish reconstruct operations initiated by the expansion process */
> -	if (sh->reconstruct_state == reconstruct_state_result) {
> -		struct stripe_head *sh2
> -			= get_active_stripe(conf, sh->sector, 1, 1, 1);
> -		if (sh2 && test_bit(STRIPE_EXPAND_SOURCE, &sh2->state)) {
> -			/* sh cannot be written until sh2 has been read.
> -			 * so arrange for sh to be delayed a little
> -			 */
> -			set_bit(STRIPE_DELAYED, &sh->state);
> -			set_bit(STRIPE_HANDLE, &sh->state);
> -			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
> -					      &sh2->state))
> -				atomic_inc(&conf->preread_active_stripes);
> -			release_stripe(sh2);
> -			return;
> -		}
> -		if (sh2)
> -			release_stripe(sh2);
> -
> -		sh->reconstruct_state = reconstruct_state_idle;
> -		clear_bit(STRIPE_EXPANDING, &sh->state);
> -		for (i = conf->raid_disks; i--; ) {
> -			set_bit(R5_Wantwrite, &sh->dev[i].flags);
> -			set_bit(R5_LOCKED, &sh->dev[i].flags);
> -			s->locked++;
> -		}
> -	}
> -
> -	if (s->expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
> -	    !sh->reconstruct_state) {
> -		/* Need to write out all blocks after computing parity */
> -		sh->disks = conf->raid_disks;
> -		stripe_set_idx(sh->sector, conf, 0, sh);
> -		schedule_reconstruction(sh, s, 1, 1);
> -	} else if (s->expanded && !sh->reconstruct_state && s->locked == 0) {
> -		clear_bit(STRIPE_EXPAND_READY, &sh->state);
> -		atomic_dec(&conf->reshape_stripes);
> -		wake_up(&conf->wait_for_overlap);
> -		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> -	}
> -
> -	if (s->expanding && s->locked == 0 &&
> -	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
> -		handle_stripe_expansion(conf, sh, NULL);
> +	return 0;
>  }
>  
> -static void handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
> +static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
>  {
>  	raid5_conf_t *conf = sh->raid_conf;
>  	int disks = sh->disks;
> @@ -3335,7 +3291,7 @@ static void handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
>  		if (s->syncing || s->expanding || s->expanded ||
>  		    s->to_write || s->written) {
>  			set_bit(STRIPE_HANDLE, &sh->state);
> -			return;
> +			return 1;
>  		}
>  		/* There is nothing for the blocked_rdev to block */
>  		rdev_dec_pending(s->blocked_rdev, conf->mddev);
> @@ -3468,57 +3424,15 @@ static void handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
>  				}
>  			}
>  		}
> -
> -	/* Finish reconstruct operations initiated by the expansion process */
> -	if (sh->reconstruct_state == reconstruct_state_result) {
> -		sh->reconstruct_state = reconstruct_state_idle;
> -		clear_bit(STRIPE_EXPANDING, &sh->state);
> -		for (i = conf->raid_disks; i--; ) {
> -			set_bit(R5_Wantwrite, &sh->dev[i].flags);
> -			set_bit(R5_LOCKED, &sh->dev[i].flags);
> -			s->locked++;
> -		}
> -	}
> -
> -	if (s->expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
> -	    !sh->reconstruct_state) {
> -		struct stripe_head *sh2
> -			= get_active_stripe(conf, sh->sector, 1, 1, 1);
> -		if (sh2 && test_bit(STRIPE_EXPAND_SOURCE, &sh2->state)) {
> -			/* sh cannot be written until sh2 has been read.
> -			 * so arrange for sh to be delayed a little
> -			 */
> -			set_bit(STRIPE_DELAYED, &sh->state);
> -			set_bit(STRIPE_HANDLE, &sh->state);
> -			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
> -					      &sh2->state))
> -				atomic_inc(&conf->preread_active_stripes);
> -			release_stripe(sh2);
> -			return;
> -		}
> -		if (sh2)
> -			release_stripe(sh2);
> -
> -		/* Need to write out all blocks after computing P&Q */
> -		sh->disks = conf->raid_disks;
> -		stripe_set_idx(sh->sector, conf, 0, sh);
> -		schedule_reconstruction(sh, s, 1, 1);
> -	} else if (s->expanded && !sh->reconstruct_state && s->locked == 0) {
> -		clear_bit(STRIPE_EXPAND_READY, &sh->state);
> -		atomic_dec(&conf->reshape_stripes);
> -		wake_up(&conf->wait_for_overlap);
> -		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> -	}
> -
> -	if (s->expanding && s->locked == 0 &&
> -	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
> -		handle_stripe_expansion(conf, sh, s);
> +	return 0;
>  }
>  
>  static void handle_stripe(struct stripe_head *sh)
>  {
>  	struct stripe_head_state s;
> +	int done;
>  	raid5_conf_t *conf = sh->raid_conf;
> +	int i;

Can be declared in a line.


>  
>  	clear_bit(STRIPE_HANDLE, &sh->state);
>  	if (test_and_set_bit(STRIPE_ACTIVE, &sh->state)) {
> @@ -3546,11 +3460,58 @@ static void handle_stripe(struct stripe_head *sh)
>  	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
>  
>  	if (conf->level == 6)
> -		handle_stripe6(sh, &s);
> +		done = handle_stripe6(sh, &s);
>  	else
> -		handle_stripe5(sh, &s);
> +		done = handle_stripe5(sh, &s);
> +
> +	if (done)
> +		goto finish;
> +	/* Finish reconstruct operations initiated by the expansion process */
> +	if (sh->reconstruct_state == reconstruct_state_result) {
> +		struct stripe_head *sh2
> +			= get_active_stripe(conf, sh->sector, 1, 1, 1);

Wouldn't it be better to use more descriptive name rather than sh2,
something like sh_prev, sh_src or whatever?

Thanks


> +		if (sh2 && test_bit(STRIPE_EXPAND_SOURCE, &sh2->state)) {
> +			/* sh cannot be written until sh2 has been read.
> +			 * so arrange for sh to be delayed a little
> +			 */
> +			set_bit(STRIPE_DELAYED, &sh->state);
> +			set_bit(STRIPE_HANDLE, &sh->state);
> +			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE,
> +					      &sh2->state))
> +				atomic_inc(&conf->preread_active_stripes);
> +			release_stripe(sh2);
> +			goto finish;
> +		}
> +		if (sh2)
> +			release_stripe(sh2);
> +
> +		sh->reconstruct_state = reconstruct_state_idle;
> +		clear_bit(STRIPE_EXPANDING, &sh->state);
> +		for (i = conf->raid_disks; i--; ) {
> +			set_bit(R5_Wantwrite, &sh->dev[i].flags);
> +			set_bit(R5_LOCKED, &sh->dev[i].flags);
> +			s.locked++;
> +		}
> +	}
>  
> +	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
> +	    !sh->reconstruct_state) {
> +		/* Need to write out all blocks after computing parity */
> +		sh->disks = conf->raid_disks;
> +		stripe_set_idx(sh->sector, conf, 0, sh);
> +		schedule_reconstruction(sh, &s, 1, 1);
> +	} else if (s.expanded && !sh->reconstruct_state && s.locked == 0) {
> +		clear_bit(STRIPE_EXPAND_READY, &sh->state);
> +		atomic_dec(&conf->reshape_stripes);
> +		wake_up(&conf->wait_for_overlap);
> +		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +	}
> +
> +	if (s.expanding && s.locked == 0 &&
> +	    !test_bit(STRIPE_COMPUTE_RUN, &sh->state))
> +		handle_stripe_expansion(conf, sh, NULL);
>  
> +finish:
>  	/* wait for this device to become unblocked */
>  	if (unlikely(s.blocked_rdev))
>  		md_wait_for_blocked_rdev(s.blocked_rdev, conf->mddev);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
