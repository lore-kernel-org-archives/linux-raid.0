From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: zero the original position of sb for 0.90 and 1.0
Date: Thu, 17 May 2018 09:21:28 -0700
Message-ID: <20180517162128.74fd5scca2yo3nep@kernel.org>
References: <1526462319-14222-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526462319-14222-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: robert.butera@oracle.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 16, 2018 at 05:18:39PM +0800, Jianchao Wang wrote:
> For sb version 0.90 and 1.0 which locates after data, when we increase
> the spindle volume size and grow the raid arry size, the older sb which is
> different between spindles will be left there. Due to this left sb, the
> spindle volume cannot be grown with zero filled part with  --asume-clean.
> applications have to take some workarounds such as sync_min/max to avoid
> resync.
> 
> It is easy and convevient for md to zero the older sb position after
> write sb to new position, so do it here.

From the description, this looks easy to do in userspace, eg, you can zero the
super before increase the spindle volume. Convenience isn't a reason we should
put these code into kernel space.

Thanks,
Shaohua 
> Cc: robert.butera@oracle.com
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> ---
>  drivers/md/md.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c208c01..a042add 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1020,6 +1020,23 @@ int md_check_no_bitmap(struct mddev *mddev)
>  }
>  EXPORT_SYMBOL(md_check_no_bitmap);
>  
> +static void md_zero_original_sb_position(struct md_rdev *rdev, sector_t old_pos)
> +{
> +	struct page *zero_pg;
> +
> +	zero_pg = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
> +	if (!zero_pg) {
> +		pr_warn("%s: failed to get page for zero original sb position",
> +				mdname(rdev->mddev));
> +		return;
> +	}
> +	md_super_write(rdev->mddev, rdev, old_pos, rdev->sb_size,
> +		       zero_pg);
> +	wait_event(rdev->mddev->sb_wait,
> +			(atomic_read(&rdev->mddev->pending_writes) == 0));
> +	__free_pages(zero_pg, 0);
> +}
> +
>  /*
>   * load_super for 0.90.0
>   */
> @@ -1394,6 +1411,8 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
>  static unsigned long long
>  super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
>  {
> +	sector_t old_pos = rdev->sb_start;
> +
>  	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
>  		return 0; /* component must fit device */
>  	if (rdev->mddev->bitmap_info.offset)
> @@ -1411,6 +1430,8 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
>  		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>  		       rdev->sb_page);
>  	} while (md_super_wait(rdev->mddev) < 0);
> +
> +	md_zero_original_sb_position(rdev, old_pos);
>  	return num_sectors;
>  }
>  
> @@ -1953,6 +1974,8 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
>  {
>  	struct mdp_superblock_1 *sb;
>  	sector_t max_sectors;
> +	sector_t old_pos = 0;
> +
>  	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
>  		return 0; /* component must fit device */
>  	if (rdev->data_offset != rdev->new_data_offset)
> @@ -1969,6 +1992,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
>  	} else {
>  		/* minor version 0; superblock after data */
>  		sector_t sb_start;
> +		old_pos = rdev->sb_start;
>  		sb_start = (i_size_read(rdev->bdev->bd_inode) >> 9) - 8*2;
>  		sb_start &= ~(sector_t)(4*2 - 1);
>  		max_sectors = rdev->sectors + sb_start - rdev->sb_start;
> @@ -1984,6 +2008,9 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
>  		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>  			       rdev->sb_page);
>  	} while (md_super_wait(rdev->mddev) < 0);
> +
> +	if (old_pos)
> +		md_zero_original_sb_position(rdev, old_pos);
>  	return num_sectors;
>  
>  }
> -- 
> 2.7.4
> 
