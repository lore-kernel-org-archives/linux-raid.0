From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: ensure sectors is nonzero when change component size
Date: Thu, 12 Oct 2017 10:37:43 -0700
Message-ID: <20171012173743.nocrm6ejov3pvhjd@kernel.org>
References: <1507797051-18545-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507797051-18545-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Thu, Oct 12, 2017 at 04:30:51PM +0800, Zhilong Liu wrote:
> Against the raids which chunk_size is meaningful, the component_size
> must be >= chunk_size when require resize. If "new_size < chunk_size"
> has required, the "mddev->pers->resize" will set sectors as '0', and
> then the raids isn't meaningful any more due to mddev->dev_sectors is
> '0'.
> 
> Cc: Neil Brown <neilb@suse.com>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

Not sure about this, does size 0 disk really harm?

> ---
>  drivers/md/raid10.c | 2 ++
>  drivers/md/raid5.c  | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 374df57..f3891f6 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3871,6 +3871,8 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
>  
>  	oldsize = raid10_size(mddev, 0, 0);
>  	size = raid10_size(mddev, sectors, 0);
> +	if (size == 0)
> +		return -EINVAL;
>  	if (mddev->external_size &&
>  	    mddev->array_sectors > size)
>  		return -EINVAL;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 928e24a..768767c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7725,6 +7725,8 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
>  	if (conf->log || raid5_has_ppl(conf))
>  		return -EINVAL;
>  	sectors &= ~((sector_t)conf->chunk_sectors - 1);
> +	if (sectors == 0)
> +		return -EINVAL;
>  	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
>  	if (mddev->external_size &&
>  	    mddev->array_sectors > newsize)
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
