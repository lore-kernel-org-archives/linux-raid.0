From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 11/14] md-cluster: introduce cluster_check_sync_size
Date: Tue, 28 Feb 2017 11:05:45 -0800
Message-ID: <20170228190545.katik7exfukly6fw@kernel.org>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-12-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487906124-20107-12-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:15:21AM +0800, Guoqing Jiang wrote:
> Support resize is a little complex for clustered
> raid, since we need to ensure all the nodes share
> the same knowledge about the size of raid.
> 
> We achieve the goal by check the sync_size which
> is in each node's bitmap, we can only change the
> capacity after cluster_check_sync_size returns 0.
> 
> Also, get_bitmap_from_slot is added to get a slot's
> bitmap. And we exported some funcs since they are
> used in cluster_check_sync_size().
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/bitmap.c     | 25 ++++++++++++++++++++-
>  drivers/md/bitmap.h     |  2 ++
>  drivers/md/md-cluster.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 84 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 9fb2ccac958a..67a7d399f501 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -471,6 +471,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
>  	kunmap_atomic(sb);
>  	write_page(bitmap, bitmap->storage.sb_page, 1);
>  }
> +EXPORT_SYMBOL(bitmap_update_sb);
>  
>  /* print out the bitmap file superblock */
>  void bitmap_print_sb(struct bitmap *bitmap)
> @@ -1727,7 +1728,7 @@ void bitmap_flush(struct mddev *mddev)
>  /*
>   * free memory that was allocated
>   */
> -static void bitmap_free(struct bitmap *bitmap)
> +void bitmap_free(struct bitmap *bitmap)
>  {
>  	unsigned long k, pages;
>  	struct bitmap_page *bp;
> @@ -1761,6 +1762,7 @@ static void bitmap_free(struct bitmap *bitmap)
>  	kfree(bp);
>  	kfree(bitmap);
>  }
> +EXPORT_SYMBOL(bitmap_free);
>  
>  void bitmap_destroy(struct mddev *mddev)
>  {
> @@ -1920,6 +1922,27 @@ int bitmap_load(struct mddev *mddev)
>  }
>  EXPORT_SYMBOL_GPL(bitmap_load);
>  
> +struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
> +{
> +	int rv = 0;
> +	struct bitmap *bitmap;
> +
> +	bitmap = bitmap_create(mddev, slot);
> +	if (IS_ERR(bitmap)) {
> +		rv = PTR_ERR(bitmap);
> +		return ERR_PTR(rv);
> +	}
> +
> +	rv = bitmap_init_from_disk(bitmap, 0);
> +	if (rv) {
> +		bitmap_free(bitmap);
> +		return ERR_PTR(rv);
> +	}
> +
> +	return bitmap;
> +}
> +EXPORT_SYMBOL(get_bitmap_from_slot);
> +
>  /* Loads the bitmap associated with slot and copies the resync information
>   * to our bitmap
>   */
> diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
> index 5b6dd63dda91..9f761097aab2 100644
> --- a/drivers/md/bitmap.h
> +++ b/drivers/md/bitmap.h
> @@ -267,8 +267,10 @@ void bitmap_daemon_work(struct mddev *mddev);
>  
>  int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>  		  int chunksize, int init);
> +struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
>  int bitmap_copy_from_slot(struct mddev *mddev, int slot,
>  				sector_t *lo, sector_t *hi, bool clear_bits);
> +void bitmap_free(struct bitmap *bitmap);
>  #endif
>  
>  #endif
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index f1b9a7a3ddd2..d3c024e6bfcf 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1089,6 +1089,64 @@ static void metadata_update_cancel(struct mddev *mddev)
>  	unlock_comm(cinfo);
>  }
>  
> +/*
> + * retun 0 if all the bitmaps have the same sync_size
> + */
> +int cluster_check_sync_size(struct mddev *mddev)
> +{
> +	int i, rv;
> +	bitmap_super_t *sb;
> +	unsigned long my_sync_size, sync_size = 0;
> +	int node_num = mddev->bitmap_info.nodes;
> +	int current_slot = md_cluster_ops->slot_number(mddev);
> +	struct bitmap *bitmap = mddev->bitmap;
> +	char str[64];
> +	struct dlm_lock_resource *bm_lockres;
> +
> +	sb = kmap_atomic(bitmap->storage.sb_page);
> +	my_sync_size = sb->sync_size;
> +	kunmap_atomic(sb);
> +
> +	for (i = 0; i < node_num; i++) {
> +		if (i == current_slot)
> +			continue;
> +
> +		bitmap = get_bitmap_from_slot(mddev, i);
> +		if (IS_ERR(bitmap)) {
> +			pr_err("can't get bitmap from slot %d\n", i);
> +			return -1;
> +		}
> +
> +		/*
> +		 * If we can hold the bitmap lock of one node then
> +		 * the slot is not occupied, update the sb.
> +		 */
> +		snprintf(str, 64, "bitmap%04d", i);
> +		bm_lockres = lockres_init(mddev, str, NULL, 1);
> +		if (!bm_lockres) {
> +			pr_err("md-cluster: Cannot initialize %s\n", str);
> +		}

just print error here?

> +		bm_lockres->flags |= DLM_LKF_NOQUEUE;
> +		rv = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
> +		if (!rv)
> +			bitmap_update_sb(bitmap);

always the sb even the sync_size is the same?

