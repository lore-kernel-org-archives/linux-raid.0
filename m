From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] Add raid10 -> raid0 takeover support
Date: Thu, 13 Jan 2011 13:49:25 +1100
Message-ID: <20110113134925.21dc040a@notabene.brown>
References: <20110112155905.18013.73701.stgit@gklab-128-111.igk.intel.com>
	<20110112160140.18013.83851.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112160140.18013.83851.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 17:01:40 +0100 Krzysztof Wojcik
<krzysztof.wojcik@intel.com> wrote:

> The patch introduces takeover form level 10 to level 0 for imsm
> metadata. This patch contains procedures connected with preparing
> and applying metadata update during 10 -> 0 takeover.
> When performing takeover 10->0 mdmon should update the external
> metadata (due to disk slot and level changes).
> To achieve that mdadm calls reshape_super() and prepare
> the "update_takeover" metadata update type.
> Prepared update is processed by mdmon in process_update().

This depends on a previous patch which I didn't apply, so I didn't apply this
one either.

NeilBrown


> 
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
>  Grow.c        |    1 
>  super-intel.c |  148 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 148 insertions(+), 1 deletions(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 6835f34..d5cd761 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1485,6 +1485,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
>  			rv = 1;
>  			goto release;
>  		}
> +		ping_monitor(container);
>  		info.delta_disks = rv;
>  	}
>  
> diff --git a/super-intel.c b/super-intel.c
> index 81f8e81..90e0b98 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -299,6 +299,7 @@ enum imsm_update_type {
>  	update_rename_array,
>  	update_add_remove_disk,
>  	update_reshape_container_disks,
> +	update_takeover
>  };
>  
>  struct imsm_update_activate_spare {
> @@ -319,6 +320,12 @@ struct geo_params {
>  	int raid_disks;
>  };
>  
> +#define TAKEOVER_R10_DISKS 2
> +struct imsm_update_takeover {
> +	enum imsm_update_type type;
> +	int subarray;
> +	int disks[TAKEOVER_R10_DISKS];
> +};
>  
>  struct imsm_update_reshape {
>  	enum imsm_update_type type;
> @@ -5764,6 +5771,68 @@ update_reshape_exit:
>  	return ret_val;
>  }
>  
> +static int apply_takeover_update(struct imsm_update_takeover *u,
> +				struct intel_super *super)
> +{
> +	struct imsm_dev *dev = NULL;
> +	struct imsm_map *map;
> +	struct dl *dm, *du;
> +	int *tab;
> +	int i;
> +
> +	dev = get_imsm_dev(super, u->subarray);
> +
> +	if (dev == NULL)
> +		return 0;
> +
> +	map = get_imsm_map(dev, 0);
> +	tab = (int *)&map->disk_ord_tbl;
> +
> +for (i=0;i<4;i++)
> +    dprintf("tab: idx= %i, val=%i\n", i, tab[i]);
> +
> +for (dm=super->disks;dm;dm=dm->next)
> +    dprintf("disk: index= %i, minor= %i, major= %i\n", dm->index, dm->minor, dm->major);
> +
> +	/* iterate through devices to mark removed disks as spare
> +	 * and update order table */
> +	for (i = 0; i < TAKEOVER_R10_DISKS; i++) {
> +		for (dm = super->disks; dm; dm = dm->next) {
> +			if (((unsigned int)dm->major != major(u->disks[i])) ||
> +			    ((unsigned int)dm->minor != minor(u->disks[i])))
> +				continue;
> +			for (du = super->disks; du; du = du->next)
> +			    if ((du->index > dm->index) && (du->index > 0))
> +				du->index--;
> +			dm->disk.status = SPARE_DISK;
> +			dm->index = -1;
> +		}
> +	}
> +
> +	/* update disk order table */
> +	i = 0;
> +	for (du = super->disks; du; du = du->next) {
> +		if (du->index >= 0) {
> +dprintf("du->index= %i\n", du->index);
> +			tab[du->index] = i;
> +			i++;
> +		}
> +	}
> +
> +for (i=0;i<4;i++)
> +    dprintf("AFTER tab: idx= %i, val=%i\n", i, tab[i]);
> +for (dm=super->disks;dm;dm=dm->next)
> +    dprintf("AFTER disk: index= %i, minor= %i, major= %i\n", dm->index, dm->minor, dm->major);
> +
> +
> +	map->num_members = 2;
> +	map->map_state = IMSM_T_STATE_NORMAL;
> +	map->num_domains = 1;
> +	map->raid_level = 0;
> +	map->failed_disk_num = -1;
> +	return 1;
> +}
> +
>  static void imsm_process_update(struct supertype *st,
>  			        struct metadata_update *update)
>  {
> @@ -5806,6 +5875,13 @@ static void imsm_process_update(struct supertype *st,
>  	mpb = super->anchor;
>  
>  	switch (type) {
> +	case update_takeover: {
> +		struct imsm_update_takeover *u = (void *)update->buf;
> +		if (apply_takeover_update(u, super))
> +			super->updates_pending++;
> +		break;
> +	}
> +
>  	case update_reshape_container_disks: {
>  		struct imsm_update_reshape *u = (void *)update->buf;
>  		if (apply_reshape_container_disks_update(
> @@ -6672,6 +6748,76 @@ analyse_change_exit:
>  	return change;
>  }
>  
> +int imsm_takeover(struct supertype *st, struct geo_params *geo)
> +{
> +	struct intel_super *super = st->sb;
> +	struct imsm_update_takeover *u;
> +	struct mdinfo *info;
> +	struct mdinfo *newdi;
> +	struct dl *dl;
> +	int subarray, i, fd;
> +	int found = 0;
> +	int devnum;
> +	char buf[PATH_MAX];
> +
> +	/* find requested device */
> +	for (subarray = 0; subarray < super->anchor->num_raid_devs; subarray++) {
> +		imsm_find_array_minor_by_subdev(subarray, st->container_dev, &devnum);
> +		if (devnum == geo->dev_id) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +
> +	if (!found) {
> +		fprintf(stderr, Name "Cannot find %s (%i) subarray\n",
> +			geo->dev_name, geo->dev_id);
> +		return 1;
> +	}
> +
> +	sprintf(buf, "/dev/md%i", devnum);
> +	fd = open(buf, O_RDONLY);
> +	if (!fd) {
> +		fprintf(stderr, Name "Cannot open %s", buf);
> +		return 1;
> +	}
> +	info = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
> +	if (!info) {
> +		fprintf(stderr, Name "Cannot load sysfs information for %s (%i)",
> +			geo->dev_name, geo->dev_id);
> +		return 1;
> +	}
> +
> +	u = malloc(sizeof(struct imsm_update_takeover));
> +	if (u == NULL)
> +		return 1;
> +
> +	u->type = update_takeover;
> +	u->subarray = subarray;
> +
> +	/* 10->0 transition - mark disks to remove */
> +	if (geo->level == 0) {
> +		i = 0;
> +		for (dl = super->disks; dl; dl = dl->next) {
> +			found = 0;
> +			for (newdi = info->devs; newdi; newdi = newdi->next) {
> +				if ((dl->major != newdi->disk.major) ||
> +					    (dl->minor != newdi->disk.minor) ||
> +					    (newdi->disk.raid_disk < 0))
> +					continue;
> +				found = 1;
> +				break;
> +			}
> +			/* if disk not found, mark it for remove */
> +			if ((found == 0) && (!(dl->disk.status & SPARE_DISK)))
> +				u->disks[i++] = makedev(dl->major, dl->minor);
> +		}
> +	}
> +
> +	append_metadata_update(st, u, sizeof(struct imsm_update_takeover));
> +	return 0;
> +}
> +
>  static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  			      int layout, int chunksize, int raid_disks,
>  			      char *backup, char *dev, int verbose)
> @@ -6735,7 +6881,7 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
>  		change = imsm_analyze_change(st, &geo);
>  		switch (change) {
>  			case CH_TAKEOVER:
> -				ret_val = 0;
> +				ret_val = imsm_takeover(st, &geo);
>  				break;
>  			case CH_CHUNK_MIGR:
>  				ret_val = 0;

