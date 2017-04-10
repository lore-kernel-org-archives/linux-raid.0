From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V2] md/raid10: reset the 'first' at the end of loop
Date: Mon, 10 Apr 2017 10:41:13 -0700
Message-ID: <20170410174113.ffdkv6unvfanyrrg@kernel.org>
References: <1491017900-8150-1-git-send-email-gqjiang@suse.com>
 <1491441138-16155-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491441138-16155-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com
List-Id: linux-raid.ids

On Thu, Apr 06, 2017 at 09:12:18AM +0800, Guoqing Jiang wrote:
> We need to set "first = 0' at the end of rdev_for_each
> loop, so we can get the array's min_offset_diff correctly
> otherwise min_offset_diff just means the last rdev's
> offset diff.
> 
> Suggested-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

applied, thanks!

> ---
>  drivers/md/raid10.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0f13d57..e055ec9 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3769,6 +3769,7 @@ static int raid10_run(struct mddev *mddev)
>  
>  		if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
>  			discard_supported = true;
> +		first = 0;
>  	}
>  
>  	if (mddev->queue) {
> @@ -4172,6 +4173,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>  			if (first || diff < min_offset_diff)
>  				min_offset_diff = diff;
>  		}
> +		first = 0;
>  	}
>  
>  	if (max(before_length, after_length) > min_offset_diff)
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
