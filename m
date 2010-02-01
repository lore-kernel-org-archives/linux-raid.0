From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/3] md: Add support for Raid5->Raid0 and Raid10->Raid0
 takeover
Date: Mon, 1 Feb 2010 11:05:49 +1100
Message-ID: <20100201110549.162aa9f5@notabene.brown>
References: <F2A46F4A087B8547923AD59C289DC90E01D16227@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2A46F4A087B8547923AD59C289DC90E01D16227@irsmsx002.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 29 Jan 2010 14:54:10 +0000
"Trela, Maciej" <Maciej.Trela@intel.com> wrote:


> +static void *raid0_takeover_raid10(mddev_t *mddev)
> +{
> +	mdk_rdev_t *rdev;
> +
> +	/* Check layout: 
> +	 *  assuming that far_copies is 1 and disks number is even 
> +	 *  also all mirrors must be already degraded
> +	 */
> +	if ((mddev->layout >> 8) != 1) {
> +	    printk(KERN_ERR "error: Raid0 cannot takover layout: %x\n", mddev->layout);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	if (mddev->raid_disks & 1) {
> +	    printk(KERN_ERR "error: Raid0 cannot takover Raid10 with odd disk number.\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +	if (mddev->degraded != (mddev->raid_disks>>1)) {
> +	    printk(KERN_ERR "error: All mirrors must be already degraded!\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +	
> +	/* Set new parameters */
> +	mddev->new_level = 0;
> +	mddev->raid_disks -= mddev->degraded;
> +	mddev->delta_disks = -mddev->degraded;
> +	mddev->degraded = 0;
> +	/* make sure it will be not marked as dirty */
> +	mddev->recovery_cp = MaxSector;
> +
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {	
> +		rdev->raid_disk /= 2;
> +	}


You assume here that near_copies is 2, but you never check for that.

Also - and this applies to raid5 and raid10 - the devices may not be all the
same size.  raid5 and raid10 will just use the size of the smallest device,
but raid0 won't.  For for a seamless conversion, you need to handle the case
that the devices are not the same size.  Either disallow that case, or make
use of the extra space.

NeilBrown


