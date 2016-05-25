From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] right meaning of PARITY_ENABLE_RMW and PARITY_PREFER_RMW
Date: Wed, 25 May 2016 09:02:16 -0700
Message-ID: <20160525160216.GA15101@kernel.org>
References: <1464049506-1589075-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464049506-1589075-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, stockhausen@collogia.de, neilb@suse.de
List-Id: linux-raid.ids

On Mon, May 23, 2016 at 05:25:06PM -0700, Song Liu wrote:
> In current handle_stripe_dirtying, the code prefers rmw with
> PARITY_ENABLE_RMW; while prefers rcw with PARITY_PREFER_RMW.
> 
> This patch reverses this behavior.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8959e6d..ad9e15a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3600,7 +3600,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>  	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
>  		(unsigned long long)sh->sector, rmw, rcw);
>  	set_bit(STRIPE_HANDLE, &sh->state);
> -	if ((rmw < rcw || (rmw == rcw && conf->rmw_level == PARITY_ENABLE_RMW)) && rmw > 0) {
> +	if ((rmw < rcw || (rmw == rcw && conf->rmw_level == PARITY_PREFER_RMW)) && rmw > 0) {
>  		/* prefer read-modify-write, but need to get some data */
>  		if (conf->mddev->queue)
>  			blk_add_trace_msg(conf->mddev->queue,
> @@ -3627,7 +3627,7 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>  			}
>  		}
>  	}
> -	if ((rcw < rmw || (rcw == rmw && conf->rmw_level != PARITY_ENABLE_RMW)) && rcw > 0) {
> +	if ((rcw < rmw || (rcw == rmw && conf->rmw_level != PARITY_PREFER_RMW)) && rcw > 0) {
>  		/* want reconstruct write, but need to get some data */
>  		int qread =0;
>  		rcw = 0;

The patch looks correct, I'll apply.

I'm wondering why original code is in current way. It dosn't work like what the
patch log (d06f191f8ecae) describes. Neil/Markus, is any patch missed?

Thanks,
Shaohua
