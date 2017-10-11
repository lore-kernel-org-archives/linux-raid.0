From: Joshua Kinard <kumba@gentoo.org>
Subject: Re: [PATCH] md/bitmap: avoid read out of the disk
Date: Wed, 11 Oct 2017 08:41:43 -0400
Message-ID: <7c6240ee-bed5-b020-db17-bd02df5467eb@gentoo.org>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

On 10/10/2017 17:20, Shaohua Li wrote:
> From: Shaohua Li <shli@fb.com>
> 
> If PAGE_SIZE is bigger than 4k, we could read out of the disk boundary. Limit
> the read size to the end of disk. Write path already has similar limitation.
> 
> Fix: 8031c3ddc70a(md/bitmap: copy correct data for bitmap super)
> Reported-by: Joshua Kinard <kumba@gentoo.org>
> Tested-by: Joshua Kinard <kumba@gentoo.org>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/bitmap.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index d2121637b4ab..f68ec973fbdd 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -153,6 +153,7 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
>  
>  	struct md_rdev *rdev;
>  	sector_t target;
> +	int target_size;
>  
>  	rdev_for_each(rdev, mddev) {
>  		if (! test_bit(In_sync, &rdev->flags)
> @@ -161,9 +162,12 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
>  			continue;
>  
>  		target = offset + index * (PAGE_SIZE/512);
> +		target_size = min_t(u64, size, i_size_read(rdev->bdev->bd_inode) -
> +			((target + rdev->sb_start) << 9));
> +		target_size = roundup(target_size,
> +			bdev_logical_block_size(rdev->bdev));
>  
> -		if (sync_page_io(rdev, target,
> -				 roundup(size, bdev_logical_block_size(rdev->bdev)),
> +		if (sync_page_io(rdev, target, target_size,
>  				 page, REQ_OP_READ, 0, true)) {
>  			page->index = index;
>  			return 0;
> 

Acked-by: Joshua Kinard <kumba@gentoo.org>

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
6144R/F5C6C943 2015-04-27
177C 1972 1FB8 F254 BAD0 3E72 5C63 F4E3 F5C6 C943

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
