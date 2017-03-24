From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5:fix typo in comments of resize_stripes
Date: Thu, 23 Mar 2017 22:59:04 -0700
Message-ID: <20170324055904.j4uxq46wtiastaj6@kernel.org>
References: <1489673439-23594-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489673439-23594-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 16, 2017 at 10:10:39PM +0800, Zhilong Liu wrote:
> raid5.c: fix typo in comment of resize_stripes()
> and delete repeated words.

I merged this one and the bitmap one into a single patch and added into md tree, thanks!
 
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  drivers/md/raid5.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4fb09b3..cb55b3b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2209,7 +2209,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
>  	 *    pages have been transferred over, and the old kmem_cache is
>  	 *    freed when all stripes are done.
>  	 * 3/ reallocate conf->disks to be suitable bigger.  If this fails,
> -	 *    we simple return a failre status - no need to clean anything up.
> +	 *    we simple return a failure status - no need to clean anything up.
>  	 * 4/ allocate new pages for the new slots in the new stripe_heads.
>  	 *    If this fails, we don't bother trying the shrink the
>  	 *    stripe_heads down again, we just leave them as they are.
> @@ -3448,7 +3448,7 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
>  	    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
>  		/* Pre-reads at not permitted until after short delay
>  		 * to gather multiple requests.  However if this
> -		 * device is no Insync, the block could only be be computed
> +		 * device is no Insync, the block could only be computed
>  		 * and there is no need to delay that.
>  		 */
>  		return 0;
> @@ -3467,7 +3467,7 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
>  
>  	/* If we are forced to do a reconstruct-write, either because
>  	 * the current RAID6 implementation only supports that, or
> -	 * or because parity cannot be trusted and we are currently
> +	 * because parity cannot be trusted and we are currently
>  	 * recovering it, there is extra need to be careful.
>  	 * If one of the devices that we would need to read, because
>  	 * it is not being overwritten (and maybe not written at all)
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
