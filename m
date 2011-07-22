From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 14/34] md/raid5: move more code into common handle_stripe
Date: Fri, 22 Jul 2011 16:32:03 +0900
Message-ID: <87r55idb4c.fsf@gmail.com>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023226.6728.59699.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721023226.6728.59699.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:32:26 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> The difference between the RAID5 and RAID6 code here is easily
> resolved using conf->max_degraded.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

and a coding style issue.


> ---
>
>  drivers/md/raid5.c |   90 ++++++++++++++++++----------------------------------
>  1 files changed, 32 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7b562fc..e41b622 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3177,34 +3177,6 @@ static int handle_stripe5(struct stripe_head *sh, struct stripe_head_state *s)
>  	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
>  	     !test_bit(STRIPE_INSYNC, &sh->state)))
>  		handle_parity_checks5(conf, sh, s, disks);
> -
> -	if (s->syncing && s->locked == 0
> -	    && test_bit(STRIPE_INSYNC, &sh->state)) {
> -		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
> -		clear_bit(STRIPE_SYNCING, &sh->state);
> -	}
> -
> -	/* If the failed drive is just a ReadError, then we might need to progress
> -	 * the repair/check process
> -	 */
> -	if (s->failed == 1 && !conf->mddev->ro &&
> -	    test_bit(R5_ReadError, &sh->dev[s->failed_num[0]].flags)
> -	    && !test_bit(R5_LOCKED, &sh->dev[s->failed_num[0]].flags)
> -	    && test_bit(R5_UPTODATE, &sh->dev[s->failed_num[0]].flags)
> -		) {
> -		dev = &sh->dev[s->failed_num[0]];
> -		if (!test_bit(R5_ReWrite, &dev->flags)) {
> -			set_bit(R5_Wantwrite, &dev->flags);
> -			set_bit(R5_ReWrite, &dev->flags);
> -			set_bit(R5_LOCKED, &dev->flags);
> -			s->locked++;
> -		} else {
> -			/* let's read it back */
> -			set_bit(R5_Wantread, &dev->flags);
> -			set_bit(R5_LOCKED, &dev->flags);
> -			s->locked++;
> -		}
> -	}
>  	return 0;
>  }
>  
> @@ -3394,36 +3366,6 @@ static int handle_stripe6(struct stripe_head *sh, struct stripe_head_state *s)
>  	     !test_bit(STRIPE_COMPUTE_RUN, &sh->state) &&
>  	     !test_bit(STRIPE_INSYNC, &sh->state)))
>  		handle_parity_checks6(conf, sh, s, disks);
> -
> -	if (s->syncing && s->locked == 0
> -	    && test_bit(STRIPE_INSYNC, &sh->state)) {
> -		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
> -		clear_bit(STRIPE_SYNCING, &sh->state);
> -	}
> -
> -	/* If the failed drives are just a ReadError, then we might need
> -	 * to progress the repair/check process
> -	 */
> -	if (s->failed <= 2 && !conf->mddev->ro)
> -		for (i = 0; i < s->failed; i++) {
> -			dev = &sh->dev[s->failed_num[i]];
> -			if (test_bit(R5_ReadError, &dev->flags)
> -			    && !test_bit(R5_LOCKED, &dev->flags)
> -			    && test_bit(R5_UPTODATE, &dev->flags)
> -				) {
> -				if (!test_bit(R5_ReWrite, &dev->flags)) {
> -					set_bit(R5_Wantwrite, &dev->flags);
> -					set_bit(R5_ReWrite, &dev->flags);
> -					set_bit(R5_LOCKED, &dev->flags);
> -					s->locked++;
> -				} else {
> -					/* let's read it back */
> -					set_bit(R5_Wantread, &dev->flags);
> -					set_bit(R5_LOCKED, &dev->flags);
> -					s->locked++;
> -				}
> -			}
> -		}
>  	return 0;
>  }
>  
> @@ -3466,6 +3408,38 @@ static void handle_stripe(struct stripe_head *sh)
>  
>  	if (done)
>  		goto finish;
> +
> +
> +	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
> +		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +		clear_bit(STRIPE_SYNCING, &sh->state);
> +	}
> +
> +	/* If the failed drives are just a ReadError, then we might need
> +	 * to progress the repair/check process
> +	 */
> +	if (s.failed <= conf->max_degraded && !conf->mddev->ro)
> +		for (i = 0; i < s.failed; i++) {
> +			struct r5dev *dev = &sh->dev[s.failed_num[i]];
> +			if (test_bit(R5_ReadError, &dev->flags)
> +			    && !test_bit(R5_LOCKED, &dev->flags)
> +			    && test_bit(R5_UPTODATE, &dev->flags)
> +				) {

This line looks weird and should be combined to previous line.

And I slightly prefer that the logical operators are put on the
same line with previous conditional, so that next one can be on
the same column and more readable, but ...

Thanks.


> +				if (!test_bit(R5_ReWrite, &dev->flags)) {
> +					set_bit(R5_Wantwrite, &dev->flags);
> +					set_bit(R5_ReWrite, &dev->flags);
> +					set_bit(R5_LOCKED, &dev->flags);
> +					s.locked++;
> +				} else {
> +					/* let's read it back */
> +					set_bit(R5_Wantread, &dev->flags);
> +					set_bit(R5_LOCKED, &dev->flags);
> +					s.locked++;
> +				}
> +			}
> +		}
> +
> +
>  	/* Finish reconstruct operations initiated by the expansion process */
>  	if (sh->reconstruct_state == reconstruct_state_result) {
>  		struct stripe_head *sh2
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
