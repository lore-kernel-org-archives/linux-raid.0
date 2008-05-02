From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: fix raid5 'repair' operations
Date: Fri, 2 May 2008 17:26:45 +1000
Message-ID: <18458.49717.471295.285149@notabene.brown>
References: <20080502031513.13090.2973.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday May 1
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux@horizon.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 1, dan.j.williams@intel.com wrote:
> commit bd2ab67030e9116f1e4aae1289220255412b37fd "md: close a livelock
> window in handle_parity_checks5" introduced a bug in handling 'repair'
> operations.  After a repair operation completes we clear the state bits
> tracking this operation.  However, they are cleared too early and this
> results in the code deciding to re-run the parity check operation.  Since
> we have done the repair in memory the second check does not find a mismatch
> and thus does not do a writeback.

yes....
I must admit that I find that code fairly hard to make sense of, but I
can see how it was failing before and how this fixes it, and testing
confirms that, so I suspect it is right.

I cannot help feeling that there must be some way to simplify all
those .pending and .complete bits and make it somewhat clearer, but I
haven't been able to figure out how :-(

So: Acked-by: NeilBrown <neilb@suse.de>

I'm heading for a weekend, but feel free to send this to akpm.

Thanks,
NeilBrown


> 
> Test results:
> $ echo repair > /sys/block/md0/md/sync_action
> $ cat /sys/block/md0/md/mismatch_cnt
> 51072
> $ echo repair > /sys/block/md0/md/sync_action
> $ cat /sys/block/md0/md/mismatch_cnt
> 0
> 
> Cc: <stable@kernel.org>
> Reported-by: George Spelvin <linux@horizon.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  drivers/md/raid5.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 087eee0..da3390d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2400,16 +2400,6 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
>  			canceled_check = 1; /* STRIPE_INSYNC is not set */
>  	}
>  
> -	/* check if we can clear a parity disk reconstruct */
> -	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
> -		test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
> -
> -		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
> -		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
> -		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
> -		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
> -	}
> -
>  	/* start a new check operation if there are no failures, the stripe is
>  	 * not insync, and a repair is not in flight
>  	 */
> @@ -2424,6 +2414,17 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
>  		}
>  	}
>  
> +	/* check if we can clear a parity disk reconstruct */
> +	if (test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete) &&
> +		test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
> +
> +		clear_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending);
> +		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
> +		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.ack);
> +		clear_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
> +	}
> +
> +
>  	/* Wait for check parity and compute block operations to complete
>  	 * before write-back.  If a failure occurred while the check operation
>  	 * was in flight we need to cycle this stripe through handle_stripe
