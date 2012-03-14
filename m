From: keld@keldix.com
Subject: Re: [md PATCH 15/23] md/raid10 - support resizing some RAID10 arrays.
Date: Wed, 14 Mar 2012 07:17:46 +0100
Message-ID: <20120314061746.GA28196@www5.open-std.org>
References: <20120314043555.7978.75486.stgit@notabene.brown> <20120314044040.7978.69754.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120314044040.7978.69754.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

What is the problem with adding space to the 'far' layout?

I would think you could just create the new array part 1 from the old array part 2, and
then sync the new array part 2 with the new array part 1. (in the case of a far=2 array,
for n>2 similar constructs would apply).

best regards
Keld

On Wed, Mar 14, 2012 at 03:40:41PM +1100, NeilBrown wrote:
> 'resizing' an array in this context means making use of extra
> space that has become available in component devices, not adding new
> devices.
> It also includes shrinking the array to take up less space of
> component devices.
> 
> This is not supported for array with a 'far' layout.  However
> for 'near' and 'offset' layout arrays, adding and removing space at
> the end of the devices is easy to support, and this patch provides
> that support.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
> 
>  drivers/md/raid10.c |   38 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 7b3346a..2f7665c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3437,6 +3437,43 @@ static void raid10_quiesce(struct mddev *mddev, int state)
>  	}
>  }
>  
> +static int raid10_resize(struct mddev *mddev, sector_t sectors)
> +{
> +	/* Resize of 'far' arrays is not supported.
> +	 * For 'near' and 'offset' arrays we can set the
> +	 * number of sectors used to be an appropriate multiple
> +	 * of the chunk size.
> +	 * For 'offset', this is far_copies*chunksize.
> +	 * For 'near' the multiplier is the LCM of
> +	 * near_copies and raid_disks.
> +	 * So if far_copies > 1 && !far_offset, fail.
> +	 * Else find LCM(raid_disks, near_copy)*far_copies and
> +	 * multiply by chunk_size.  Then round to this number.
> +	 * This is mostly done by raid10_size()
> +	 */
> +	struct r10conf *conf = mddev->private;
> +	sector_t oldsize, size;
> +
> +	if (conf->far_copies > 1 && !conf->far_offset)
> +		return -EINVAL;
> +
> +	oldsize = raid10_size(mddev, 0, 0);
> +	size = raid10_size(mddev, sectors, 0);
> +	md_set_array_sectors(mddev, size);
> +	if (mddev->array_sectors > size)
> +		return -EINVAL;
> +	set_capacity(mddev->gendisk, mddev->array_sectors);
> +	revalidate_disk(mddev->gendisk);
> +	if (sectors > mddev->dev_sectors &&
> +	    mddev->recovery_cp > oldsize) {
> +		mddev->recovery_cp = oldsize;
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +	}
> +	mddev->dev_sectors = sectors;
> +	mddev->resync_max_sectors = size;
> +	return 0;
> +}
> +
>  static void *raid10_takeover_raid0(struct mddev *mddev)
>  {
>  	struct md_rdev *rdev;
> @@ -3506,6 +3543,7 @@ static struct md_personality raid10_personality =
>  	.sync_request	= sync_request,
>  	.quiesce	= raid10_quiesce,
>  	.size		= raid10_size,
> +	.resize		= raid10_resize,
>  	.takeover	= raid10_takeover,
>  };
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
