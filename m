From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: correct degraded calculation in raid5_error
Date: Fri, 17 Nov 2017 10:44:04 -0800
Message-ID: <20171117184404.vjvxnuyfgqdqidpt@kernel.org>
References: <037b2ecbddfc7710ebf8bb345e991836@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <037b2ecbddfc7710ebf8bb345e991836@synology.com>
Sender: linux-raid-owner@vger.kernel.org
To: bingjingc <bingjingc@synology.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 17, 2017 at 10:57:44AM +0800, bingjingc wrote:
> When disk failure occurs on new disks for reshape, mddev->degraded
> is not calculated correctly. Faulty bit of the failure device is not
> set before raid5_calc_degraded(conf).
> 
> mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/loop[012]
> mdadm /dev/md0 -a /dev/loop3
> mdadm /dev/md0 --grow -n4
> mdadm /dev/md0 -f /dev/loop3 # simulating disk failure
> 
> cat /sys/block/md0/md/degraded # it outputs 0, but it should be 1.
> 
> However, mdadm -D /dev/md0 will show that it is degraded. It's a bug.
> It can be fixed by moving the resources raid5_calc_degraded() depends
> on before it.
> 
> Reported-by: Roy Chung <roychung@synology.com>
> Reviewed-by: Alex Wu <alexwu@synology.com>
> Signed-off-by: BingJing Chang <bingjingc@synology.com>

Applied, thanks!
> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 31dc25e..98ce427 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2677,13 +2677,13 @@ static void raid5_error(struct mddev *mddev, struct
> md_rdev *rdev)
>  	pr_debug("raid456: error called\n");
> 
>  	spin_lock_irqsave(&conf->device_lock, flags);
> +	set_bit(Faulty, &rdev->flags);
>  	clear_bit(In_sync, &rdev->flags);
>  	mddev->degraded = raid5_calc_degraded(conf);
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
>  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> 
>  	set_bit(Blocked, &rdev->flags);
> -	set_bit(Faulty, &rdev->flags);
>  	set_mask_bits(&mddev->sb_flags, 0,
>  		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
>  	pr_crit("md/raid:%s: Disk failure on %s, disabling device.\n"
> --
> 2.7.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
