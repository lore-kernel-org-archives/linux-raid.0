From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: disable bitmap_resize for file-backed bitmaps.
Date: Thu, 31 Aug 2017 22:56:11 -0700
Message-ID: <20170901055611.aeio2tgbb27g7rzr@kernel.org>
References: <87tw0ofuv6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87tw0ofuv6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Zhilong Liu <zlliu@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 31, 2017 at 10:23:25AM +1000, Neil Brown wrote:
> 
> bitmap_resize() does not work for file-backed bitmaps.
> The buffer_heads are allocated and initialized when
> the bitmap is read from the file, but resize doesn't
> read from the file, it loads from the internal bitmap.
> When it comes time to write the new bitmap, the bh is
> non-existent and we crash.
> 
> The common case when growing an array involves making the array larger,
> and that normally means making the bitmap larger.  Doing
> that inside the kernel is possible, but would need more code.
> It is probably easier to require people who use file-backed
> bitmaps to remove them and re-add after a reshape.
> 
> So this patch disables the resizing of arrays which have
> file-backed bitmaps.  This is better than crashing.
> 
> Reported-by: Zhilong Liu <zlliu@suse.com>
> Fixes: d60b479d177a ("md/bitmap: add bitmap_resize function to allow bitmap resizing.")
> Cc: stable@vger.kernel.org (v3.5+).
> Signed-off-by: NeilBrown <neilb@suse.com>

Makes sense, applied
> ---
>  drivers/md/bitmap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> It might not be *too* hard to make this work for file-backed bitmaps,
> but I'm not sure it is worth the effort, and this is certainly the best
> patch to send to -stable.
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 40f3cd7eab0f..cae57b5be817 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -2058,6 +2058,11 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>  	long pages;
>  	struct bitmap_page *new_bp;
>  
> +	if (bitmap->storage.file && !init) {
> +		pr_info("md: cannot resize file-based bitmap\n");
> +		return -EINVAL;
> +	}
> +
>  	if (chunksize == 0) {
>  		/* If there is enough space, leave the chunk size unchanged,
>  		 * else increase by factor of two until there is enough space.
> -- 
> 2.14.0.rc0.dirty
> 


