From: Neil Brown <neilb@suse.de>
Subject: Re: linear : divide error: 0000
Date: Thu, 6 Nov 2008 17:44:24 +1100
Message-ID: <18706.37448.38431.286111@notabene.brown>
References: <20081103103221.GJ17966@skl-net.de>
	<20081103182818.GM17966@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday November 3
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Wei Yongquan <weiyqlq@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday November 3, maan@systemlinux.org wrote:
> > This sector_div() is in linear_conf() while the call trace indicates
> > the bug happens in mddev_put(). I'll have a deeper look later today.
> 
> Indeed, this sector_div() is responsible for the bug. The following
> patch (against Neil's for-next tree) should fix this. Please give it a
> try.

Thanks Andre.  This is definitely a bug, since 2.6.14!!

I'll queue that patch for mainline and -stable.

Thanks,
NeilBrown

> 
> Andre
> 
> commit 284b3e2a37c8790d0e9315aed03d594165a85455
> Author: Andre Noll <maan@systemlinux.org>
> Date:   Mon Nov 3 19:39:22 2008 +0100
> 
>     md: linear: Fix a division by zero bug for very small arrays.
>     
>     We currently oops with a divide error on starting a linear software
>     raid array consisting of at least two very small (< 500K) devices.
>     
>     The bug is caused by the calculation of the hash table size which
>     tries to compute sector_div(sz, base) with "base" being zero due to
>     the small size of the component devices of the array.
>     
>     Fix this by requiring the hash spacing to be at least one which
>     implies that also "base" is non-zero.
>     
>     Signed-off-by: Andre Noll <maan@systemlinux.org>
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 190147c..3b90c5c 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -148,6 +148,8 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>  
>  	min_sectors = conf->array_sectors;
>  	sector_div(min_sectors, PAGE_SIZE/sizeof(struct dev_info *));
> +	if (min_sectors == 0)
> +		min_sectors = 1;
>  
>  	/* min_sectors is the minimum spacing that will fit the hash
>  	 * table in one PAGE.  This may be much smaller than needed.
> -- 
> The only person who always got his work done by Friday was Robinson Crusoe
