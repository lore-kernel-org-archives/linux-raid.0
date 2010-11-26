From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 16/53] Add takeover support for external meta
Date: Fri, 26 Nov 2010 09:05:52 +0100
Message-ID: <20101126080552.5221.95361.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When performing takeover 0->10 or 10->0 mdmon should update the external metadata (due to disk slot changes).
To achieve that mdadm, after changing the level in md, mdadm calls update_super with "update_level" type.
update_super() allocates a new imsm_dev with updated disk slot numbers to be processed by mdmon in process_update().
process_update() discovers missing disks and adds them to imsm metadata.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |   28 ++++++
 managemon.c   |   16 +++
 monitor.c     |    2 
 super-intel.c |  279 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 321 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8ca1812..e977ce2 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1066,6 +1066,31 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				fprintf(stderr, Name " level of %s changed to %s\n",
 					devname, c);
 			changed = 1;
+
+			st = super_by_fd(fd);
+			if (!st) {
+				fprintf(stderr, Name ": cannot handle this array\n");
+				if (container)
+					free(container);
+				if (cfd > -1)
+					close(cfd);
+				return 1;
+			} else {
+				if (st && reshape_super(st, -1, level, UnSet, 0, 0, NULL, devname, !quiet)) {
+					rv = 1;
+					goto release;
+				}
+				/* before sending update make sure that for external metadata
+				 * and after changing raid level mdmon is running
+				 */
+				if (st->ss->external && !mdmon_running(st->container_dev) &&
+				    level > 0) {
+					start_mdmon(st->container_dev);
+					if (container)
+						ping_monitor(container);
+				}
+				sync_metadata(st);
+			}
 		}
 	}
 
@@ -1140,7 +1165,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		if (st->ss->external && !mdmon_running(st->container_dev) &&
 		    level > 0) {
 			start_mdmon(st->container_dev);
-			ping_monitor(container);
+			if (container)
+				ping_monitor(container);
 		}
 		goto release;
 	}
diff --git a/managemon.c b/managemon.c
index 164e4f8..53ab4a9 100644
--- a/managemon.c
+++ b/managemon.c
@@ -381,6 +381,9 @@ static int disk_init_and_add(struct mdinfo *disk, struct mdinfo *clone,
 static void manage_member(struct mdstat_ent *mdstat,
 			  struct active_array *a)
 {
+	struct active_array *newa;
+	int level;
+
 	/* Compare mdstat info with known state of member array.
 	 * We do not need to look for device state changes here, that
 	 * is dealt with by the monitor.
@@ -408,6 +411,19 @@ static void manage_member(struct mdstat_ent *mdstat,
 	else
 		frozen = 1; /* can't read metadata_version assume the worst */
 
+	level = a->info.array.level;
+	if (mdstat->level) {
+		level = map_name(pers, mdstat->level);
+		if (a->info.array.level != level && level >= 0) {
+			newa = duplicate_aa(a);
+			if (newa) {
+				newa->info.array.level = level;
+				replace_array(a->container, a, newa);
+				a = newa;
+			}
+		}
+	}
+
 	if (a->check_degraded && !frozen) {
 		struct metadata_update *updates = NULL;
 		struct mdinfo *newdev = NULL;
diff --git a/monitor.c b/monitor.c
index 59b4181..5705a9b 100644
--- a/monitor.c
+++ b/monitor.c
@@ -483,7 +483,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 		/* once an array has been deactivated we want to
 		 * ask the manager to discard it.
 		 */
-		if (!a->container) {
+		if (!a->container || a->info.array.level == 0) {
 			if (discard_this) {
 				ap = &(*ap)->next;
 				continue;
diff --git a/super-intel.c b/super-intel.c
index 7c5fcc4..2434fa1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -285,6 +285,7 @@ enum imsm_update_type {
 	update_kill_array,
 	update_rename_array,
 	update_add_disk,
+	update_level,
 };
 
 struct imsm_update_activate_spare {
@@ -320,6 +321,13 @@ struct imsm_update_add_disk {
 	enum imsm_update_type type;
 };
 
+struct imsm_update_level {
+	enum imsm_update_type type;
+	int delta_disks;
+	int container_member;
+	struct imsm_dev dev;
+};
+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
 	struct supertype *st;
@@ -1666,6 +1674,9 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 	}
 }
 
+static int is_raid_level_supported(const struct imsm_orom *orom, int level, int raiddisks);
+static void imsm_copy_dev(struct imsm_dev *dest, struct imsm_dev *src);
+
 static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 			     char *update, char *devname, int verbose,
 			     int uuid_set, char *homehost)
@@ -1698,12 +1709,15 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb;
 
-	/* we can only update container info */
-	if (!super || super->current_vol >= 0 || !super->anchor)
+	if (!super || !super->anchor)
 		return 1;
 
 	mpb = super->anchor;
 
+	/* we can only update container info */
+	if (super->current_vol >= 0)
+		return 1;
+
 	if (strcmp(update, "uuid") == 0 && uuid_set && !info->update_private)
 		fprintf(stderr,
 			Name ": '--uuid' not supported for imsm metadata\n");
@@ -1778,6 +1792,45 @@ static void imsm_copy_dev(struct imsm_dev *dest, struct imsm_dev *src)
 	memcpy(dest, src, sizeof_imsm_dev(src, 0));
 }
 
+struct imsm_dev *reallocate_imsm_dev(struct intel_super *super,
+					 unsigned int array_index,
+					 int map_num_members)
+{
+	struct imsm_dev *newdev = NULL;
+	struct imsm_dev *retval = NULL;
+	struct intel_dev *dv = NULL;
+	struct imsm_dev *dv_free = NULL;
+	int memNeeded;
+
+	if (!super)
+		return NULL;
+
+	/* Calculate space needed for imsm_dev with a double map */
+	memNeeded = sizeof(struct imsm_dev) + sizeof(__u32) * (map_num_members - 1) +
+		sizeof(struct imsm_map) + sizeof(__u32) * (map_num_members - 1);
+
+	newdev = malloc(memNeeded);
+	if (!newdev) {
+		fprintf(stderr, "error: imsm meta update not possible due to no memory conditions\n");
+		return NULL;
+	}
+	/* Find our device */
+	for (dv = super->devlist; dv; dv = dv->next)
+		if (dv->index == array_index) {
+			/* Copy imsm_dev into the new buffer */
+			imsm_copy_dev(newdev, dv->dev);
+			dv_free = dv->dev;
+			dv->dev = newdev;
+			retval = newdev;
+			free(dv_free);
+			break;
+		}
+	if (retval == NULL)
+		free(newdev);
+
+	return retval;
+}
+
 static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 {
 	/*
@@ -5123,6 +5176,57 @@ static void imsm_process_update(struct supertype *st,
 	mpb = super->anchor;
 
 	switch (type) {
+	case update_level: {
+		struct imsm_update_level *u = (void *)update->buf;
+		struct imsm_dev *dev_new, *dev = NULL;
+		struct imsm_map *map;
+		struct dl *d;
+		int i;
+		int start_disk;
+
+		dev_new = &u->dev;
+		for (i = 0; i < mpb->num_raid_devs; i++) {
+			dev = get_imsm_dev(super, i);
+			if (strcmp((char *)dev_new->volume, (char *)dev->volume) == 0)
+				break;
+		}
+		if (i == super->anchor->num_raid_devs)
+			return;
+
+		if (dev == NULL)
+			return;
+
+		imsm_copy_dev(dev, dev_new);
+		map = get_imsm_map(dev, 0);
+		start_disk = mpb->num_disks;
+		mpb->num_disks += u->delta_disks;
+
+		/* clear missing disks list */
+		while (super->missing) {
+			d = super->missing;
+			super->missing = d->next;
+			__free_imsm_disk(d);
+		}
+		find_missing(super);
+
+		/* clear new disk entries if number of disks increased*/
+		d = super->missing;
+		for (i = start_disk; i < map->num_members; i++) {
+			assert(d != NULL);
+			if (!d)
+				break;
+			memset(&d->disk, 0, sizeof(d->disk));
+			strcpy((char *)d->disk.serial, "MISSING");
+			d->disk.total_blocks = map->blocks_per_member;
+			/* Set slot for missing disk */
+			set_imsm_ord_tbl_ent(map, i, d->index | IMSM_ORD_REBUILD);
+			d->raiddisk = i;
+			d = d->next;
+		}
+
+		super->updates_pending++;
+		break;
+	}
 	case update_activate_spare: {
 		struct imsm_update_activate_spare *u = (void *) update->buf; 
 		struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -5442,6 +5546,26 @@ static void imsm_prepare_update(struct supertype *st,
 	size_t len = 0;
 
 	switch (type) {
+	case update_level: {
+		struct imsm_update_level *u = (void *) update->buf;
+		struct active_array *a;
+
+		dprintf("prepare_update(): update level\n");
+		len += u->delta_disks * sizeof(struct imsm_disk) +
+			u->delta_disks * sizeof(__u32);
+
+		for (a = st->arrays; a; a = a->next)
+			if (a->info.container_member == u->container_member)
+				break;
+		if (a == NULL)
+			break; /* what else we can do here? */
+
+		/* we'll add new disks to imsm_dev */
+		if (u->delta_disks > 0)
+			reallocate_imsm_dev(super, u->container_member,
+					    a->info.array.raid_disks);
+		break;
+	}
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
@@ -5561,6 +5685,156 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 }
 #endif /* MDASSEMBLE */
 
+static int update_level_imsm(struct supertype *st, struct mdinfo *info,
+			     char *devname, int verbose,
+			     int uuid_set, char *homehost)
+{
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super->anchor;
+	struct imsm_update_level *u;
+	struct imsm_dev *dev_new, *dev = NULL;
+	struct imsm_map *map_new, *map;
+	struct mdinfo *newdi;
+	struct dl *dl;
+	int *tmp_ord_tbl;
+	int i, slot, idx;
+	int len, disks;
+
+	if (!is_raid_level_supported(super->orom,
+				     info->array.level,
+				     info->array.raid_disks))
+		return 1;
+
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		dev = get_imsm_dev(super, i);
+		if (strcmp(devname, (char *)dev->volume) == 0)
+			break;
+	}
+	if (dev == NULL)
+		return 1;
+
+	if (i == super->anchor->num_raid_devs)
+		return 1;
+
+	map = get_imsm_map(dev, 0);
+
+	/* update level is needed only for 0->10 and 10->0 transitions */
+	if ((info->array.level != 10 || map->raid_level != 0) &&
+	    (info->array.level != 0 || map->raid_level != 10))
+		return 1;
+
+	disks = (info->array.raid_disks > map->num_members) ?
+		info->array.raid_disks : map->num_members;
+	len = sizeof(struct imsm_update_level) +
+		((disks - 1) * sizeof(__u32));
+
+	u = malloc(len);
+	if (u == NULL)
+		return 1;
+
+	dev_new = &u->dev;
+	imsm_copy_dev(dev_new, dev);
+	map_new = get_imsm_map(dev_new, 0);
+
+	tmp_ord_tbl = malloc(sizeof(int) * disks);
+	if (tmp_ord_tbl == NULL) {
+		free(u);
+		return 1;
+	}
+
+	for (i = 0; i < disks; i++)
+		tmp_ord_tbl[i] = -1;
+
+	/* iterate through devices to detect slot changes */
+	for (dl = super->disks; dl; dl = dl->next)
+		for (newdi = info->devs; newdi; newdi = newdi->next) {
+			if ((dl->major != newdi->disk.major) ||
+			    (dl->minor != newdi->disk.minor))
+				continue;
+			slot = get_imsm_disk_slot(map, dl->index);
+			idx = get_imsm_ord_tbl_ent(dev_new, slot);
+			tmp_ord_tbl[newdi->disk.raid_disk] = idx;
+			break;
+		}
+
+	for (i = 0; i < disks; i++)
+		set_imsm_ord_tbl_ent(map_new, i, tmp_ord_tbl[i]);
+	free(tmp_ord_tbl);
+	map_new->raid_level = info->array.level;
+	map_new->num_members = info->array.raid_disks;
+	u->type = update_level;
+	u->delta_disks = info->array.raid_disks - map->num_members;
+	u->container_member = info->container_member;
+	append_metadata_update(st, u, len);
+
+	return 0;
+}
+
+
+int imsm_reshape_super(struct supertype *st, long long size, int level,
+		       int layout, int chunksize, int raid_disks,
+		       char *backup, char *dev, int verbouse)
+{
+	int ret_val = 1;
+	struct mdinfo *sra = NULL;
+	int fd = -1;
+	char buf[PATH_MAX];
+
+	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
+	fd = open(buf , O_RDONLY | O_DIRECT);
+	if (fd < 0) {
+		dprintf("imsm: cannot open device: %s\n", buf);
+		goto imsm_reshape_super_exit;
+	}
+
+	if ((size == -1) && (layout == UnSet) && (raid_disks == 0) && (level != UnSet)) {
+		/* ok - this is takeover */
+		int container_fd;
+		int dn;
+		int err;
+
+		sra = sysfs_read(fd, 0,  GET_VERSION | GET_LEVEL |
+				 GET_LAYOUT | GET_DISKS | GET_DEVS);
+		if (sra == NULL) {
+			fprintf(stderr, Name ": Cannot read sysfs info (imsm)\n");
+			goto imsm_reshape_super_exit;
+		}
+		dn = devname2devnum(sra->text_version + 1);
+		container_fd = open_dev_excl(dn);
+		if (container_fd < 0) {
+			fprintf(stderr, Name ": Cannot get exclusive access "
+				"to container (imsm).\n");
+			goto imsm_reshape_super_exit;
+		}
+		st->ss->load_super(st, container_fd, NULL);
+		close(container_fd);
+		st->ss->getinfo_super(st, sra);
+
+		/* send metadata update for raid10 takeover
+		 * this means we are going from/to raid10
+		 * to/from different than raid10 level
+		 * if source level is raid0 mdmon is sterted only
+		 */
+		if (((level == 10) || (sra->array.level == 10) || (sra->array.level == 0)) &&
+		     (level != sra->array.level) &&
+		     (level > 0)) {
+			st->update_tail = &st->updates;
+			err = update_level_imsm(st, sra, sra->name, 0, 0, NULL);
+			ret_val = 0;
+		}
+		sysfs_free(sra);
+		sra = NULL;
+	}
+
+imsm_reshape_super_exit:
+	sysfs_free(sra);
+	if (fd >= 0)
+		close(fd);
+
+	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
+	return ret_val;
+}
+
 struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_imsm,
@@ -5592,6 +5866,7 @@ struct superswitch super_imsm = {
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,
 	.default_geometry = default_geometry_imsm,
+	.reshape_super  = imsm_reshape_super,
 
 	.external	= 1,
 	.name = "imsm",

