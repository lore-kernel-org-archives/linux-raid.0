From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] md: fix two problems with setting the "re-add" device
 state.
Date: Sun, 29 Apr 2018 04:44:13 -0500
Message-ID: <2f8d2066-8b2e-dab9-d1b9-b750055d6937@suse.de>
References: <87efj2mv6i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87efj2mv6i.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids



On 04/25/2018 11:46 PM, NeilBrown wrote:
> 
> If "re-add" is written to the "state" file for a device
> which is faulty, this has an effect similar to removing
> and re-adding the device.  It should take up the
> same slot in the array that it previously had, and
> an accelerated (e.g. bitmap-based) rebuild should happen.
> 
> The slot that "it previously had" is determined by
> rdev->saved_raid_disk.
> However this is not set when a device fails (only when a device
> is added), and it is cleared when resync completes.
> This means that "re-add" will normally work once, but may not work a
> second time.
> 
> This patch includes two fixes.
> 1/ when a device fails, record the ->raid_disk value in
>     ->saved_raid_disk before clearing ->raid_disk
> 2/ when "re-add" is written to a device for which
>     ->saved_raid_disk is not set, fail.
> 
> I think this is suitable for stable as it can
> cause re-adding a device to be forced to do a full
> resync which takes a lot longer and so puts data at
> more risk.
> 
> Cc: <stable@vger.kernel.org> (v4.1)
> Fixes: 97f6cd39da22 ("md-cluster: re-add capabilities")
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3bea45e8ccff..ecd4235c6e30 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2853,7 +2853,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>  			err = 0;
>  		}
>  	} else if (cmd_match(buf, "re-add")) {
> -		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1)) {
> +		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1) &&
> +			rdev->saved_raid_disk >= 0) {
>  			/* clear_bit is performed _after_ all the devices
>  			 * have their local Faulty bit cleared. If any writes
>  			 * happen in the meantime in the local node, they
> @@ -8641,6 +8642,7 @@ static int remove_and_add_spares(struct mddev *mddev,
>  			if (mddev->pers->hot_remove_disk(
>  				    mddev, rdev) == 0) {
>  				sysfs_unlink_rdev(mddev, rdev);
> +				rdev->saved_raid_disk = rdev->raid_disk;
>  				rdev->raid_disk = -1;
>  				removed++;
>  			}
> 

Performing a partial resync as opposed to full resync is always better
and less time consuming. Thanks!

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

-- 
Goldwyn
