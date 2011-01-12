From: NeilBrown <neilb@suse.de>
Subject: Re: Subject: [PATCH 4/4] imsm: support for raid0 <-> raid5
 migration
Date: Wed, 12 Jan 2011 17:20:05 +1100
Message-ID: <20110112172005.6b3ff180@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D176E1A452@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176E1A452@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Tue, 11 Jan 2011 15:24:54 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> >From 218f21b2d6f55798ea7df2f82668fdf51f4b158a Mon Sep 17 00:00:00 2001
> From: Marcin Labun <marcin.labun@intel.com>
> Date: Tue, 11 Jan 2011 16:01:59 +0100
> Subject: [PATCH 4/4] imsm: support for raid0 <-> raid5 migration
> 
> Support for raid0 to raid5 and raid5 to raid0 migration in imsm.
> This is work in progress.

This could usefully be broken up into smaller patches.

e.g. your 'allocate_space_list' contains code copied from imsm_prepare_update.
It would be better to have a single patch which moved that code into a
separate function, then another patch which uses the new function in the new
for the new functionality.

So: not applied.

NeilBrown


> 
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> ---
>  super-intel.c |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 143 insertions(+), 4 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index d3da6f9..3a471c3 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -317,6 +317,9 @@ struct imsm_update_reshape {
>  	enum imsm_update_type type;
>  	int old_raid_disks;
>  	int new_raid_disks;
> +  	int new_level;
> +	int new_chunksize;
> +	long long new_size;
>  	int new_disks[1]; /* new_raid_disks - old_raid_disks makedev number */
>  };
>  
> @@ -5816,6 +5819,7 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
>  			newdev->vol.curr_migr_unit = 0;
>  			newdev->vol.migr_type = MIGR_GEN_MIGR;
>  			newmap->num_members = u->new_raid_disks;
> +			newmap->raid_level = u->new_level;
>  			for (i = 0; i < delta_disks; i++) {
>  				set_imsm_ord_tbl_ent(newmap,
>  						     u->old_raid_disks + i,
> @@ -6421,6 +6425,18 @@ static int imsm_find_array_minor_by_subdev(int subdev, int container, int *minor
>  	return 0;
>  }
>  
> +
> +static int imsm_reshape_is_allowed_on_subarray(struct supertype *st,
> +					       struct geo_params *geo,
> +					       int *old_raid_disks)
> +{
> +	/* needs to convert requested geo to IMSM valid geometry 
> +	 * all unset value shall be converted to current array values 
> +	 */
> +	dprintf("\tSub-array operation operation allowed\n");
> +	return 1;
> +}
> +
>  static int imsm_reshape_is_allowed_on_container(struct supertype *st,
>  						struct geo_params *geo,
>  						int *old_raid_disks)
> @@ -6569,12 +6585,14 @@ static int imsm_create_metadata_update_for_reshape(
>  	u->type = update_reshape_container_disks;
>  	u->old_raid_disks = old_raid_disks;
>  	u->new_raid_disks = geo->raid_disks;
> -
> +	u->new_level = geo->level;
> +	u->new_chunksize = geo->chunksize;
> +	u->new_size = geo->size;
>  	/* now get spare disks list
>  	 */
>  	spares = get_spares_for_grow(st);
>  
> -	if (spares == NULL
> +	if (((spares == NULL) && (delta_disks != 0)) 
>  	    || delta_disks > spares->array.spare_disks) {
>  		dprintf("imsm: ERROR: Cannot get spare devices.\n");
>  		goto abort;
> @@ -6618,6 +6636,75 @@ abort:
>  }
>  
>  
> +static int allocate_space_list(struct intel_super *super, struct imsm_update_reshape *u, void ***space_list)
> +{
> +	/* Every raid device in the container is about to
> +	 * gain some more devices, and we will enter a
> +	 * reconfiguration.
> +	 * So each 'imsm_map' will be bigger, and the imsm_vol
> +	 * will now hold 2 of them.
> +	 * Thus we need new 'struct imsm_dev' allocations sized
> +	 * as sizeof_imsm_dev but with more devices in both maps.
> +	 */
> +	struct intel_dev *dl;
> +	void **space_tail = (void**)space_list;
> +
> +	dprintf("imsm: allocate_space_list() for update_reshape\n");
> +	
> +	for (dl = super->devlist; dl; dl = dl->next) {
> +		int size = sizeof_imsm_dev(dl->dev, 1);
> +		void *s;
> +		if (u->new_raid_disks > u->old_raid_disks)
> +			size += sizeof(__u32)*2*
> +			  (u->new_raid_disks - u->old_raid_disks);
> +		s = malloc(size);
> +		if (!s)
> +			return 1;
> +		*space_tail = s;
> +		space_tail = s;
> +		*space_tail = NULL;
> +	}
> +	return 0;
> +}
> +
> +// static int reallocate_anchor_for_update(struct intel_super *super, struct imsm_update_reshape *u);
> +/*  
> + * Check if there is enouht spare and reallocate anchor if neccessary
> + * Return:
> + *  1 - no enouth space for new request
> + *  0 - anchor ready for updates
> + */
> +static int reallocate_anchor_for_update(struct intel_super *super, struct imsm_update_reshape *u)
> +{
> +	/* reallocate anchor
> +	 */
> +	size_t buf_len = super->len;
> +	size_t len = disks_to_mpb_size(u->new_raid_disks);
> +	struct imsm_super *mpb = super->anchor;
> +	void *new_anchor;
> +
> +	dprintf("imsm: realocate anchore\n");
> +
> +	if (__le32_to_cpu(mpb->mpb_size) + len > buf_len) {
> +		buf_len = ROUND_UP(__le32_to_cpu(mpb->mpb_size) + len, 512);
> +		if (posix_memalign(&new_anchor,
> +				   512, buf_len) == 0) {
> +			memcpy(new_anchor, super->buf, super->len);
> +			free(super->buf);
> +			super->buf = new_anchor;
> +			super->len = buf_len;
> +		} else 
> +			return 1;
> +
> +	}
> +	return 0;
> +}
> +
> +/* 
> + * Reshape IMSM metadata - prepare metadata update 
> + * 0 - update successfully reshaped
> + * 1 - reshape start failed - abort the process 
> + */
>  static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  			      int layout, int chunksize, int raid_disks,
>  			      char *backup, char *dev, int verbose)
> @@ -6643,6 +6730,9 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  
>  	dprintf("\tfor level      : %i\n", geo.level);
>  	dprintf("\tfor raid_disks : %i\n", geo.raid_disks);
> +	dprintf("\tfor layout : %i\n", geo.layout);
> +	dprintf("\tfor size : %llu\n", geo.size);
> +	dprintf("\tfor chunksize : %i\n", geo.chunksize);
>  
>  	if (experimental() == 0)
>  		return ret_val;
> @@ -6734,8 +6824,57 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  		} else
>  			fprintf(stderr, Name "imsm: Operation is not allowed "
>  				"on this container\n");
> -	} else
> -		fprintf(stderr, Name "imsm: not a container operation\n");
> +	} else {
> +		struct imsm_update_reshape *u = NULL;
> +		int len;
> +		struct intel_super *super = st->sb;
> +		void **space_list=NULL;
> +
> +		int old_raid_disks = 0;
> +
> +		dprintf("imsm: subarray reshape\n");
> +		if (imsm_reshape_is_allowed_on_subarray(st, &geo, &old_raid_disks) == 0) {
> +			dprintf("imsm: reshape not allowed\n");
> +			goto exit_imsm_reshape_super;
> +		}
> +		
> +		len = imsm_create_metadata_update_for_reshape(st, &geo, old_raid_disks, &u);
> +
> +		if (len <= 0) {
> +			dprintf("imsm: Cannot prepare update\n");
> +			goto exit_imsm_reshape_super;
> +		}
> +
> +		if (mdmon_running(st->container_dev)) {
> +			ret_val = 0;
> +			append_metadata_update(st, u, len);
> +			goto exit_imsm_reshape_super;
> +		}
> +		/* no mdmon - apply update
> +		 */
> +
> +		dprintf("imsm:prepare space list for update_reshape\n");
> +		ret_val = allocate_space_list(super, u, &space_list);
> +		if (ret_val == 0) {
> +			ret_val = apply_reshape_container_disks_update(u, super, &space_list);
> +			/* processed if reshape applied */
> +			if (ret_val == 1) {
> +				ret_val = reallocate_anchor_for_update(super, u);
> +				if (ret_val == 0)
> +				  super->updates_pending++;
> +			}
> +			else
> +				/* set error code */
> +				ret_val = 1;
> +		}
> +		/* release memory */
> +		while (space_list) {
> +			void *space = space_list;
> +			space_list = *space_list;
> +			free(space);
> +		}
> +		free(u);
> +	}
>  
>  exit_imsm_reshape_super:
>  	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);

