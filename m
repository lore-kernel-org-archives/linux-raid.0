From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 05/36] md: Disable bad blocks and v0.90 metadata.
Date: Sat, 23 Jul 2011 02:02:50 +0900
Message-ID: <87mxg645ad.fsf@gmail.com>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.55780.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721025847.8422.55780.stgit@notabene.brown> (NeilBrown's
	message of "Thu, 21 Jul 2011 12:58:48 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> v0.90 metadata cannot record bad blocks, so when loading metadata
> for such a device, set shift to -1.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>
>  drivers/md/md.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 18c3aab..340e2d4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1058,6 +1058,7 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
>  	rdev->preferred_minor = sb->md_minor;
>  	rdev->data_offset = 0;
>  	rdev->sb_size = MD_SB_BYTES;
> +	rdev->badblocks.shift = -1;
>  
>  	if (sb->level == LEVEL_MULTIPATH)
>  		rdev->desc_nr = -1;
> @@ -3009,6 +3010,9 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
>  			goto abort_free;
>  		}
>  	}
> +	if (super_format == -1)
> +		/* hot-add for 0.90, or non-persistent: so no badblocks */
> +		rdev->badblocks.shift = -1;

Maybe we need this as well:

	if (rdev->badblocks.shift == -1) {
		kfree(rdev->badblocks.page);
                rdev->badblocks.page = NULL;
                rdev->badblocks.active_page = NULL;
                rdev->badblocks.count = 0;
	}


>  
>  	return rdev;
>  
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
