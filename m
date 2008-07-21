From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/4] md: Make mddev->array_size sector-based.
Date: Mon, 21 Jul 2008 20:29:21 +1000
Message-ID: <18564.25857.90818.972326@notabene.brown>
References: <1216382419-2560-1-git-send-email-maan@systemlinux.org>
	<1216382419-2560-4-git-send-email-maan@systemlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Friday July 18
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 18, maan@systemlinux.org wrote:
> index 8f4c70a..1e1a217 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4413,8 +4413,8 @@ static int raid5_resize(mddev_t *mddev, sector_t sectors)
>  	raid5_conf_t *conf = mddev_to_conf(mddev);
>  
>  	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
> -	mddev->array_size = (sectors * (mddev->raid_disks-conf->max_degraded))>>1;
> -	set_capacity(mddev->gendisk, mddev->array_size << 1);
> +	mddev->array_sectors = sectors * mddev->raid_disks-conf->max_degraded;
> +	set_capacity(mddev->gendisk, mddev->array_sectors);
>  	mddev->changed = 1;
>  	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
>  		mddev->recovery_cp = mddev->size << 1;

Can you spot the bug in this chunk?

There is a subtraction in there which is no longer inside parentheses,
so the multiplication takes precedence.
I've fixed it and put spaces around the '-' to make it more obvious.

The rest are OK.

For future patches, could you please:

1/ run ./scripts/checkpatch.pl on them and fix the warnings, mostly
   line length issues in this case.
2/ run the mdadm test suite on a kernel with the patches applied.
   In an mdadm source directory,
        make test
        sudo sh test

   You probably need
        echo 2000 > /proc/sys/dev/raid/speed_limit_max
   first.. I should make that part of the test code one day.

   Interpreting the errors can be a bit tricky, and while seeing
   complete success doesn't prove it is bug free, it is encouraging, and
   did catch the above bug.
   Note that you cannot use this test suite on a machine that has
   active md arrays.

Thanks,
NeilBrown
