From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: raid0: Make raid0_run() return a proper error code.
Date: Thu, 14 May 2009 21:21:46 +1000 (EST)
Message-ID: <846d967866a89248644f819abeddfc62.squirrel@neil.brown.name>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
    <1242297833-13908-5-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-5-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

On Thu, May 14, 2009 8:43 pm, Andre Noll wrote:
> Currently raid0_run() always returns -ENOMEM on errors. This is
> incorrect as running the array might fail for other reasons, for
> example because not all component devices were available.
>
> This patch changes create_strip_zones() so that it returns a proper
> error code (either -ENOMEM or -EINVAL) rather than 1 on errors and
> makes raid0_run(), its single caller, return that value instead
> of -ENOMEM.
>
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> ---
>  drivers/md/raid0.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 2401e94..0f4330f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -106,12 +106,12 @@ static int create_strip_zones (mddev_t *mddev)
>  	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
>  				conf->nr_strip_zones, GFP_KERNEL);
>  	if (!conf->strip_zone)
> -		return 1;
> +		return -ENOMEM;
>  	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
>  				conf->nr_strip_zones*mddev->raid_disks,
>  				GFP_KERNEL);
>  	if (!conf->devlist)
> -		return 1;
> +		return -ENOMEM;
>
>  	/* The first zone must contain all devices, so here we check that
>  	 * there is a proper alignment of slots to devices and find them all
> @@ -211,8 +211,8 @@ static int create_strip_zones (mddev_t *mddev)
>
>  	printk(KERN_INFO "raid0: done.\n");
>  	return 0;
> - abort:
> -	return 1;
> +abort:
> +	return -EINVAL;
>  }
>
>  /**
> @@ -258,6 +258,7 @@ static sector_t raid0_size(mddev_t *mddev, sector_t
> sectors, int raid_disks)
>  static int raid0_run(mddev_t *mddev)
>  {
>  	raid0_conf_t *conf;
> +	int ret;
>
>  	if (mddev->chunk_size == 0) {
>  		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
> @@ -273,12 +274,13 @@ static int raid0_run(mddev_t *mddev)
>
>  	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
>  	if (!conf)
> -		goto out;
> +		return -ENOMEM;
>  	mddev->private = (void *)conf;
>
>  	conf->strip_zone = NULL;
>  	conf->devlist = NULL;
> -	if (create_strip_zones (mddev))
> +	ret = create_strip_zones(mddev);
> +	if (ret < 0)
>  		goto out_free_conf;

Can we go one set further here and move the allocation of ->private
into create_stripe_zones.  It seems funny allocating it here and
never actually using it directly.

??

Everything else looks good.
Thanks for doing this.

NeilBrown




