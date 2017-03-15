From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/2] md/r5cache: journal remove support
Date: Wed, 15 Mar 2017 15:52:37 -0700
Message-ID: <20170315225237.ahnmqsoest57tj3m@kernel.org>
References: <20170315182816.3627123-1-songliubraving@fb.com>
 <20170315182816.3627123-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170315182816.3627123-2-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Wed, Mar 15, 2017 at 11:28:16AM -0700, Song Liu wrote:
> When journal device of an array fails, the array is forced into read-only
> mode. To make the array normal without adding another journal device, we
> need to remove journal _feature_ from the array.
> 
> This patch allows remove journal _feature_ from an array, For journal
> remove to work, existing journal should be either missing or faulty.
> 
> Two flags are added to GET_ARRAY_INFO for mdadm.
>   1. MD_SB_HAS_JOURNAL: meaning the array have journal feature;
>   2. MD_SB_JOURNAL_REMOVABLE: meaning the journal is faulty or missing
> 
> When both flags are set, mdadm can clear MD_SB_HAS_JOURNAL to remove
> journal _feature_.

please use the new 'consistency_policy' interface to remove journal support

> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/md.c                | 42 ++++++++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/raid/md_p.h | 11 ++++++++---
>  2 files changed, 48 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac3bd15..32ee994 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5981,6 +5981,25 @@ static void autorun_devices(int part)
>  }
>  #endif /* !MODULE */
>  
> +/*
> + * the journal _feature_ is removable when:
> + * the array has journal support &&
> + *    (journal is missing || journal is faulty)
> + */
> +static bool journal_removable(struct mddev *mddev)
> +{
> +	struct md_rdev *rdev;
> +
> +	if (!test_bit(MD_HAS_JOURNAL, &mddev->flags))
> +		return false;
> +
> +	rdev_for_each_rcu(rdev, mddev)
> +		if (test_bit(Journal, &rdev->flags) &&
> +		    !test_bit(Faulty, &rdev->flags))
> +		    return false;
> +	return true;
> +}
> +
>  static int get_version(void __user *arg)
>  {
>  	mdu_version_t ver;
> @@ -6041,6 +6060,10 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
>  		info.state |= (1<<MD_SB_BITMAP_PRESENT);
>  	if (mddev_is_clustered(mddev))
>  		info.state |= (1<<MD_SB_CLUSTERED);
> +	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
> +		info.state |= (1<<MD_SB_HAS_JOURNAL);
> +	if (journal_removable(mddev))
> +		info.state |= (1<<MD_SB_JOURNAL_REMOVABLE);
>  	info.active_disks  = insync;
>  	info.working_disks = working;
>  	info.failed_disks  = failed;
> @@ -6721,6 +6744,8 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
>  	/* calculate expected state,ignoring low bits */
>  	if (mddev->bitmap && mddev->bitmap_info.offset)
>  		state |= (1 << MD_SB_BITMAP_PRESENT);
> +	if (journal_removable(mddev))
> +		state |= (1 << MD_SB_JOURNAL_REMOVABLE);
>  
>  	if (mddev->major_version != info->major_version ||
>  	    mddev->minor_version != info->minor_version ||
> @@ -6730,8 +6755,11 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
>  /*	    mddev->layout        != info->layout        || */
>  	    mddev->persistent	 != !info->not_persistent ||
>  	    mddev->chunk_sectors != info->chunk_size >> 9 ||
> -	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT to change */
> -	    ((state^info->state) & 0xfffffe00)
> +	    /*
> +	     * ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT
> +	     * and SB_HAS_JOURNAL to change
> +	     */
> +	    ((state^info->state) & 0xfffffc00)
>  		)
>  		return -EINVAL;
>  	/* Check there is only one change */
> @@ -6743,6 +6771,8 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
>  		cnt++;
>  	if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT))
>  		cnt++;
> +	if ((state ^ info->state) & (1<<MD_SB_HAS_JOURNAL))
> +		cnt++;
>  	if (cnt == 0)
>  		return 0;
>  	if (cnt > 1)
> @@ -6831,6 +6861,14 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
>  			mddev->bitmap_info.offset = 0;
>  		}
>  	}
> +	if ((state ^ info->state) & (1<<MD_SB_HAS_JOURNAL)) {
> +		if (!journal_removable(mddev)) {
> +			rv = -EINVAL;
> +			goto err;
> +		}
> +		clear_bit(MD_HAS_JOURNAL,  &mddev->flags);
> +	}
> +
>  	md_update_sb(mddev, 1);
>  	return rv;
>  err:
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
> index d9a1ead..b1f2b63 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -1,15 +1,15 @@
>  /*
>     md_p.h : physical layout of Linux RAID devices
>            Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
> -	  
> +
>     This program is free software; you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
>     the Free Software Foundation; either version 2, or (at your option)
>     any later version.
> -   
> +
>     You should have received a copy of the GNU General Public License
>     (for example /usr/src/linux/COPYING); if not, write to the Free
> -   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
> +   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>  */
>  
>  #ifndef _MD_P_H
> @@ -119,6 +119,11 @@ typedef struct mdp_device_descriptor_s {
>  
>  #define	MD_SB_CLUSTERED		5 /* MD is clustered */
>  #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
> +#define	MD_SB_HAS_JOURNAL	9
> +#define	MD_SB_JOURNAL_REMOVABLE	10 /* journal _feature_ can be removed,
> +				    * which means the journal is either
> +				    * missing or Faulty
> +				    */
>  
>  /*
>   * Notes:
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
