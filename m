From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 20/53] imsm: Add reshape_update for grow array case
Date: Mon, 29 Nov 2010 12:48:14 +1100
Message-ID: <20101129124814.174f2506@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080629.5221.70482.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126080629.5221.70482.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Fri, 26 Nov 2010 09:06:29 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> Store metadata update during Online Capacity Expansion initialization to currently reshaped array in container.
> New update type imsm_update_reshape is added to perform this action.
> Active array is extended with reshape_delta_disk variable that triggers additional actions in managemon.
> 
> 1. reshape_super() prepares metadata update and send it to mdmon 2. managemon in prepare_update() allocates required memory for bigger device object 3. monitor in
> process_update() updates (replaces) device object with information
>    passed from mdadm (memory was allocated by managemon) 4. set reshape_delta_disks variable to delta_disks value from update.
>    This signals managemon to add devices to md and start reshape for this array

I haven't applied this patch because there is too much of it that doesn't
make sense to me.  Maybe you need to break it up and explain it better.  But
see below


> 
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> ---
> 
>  Makefile      |    6 
>  managemon.c   |    2 
>  mdadm.h       |    4 
>  mdmon.h       |    5 
>  super-intel.c |  792 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  sysfs.c       |  144 ++++++++++
>  util.c        |  148 +++++++++++
>  7 files changed, 1094 insertions(+), 7 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index e2c65a5..e3fb949 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -112,17 +112,17 @@ SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
>  MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
>  	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
>  	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
> -	platform-intel.o probe_roms.o
> +	platform-intel.o probe_roms.o mapfile.o
>  
>  MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c \
>  	Kill.c sg_io.c dlink.c ReadMe.c super0.c super1.c super-intel.c \
>  	super-ddf.c sha1.c crc32.c msg.c bitmap.c \
> -	platform-intel.c probe_roms.c
> +	platform-intel.c probe_roms.c mapfile.c

I can see no justification for adding mapfile to mdmon.  If you find you need
to do that, you have done something wrong.



>  
>  STATICSRC = pwgr.c
>  STATICOBJS = pwgr.o
>  
> -ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c dlink.c util.c \
> +ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c dlink.c util.c mapfile.c\
>  	super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c \
>  	platform-intel.c probe_roms.c sysfs.c
>  ASSEMBLE_AUTO_SRCS := mdopen.c
> diff --git a/managemon.c b/managemon.c
> index 53ab4a9..d495014 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -536,6 +536,8 @@ static void manage_new(struct mdstat_ent *mdstat,
>  
>  	new->container = container;
>  
> +	new->reshape_state = reshape_not_active;
> +
>  	inst = to_subarray(mdstat, container->devname);
>  
>  	new->info.array = mdi->array;
> diff --git a/mdadm.h b/mdadm.h
> index bf3c1d3..4777ad2 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -447,6 +447,7 @@ extern int sysfs_disk_to_scsi_id(int fd, __u32 *id);
>  extern int sysfs_unique_holder(int devnum, long rdev);
>  extern int sysfs_freeze_array(struct mdinfo *sra);
>  extern int load_sys(char *path, char *buf);
> +extern struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd);
>  
>  
>  extern int save_stripes(int *source, unsigned long long *offsets,
> @@ -473,6 +474,7 @@ extern char *map_dev(int major, int minor, int create);
>  
>  struct active_array;
>  struct metadata_update;
> +enum state_of_reshape;

Why declare state_of_reshape like this in mdadm.h if it isn't used at all in
mdadm.h??


>  
>  /* A superswitch provides entry point the a metadata handler.
>   *
> @@ -891,6 +893,8 @@ extern int conf_name_is_free(char *name);
>  extern int devname_matches(char *name, char *match);
>  extern struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st);
>  extern inline int experimental(void);
> +extern int find_array_minor(char *text_version, int external, int container, int *minor);
> +extern int find_array_minor2(char *text_version, int external, int container, int *minor);
>  
>  extern void free_line(char *line);
>  extern int match_oneof(char *devices, char *devname);
> diff --git a/mdmon.h b/mdmon.h
> index 8190358..9ea0b93 100644
> --- a/mdmon.h
> +++ b/mdmon.h
> @@ -24,6 +24,8 @@ enum array_state { clear, inactive, suspended, readonly, read_auto,
>  enum sync_action { idle, reshape, resync, recover, check, repair, bad_action };
>  
>  
> +enum state_of_reshape { reshape_not_active, reshape_is_starting, reshape_in_progress, reshape_cancel_request };
> +
>  struct active_array {
>  	struct mdinfo info;
>  	struct supertype *container;
> @@ -45,6 +47,9 @@ struct active_array {
>  	enum array_state prev_state, curr_state, next_state;
>  	enum sync_action prev_action, curr_action, next_action;
>  
> +	enum state_of_reshape reshape_state;
> +	int reshape_delta_disks;
> +

Adding these fields seems correct, but I would really like a separate patch
which adds the fields, and the definition and the initialisation.

If it had a comment explaining the stages and how each state change happens,
that would be an added bonus.


>  	int check_degraded; /* flag set by mon, read by manage */
>  
>  	int devnum;
> diff --git a/super-intel.c b/super-intel.c
> index 90faff6..98e4c6d 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -286,6 +286,7 @@ enum imsm_update_type {
>  	update_rename_array,
>  	update_add_disk,
>  	update_level,
> +	update_reshape,
>  };
>  
>  struct imsm_update_activate_spare {
> @@ -296,6 +297,43 @@ struct imsm_update_activate_spare {
>  	struct imsm_update_activate_spare *next;
>  };
>  
> +struct geo_params {
> +	int dev_id;
> +	char *dev_name;
> +	long long size;
> +	int level;
> +	int layout;
> +	int chunksize;
> +	int raid_disks;
> +};
> +
> +
> +struct imsm_update_reshape {
> +	enum imsm_update_type type;
> +	int update_memory_size;
> +	int reshape_delta_disks;
> +	int disks_count;
> +	int spares_in_update;
> +	int devnum;
> +	/* pointers to memory that will be allocated
> +	 * by manager during prepare_update()
> +	 */
> +	struct intel_dev devs_mem;
> +	/* status of update preparation
> +	 */
> +	int update_prepared;
> +	/* anchor data prepared by mdadm */
> +	int upd_devs_offset;
> +	int device_size;
> +	struct dl upd_disks[1];
> +	/* here goes added spares
> +	 */
> +	/* and here goes imsm_devs pointed by upd_devs
> +	 * devs are put here as row data every device_size bytes
> +	 *
> +	 */
> +};
> +
>  struct disk_info {
>  	__u8 serial[MAX_RAID_SERIAL_LEN];
>  };
> @@ -5189,6 +5227,7 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_
>  }
>  
>  static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned index);
> +int imsm_get_new_device_name(struct dl *dl);
>  
>  static void imsm_process_update(struct supertype *st,
>  			        struct metadata_update *update)
> @@ -5224,6 +5263,102 @@ static void imsm_process_update(struct supertype *st,
>  	mpb = super->anchor;
>  
>  	switch (type) {
> +	case update_reshape: {
> +		struct imsm_update_reshape *u = (void *)update->buf;
> +		struct dl *new_disk;
> +		struct active_array *a;
> +		int i;
> +		__u32 new_mpb_size;
> +		int new_disk_num;
> +		struct intel_dev *current_dev;
> +
> +		dprintf("imsm: imsm_process_update() for update_reshape [u->update_prepared  = %i]\n", u->update_prepared);
> +		if ((u->update_prepared == -1) ||
> +		    (u->devnum < 0)) {
> +			dprintf("imsm: Error: update_reshape not prepared\n");
> +			goto update_reshape_exit;
> +		}
> +
> +		if (u->spares_in_update) {
> +			new_disk_num = mpb->num_disks + u->reshape_delta_disks;
> +			new_mpb_size = disks_to_mpb_size(new_disk_num);
> +			if (mpb->mpb_size < new_mpb_size)
> +				mpb->mpb_size = new_mpb_size;
> +
> +			/* enable spares to use in array
> +			*/
> +			for (i = 0; i < u->reshape_delta_disks; i++) {
> +				char buf[PATH_MAX];
> +
> +				new_disk = super->disks;
> +				while (new_disk) {
> +					if ((new_disk->major == u->upd_disks[i].major) &&
> +					    (new_disk->minor == u->upd_disks[i].minor))
> +							break;
> +					new_disk = new_disk->next;
> +				}
> +				if (new_disk == NULL) {
> +					u->update_prepared = -1;
> +					goto update_reshape_exit;
> +				}
> +				if (new_disk->index < 0) {
> +					new_disk->index = i + mpb->num_disks;
> +					new_disk->raiddisk = new_disk->index; /* slot to fill in autolayout */
> +					new_disk->disk.status |= CONFIGURED_DISK;
> +					new_disk->disk.status &= ~SPARE_DISK;
> +				}
> +				sprintf(buf, "%d:%d", new_disk->major, new_disk->minor);
> +				if (new_disk->fd < 0)
> +					new_disk->fd = dev_open(buf, O_RDWR);
> +				imsm_get_new_device_name(new_disk);
> +			}
> +		}
> +
> +		dprintf("imsm: process_update(): update_reshape: volume set mpb->num_raid_devs = %i\n", mpb->num_raid_devs);
> +		/* manage changes in volumes
> +		 */
> +		/* check if array is in RESHAPE_NOT_ACTIVE reshape state
> +		*/
> +		for (a = st->arrays; a; a = a->next)
> +			if (a->devnum == u->devnum)
> +				break;
> +		if ((a == NULL) || (a->reshape_state != reshape_not_active)) {
> +			u->update_prepared = -1;
> +			goto update_reshape_exit;
> +		}
> +		/* find current dev in intel_super
> +		 */
> +		dprintf("\t\tLooking  for volume %s\n", (char *)u->devs_mem.dev->volume);
> +		current_dev = super->devlist;
> +		while (current_dev) {
> +			if (strcmp((char *)current_dev->dev->volume,
> +				   (char *)u->devs_mem.dev->volume) == 0)
> +				break;
> +			current_dev = current_dev->next;
> +		}
> +		if (current_dev == NULL) {
> +			u->update_prepared = -1;
> +			goto update_reshape_exit;
> +		}
> +
> +		dprintf("Found volume %s\n", (char *)current_dev->dev->volume);
> +		/* replace current device with provided in update
> +		 */
> +		free(current_dev->dev);
> +		current_dev->dev = u->devs_mem.dev;
> +		u->devs_mem.dev = NULL;
> +
> +		/* set reshape_delta_disks
> +		 */
> +		a->reshape_delta_disks = u->reshape_delta_disks;
> +		a->reshape_state = reshape_is_starting;
> +
> +		super->updates_pending++;
> +update_reshape_exit:
> +		if (u->devs_mem.dev)
> +			free(u->devs_mem.dev);
> +		break;
> +	}
>  	case update_level: {
>  		struct imsm_update_level *u = (void *)update->buf;
>  		struct imsm_dev *dev_new, *dev = NULL;
> @@ -5592,8 +5727,58 @@ static void imsm_prepare_update(struct supertype *st,
>  	struct imsm_super *mpb = super->anchor;
>  	size_t buf_len;
>  	size_t len = 0;
> +	void *upd_devs;
>  
>  	switch (type) {
> +	case update_reshape: {
> +		struct imsm_update_reshape *u = (void *)update->buf;
> +		struct dl *dl = NULL;
> +
> +		u->update_prepared = -1;
> +		u->devs_mem.dev = NULL;
> +		dprintf("imsm: imsm_prepare_update() for update_reshape\n");
> +		if (u->devnum < 0) {
> +			dprintf("imsm: No passed device.\n");
> +			break;
> +		}
> +		dprintf("imsm: reshape delta disks is = %i\n", u->reshape_delta_disks);
> +		if (u->reshape_delta_disks < 0)
> +			break;
> +		u->update_prepared = 1;
> +		if (u->reshape_delta_disks == 0) {
> +			/* for non growing reshape buffers sizes are not affected
> +			 * but check some parameters
> +			 */
> +			break;
> +		}
> +		/* count HDDs
> +		 */
> +		u->disks_count = 0;
> +		for (dl = super->disks; dl; dl = dl->next)
> +			if (dl->index >= 0)
> +				u->disks_count++;
> +
> +		/* set pointer in monitor address space
> +		*/
> +		upd_devs = (struct imsm_dev *)((void *)u + u->upd_devs_offset);
> +		/* allocate memory for new volumes */
> +		if (((struct imsm_dev *)(upd_devs))->vol.migr_type != MIGR_GEN_MIGR) {
> +			dprintf("imsm: Error.Device is not in migration state.\n");
> +			u->update_prepared = -1;
> +			break;
> +		}
> +		dprintf("passed device : %s\n", ((struct imsm_dev *)(upd_devs))->volume);
> +		u->devs_mem.dev = calloc(1, u->device_size);
> +		if (u->devs_mem.dev == NULL) {
> +			u->update_prepared = -1;
> +			break;
> +		}
> +		dprintf("METADATA Copy - using it.\n");
> +		memcpy(u->devs_mem.dev, upd_devs, u->device_size);
> +		len = disks_to_mpb_size(u->spares_in_update + mpb->num_disks);
> +		dprintf("New anchor length is %llu\n", (unsigned long long)len);
> +		break;
> +	}
>  	case update_level: {
>  		struct imsm_update_level *u = (void *) update->buf;
>  		struct active_array *a;
> @@ -5818,6 +6003,525 @@ static int update_level_imsm(struct supertype *st, struct mdinfo *info,
>  	return 0;
>  }
>  
> +int imsm_reshape_is_allowed_on_container(struct supertype *st,
> +					 struct geo_params *geo)
> +{
> +	int ret_val = 0;
> +	struct mdinfo *info = NULL;
> +	char buf[PATH_MAX];
> +	int fd = -1;
> +	int device_num = -1;
> +	int devices_that_can_grow = 0;
> +
> +	dprintf("imsm: imsm_reshape_is_allowed_on_container(ENTER): st->devnum = (%i)\n", st->devnum);
> +
> +	if (geo == NULL ||
> +	    (geo->size != -1) || (geo->level != UnSet) ||
> +	    (geo->layout != UnSet) || (geo->chunksize != 0)) {
> +		dprintf("imsm: Container operation is allowed for raid disks number change only.\n");
> +		return ret_val;
> +	}
> +
> +	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
> +	dprintf("imsm: open device (%s)\n", buf);
> +	fd = open(buf , O_RDONLY | O_DIRECT);
> +	if (fd < 0) {
> +		dprintf("imsm: cannot open device\n");
> +		return ret_val;
> +	}
> +
> +	if (geo->raid_disks == UnSet) {
> +		dprintf("imsm: for container operation raid disks change is required\n");
> +		goto exit_imsm_reshape_is_allowed_on_container;
> +	}
> +
> +	device_num = 0; /* start from first device (skip container info) */
> +	while (device_num > -1) {
> +		int result;
> +		int minor;
> +		unsigned long long array_blocks;
> +		struct imsm_map *map = NULL;
> +		struct imsm_dev *dev = NULL;
> +		struct intel_super *super = NULL;
> +		int used_disks;
> +
> +
> +		dprintf("imsm: checking device_num: %i\n", device_num);
> +		sprintf(st->subarray, "%i", device_num);
> +		st->ss->load_super(st, fd, NULL);
> +		if (st->sb == NULL) {
> +			if (device_num == 0) {
> +				/* for the first checked device this is error
> +				   there should be at least one device to check
> +				 */
> +				dprintf("imsm: error: superblock is NULL during container operation\n");
> +			} else {
> +				dprintf("imsm: no more devices to check, number of forund devices: %i\n",
> +					devices_that_can_grow);
> +				/* check if any device in container can be groved
> +				 */
> +				if (devices_that_can_grow)
> +					ret_val = 1;
> +				/* restore superblock, for last device not loaded */
> +				sprintf(st->subarray, "%i", 0);
> +				st->ss->load_super(st, fd, NULL);
> +			}
> +			break;
> +		}
> +		info = sysfs_read(fd, 0, GET_LEVEL|GET_VERSION|GET_DEVS|GET_STATE);
> +		if (info == NULL) {
> +			dprintf("imsm: Cannot get device info.\n");
> +			break;
> +		}
> +		st->ss->getinfo_super(st, info);
> +
> +		if (geo->raid_disks < info->array.raid_disks) {
> +			/* we work on container for Online Capacity Expansion
> +			 * only so raid_disks has to grow
> +			 */
> +			dprintf("imsm: for container operation raid disks increase is required\n");
> +			break;
> +		}
> +		/* check if size is set corectly
> +		 * wrong conditions could happend when previous reshape wes interrupted
> +		 */
> +		super = st->sb;
> +		dev = get_imsm_dev(super, device_num);
> +		if (dev == NULL) {
> +			dprintf("cannot get imsm device\n");
> +			ret_val = 0;
> +			break;
> +		}
> +		map = get_imsm_map(dev, 0);
> +		if (dev == NULL) {
> +			dprintf("cannot get imsm device map\n");
> +			ret_val = 0;
> +			break;
> +		}
> +		used_disks = imsm_num_data_members(dev);
> +		dprintf("read raid_disks = %i\n", used_disks);
> +		dprintf("read requested disks = %i\n", geo->raid_disks);
> +		array_blocks = map->blocks_per_member * used_disks;
> +		/* round array size down to closest MB
> +		 */
> +		array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
> +		if (sysfs_set_num(info, NULL, "array_size", array_blocks/2) < 0)
> +			dprintf("cannot set array size to %llu\n", array_blocks/2);
> +
> +		if (geo->raid_disks > info->array.raid_disks)
> +			devices_that_can_grow++;
> +
> +		if ((info->array.level != 0) &&
> +		    (info->array.level != 5)) {
> +			/* we cannot use this container other raid level
> +			 */
> +			dprintf("imsm: for container operation wrong raid level (%i) detected\n", info->array.level);
> +			break;
> +		} else {
> +			/* check for platform support for this raid level configuration
> +			 */
> +			struct intel_super *super = st->sb;
> +			if (!is_raid_level_supported(super->orom,  info->array.level, geo->raid_disks)) {
> +				dprintf("platform does not support raid%d with %d disk%s\n",
> +					 info->array.level, geo->raid_disks, geo->raid_disks > 1 ? "s" : "");
> +				break;
> +			}
> +		}
> +
> +		/* all raid5 and raid0 volumes in container
> +		 * has to be ready for Online Capacity Expansion
> +		 */
> +		result = find_array_minor2(info->text_version, st->ss->external, st->devnum, &minor);
> +		if (result < 0) {
> +			dprintf("imsm: cannot find array\n");
> +			break;
> +		}
> +		sprintf(info->sys_name, "md%i", minor);
> +		if (sysfs_get_str(info, NULL, "array_state", buf, 20) <= 0) {
> +			dprintf("imsm: cannot read array state\n");
> +			break;
> +		}
> +		if ((strncmp(buf, "clean", 5) != 0) &&
> +		    (strncmp(buf, "clear", 5) != 0) &&
> +		    (strncmp(buf, "active", 6) != 0)) {
> +			int index = strlen(buf) - 1;
> +
> +			if (index < 0)
> +				index = 0;
> +			*(buf + index) = 0;
> +			fprintf(stderr, "imsm: Error: Array %s is not in proper state (current state: %s). Cannot continue.\n", info->sys_name, buf);
> +			break;
> +		}
> +		if (info->array.level > 0) {
> +			if (sysfs_get_str(info, NULL, "sync_action", buf, 20) <= 0) {
> +				dprintf("imsm: for container operation no sync action\n");
> +				break;
> +			}
> +			/* check if any reshape is not in progress
> +			 */
> +			if (strncmp(buf, "reshape", 7) == 0) {
> +				dprintf("imsm: for container operation reshape is currently in progress\n");
> +				break;
> +			}
> +		}
> +		sysfs_free(info);
> +		info = NULL;
> +		device_num++;
> +	}
> +	sysfs_free(info);
> +	info = NULL;
> +
> +exit_imsm_reshape_is_allowed_on_container:
> +	if (fd >= 0)
> +		close(fd);
> +
> +	dprintf("imsm: imsm_reshape_is_allowed_on_container(Exit) device_num = %i, ret_val = %i\n", device_num, ret_val);
> +	if (ret_val)
> +		dprintf("\tContainer operation allowed\n");
> +	else
> +		dprintf("\tError: %i\n", ret_val);
> +
> +	return ret_val;
> +}
> +struct mdinfo *get_spares_imsm(int devnum)
> +{
> +	int fd = -1;
> +	char buf[PATH_MAX];
> +	struct mdinfo *info = NULL;
> +	struct mdinfo *ret_val = NULL;
> +	int cont_id = -1;
> +	struct supertype *st = NULL;
> +	int find_result;
> +
> +	dprintf("imsm: get_spares_imsm for device: %i.\n", devnum);
> +
> +	sprintf(buf, "/dev/md%i", devnum);
> +	dprintf("try to read container %s\n", buf);
> +
> +	cont_id = open(buf, O_RDONLY);
> +	if (cont_id < 0) {
> +		dprintf("imsm: ERROR: Cannot open container.\n");
> +		goto abort;
> +	}
> +
> +	/* get first volume */
> +	st = super_by_fd(cont_id);
> +	if (st == NULL) {
> +		dprintf("imsm: ERROR: Cannot load container information.\n");
> +		goto abort;
> +	}
> +	sprintf(buf, "/md%i/0", devnum);
> +	find_result = find_array_minor2(buf, 1, devnum, &devnum);
> +	if (find_result < 0) {
> +		dprintf("imsm: ERROR: Cannot find array.\n");
> +		goto abort;
> +	}
> +	sprintf(buf, "/dev/md%i", devnum);
> +	fd = open(buf, O_RDONLY);
> +	if (fd < 0) {
> +		dprintf("imsm: ERROR: Cannot open device.\n");
> +		goto abort;
> +	}
> +	sprintf(st->subarray, "0");
> +	st->ss->load_super(st, cont_id, NULL);
> +	if (st->sb == NULL) {
> +		dprintf("imsm: ERROR: Cannot load array information.\n");
> +		goto abort;
> +	}
> +	info = sysfs_read(fd, 0, GET_LEVEL | GET_VERSION | GET_DEVS | GET_STATE);
> +	if (info == NULL) {
> +		dprintf("imsm: Cannot get device info.\n");
> +		goto abort;
> +	}
> +	st->ss->getinfo_super(st, info);
> +	sprintf(buf, "/dev/md/%s", info->name);
> +	ret_val = sysfs_get_unused_spares(cont_id, fd);
> +	if (ret_val == NULL) {
> +		dprintf("imsm: ERROR: Cannot get spare devices.\n");
> +		goto abort;
> +	}
> +	if (ret_val->array.spare_disks == 0) {
> +		dprintf("imsm: ERROR: No available spares.\n");
> +		free(ret_val);
> +		ret_val = NULL;
> +		goto abort;
> +	}
> +
> +abort:
> +	if (st)
> +		st->ss->free_super(st);
> +	sysfs_free(info);
> +	if (fd > -1)
> +		close(fd);
> +	if (cont_id > -1)
> +		close(cont_id);
> +
> +	return ret_val;
> +}
> +
> +/******************************************************************************
> + * function: imsm_create_metadata_update_for_reshape
> + * Function creates update for whole IMSM container.
> + * Slot number for new devices are guesed only. Managemon will correct them
> + * when reshape will be triggered and md sets slot numbers.
> + * Slot numbers in metadata will be updated with stage_2 update
> + ******************************************************************************/
> +struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct supertype *st, struct geo_params *geo)
> +{
> +	struct imsm_update_reshape *ret_val = NULL;
> +	struct intel_super *super = st->sb;
> +	int update_memory_size = 0;
> +	struct imsm_update_reshape *u = NULL;
> +	struct imsm_map *new_map = NULL;
> +	struct mdinfo *spares = NULL;
> +	int i;
> +	unsigned long long array_blocks;
> +	int used_disks;
> +	int delta_disks = 0;
> +	struct dl *new_disks;
> +	int device_size;
> +	void *upd_devs;
> +
> +	dprintf("imsm imsm_update_metadata_for_reshape(enter) raid_disks = %i\n", geo->raid_disks);
> +
> +	if ((geo->raid_disks < super->anchor->num_disks) ||
> +	    (geo->raid_disks == UnSet))
> +		geo->raid_disks = super->anchor->num_disks;
> +	delta_disks = geo->raid_disks - super->anchor->num_disks;
> +
> +	/* size of all update data without anchor */
> +	update_memory_size = sizeof(struct imsm_update_reshape);
> +	/* add space for all devices,
> +	 * then add maps space
> +	 */
> +	device_size = sizeof(struct imsm_dev);
> +	device_size += sizeof(struct imsm_map);
> +	device_size += 2 * (geo->raid_disks - 1) * sizeof(__u32);
> +
> +	update_memory_size += device_size * super->anchor->num_raid_devs;
> +	if (delta_disks > 1) {
> +		/* now add space for spare disks information
> +		 */
> +		update_memory_size += sizeof(struct dl) * (delta_disks - 1);
> +	}
> +
> +	u = calloc(1, update_memory_size);
> +	if (u == NULL) {
> +		dprintf("error: cannot get memory for imsm_update_reshape update\n");
> +		return ret_val;
> +	}
> +	u->reshape_delta_disks = delta_disks;
> +	u->update_prepared = -1;
> +	u->update_memory_size = update_memory_size;
> +	u->type = update_reshape;
> +	u->spares_in_update = 0;
> +	u->upd_devs_offset =  sizeof(struct imsm_update_reshape) + sizeof(struct dl) * (delta_disks - 1);
> +	upd_devs = (struct imsm_dev *)((void *)u + u->upd_devs_offset);
> +	u->device_size = device_size;
> +
> +	for (i = 0; i < super->anchor->num_raid_devs; i++) {
> +		struct imsm_dev *old_dev = __get_imsm_dev(super->anchor, i);
> +		int old_disk_number;
> +		int devnum = -1;
> +
> +		u->devnum = -1;
> +		if (old_dev == NULL)
> +			break;
> +
> +		find_array_minor((char *)old_dev->volume, 1, st->devnum, &devnum);
> +		if (devnum == geo->dev_id) {
> +			__u8 to_state;
> +			struct imsm_map *new_map2;
> +			int idx;
> +
> +			new_map = NULL;
> +			imsm_copy_dev(upd_devs, old_dev);
> +			new_map = get_imsm_map(upd_devs, 0);
> +			old_disk_number = new_map->num_members;
> +			new_map->num_members = geo->raid_disks;
> +			u->reshape_delta_disks = new_map->num_members - old_disk_number;
> +			/* start migration on new device
> +			 * it puts second map there also
> +			 */
> +
> +			to_state = imsm_check_degraded(super, old_dev, 0);
> +			migrate(upd_devs, to_state, MIGR_GEN_MIGR);
> +			/* second map length is equal to first map
> +			* correct second map length to old value
> +			*/
> +			new_map2 = get_imsm_map(upd_devs, 1);
> +			if (new_map2) {
> +				if (new_map2->num_members != old_disk_number) {
> +					new_map2->num_members = old_disk_number;
> +					/* guess new disk indexes
> +					*/
> +					for (idx = new_map2->num_members; idx < new_map->num_members; idx++)
> +						set_imsm_ord_tbl_ent(new_map, idx, idx);
> +				}
> +				u->devnum = geo->dev_id;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (delta_disks <= 0) {
> +		dprintf("imsm: reshape without grow (disk add).\n");
> +		/* finalize update */
> +		goto calculate_size_only;
> +	}
> +
> +	/* now get spare disks list
> +	 */
> +	spares = get_spares_imsm(st->container_dev);
> +
> +	if (spares == NULL) {
> +		dprintf("imsm: ERROR: Cannot get spare devices.\n");
> +		goto exit_imsm_create_metadata_update_for_reshape;
> +	}
> +	if ((spares->array.spare_disks == 0) ||
> +	(u->reshape_delta_disks > spares->array.spare_disks)) {
> +		dprintf("imsm: ERROR: No available spares.\n");
> +		goto exit_imsm_create_metadata_update_for_reshape;
> +	}
> +	/* we have got spares
> +	 * update disk list in imsm_disk list table in anchor
> +	 */
> +	dprintf("imsm: %i spares are available.\n\n", spares->array.spare_disks);
> +	new_disks = u->upd_disks;
> +	for (i = 0; i < u->reshape_delta_disks; i++) {
> +		struct mdinfo *dev = spares->devs;
> +		__u32 id;
> +		int fd;
> +		char buf[PATH_MAX];
> +		int rv;
> +		unsigned long long size;
> +
> +		sprintf(buf, "%d:%d", dev->disk.major, dev->disk.minor);
> +		dprintf("open spare disk %s (%s)\n", buf, dev->sys_name);
> +		fd = dev_open(buf, O_RDWR);
> +		if (fd < 0) {
> +			dprintf("\topen failed\n");
> +			goto exit_imsm_create_metadata_update_for_reshape;
> +		}
> +		if (sysfs_disk_to_scsi_id(fd, &id) == 0)
> +			new_disks[i].disk.scsi_id = __cpu_to_le32(id);
> +		else
> +			new_disks[i].disk.scsi_id = __cpu_to_le32(0);
> +		new_disks[i].disk.status = CONFIGURED_DISK;
> +		rv = imsm_read_serial(fd, NULL, new_disks[i].disk.serial);
> +		if (rv != 0) {
> +			dprintf("\tcannot read disk serial\n");
> +			close(fd);
> +			goto exit_imsm_create_metadata_update_for_reshape;
> +		}
> +		dprintf("\tdisk serial: %s\n", new_disks[i].disk.serial);
> +		get_dev_size(fd, NULL, &size);
> +		size /= 512;
> +		new_disks[i].disk.total_blocks = __cpu_to_le32(size);
> +		new_disks[i].disk.owner_cfg_num = super->anchor->disk->owner_cfg_num;
> +
> +		new_disks[i].major = dev->disk.major;
> +		new_disks[i].minor = dev->disk.minor;
> +		/* no relink in update
> +		 * use table access
> +		 */
> +		new_disks[i].next = NULL;
> +
> +		close(fd);
> +		spares->devs = dev->next;
> +		u->spares_in_update++;
> +
> +		free(dev);
> +		dprintf("\n");
> +	}
> +calculate_size_only:
> +	/* calculate new size
> +	 */
> +	if (new_map != NULL) {
> +
> +		used_disks = imsm_num_data_members(upd_devs);
> +		if (used_disks) {
> +			array_blocks = new_map->blocks_per_member * used_disks;
> +			/* round array size down to closest MB
> +			 */
> +			array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
> +			((struct imsm_dev *)(upd_devs))->size_low = __cpu_to_le32((__u32)array_blocks);
> +			((struct imsm_dev *)(upd_devs))->size_high = __cpu_to_le32((__u32)(array_blocks >> 32));
> +			/* finalize update */
> +			ret_val = u;
> +		}
> +	}
> +
> +exit_imsm_create_metadata_update_for_reshape:
> +	/* free spares
> +	 */
> +	if (spares) {
> +		while (spares->devs) {
> +			struct mdinfo *dev = spares->devs;
> +			spares->devs = dev->next;
> +			free(dev);
> +		}
> +		free(spares);
> +	}
> +
> +	if (ret_val == NULL)
> +		free(u);
> +
> +	return ret_val;
> +}
> +
> +char *get_volume_for_olce(struct supertype *st, int raid_disks)
> +{
> +	char *ret_val = NULL;
> +	struct mdinfo *sra = NULL;
> +	struct mdinfo info;
> +	char *ret_buf;
> +	struct intel_super *super = st->sb;
> +	int i;
> +	int fd = -1;
> +	char buf[PATH_MAX];
> +
> +	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
> +	dprintf("imsm: open device (%s)\n", buf);
> +	fd = open(buf , O_RDONLY | O_DIRECT);
> +	if (fd < 0) {
> +		dprintf("imsm: cannot open device\n");
> +		return ret_val;
> +	}
> +
> +	ret_buf = malloc(PATH_MAX);
> +	if (ret_buf == NULL)
> +		goto exit_get_volume_for_olce;
> +
> +	super = st->sb;
> +	for (i = 0; i < super->anchor->num_raid_devs; i++) {
> +		sprintf(st->subarray, "%i", i);
> +		st->ss->load_super(st, fd, NULL);
> +		if (st->sb == NULL)
> +			goto exit_get_volume_for_olce;
> +		info.devs = NULL;
> +		st->ss->getinfo_super(st, &info);
> +
> +		if (raid_disks > info.array.raid_disks) {
> +			snprintf(ret_buf, PATH_MAX,
> +				 "%s",  info.name);
> +			dprintf("Found device for OLCE requested raid_disks = %i, array raid_disks = %i\n",
> +				raid_disks, info.array.raid_disks);
> +			ret_val = ret_buf;
> +			break;
> +		}
> +	}
> +
> +exit_get_volume_for_olce:
> +	if ((ret_val == NULL) && ret_buf)
> +		free(ret_buf);
> +	sysfs_free(sra);
> +	if (fd > -1)
> +		close(fd);
> +
> +	return ret_val;
> +}
> +
>  
>  int imsm_reshape_super(struct supertype *st, long long size, int level,
>  		       int layout, int chunksize, int raid_disks,
> @@ -5827,7 +6531,20 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
>  	struct mdinfo *sra = NULL;
>  	int fd = -1;
>  	char buf[PATH_MAX];
> +	struct geo_params geo;
> +
> +	memset(&geo, sizeof (struct geo_params), 0);
> +
> +	geo.dev_name = dev;
> +	geo.size = size;
> +	geo.level = level;
> +	geo.layout = layout;
> +	geo.chunksize = chunksize;
> +	geo.raid_disks = raid_disks;
>  
> +	dprintf("imsm: reshape_super called().\n");
> +	dprintf("\tfor level      : %i\n", geo.level);
> +	dprintf("\tfor raid_disks : %i\n", geo.raid_disks);
>  
>  	if (experimental() == 0)
>  		return ret_val;
> @@ -5839,7 +6556,46 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
>  		goto imsm_reshape_super_exit;
>  	}
>  
> -	if ((size == -1) && (layout == UnSet) && (raid_disks == 0) && (level != UnSet)) {
> +	/* verify reshape conditions
> +	 * on container level we can do almost  everything */
> +	if (st->subarray[0] == 0) {
> +		/* check for delta_disks > 0 and supported raid levels 0 and 5 only in container */
> +		if (imsm_reshape_is_allowed_on_container(st, &geo)) {
> +			struct imsm_update_reshape *u;
> +			char *array;
> +
> +			array = get_volume_for_olce(st, geo.raid_disks);
> +			if (array) {
> +				find_array_minor(array, 1, st->devnum, &geo.dev_id);
> +				if (geo.dev_id > 0) {
> +					dprintf("imsm: Preparing metadata update for: %s\n", array);
> +
> +					st->update_tail = &st->updates;
> +					u = imsm_create_metadata_update_for_reshape(st, &geo);
> +
> +					if (u) {
> +						ret_val = 0;
> +						append_metadata_update(st, u, u->update_memory_size);
> +					} else
> +						dprintf("imsm: Cannot prepare update\n");
> +				} else
> +					dprintf("imsm: Cannot find array in container\n");
> +				free(array);
> +			}
> +		} else
> +			dprintf("imsm: Operation is not allowed on container\n");
> +		*st->subarray = 0;
> +		goto imsm_reshape_super_exit;
> +	} else
> +		dprintf("imsm: not a container operation\n");
> +
> +	geo.dev_id = -1;
> +	find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id);
> +
> +	/* we have volume so takeover can be performed for single volume only
> +	 */
> +	if ((geo.size == -1) && (geo.layout == UnSet) && (geo.raid_disks == 0) && (geo.level != UnSet) &&
> +	    (geo.dev_id > -1)) {
>  		/* ok - this is takeover */
>  		int container_fd;
>  		int dn;
> @@ -5867,9 +6623,9 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
>  		 * to/from different than raid10 level
>  		 * if source level is raid0 mdmon is sterted only
>  		 */
> -		if (((level == 10) || (sra->array.level == 10) || (sra->array.level == 0)) &&
> -		     (level != sra->array.level) &&
> -		     (level > 0)) {
> +		if (((geo.level == 10) || (sra->array.level == 10) || (sra->array.level == 0)) &&
> +		     (geo.level != sra->array.level) &&
> +		     (geo.level > 0)) {
>  			st->update_tail = &st->updates;
>  			err = update_level_imsm(st, sra, sra->name, 0, 0, NULL);
>  			ret_val = 0;
> @@ -5887,6 +6643,34 @@ imsm_reshape_super_exit:
>  	return ret_val;
>  }
>  
> +int imsm_get_new_device_name(struct dl *dl)
> +{
> +	int rv;
> +	char dv[PATH_MAX];
> +	char nm[PATH_MAX];
> +	char *dname;
> +
> +	if (dl->devname != NULL)
> +		return 0;
> +
> +	sprintf(dv, "/sys/dev/block/%d:%d", dl->major, dl->minor);
> +	memset(nm, 0, sizeof(nm));
> +	rv = readlink(dv, nm, sizeof(nm));
> +	if (rv > 0) {
> +		nm[rv] = '\0';
> +		dname = strrchr(nm, '/');
> +		if (dname) {
> +			char buf[PATH_MAX];
> +
> +			dname++;
> +			sprintf(buf, "/dev/%s", dname);
> +			dl->devname = strdup(buf);
> +		}
> +	}
> +
> +	return rv;
> +}
> +
>  struct superswitch super_imsm = {
>  #ifndef	MDASSEMBLE
>  	.examine_super	= examine_super_imsm,
> diff --git a/sysfs.c b/sysfs.c
> index 3582fed..e316785 100644
> --- a/sysfs.c
> +++ b/sysfs.c
> @@ -800,6 +800,150 @@ int sysfs_unique_holder(int devnum, long rdev)
>  		return found;
>  }
>  
> +int sysfs_is_spare_device_belongs_to(int fd, char *devname)
> +{
> +	int ret_val = -1;
> +	char fname[PATH_MAX];
> +	char *base;
> +	char *dbase;
> +	struct mdinfo *sra;
> +	DIR *dir = NULL;
> +	struct dirent *de;
> +
> +	sra = malloc(sizeof(*sra));
> +	if (sra == NULL)
> +		goto abort;
> +	memset(sra, 0, sizeof(*sra));
> +	sysfs_init(sra, fd, -1);
> +	if (sra->sys_name[0] == 0)
> +		goto abort;
> +
> +	memset(fname, PATH_MAX, 0);
> +	sprintf(fname, "/sys/block/%s/md/", sra->sys_name);
> +	base = fname + strlen(fname);
> +
> +	/* Get all the devices as well */
> +	*base = 0;
> +	dir = opendir(fname);
> +	if (!dir)
> +		goto abort;
> +	while ((de = readdir(dir)) != NULL) {
> +		if (de->d_ino == 0 ||
> +		    strncmp(de->d_name, "dev-", 4) != 0)
> +			continue;
> +		strcpy(base, de->d_name);
> +		dbase = base + strlen(base);
> +		*dbase = '\0';
> +		dbase = strstr(fname, "/md/");
> +		if (dbase && strcmp(devname, dbase) == 0) {
> +			ret_val = 1;
> +			goto abort;
> +		}
> +	}
> +abort:
> +	if (dir)
> +		closedir(dir);
> +	sysfs_free(sra);
> +
> +	return ret_val;
> +}

This at least needs a comment at the tops saying what it does, and why.

Why don't you do a sysfs_read, then do a search based on device id rather
than name?  It is always safer to use device id than device name if possible.


> +
> +struct mdinfo *sysfs_get_unused_spares(int container_fd, int fd)
> +{
> +	char fname[PATH_MAX];
> +	char buf[PATH_MAX];
> +	char *base;
> +	char *dbase;
> +	struct mdinfo *ret_val;
> +	struct mdinfo *dev;
> +	DIR *dir = NULL;
> +	struct dirent *de;
> +	int is_in;
> +	char *to_check;
> +
> +	ret_val = malloc(sizeof(*ret_val));
> +	if (ret_val == NULL)
> +		goto abort;
> +	memset(ret_val, 0, sizeof(*ret_val));
> +	sysfs_init(ret_val, container_fd, -1);
> +	if (ret_val->sys_name[0] == 0)
> +		goto abort;
> +
> +	sprintf(fname, "/sys/block/%s/md/", ret_val->sys_name);
> +	base = fname + strlen(fname);
> +
> +	strcpy(base, "raid_disks");
> +	if (load_sys(fname, buf))
> +		goto abort;
> +	ret_val->array.raid_disks = strtoul(buf, NULL, 0);
> +
> +	/* Get all the devices as well */
> +	*base = 0;
> +	dir = opendir(fname);
> +	if (!dir)
> +		goto abort;
> +	ret_val->array.spare_disks = 0;
> +	while ((de = readdir(dir)) != NULL) {
> +		char *ep;
> +		if (de->d_ino == 0 ||
> +		    strncmp(de->d_name, "dev-", 4) != 0)
> +			continue;
> +		strcpy(base, de->d_name);
> +		dbase = base + strlen(base);
> +		*dbase = '\0';
> +
> +		to_check = strstr(fname, "/md/");
> +		is_in = sysfs_is_spare_device_belongs_to(fd, to_check);
> +		if (is_in == -1) {
> +			dev = malloc(sizeof(*dev));
> +			if (!dev)
> +				goto abort;
> +			strncpy(dev->text_version, fname, 50);
> +
> +			*dbase++ = '/';
> +
> +			dev->disk.raid_disk = strtoul(buf, &ep, 10);
> +			dev->disk.raid_disk = -1;
> +
> +			strcpy(dbase, "block/dev");
> +			if (load_sys(fname, buf)) {
> +				free(dev);
> +				continue;
> +			}
> +			sscanf(buf, "%d:%d", &dev->disk.major, &dev->disk.minor);
> +			strcpy(dbase, "block/device/state");
> +			if (load_sys(fname, buf) != 0) {
> +				free(dev);
> +				continue;
> +			}
> +			if (strncmp(buf, "offline", 7) == 0) {
> +				free(dev);
> +				continue;
> +			}
> +			if (strncmp(buf, "failed", 6) == 0) {
> +				free(dev);
> +				continue;
> +			}
> +
> +			/* add this disk to spares list */
> +			dev->next = ret_val->devs;
> +			ret_val->devs = dev;
> +			ret_val->array.spare_disks++;
> +			*(dbase-1) = '\0';
> +			dprintf("sysfs: found spare: (%s)\n", fname);
> +		}
> +	}
> +	closedir(dir);
> +	return ret_val;
> +
> +abort:
> +	if (dir)
> +		closedir(dir);
> +	sysfs_free(ret_val);
> +
> +	return NULL;
> +}

Again, why not sysfs_read, then process that data structure?


> +
>  int sysfs_freeze_array(struct mdinfo *sra)
>  {
>  	/* Try to freeze resync/rebuild on this array/container.
> diff --git a/util.c b/util.c
> index f220792..396f6d8 100644
> --- a/util.c
> +++ b/util.c
> @@ -1869,3 +1869,151 @@ inline int experimental(void)
>  	}
>  }
>  
> +int path2devnum(char *pth)
> +{
> +	char *ep;
> +	int fd = -1;
> +	char *dev_pth = NULL;
> +	char *dev_str;
> +	int dev_num = -1;
> +
> +	fd = open(pth, O_RDONLY);
> +	if (fd < 0)
> +		return dev_num;
> +	close(fd);
> +	dev_pth = canonicalize_file_name(pth);
> +	if (dev_pth == NULL)
> +		return dev_num;
> +	dev_str = strrchr(dev_pth, '/');
> +	if (dev_str) {
> +		while (!isdigit(dev_str[0]))
> +			dev_str++;
> +		dev_num = strtoul(dev_str, &ep, 10);
> +		if (*ep != '\0')
> +			dev_num = -1;
> +	}
> +
> +	if (dev_pth)
> +		free(dev_pth);
> +
> +	return dev_num;
> +}
> +
> +extern void map_read(struct map_ent **map);
> +extern void map_free(struct map_ent *map);
> +int find_array_minor(char *text_version, int external, int container, int *minor)
> +{
> +	int i;
> +	char path[PATH_MAX];
> +	struct stat s;
> +
> +	if (minor == NULL)
> +		return -2;
> +
> +	snprintf(path, PATH_MAX, "/dev/md/%s", text_version);
> +	i = path2devnum(path);
> +	if (i > -1) {
> +		*minor = i;
> +		return 0;
> +	}
> +
> +	i = path2devnum(text_version);
> +	if (i > -1) {
> +		*minor = i;
> +		return 0;
> +	}
> +
> +	if (container > 0) {
> +		struct map_ent *map = NULL;
> +		struct map_ent *m;
> +		char cont[PATH_MAX];
> +
> +		snprintf(cont, PATH_MAX, "/md%i/", container);
> +		map_read(&map);
> +		for (m = map; m; m = m->next) {
> +			int index;
> +			unsigned int len = 0;
> +			char buf[PATH_MAX];
> +
> +			/* array have belongs to proper container
> +			*/
> +			if (strncmp(cont, m->metadata, 6) != 0)
> +				continue;
> +			/* begin of array name in map have to be the same
> +			 * as array name in metadata
> +			 */
> +			if (strncmp(m->path, path, strlen(path)) != 0)
> +				continue;
> +			/* array name has to be followed by '_' char
> +			 */
> +			len = strlen(path);
> +			if (*(m->path + len) != '_')
> +				continue;
> +			/* then we have to have  valid index
> +			 */
> +			len++;
> +			if (strlen(m->path + len) <= 0)
> +			    continue;
> +			/* index has to be las position in array name
> +			 */
> +			index = atoi(m->path + strlen(path) + 1);
> +			snprintf(buf, PATH_MAX, "%i", index);
> +			len += strlen(buf);
> +			if (len != strlen(m->path))
> +				continue;
> +			dprintf("Found %s device based on mdadm maps\n", m->path);
> +			*minor = m->devnum;
> +			map_free(map);
> +			return 0;
> +		}
> +		map_free(map);
> +	}
> +
> +	for (i = 127; i >= 0; i--) {
> +		char buf[PATH_MAX];
> +
> +		snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
> +		if (stat(path, &s) != -1) {
> +			strcat(path, "metadata_version");
> +			if (load_sys(path, buf))
> +				continue;
> +			if (external) {
> +				char *version = strchr(buf, ':');
> +				if (version && strcmp(version + 1,
> +						      text_version))
> +					continue;
> +			} else {
> +				if (strcmp(buf, text_version))
> +					continue;
> +			}
> +			*minor = i;
> +			return 0;
> +		}
> +	}
> +
> +
> +	return -1;
> +}
> +
> +/* find_array_minor2 looks for frozen devices also
> + */
> +int find_array_minor2(char *text_version, int external, int container, int *minor)
> +{
> +	int result;
> +	char buf[PATH_MAX];
> +
> +	strcpy(buf, text_version);
> +	result = find_array_minor(text_version, external, container, minor);
> +	if (result < 0) {
> +		/* try to find frozen array also
> +		 */
> +		char buf[PATH_MAX];
> +
> +		strcpy(buf, text_version);
> +
> +		*buf = '-';
> +		result = find_array_minor(buf, external, container, minor);
> +	}
> +	return result;
> +}
> +

This all looks way to complicated, should be using map_read, and it totally
undocumented so it is too hard to figure out what you were really trying to
do.

NeilBrown

