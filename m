From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH] md: also hot remove disk from pers when hot removing
Date: Fri, 16 Nov 2012 16:59:55 +0100
Message-ID: <50A662FB.1040801@profitbricks.com>
References: <1353079062-6711-1-git-send-email-sebastian.riemer@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1353079062-6711-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16.11.2012 16:17, Sebastian Riemer wrote:
> If hot adding a disk not as spare but at the same slot, the disk isn't added
> correctly in the pers and it is possible to cause a kernel panic/oops due to
> the invalid pointer to the old rdev in the pers. So hot remove the disk from
> the personality before removing it from the array.
>
> Tested with raid1.
>
> Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> ---
>  drivers/md/md.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9ab768a..1fc545b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5852,6 +5852,7 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
>  {
>  	char b[BDEVNAME_SIZE];
>  	struct md_rdev *rdev;
> +	int err;
>  
>  	rdev = find_rdev(mddev, dev);
>  	if (!rdev)
> @@ -5860,6 +5861,13 @@ static int hot_remove_disk(struct mddev * mddev, dev_t dev)
>  	if (rdev->raid_disk >= 0)
>  		goto busy;
>  
> +	if (mddev->pers && mddev->pers->hot_remove_disk) {
> +		err = mddev->pers->hot_remove_disk(mddev, rdev);
> +		if (err)
> +			return err;
> +		sysfs_unlink_rdev(rdev->mddev, rdev);

In this line for parameter 1 just "mddev" is better.

> +		rdev->raid_disk = -1;

Oops, this line is wrong and has to be removed. The slot number counts
up when re-adding. Because it is written to the superblock that this is
a spare.

> +	}
>  	kick_rdev_from_array(rdev);
>  	md_update_sb(mddev, 1);
>  	md_new_event(mddev);

I'll resend the patch.

Btw.: How I noticed the issue: I've developed MD RAID-1 replication for
read-only CD-ROM images. Nothing may write to read-only exports.
Therefore, I don't need any spares and can add the devices directly
again to the same slots of the MD array.

Cheers,
Sebastian
