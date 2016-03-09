From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: preserve STRIPE_PREREAD_ACTIVE in
 break_stripe_batch_list
Date: Wed, 9 Mar 2016 09:26:52 -0800
Message-ID: <20160309172652.GA8073@kernel.org>
References: <87r3fkjttq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r3fkjttq.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Martin Svec <martin.svec@zoner.cz>
List-Id: linux-raid.ids

On Wed, Mar 09, 2016 at 12:58:25PM +1100, Neil Brown wrote:
> 
> break_stripe_batch_list breaks up a batch and copies some flags from
> the batch head to the members, preserving others.
> 
> It doesn't preserve or copy STRIPE_PREREAD_ACTIVE.  This is not
> normally a problem as STRIPE_PREREAD_ACTIVE is cleared when a
> stripe_head is added to a batch, and is not set on stripe_heads
> already in a batch.
> 
> However there is no locking to ensure one thread doesn't set the flag
> after it has just been cleared in another.  This does occasionally happen.
> 
> md/raid5 maintains a count of the number of stripe_heads with
> STRIPE_PREREAD_ACTIVE set: conf->preread_active_stripes.  When
> break_stripe_batch_list clears STRIPE_PREREAD_ACTIVE inadvertently
> this could becomes incorrect and will never again return to zero.
> 
> md/raid5 delays the handling of some stripe_heads until
> preread_active_stripes becomes zero.  So when the above mention race
> happens, those stripe_heads become blocked and never progress,
> resulting is write to the array handing.
> 
> So: change break_stripe_batch_list to preserve STRIPE_PREREAD_ACTIVE
> in the members of a batch.
> 
> URL: https://bugzilla.kernel.org/show_bug.cgi?id=108741
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=1258153
> URL: http://thread.gmane.org/5649C0E9.2030204@zoner.cz
> Reported-by: Martin Svec <martin.svec@zoner.cz> (and others)
> Tested-by: Tom Weber <linux@junkyard.4t2.com>
> Fixes: 1b956f7a8f9a ("md/raid5: be more selective about distributing flags across batch.")
> Cc: stable@vger.kernel.org (v4.1 and later)
> Signed-off-by: NeilBrown <neilb@suse.com>

Applied, thanks Neil! I'll split the WARN_ON_ONCE and do it for each bit, so
next time we can have clear clue.

Thanks,
Shaohua

> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b4f02c9959f2..2e7d253be6ce 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4236,7 +4236,6 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
>  		WARN_ON_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
>  					  (1 << STRIPE_SYNCING) |
>  					  (1 << STRIPE_REPLACED) |
> -					  (1 << STRIPE_PREREAD_ACTIVE) |
>  					  (1 << STRIPE_DELAYED) |
>  					  (1 << STRIPE_BIT_DELAY) |
>  					  (1 << STRIPE_FULL_WRITE) |
> @@ -4251,6 +4250,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
>  					      (1 << STRIPE_REPLACED)));
>  
>  		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
> +					    (1 << STRIPE_PREREAD_ACTIVE) |
>  					    (1 << STRIPE_DEGRADED)),
>  			      head_sh->state & (1 << STRIPE_INSYNC));
>  
> -- 
> 2.7.2
> 


