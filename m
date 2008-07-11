From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/5] md: Make update_size() take the number of sectors.
Date: Fri, 11 Jul 2008 20:56:41 +1000
Message-ID: <18551.15465.61079.450222@notabene.brown>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
	<1215681338-32365-2-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Thursday July 10
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 10, maan@systemlinux.org wrote:
> @@ -4588,7 +4588,7 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
>  			return mddev->pers->reconfig(mddev, info->layout, -1);
>  	}
>  	if (info->size >= 0 && mddev->size != info->size)
> -		rv = update_size(mddev, info->size);
> +		rv = update_size(mddev, info->size * 2);
>  
>  	if (mddev->raid_disks    != info->raid_disks)
>  		rv = update_raid_disks(mddev, info->raid_disks);

I've made this
		rv = update_size(mddev, (sector_t)info->size * 2);

as info->size is an int and without the cast, a size of 2TB 
(2^31 K) would become 0.

Otherwise, it's good.  Thanks.

NeilBrown
