From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] reshape_super reorganization
Date: Thu, 13 Jan 2011 13:45:01 +1100
Message-ID: <20110113134501.58df170c@notabene.brown>
References: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
	<20110112160058.18013.57625.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112160058.18013.57625.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 17:00:58 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> Function has been divided into two clear parts:
> 1. Container operations
> 2. Volume operations
> 
> Prototype of imsm_analyze_change function has been added.
> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  super-intel.c |   60 ++++++++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 46 insertions(+), 14 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 0c70fda..8c1ed4e 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -284,6 +284,13 @@ struct extent {
>  	unsigned long long start, size;
>  };
>  
> +/* definitions of reshape process types */
> +enum imsm_reshape_type {
> +	CH_TAKEOVER,
> +	CH_CHUNK_MIGR,
> +	CH_LEVEL_MIGRATION
> +};
> +
>  /* definition of messages passed to imsm_process_update */
>  enum imsm_update_type {
>  	update_activate_spare,
> @@ -6324,6 +6331,10 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
>  						struct geo_params *geo,
>  						int *old_raid_disks)
>  {
> +	/* currently we only support increasing the number of devices
> +	 * for a container.  This increases the number of device for each
> +	 * member array.  They must all be RAID0 or RAID5.
> +	 */
>  	int ret_val = 0;
>  	struct mdinfo *info, *member;
>  	int devices_that_can_grow = 0;
> @@ -6538,15 +6549,21 @@ static void imsm_update_metadata_locally(struct supertype *st,
>  	}
>  }
>  
> +/**************************************************************************************
> +* Function:	imsm_analyze_change
> +* Description:	Function analyze and validate change for single volume migration
> +* Parameters:	Geometry parameters, supertype structure
> +* Returns:	Operation type code on success, -1 if fail
> +*************************************************************************************/
> +enum imsm_reshape_type imsm_analyze_change(struct supertype *st, struct geo_params *geo)
> +{
> +	return -1;
> +}
> +
>  static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  			      int layout, int chunksize, int raid_disks,
>  			      char *backup, char *dev, int verbose)
>  {
> -	/* currently we only support increasing the number of devices
> -	 * for a container.  This increases the number of device for each
> -	 * member array.  They must all be RAID0 or RAID5.
> -	 */
> -
>  	int ret_val = 1;
>  	struct geo_params geo;
>  
> @@ -6555,6 +6572,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  	memset(&geo, sizeof(struct geo_params), 0);
>  
>  	geo.dev_name = dev;
> +	geo.dev_id = st->devnum;
>  	geo.size = size;
>  	geo.level = level;
>  	geo.layout = layout;
> @@ -6567,13 +6585,9 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  	if (experimental() == 0)
>  		return ret_val;
>  
> -	/* verify reshape conditions
> -	 * on container level we can only increase number of devices.
> -	 */
>  	if (st->container_dev == st->devnum) {
> -		/* check for delta_disks > 0
> -		 * and supported raid levels 0 and 5 only in container
> -		 */
> +		/* On container level we can only increase number of devices. */
> +		dprintf("imsm: info: Container operation\n");
>  		int old_raid_disks = 0;
>  		if (imsm_reshape_is_allowed_on_container(
>  			    st, &geo, &old_raid_disks)) {
> @@ -6594,11 +6608,29 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  			/* update metadata locally
>  			 */
>  			imsm_update_metadata_locally(st, st->updates);
> -		} else
> +		} else {
>  			fprintf(stderr, Name "imsm: Operation is not allowed "
>  				"on this container\n");
> -	} else
> -		fprintf(stderr, Name "imsm: not a container operation\n");
> +		}
> +	} else {
> +		/* On volume level we support following operations
> +		* - takeover: raid10 -> raid0; raid0 -> raid10
> +		* - chunk size migration
> +		* - migration: raid5 -> raid0; raid0 -> raid5
> +		*/
> +		int change;
> +		dprintf("imsm: info: Volume operation\n");
> +		change = imsm_analyze_change(st, &geo);
> +		switch (change) {
> +			case CH_TAKEOVER:
> +			break;
> +			case CH_CHUNK_MIGR:
> +			break;
> +			case CH_LEVEL_MIGRATION:
> +			break;
> +		}
> +		ret_val = 0;
> +	}
>  
>  exit_imsm_reshape_super:
>  	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);



Applied, thanks.

NeilBrown

