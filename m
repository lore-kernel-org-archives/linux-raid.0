From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md: Add support for Raid0->Raid10 takeover
Date: Mon, 1 Feb 2010 11:08:29 +1100
Message-ID: <20100201110829.5516c80e@notabene.brown>
References: <F2A46F4A087B8547923AD59C289DC90E01D16228@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2A46F4A087B8547923AD59C289DC90E01D16228@irsmsx002.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 29 Jan 2010 14:54:21 +0000
"Trela, Maciej" <Maciej.Trela@intel.com> wrote:


> +static void *raid10_takeover_raid0(mddev_t *mddev)
> +{
> +	mdk_rdev_t *rdev;
> +
> +	if (mddev->degraded > 0)
> +	{
> +	    printk(KERN_ERR "error: degraded raid0!\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +	
> +	/* Update slot numbers to obtain 
> +	 * degraded raid10 with missing mirrors
> +	 */
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
> +		rdev->raid_disk *= 2;
> +	}
> +	
> +	/* Set new parameters */
> +	mddev->new_level = 10;
> +	/* new layout: far_copies = 1, 
> +       near_copies = raid0->raid_disks */
> +	mddev->new_layout = (1<<8) + mddev->raid_disks;
> +	mddev->delta_disks = mddev->raid_disks;
> +	mddev->degraded = mddev->raid_disks;
> +	mddev->raid_disks *= 2;

You are confusing raid_disk with near_copies.  They are very different things.

Presumably you want to make 'near_copies' always be 2.

NeilBrown

