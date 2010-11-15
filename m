From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: fix return value of rdev_size_change()
Date: Mon, 15 Nov 2010 12:00:57 +1100
Message-ID: <20101115120057.4879d7dc@notabene.brown>
References: <4cdc55d1.4800e70a.1ffa.6729@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4cdc55d1.4800e70a.1ffa.6729@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 11 Nov 2010 20:25:17 +0000
Justin Maggard <jmaggard10@gmail.com> wrote:

> When trying to grow an array by enlarging component devices, rdev_size_store()
> expects the return value of rdev_size_change() to be in sectors, but the actual
> value is returned in KBs.

Thanks.
This was broken by commit dd8ac336c13fd8afdb082ebacb1cddd5cf727889
so is broken in all kernels since 2.6.30.
I've queued of the patch for my next pull request to Linus.

Thanks for the report and the patch.

NeilBrown


> 
> Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
> ---
>  drivers/md/md.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4e957f3..a0615af 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1337,7 +1337,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
>  	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>  		       rdev->sb_page);
>  	md_super_wait(rdev->mddev);
> -	return num_sectors / 2; /* kB for sysfs */
> +	return num_sectors;
>  }
>  
>  
> @@ -1704,7 +1704,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
>  	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
>  		       rdev->sb_page);
>  	md_super_wait(rdev->mddev);
> -	return num_sectors / 2; /* kB for sysfs */
> +	return num_sectors;
>  }
>  
>  static struct super_type super_types[] = {

