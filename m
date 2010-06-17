From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md: enable raid4->raid0 takeover
Date: Thu, 17 Jun 2010 15:25:01 +1000
Message-ID: <20100617152501.596c9574@notabene.brown>
References: <BE2BFE91933D1B4089447C64486040801E873F07@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801E873F07@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 16 Jun 2010 11:56:12 +0100
"Trela, Maciej" <Maciej.Trela@intel.com> wrote:

> From: Maciej Trela <maciej.trela@intel.com>
> 
> Only level 5 with layout=PARITY_N can be taken over to raid0 now.
> Lets allow level 4 either.

Thanks.
->layout isn't set for level==4 so we really need separate code branches for
'4' and '5'.  I made this change.

Applied.
Thanks,
NeilBrown

> 
> Signed-off-by: Maciej Trela <maciej.trela@intel.com>
> ---
>  drivers/md/raid0.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c index ac09b7d..0b45759 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -569,7 +569,7 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
>  	return;
>  }
>  
> -static void *raid0_takeover_raid5(mddev_t *mddev)
> +static void *raid0_takeover_raid45(mddev_t *mddev)
>  {
>  	mdk_rdev_t *rdev;
>  	raid0_conf_t *priv_conf;
> @@ -650,9 +650,9 @@ static void *raid0_takeover(mddev_t *mddev)
>  	 *  raid5 - providing it is Raid4 layout and one disk is faulty
>  	 *  raid10 - assuming we have all necessary active disks
>  	 */
> -	if (mddev->level == 5) {
> +	if (mddev->level == 5 || mddev->level == 4){
>  		if (mddev->layout == ALGORITHM_PARITY_N)
> -			return raid0_takeover_raid5(mddev);
> +			return raid0_takeover_raid45(mddev);
>  
>  		printk(KERN_ERR "md/raid0:%s: Raid can only takeover Raid5 with layout: %d\n",
>  		       mdname(mddev), ALGORITHM_PARITY_N);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

