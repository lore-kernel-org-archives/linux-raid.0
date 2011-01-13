From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/6] Define imsm_analyze_change function
Date: Thu, 13 Jan 2011 13:46:30 +1100
Message-ID: <20110113134630.6afbd4ed@notabene.brown>
References: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
	<20110112160106.18013.76270.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112160106.18013.76270.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 17:01:06 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Function intended to use for single volume migration.
> Function analyze transition and validate if it is supported.
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  super-intel.c |  134 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 125 insertions(+), 9 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 8c1ed4e..81f8e81 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6549,15 +6549,127 @@ static void imsm_update_metadata_locally(struct supertype *st,
>  	}
>  }
>  
> -/**************************************************************************************
> +/***************************************************************************
> +>>>>>>> 686d792... Define imsm_analyze_change function:super-intel.c

Leaving that sort of thing in the patch is a bad idea....



>  * Function:	imsm_analyze_change
> -* Description:	Function analyze and validate change for single volume migration
> +* Description:	Function analyze change for single volume
> +* 		and validate if transition is supported
>  * Parameters:	Geometry parameters, supertype structure
>  * Returns:	Operation type code on success, -1 if fail
> -*************************************************************************************/
> -enum imsm_reshape_type imsm_analyze_change(struct supertype *st, struct geo_params *geo)
> +****************************************************************************/
> +enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
> +						struct geo_params *geo)
>  {
> -	return -1;
> +	int fd = -1;
> +	struct mdinfo *sra = NULL;
> +	int change = -1;
> +	int check_devs = 0;
> +
> +	fd = open_dev(geo->dev_id);
> +	if (fd < 0) {
> +		printf("imsm: Error. Cannot open %s device\n", geo->dev_name);
> +		return -1;
> +	}
> +
> +	sra = sysfs_read(fd, 0,
> +			GET_DISKS | GET_LAYOUT | GET_CHUNK |
> +			GET_SIZE | GET_LEVEL | GET_DEVS);


loading info from the array is the wrong thing to do.  You have to superblock
in st - you should use that to determine the current state of the array.
Maybe use getinfo_super_imsm or something.

Not applied.

NeilBrown



> +	if (!sra) {
> +		dprintf("imsm: Error. Cannot get mdinfo for %s!\n", geo->dev_name);
> +		goto analyse_change_exit;
> +	}
> +
> +	if ((geo->level != sra->array.level) &&
> +		(geo->level >= 0) &&
> +		(geo->level != UnSet)) {
> +		switch (sra->array.level) {
> +		case 0:
> +			if (geo->level == 5) {
> +				change = CH_LEVEL_MIGRATION;
> +				check_devs = 1;
> +			}
> +			if (geo->level == 10) {
> +				change = CH_TAKEOVER;
> +				check_devs = 1;
> +			}
> +			break;
> +		case 5:
> +			if (geo->level != 0)
> +				change = CH_LEVEL_MIGRATION;
> +			break;
> +		case 10:
> +			if (geo->level == 0) {
> +				change = CH_TAKEOVER;
> +				check_devs = 1;
> +			}
> +			break;
> +		}
> +		if (change == -1) {
> +			dprintf("imsm: Error. Level Migration from %d to %d "\
> +				"not supported!\n", sra->array.level, geo->level);
> +			goto analyse_change_exit;
> +		}
> +	} else {
> +		geo->level = sra->array.level;
> +	}
> +
> +	if ((geo->layout != sra->array.layout)
> +		&& ((geo->layout != UnSet) && (geo->layout != -1))) {
> +		change = CH_LEVEL_MIGRATION;
> +		if ((sra->array.layout == 0) && (sra->array.level == 5)
> +			&& (geo->layout == 5)) {
> +			/* reshape 5 -> 4 */
> +		} else if ((sra->array.layout == 5)
> +				&& (sra->array.level == 5)
> +				&& (geo->layout == 0)) {
> +			/* reshape 4 -> 5 */
> +			geo->layout = 0;
> +			geo->level = 5;
> +		} else {
> +			dprintf("imsm: Error. Layout Migration from %d to %d "\
> +				"not supported!\n", sra->array.layout, geo->layout);
> +			change = -1;
> +			goto analyse_change_exit;
> +		}
> +	} else {
> +		geo->layout = sra->array.layout;
> +	}
> +
> +	if ((geo->chunksize > 0) && (geo->chunksize != UnSet)
> +		&& (geo->chunksize != sra->array.chunk_size)) {
> +		change = CH_CHUNK_MIGR;
> +	} else {
> +		geo->chunksize = sra->array.chunk_size;
> +	}
> +
> +	if (!validate_geometry_imsm(st,
> +					geo->level,
> +					geo->layout,
> +					geo->raid_disks,
> +					(geo->chunksize / 1024),
> +					geo->size,
> +					0, 0, 1))
> +		change = -1;
> +
> +	if (check_devs) {
> +		struct intel_super *super = st->sb;
> +		struct imsm_super *mpb = super->anchor;
> +
> +		if (mpb->num_raid_devs > 1) {
> +			printf("imsm: Error. Cannot perform operation on %s"\
> +				"- for this operation it MUST be single "\
> +			       "array in container\n",
> +				geo->dev_name);
> +			change = -1;
> +		}
> +	}
> +
> +analyse_change_exit:
> +	sysfs_free(sra);
> +	if (fd > -1)
> +		close(fd);
> +
> +	return change;
>  }
>  
>  static int imsm_reshape_super(struct supertype *st, long long size, int level,
> @@ -6623,13 +6735,17 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  		change = imsm_analyze_change(st, &geo);
>  		switch (change) {
>  			case CH_TAKEOVER:
> -			break;
> +				ret_val = 0;
> +				break;
>  			case CH_CHUNK_MIGR:
> -			break;
> +				ret_val = 0;
> +				break;
>  			case CH_LEVEL_MIGRATION:
> -			break;
> +				ret_val = 0;
> +				break;
> +			default:
> +				ret_val = 1;
>  		}
> -		ret_val = 0;
>  	}
>  
>  exit_imsm_reshape_super:

