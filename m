From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Wed, 13 Feb 2013 12:45:42 +0100
Message-ID: <511B7CE6.5060806@profitbricks.com>
References: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com> <20130213133820.6496b074@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130213133820.6496b074@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13.02.2013 03:38, NeilBrown wrote:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8b557d2..292cc2f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6529,7 +6529,17 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>  			mddev->ro = 0;
>  			sysfs_notify_dirent_safe(mddev->sysfs_state);
>  			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -			md_wakeup_thread(mddev->thread);
> +			/* mddev_unlock will wake thread */
> +			/* If a device failed while we were read-only, we
> +			 * need to make sure the metadata is updated now.
> +			 */
> +			if (test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
> +				mddev_unlock(mddev);
> +				wait_event(mddev->sb_wait,
> +					   !test_bit(MD_CHANGE_DEVS, &mddev->flags) &&
> +					   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> +				mddev_lock(mddev);
> +			}
>  		} else {
>  			err = -EROFS;
>  			goto abort_unlock;
> 

Thanks, Neil!

I can confirm the issue on 3.4.y and that your patch fixes it reliably.

Acked-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>

