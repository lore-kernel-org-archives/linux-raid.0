From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid5: remove raid5_build_block
Date: Mon, 14 Aug 2017 09:20:20 -0700
Message-ID: <20170814162020.wkesdge7oego5xng@kernel.org>
References: <1502352737-26945-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1502352737-26945-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 10, 2017 at 04:12:17PM +0800, Guoqing Jiang wrote:
> Now raid5_build_block is just called to set the
> sector of r5dev, raid5_compute_blocknr can be
> used directly for the purpose.
> 
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Applied, thanks!
> ---
>  drivers/md/raid5.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 356cd9c..41143f9 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -491,7 +491,6 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
>  	return 0;
>  }
>  
> -static void raid5_build_block(struct stripe_head *sh, int i, int previous);
>  static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int previous,
>  			    struct stripe_head *sh);
>  
> @@ -527,7 +526,7 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int previous)
>  			WARN_ON(1);
>  		}
>  		dev->flags = 0;
> -		raid5_build_block(sh, i, previous);
> +		dev->sector = raid5_compute_blocknr(sh, i, previous);
>  	}
>  	if (read_seqcount_retry(&conf->gen_lock, seq))
>  		goto retry;
> @@ -2663,14 +2662,6 @@ static void raid5_end_write_request(struct bio *bi)
>  		raid5_release_stripe(sh->batch_head);
>  }
>  
> -static void raid5_build_block(struct stripe_head *sh, int i, int previous)
> -{
> -	struct r5dev *dev = &sh->dev[i];
> -
> -	dev->flags = 0;
> -	dev->sector = raid5_compute_blocknr(sh, i, previous);
> -}
> -
>  static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
>  {
>  	char b[BDEVNAME_SIZE];
> -- 
> 2.10.0
> 
