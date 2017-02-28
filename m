From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 12/14] md/bitmap: replace redundant codes with
 get_bitmap_from_slot
Date: Tue, 28 Feb 2017 11:06:10 -0800
Message-ID: <20170228190610.xq6kyo2blyme2syf@kernel.org>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-13-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487906124-20107-13-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:15:22AM +0800, Guoqing Jiang wrote:
> Since get_bitmap_from_slot is introduced in previous
> commit, we can use it in bitmap_copy_from_slot to
> remove redundant code.

this should be merged into patch 11
 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/bitmap.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 67a7d399f501..b6fa55a3cff8 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1952,14 +1952,13 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
>  	int rv = 0, i, j;
>  	sector_t block, lo = 0, hi = 0;
>  	struct bitmap_counts *counts;
> -	struct bitmap *bitmap = bitmap_create(mddev, slot);
> -
> -	if (IS_ERR(bitmap))
> -		return PTR_ERR(bitmap);
> +	struct bitmap *bitmap;
>  
> -	rv = bitmap_init_from_disk(bitmap, 0);
> -	if (rv)
> -		goto err;
> +	bitmap = get_bitmap_from_slot(mddev, slot);
> +	if (IS_ERR(bitmap)) {
> +		pr_err("%s can't get bitmap from slot %d\n", __func__, slot);
> +		return -1;
> +	}
>  
>  	counts = &bitmap->counts;
>  	for (j = 0; j < counts->chunks; j++) {
> @@ -1986,8 +1985,7 @@ int bitmap_copy_from_slot(struct mddev *mddev, int slot,
>  	bitmap_unplug(mddev->bitmap);
>  	*low = lo;
>  	*high = hi;
> -err:
> -	bitmap_free(bitmap);
> +
>  	return rv;
>  }
>  EXPORT_SYMBOL_GPL(bitmap_copy_from_slot);
> -- 
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
