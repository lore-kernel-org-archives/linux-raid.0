From: Neil Brown <neilb@suse.de>
Subject: Re: [md PATCH 2/5]  md: Enable reshape for external metadata
Date: Wed, 16 Jun 2010 14:53:43 +1000
Message-ID: <20100616145343.1fc13b4c@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D11EECE8A2@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D11EECE8A2@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 9 Jun 2010 15:21:05 +0100
"Kwolek, Adam" <adam.kwolek@intel.com> wrote:

> (md: Online Capacity Expansion for IMSM)
> Reshape can't go forward for external metadatas due to fact, that internal md flags are updated during native meta writing. For external metadatas
> md_update_sb() is not called (reshape process is blocked).
> To take carry about md flags in external metadata array case and allow reshape to roll over, md_update_sb() is called in similar way to native metadata. The difference is that metadata is not stored to disks by md, but externally by mdmon.

I agree there is a problem here but I think you are approaching it the wrong
way.  We need to make sure the problem flag doesn't get set when external
metadata is used.

I found something similar (maybe the same thing) when writing the dm-raid456
module.  Does that patch:

http://neil.brown.name/git?p=md;a=commitdiff;h=3b930b37e50702f97f8fad6d7f5ee6d3f268394e

solve the problem for you?

Thanks,
NeilBrown


> ---
> 
>  drivers/md/md.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c index 9cec771..0a51406 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2065,8 +2065,6 @@ static void md_update_sb(mddev_t * mddev, int force_change)
>  	int nospares = 0;
>  
>  	mddev->utime = get_seconds();
> -	if (mddev->external)
> -		return;
>  repeat:
>  	spin_lock_irq(&mddev->write_lock);
>  
> @@ -2130,11 +2128,16 @@ repeat:
>  	/*
>  	 * do not write anything to disk if using
>  	 * nonpersistent superblocks
> +	 * and
> +	 * for external meta and reshape
> +	 * we can get here also
>  	 */
> -	if (!mddev->persistent) {
> -		if (!mddev->external)
> -			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
> -
> +	if (!mddev->persistent ||
> +	    mddev->external) {
> +		/* Reshape for external meta
> +		 * MD_CHANGE_PENDING has to be cleared also
> +		 */
> +		clear_bit(MD_CHANGE_PENDING, &mddev->flags);
>  		spin_unlock_irq(&mddev->write_lock);
>  		wake_up(&mddev->sb_wait);
>  		return;
> @@ -6895,8 +6898,15 @@ void md_check_recovery(mddev_t *mddev)
>  		(mddev->external == 0 && mddev->safemode == 1) ||
>  		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
>  		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
> -		))
> +		)) {
> +
> +		/* Reshape for external meta /add disks/
> +		 */
> +		if ((mddev->external) && (mddev->flags))
> +			md_update_sb(mddev, 0);
> +
>  		return;
> +	}
>  
>  	if (mddev_trylock(mddev)) {
>  		int spares = 0;
> 

