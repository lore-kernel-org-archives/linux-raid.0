From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 1/2] mdadm: Add takeover support for external meta
Date: Fri, 30 Apr 2010 14:47:49 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801B61C4B2@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids


When performing takeover 0->10 or 10->0 mdmon should update the
external metadata (due to disk slot changes).
To achieve that mdadm, after changing the level in md,
sends update_level to mdmon.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 Grow.c        |   38 ++++++++++++++++-
 managemon.c   |   14 ++++++-
 mdadm.h       |    1 +
 mdstat.c      |   24 ++++++++++
 monitor.c     |    2 +-
 super-intel.c |  133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 207 insertions(+), 5 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6264996..17974fa 100644
--- a/Grow.c
+++ b/Grow.c
@@ -540,7 +540,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			"       Please use a newer kernel\n");
 		return 1;
 	}
-	sra = sysfs_read(fd, 0, GET_LEVEL);
+	sra = sysfs_read(fd, 0, GET_VERSION | GET_LEVEL);
 	frozen = freeze_array(sra);
 	if (frozen < 0) {
 		fprintf(stderr, Name ": %s is performing resync/recovery and cannot"
@@ -690,6 +690,42 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				fprintf(stderr, Name " level of %s changed to %s\n",
 					devname, c);
 			changed = 1;
+
+			st = super_by_fd(fd);
+			if (st->ss->external) {
+				int dn = devname2devnum(sra->text_version + 1);
+				/* if raid0 was takeovered by any other
+				   personality start mdmon */
+				if ((level > 0) && (orig.level == 0)) {
+					if (!mdmon_running(dn))
+						start_mdmon(dn);
+					ping_monitor(devnum2devname(dn));
+				}
+				/* inform mdmon about raid level change
+				 * only for 0->10 and 10->0 transitions */
+				if ((level == 10) || (orig.level == 10)) {
+					struct mdinfo *new_info;
+					struct mdinfo curr_info;
+
+					new_info = sysfs_read(fd, 0, GET_LEVEL | GET_LAYOUT
+							      | GET_DISKS | GET_DEVS);
+					int container_fd = open_dev_excl(dn);
+					if (container_fd < 0) {
+						fprintf(stderr, Name ": Cannot get exclusive access "
+							"to container.\n");
+						rv = 1;
+						goto release;
+					}
+					st->ss->load_super(st, container_fd, NULL);
+					close(container_fd);
+
+					st->ss->getinfo_super(st, &curr_info);
+					st->update_tail = &st->updates;
+					st->ss->update_super(st, new_info, "update_level",
+							     curr_info.name, 0, 0, NULL);
+					flush_metadata_updates(st);
+				}
+			}
 		}
 	}
 
diff --git a/managemon.c b/managemon.c
index 037406f..e4eab1a 100644
--- a/managemon.c
+++ b/managemon.c
@@ -364,6 +364,7 @@ static void manage_container(struct mdstat_ent *mdstat,
 static void manage_member(struct mdstat_ent *mdstat,
 			  struct active_array *a)
 {
+	int level;
 	/* Compare mdstat info with known state of member array.
 	 * We do not need to look for device state changes here, that
 	 * is dealt with by the monitor.
@@ -382,6 +383,16 @@ static void manage_member(struct mdstat_ent *mdstat,
 	a->info.array.chunk_size = mdstat->chunk_size;
 	// MORE
 
+	level = mdstat_to_level(mdstat);
+	if (a->info.array.level != level) {
+		struct active_array *newa;
+		newa = duplicate_aa(a);
+		if (!newa)
+			goto out;
+		newa->info.array.level = level;
+		replace_array(a->container, a, newa);
+	}
+
 	if (a->check_degraded) {
 		struct metadata_update *updates = NULL;
 		struct mdinfo *newdev = NULL;
@@ -597,6 +608,8 @@ void manage(struct mdstat_ent *mdstat, struct supertype *container)
 	}
 }
 
+
+
 static void handle_message(struct supertype *container, struct metadata_update *msg)
 {
 	/* queue this metadata update through to the monitor */
@@ -623,7 +636,6 @@ static void handle_message(struct supertype *container, struct metadata_update *
 			usleep(10 * 1000);
 	} else if (msg->len == -1) { /* ping_manager */
 		struct mdstat_ent *mdstat = mdstat_read(1, 0);
-
 		manage(mdstat, container);
 		free_mdstat(mdstat);
 	} else if (!sigterm) {
diff --git a/mdadm.h b/mdadm.h
index 362b66b..68c15ab 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -358,6 +358,7 @@ extern void free_mdstat(struct mdstat_ent *ms);
 extern void mdstat_wait(int seconds);
 extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);
 extern int mddev_busy(int devnum);
+int mdstat_to_level(struct mdstat_ent *ms);
 
 struct map_ent {
 	struct map_ent *next;
diff --git a/mdstat.c b/mdstat.c
index 4a9f370..af1cae4 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -251,6 +251,30 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 	return rv;
 }
 
+int mdstat_to_level(struct mdstat_ent *ms)
+{
+	if (strncmp(ms->level, "raid0", 5) == 0)
+		return 0;
+	else if (strncmp(ms->level, "raid10", 6) == 0)
+		return 10;
+	else if (strncmp(ms->level, "raid1", 5) == 0)
+		return 1;
+	else if (strncmp(ms->level, "raid4", 5) == 0)
+		return 4;
+	else if (strncmp(ms->level, "raid5", 5) == 0)
+		return 5;
+	else if (strncmp(ms->level, "raid6", 5) == 0)
+		return 6;
+	else if (strncmp(ms->level, "linear", 6) == 0)
+		return LEVEL_LINEAR;
+	else if (strncmp(ms->level, "faulty", 6) == 0)
+		return LEVEL_FAULTY;
+	else if (strncmp(ms->level, "multipath", 9) == 0)
+		return LEVEL_MULTIPATH;
+
+	return LEVEL_UNSUPPORTED;
+}
+
 void mdstat_wait(int seconds)
 {
 	fd_set fds;
diff --git a/monitor.c b/monitor.c
index e43e545..4bf1a41 100644
--- a/monitor.c
+++ b/monitor.c
@@ -447,7 +447,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 		/* once an array has been deactivated we want to
 		 * ask the manager to discard it.
 		 */
-		if (!a->container) {
+		if ((!a->container) || (a->info.array.level == 0)) {
 			if (discard_this) {
 				ap = &(*ap)->next;
 				continue;
diff --git a/super-intel.c b/super-intel.c
index a196ca3..751baaf 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -283,6 +283,7 @@ enum imsm_update_type {
 	update_activate_spare,
 	update_create_array,
 	update_add_disk,
+	update_level,
 };
 
 struct imsm_update_activate_spare {
@@ -307,6 +308,12 @@ struct imsm_update_add_disk {
 	enum imsm_update_type type;
 };
 
+struct imsm_update_level {
+	enum imsm_update_type type;
+	int delta_disks;
+	struct imsm_dev dev;
+};
+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
 	struct supertype *st;
@@ -1588,6 +1595,8 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 	}
 }
 
+static void imsm_copy_dev(struct imsm_dev *dest, struct imsm_dev *src);
+
 static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 			     char *update, char *devname, int verbose,
 			     int uuid_set, char *homehost)
@@ -1620,12 +1629,76 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 	struct intel_super *super = st->sb;
 	struct imsm_super *mpb;
 
-	/* we can only update container info */
-	if (!super || super->current_vol >= 0 || !super->anchor)
+	if (!super || !super->anchor)
 		return 1;
 
 	mpb = super->anchor;
 
+	if (strcmp(update, "update_level") == 0) {
+		struct imsm_update_level *u;
+		struct imsm_dev *dev_new, *dev;
+		struct imsm_map *map_new, *map;
+		struct mdinfo *newdi;
+		struct dl *dl;
+		int *tmp_ord_tbl;
+		int i, slot, idx;
+		int len, disks;
+
+		for (i = 0; i < mpb->num_raid_devs; i++) {
+			dev = get_imsm_dev(super, i);
+			if (strcmp(devname, (char *)dev->volume) == 0)
+				break;
+		}
+		if (i == super->anchor->num_raid_devs)
+			return 1;
+
+		disks = (info->array.raid_disks > map->num_members) ?
+			info->array.raid_disks : map->num_members;
+		len = sizeof(struct imsm_update_level) +
+			((disks - 1) * sizeof(__u32));
+
+		u = malloc(len);
+		dev_new = &u->dev;
+		imsm_copy_dev(dev_new, dev);
+		map = get_imsm_map(dev, 0);
+		map_new = get_imsm_map(dev_new, 0);
+
+		tmp_ord_tbl = malloc(sizeof(int) * disks);
+		for (i = 0; i < disks; i++)
+			tmp_ord_tbl[i] = -1;
+
+		/* iterate through devices to detect slot changes */
+		for (dl = super->disks; dl; dl = dl->next) {
+			for (newdi = info->devs; newdi; newdi = newdi->next) {
+
+				if ((dl->major != newdi->disk.major) ||
+				    (dl->minor != newdi->disk.minor))
+					continue;
+				slot = get_imsm_disk_slot(map, dl->index);
+				idx = get_imsm_ord_tbl_ent(dev_new, slot);
+				tmp_ord_tbl[newdi->disk.raid_disk] = idx;
+				break;
+			}
+		}
+
+		for (i = 0; i < disks; i++)
+			set_imsm_ord_tbl_ent(map_new, i, tmp_ord_tbl[i]);
+		free(tmp_ord_tbl);
+
+		map_new->raid_level = info->array.level;
+		map_new->num_members = info->array.raid_disks;
+
+		u->type = update_level;
+		u->delta_disks = info->array.raid_disks - map->num_members;
+		append_metadata_update(st, u, len);
+		rv = 0;
+		goto completed;
+	}
+
+	/* we can only update container info */
+	if (super->current_vol >= 0)
+		return 1;
+
 	if (strcmp(update, "uuid") == 0 && uuid_set && !info->update_private)
 		fprintf(stderr,
 			Name ": '--uuid' not supported for imsm metadata\n");
@@ -1653,6 +1726,7 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 			Name ": '--update=%s' not supported for imsm metadata\n",
 			update);
 
+ completed:
 	/* successful update? recompute checksum */
 	if (rv == 0)
 		mpb->check_sum = __le32_to_cpu(__gen_imsm_checksum(mpb));
@@ -4843,6 +4917,54 @@ static void imsm_process_update(struct supertype *st,
 	mpb = super->anchor;
 
 	switch (type) {
+	case update_level: {
+		struct imsm_update_level *u = (void *) update->buf;
+		struct imsm_dev *dev_new, *dev;
+		struct imsm_map *map;
+		struct dl *d;
+		int i;
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
+		imsm_copy_dev(dev, dev_new);
+		map = get_imsm_map(dev, 0);
+		mpb->num_disks += u->delta_disks;
+
+		/* Reload missing disks list */
+		while (super->missing) {
+			d = super->missing;
+			super->missing = d->next;
+			__free_imsm_disk(d);
+		}
+		find_missing(super);
+
+		/* set new disk entries if number of disks increased */
+		d = super->missing;
+		for (i = 0; i < map->num_members; i++) {
+			if (map->disk_ord_tbl[i] != -1)
+				continue;
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
@@ -5098,6 +5220,13 @@ static void imsm_prepare_update(struct supertype *st,
 	size_t len = 0;
 
 	switch (type) {
+	case update_level: {
+		struct imsm_update_level *u = (void *) update->buf;
+		dprintf("prepare_update(): update level\n");
+		len += u->delta_disks * sizeof(struct imsm_disk) +
+			u->delta_disks * sizeof(__u32);
+		break;
+	}
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
-- 
1.7.0.2

