From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH]  md: raid5 run(): Fix max_degraded for raid level 4.
Date: Fri, 20 Mar 2009 11:09:30 +1100
Message-ID: <18882.57018.465098.201167@notabene.brown>
References: <20090318125324.GL17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Wednesday March 18
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 18, maan@systemlinux.org wrote:
> Hi Neil,
> 
> I found this one while trying to figure out why 3-disk raid6 arrays
> aren't supported. It's an obvious and trivial bug fix but probably
> not important enough for stable as it only affects raid4.
> 

Thanks!
Applied.

Have you tried a 3-disk raid6 yet?  Any conclusions?

NeilBrown


> Regards
> Andre
> 
> commit ea30abef4d1f3aad635eb24db082f3531b573540
> Author: Andre Noll <maan@systemlinux.org>
> Date:   Wed Mar 18 13:43:08 2009 +0100
> 
>     md: raid5 run(): Fix max_degraded for raid level 4.
>     
>     raid4 allows only one failed disk.
>     
>     Signed-off-by: Andre Noll <maan@systemlinux.org>
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a76ef52..ceb5924 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4484,7 +4484,7 @@ static int run(mddev_t *mddev)
>  		 */
>  		sector_t here_new, here_old;
>  		int old_disks;
> -		int max_degraded = (mddev->level == 5 ? 1 : 2);
> +		int max_degraded = (mddev->level == 6 ? 2 : 1);
>  
>  		if (mddev->new_level != mddev->level ||
>  		    mddev->new_layout != mddev->layout ||
> -- 
> The only person who always got his work done by Friday was Robinson Crusoe
