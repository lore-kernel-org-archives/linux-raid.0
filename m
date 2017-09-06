From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md/raid5: preserve STRIPE_ON_UNPLUG_LIST in
 break_stripe_batch_list
Date: Tue, 5 Sep 2017 22:50:13 -0700
Message-ID: <20170906055013.63i4zshqxxtm6x6d@kernel.org>
References: <1504666955-15635-1-git-send-email-dennisyang@qnap.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504666955-15635-1-git-send-email-dennisyang@qnap.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Yang <dennisyang@qnap.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 06, 2017 at 11:02:35AM +0800, Dennis Yang wrote:
> In release_stripe_plug(), if a stripe_head has its STRIPE_ON_UNPLUG_LIST
> set, it indicates that this stripe_head is already in the raid5_plug_cb
> list and release_stripe() would be called instead to drop a reference
> count. Otherwise, the STRIPE_ON_UNPLUG_LIST bit would be set for this
> stripe_head and it will get queued into the raid5_plug_cb list.
> 
> Since break_stripe_batch_list() did not preserve STRIPE_ON_UNPLUG_LIST,
> A stripe could be re-added to plug list while it is still on that list
> in the following situation. If stripe_head A is added to another
> stripe_head B's batch list, in this case A will have its
> batch_head != NULL and be added into the plug list. After that,
> stripe_head B gets handled and called break_stripe_batch_list() to
> reset all the batched stripe_head(including A which is still on
> the plug list)'s state and reset their batch_head to NULL.
> Before the plug list gets processed, if there is another write request
> comes in and get stripe_head A, A will have its batch_head == NULL
> (cleared by calling break_stripe_batch_list() on B) and be added to
> plug list once again.

applied, thanks!
 
> Signed-off-by: Dennis Yang <dennisyang@qnap.com>
> ---
>  drivers/md/raid5.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e92dd2d..faf3cfd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4611,7 +4611,8 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
>  
>  		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
>  					    (1 << STRIPE_PREREAD_ACTIVE) |
> -					    (1 << STRIPE_DEGRADED)),
> +					    (1 << STRIPE_DEGRADED) |
> +					    (1 << STRIPE_ON_UNPLUG_LIST)),
>  			      head_sh->state & (1 << STRIPE_INSYNC));
>  
>  		sh->check_state = head_sh->check_state;
> -- 
> 1.9.1
> 
