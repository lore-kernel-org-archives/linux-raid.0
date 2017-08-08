From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: preserve whole sb_page when initializing
 bitmap
Date: Tue, 8 Aug 2017 08:29:29 -0700
Message-ID: <20170808152856.bhoikpeuw7pg6yy5@kernel.org>
References: <20170802061137.2434370-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170802061137.2434370-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Tue, Aug 01, 2017 at 11:11:37PM -0700, Song Liu wrote:
> When bitmap_resize() is used to initialize the bitmap, it is
> necessary to preserve the whole page of sb_page instead of just
> the header (bitmap_super_t). This is because the sb_page may
> contain bitmap read from the disks (initialized by mdadm).
> 
> Note that, this code path is only triggered with certain
> combinations of parameters. One example is when raid456 array
> is created with write journal

Good catch, this issue probably only exists with journal, because we write
superblock there.
 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/bitmap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 40f3cd7..93dd809 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -2118,7 +2118,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blocks,
>  	if (store.sb_page && bitmap->storage.sb_page)
>  		memcpy(page_address(store.sb_page),
>  		       page_address(bitmap->storage.sb_page),
> -		       sizeof(bitmap_super_t));
> +		       init ? PAGE_SIZE : sizeof(bitmap_super_t));

I think this should be 'roundup(sizeof(bitmap_super_t),
bdev_logical_block_size(rdev->bdev))', we not always read one page.

The init check is unnecessary too, because if it isn't init, we will initialize
the bitmaps later in bitmap_resize, so the copy doesn't matter.

Thanks,
Shaohua


>  	bitmap_file_unmap(&bitmap->storage);
>  	bitmap->storage = store;
>  
> -- 
> 2.9.3
> 
