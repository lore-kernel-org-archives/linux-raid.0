From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 1/2] IMSM: Fix problem in mdmon monitor of using removed
 disk from in imsm container.
Date: Tue, 7 Dec 2010 16:07:35 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17676E3B8@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 4bd19fb7b8a4258bf6cf34288be635bdb9af3dbe Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Wed, 30 Nov 2010 03:55:18 +0100
Subject: [PATCH 1/2] IMSM: Fix problem in mdmon monitor of using removed disk from in imsm container.

Manager thread shall pass the information to monitor thread (mdmon)
that some devices are removed from container. Otherwise, monitor (mdmon)
might use such devices (spares) to rebuild the array that has gone degraded.

This problem happens for imsm containers, since a list of the container disks
is maintained in intel_super structure. When array goes degraded, the list is
searched to find a spare disks to start rebuild.
Without this fix the rebuild could be stared on the spare device that was
a member of the container, but has been removed from it.

New super type function handler has been introduced to prepare metadata
format specific information about removed devices.
int (*remove_from_super)(struct supertype *st, mdu_disk_info_t *dinfo,
                         int fd);
The message prepared in remove_from_super is later processed
by proceess_update handler in monitor thread.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 managemon.c   |   37 ++++++++++++
 mdadm.h       |    7 ++-
 super-intel.c |  183 +++++++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 196 insertions(+), 31 deletions(-)

diff --git a/managemon.c b/managemon.c
index bab0397..61037d1 100644
--- a/managemon.c
+++ b/managemon.c
@@ -297,6 +297,42 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
 	st->update_tail = NULL;
 }
 
+/*
+ * Create and queue update structure about the removed disks.
+ * The update is prepared by super type handler and passed to the monitor
+ * thread.
+ */
+static void remove_disk_from_container(struct supertype *st, struct mdinfo *sd)
+{
+	int dfd;
+	char nm[20];
+	struct metadata_update *update = NULL;
+	mdu_disk_info_t dk = {
+		.number = -1,
+		.major = sd->disk.major,
+		.minor = sd->disk.minor,
+		.raid_disk = -1,
+		.state = 0,
+	};
+	/* nothing to do if super type handler does not support
+	 * remove disk primitive
+	 */
+	if (!st->ss->remove_from_super)
+		return;
+	dprintf("%s: remove %d:%d from container\n",
+		__func__, sd->disk.major, sd->disk.minor);
+
+	sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+	/* accept that dev might be gone */
+	dfd = dev_open(nm, O_RDWR);
+
+	st->update_tail = &update;
+	st->ss->remove_from_super(st, &dk, dfd);
+	st->ss->write_init_super(st);
+	queue_metadata_update(update);
+	st->update_tail = NULL;
+}
+
 static void manage_container(struct mdstat_ent *mdstat,
 			     struct supertype *container)
 {
@@ -334,6 +370,7 @@ static void manage_container(struct mdstat_ent *mdstat,
 			if (!found) {
 				cd = *cdp;
 				*cdp = (*cdp)->next;
+				remove_disk_from_container(container, cd);
 				free(cd);
 			} else
 				cdp = &(*cdp)->next;
diff --git a/mdadm.h b/mdadm.h
index b2d39c1..b188f79 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -597,7 +597,12 @@ extern struct superswitch {
 	 * when hot-adding a spare.
 	 */
 	int (*add_to_super)(struct supertype *st, mdu_disk_info_t *dinfo,
-			     int fd, char *devname);
+			    int fd, char *devname);
+	/* update the metadata to delete a device,
+	 * when hot-removing a spare.
+	 */
+	int (*remove_from_super)(struct supertype *st, mdu_disk_info_t *dinfo,
+				 int fd);
 
 	/* Write metadata to one device when fixing problems or adding
 	 * a new device.
diff --git a/super-intel.c b/super-intel.c
index 8ef6164..1cee6c1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -233,6 +233,10 @@ struct intel_dev {
 	unsigned index;
 };
 
+enum action {
+  DISK_REMOVE = 1,
+  DISK_ADD
+};
 /* internal representation of IMSM metadata */
 struct intel_super {
 	union {
@@ -258,8 +262,10 @@ struct intel_super {
 		int extent_cnt;
 		struct extent *e; /* for determining freespace @ create */
 		int raiddisk; /* slot to fill in autolayout */
+		enum action action;
 	} *disks;
-	struct dl *add; /* list of disks to add while mdmon active */
+	struct dl *disk_mgmt_list; /* list of disks to add/remove while mdmon
+				      active */
 	struct dl *missing; /* disks removed while we weren't looking */
 	struct bbm_log *bbm_log;
 	const char *hba; /* device path of the raid controller for this metadata */
@@ -285,6 +291,7 @@ enum imsm_update_type {
 	update_kill_array,
 	update_rename_array,
 	update_add_disk,
+	update_add_remove_disk
 };
 
 struct imsm_update_activate_spare {
@@ -316,7 +323,7 @@ struct imsm_update_rename_array {
 	int dev_idx;
 };
 
-struct imsm_update_add_disk {
+struct imsm_update_add_remove_disk {
 	enum imsm_update_type type;
 };
 
@@ -2404,6 +2411,7 @@ static void __free_imsm_disk(struct dl *d)
 	free(d);
 
 }
+
 static void free_imsm_disks(struct intel_super *super)
 {
 	struct dl *d;
@@ -3408,6 +3416,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	dd->devname = devname ? strdup(devname) : NULL;
 	dd->fd = fd;
 	dd->e = NULL;
+	dd->action = DISK_ADD;
 	rv = imsm_read_serial(fd, devname, dd->serial);
 	if (rv) {
 		fprintf(stderr,
@@ -3427,8 +3436,8 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		dd->disk.scsi_id = __cpu_to_le32(0);
 
 	if (st->update_tail) {
-		dd->next = super->add;
-		super->add = dd;
+		dd->next = super->disk_mgmt_list;
+		super->disk_mgmt_list = dd;
 	} else {
 		dd->next = super->disks;
 		super->disks = dd;
@@ -3437,6 +3446,45 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	return 0;
 }
 
+
+static int remove_from_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
+				  int fd)
+{
+	struct intel_super *super = st->sb;
+	struct dl *dd;
+
+	/* remove from super works only in mdmon - for communication
+	 * manager - monitor. Check if communication memory buffer
+	 * is prepared.
+	 */
+	if (!st->update_tail) {
+		fprintf(stderr,
+			Name ": %s shall be used in mdmon context only"
+			"(line %d).\n", __func__, __LINE__);
+		return 1;
+	}
+	dd = malloc(sizeof(*dd));
+	if (!dd) {
+		fprintf(stderr,
+			Name ": malloc failed %s:%d.\n", __func__, __LINE__);
+		return 1;
+	}
+	memset(dd, 0, sizeof(*dd));
+	dd->major = dk->major;
+	dd->minor = dk->minor;
+	dd->index = -1;
+	dd->fd = fd;
+	dd->disk.status = SPARE_DISK;
+	dd->action = DISK_REMOVE;
+
+	if (st->update_tail) {
+		dd->next = super->disk_mgmt_list;
+		super->disk_mgmt_list = dd;
+	}
+
+	return 0;
+}
+
 static int store_imsm_mpb(int fd, struct imsm_super *mpb);
 
 static union {
@@ -3589,13 +3637,13 @@ static int create_array(struct supertype *st, int dev_idx)
 	return 0;
 }
 
-static int _add_disk(struct supertype *st)
+static int mgmt_disk(struct supertype *st)
 {
 	struct intel_super *super = st->sb;
 	size_t len;
-	struct imsm_update_add_disk *u;
+	struct imsm_update_add_remove_disk *u;
 
-	if (!super->add)
+	if (!super->disk_mgmt_list)
 		return 0;
 
 	len = sizeof(*u);
@@ -3606,7 +3654,7 @@ static int _add_disk(struct supertype *st)
 		return 1;
 	}
 
-	u->type = update_add_disk;
+	u->type = update_add_remove_disk;
 	append_metadata_update(st, u, len);
 
 	return 0;
@@ -3628,10 +3676,10 @@ static int write_init_super_imsm(struct supertype *st)
 
 		/* determine if we are creating a volume or adding a disk */
 		if (current_vol < 0) {
-			/* in the add disk case we are running in mdmon
-			 * context, so don't close fd's
+			/* in the mgmt (add/remove) disk case we are running
+			 * in mdmon context, so don't close fd's
 			 */
-			return _add_disk(st);
+			return mgmt_disk(st);
 		} else
 			rv = create_array(st, current_vol);
 
@@ -4871,10 +4919,9 @@ static int store_imsm_mpb(int fd, struct imsm_super *mpb)
 static void imsm_sync_metadata(struct supertype *container)
 {
 	struct intel_super *super = container->sb;
-
+	dprintf("sync metadata: %d\n", super->updates_pending);
 	if (!super->updates_pending)
 		return;
-
 	write_super_imsm(super, 0);
 
 	super->updates_pending = 0;
@@ -5163,8 +5210,90 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_
 	return 0;
 }
 
+
+static struct dl *get_disk_super(struct intel_super *super, int major, int minor)
+{
+	struct dl *dl = NULL;
+	for (dl = super->disks; dl; dl = dl->next)
+		if ((dl->major == major) &&  (dl->minor == minor))
+			return dl;
+	return NULL;
+}
+
+static int remove_disk_super(struct intel_super *super, int major, int minor)
+{
+	struct dl *prev = NULL;
+	struct dl *dl;
+
+	prev = NULL;
+	for (dl = super->disks; dl; dl = dl->next) {
+		if ((dl->major == major) && (dl->minor == minor)) {
+			/* remove */
+			if (prev)
+				prev->next = dl->next;
+			else
+				super->disks = dl->next;
+			dl->next = NULL;
+			__free_imsm_disk(dl);
+			dprintf("%s: removed %x:%x\n",
+				__func__, major, minor);
+			break;
+		}
+		prev = dl;
+	}
+	return 0;
+}
+
 static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned index);
 
+static int add_remove_disk_update(struct intel_super *super)
+{
+	int check_degraded = 0;
+	struct dl *disk = NULL;
+	/* add/remove some spares to/from the metadata/contrainer */
+	while (super->disk_mgmt_list) {
+		struct dl *disk_cfg;
+
+		disk_cfg = super->disk_mgmt_list;
+		super->disk_mgmt_list = disk_cfg->next;
+		disk_cfg->next = NULL;
+
+		if (disk_cfg->action == DISK_ADD) {
+			disk_cfg->next = super->disks;
+			super->disks = disk_cfg;
+			check_degraded = 1;
+			dprintf("%s: added %x:%x\n",
+				__func__, disk_cfg->major,
+				disk_cfg->minor);
+		} else if (disk_cfg->action == DISK_REMOVE) {
+			dprintf("Disk remove action processed: %x.%x\n",
+				disk_cfg->major, disk_cfg->minor);
+			disk = get_disk_super(super,
+					      disk_cfg->major,
+					      disk_cfg->minor);
+			if (disk) {
+				/* store action status */
+				disk->action = DISK_REMOVE;
+				/* remove spare disks only */
+				if (disk->index == -1) {
+					remove_disk_super(super,  
+							  disk_cfg->major,
+							  disk_cfg->minor);
+				}
+			}
+			/* remove spare disks only */
+			if (disk->index == -1) {
+				remove_disk_super(super,  
+						  disk_cfg->major,
+						  disk_cfg->minor);
+			}
+			/* release allocate disk structure */
+			__free_imsm_disk(disk_cfg);
+		}
+	}
+	return check_degraded;
+}
+
 static void imsm_process_update(struct supertype *st,
 			        struct metadata_update *update)
 {
@@ -5474,31 +5603,24 @@ static void imsm_process_update(struct supertype *st,
 		super->updates_pending++;
 		break;
 	}
-	case update_add_disk:
-
+	case update_add_remove_disk: {
 		/* we may be able to repair some arrays if disks are
-		 * being added */
-		if (super->add) {
+		 * being added, check teh status of add_remove_disk
+		 * if discs has been added.
+		 */
+		if (add_remove_disk_update(super)) {
 			struct active_array *a;
 
 			super->updates_pending++;
- 			for (a = st->arrays; a; a = a->next)
+			for (a = st->arrays; a; a = a->next)
 				a->check_degraded = 1;
 		}
-		/* add some spares to the metadata */
-		while (super->add) {
-			struct dl *al;
-
-			al = super->add;
-			super->add = al->next;
-			al->next = super->disks;
-			super->disks = al;
-			dprintf("%s: added %x:%x\n",
-				__func__, al->major, al->minor);
-		}
-
 		break;
 	}
+	default:
+		fprintf(stderr, "error: unsuported process update type:"
+			"(type: %d)\n",	type);
+	}
 }
 
 static void imsm_prepare_update(struct supertype *st,
@@ -5684,6 +5806,7 @@ struct superswitch super_imsm = {
 	.validate_geometry = validate_geometry_imsm,
 	.default_chunk	= default_chunk_imsm,
 	.add_to_super	= add_to_super_imsm,
+	.remove_from_super	= remove_from_super_imsm,
 	.detail_platform = detail_platform_imsm,
 	.kill_subarray = kill_subarray_imsm,
 	.update_subarray = update_subarray_imsm,
-- 
1.6.4.2
