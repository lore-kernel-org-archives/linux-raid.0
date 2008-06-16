From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] linear: correct disk numbering error check
Date: Tue, 17 Jun 2008 08:54:27 +1000
Message-ID: <18518.61219.83135.383069@notabene.brown>
References: <48527F2D020000C500027A7E@victor.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nikanth Karthikesan on Friday June 13
Sender: linux-raid-owner@vger.kernel.org
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 13, knikanth@novell.com wrote:
> Correct disk numbering problem check.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

Good catch, thanks for that!

NeilBrown


> 
> ---
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 1074824..ec921f5 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -126,7 +126,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>  		int j = rdev->raid_disk;
>  		dev_info_t *disk = conf->disks + j;
>  
> -		if (j < 0 || j > raid_disks || disk->rdev) {
> +		if (j < 0 || j >= raid_disks || disk->rdev) {
>  			printk("linear: disk numbering problem. Aborting!\n");
>  			goto out;
>  		}
> 
