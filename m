From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 3/5] md: Use added disks for external metadata case
 in start_reshape()
Date: Wed, 16 Jun 2010 14:58:18 +1000
Message-ID: <20100616145818.75bf0720@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A3@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11EECE8A3@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 9 Jun 2010 15:21:44 +0100
"Kwolek, Adam" <adam.kwolek@intel.com> wrote:

> (md: Online Capacity Expansion for IMSM)
> Disks added by mdadm for external metadata are not taken for configuration check before reshape.
> This causes configuration check fail.
> 
> For reshape, we should check if added disks to volume by mdadm, will satisfy degradation condition after operation (comparing difference of target disk number and available disks number to mddev->max_degraded field).
> ---

I'm sorry but I don't understand what you are saying, and I think the
required check is already in place.
Could you please describe a specific circumstance where the current code
fails?

Thanks,
NeilBrown


> 
>  drivers/md/raid5.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index 546e23e..dc25a32 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5411,6 +5411,7 @@ static int raid5_start_reshape(mddev_t *mddev)
>  	int spares = 0;
>  	int added_devices = 0;
>  	unsigned long flags;
> +	int disk_count = 0;
>  
>  	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>  		return -EBUSY;
> @@ -5422,12 +5423,20 @@ static int raid5_start_reshape(mddev_t *mddev)
>  		if (rdev->raid_disk < 0 &&
>  		    !test_bit(Faulty, &rdev->flags))
>  			spares++;
> +		else
> +			/* check reshape condition/spares are added already
> +			 */
> +			disk_count++;
>  
>  	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
>  		/* Not enough devices even to make a degraded array
>  		 * of that size
> +		 * but check first if this is not reshape case
> +		 * if not reshape on degraded array /takeover/ than exit
>  		 */
> -		return -EINVAL;
> +		if ((conf->raid_disks + mddev->delta_disks)
> +		    > (disk_count + conf->max_degraded))
> +			return -EINVAL;
>  
>  	/* Refuse to reduce size of the array.  Any reductions in
>  	 * array size must be through explicit setting of array_size
> 

