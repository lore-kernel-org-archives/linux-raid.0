From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 35/35] Fix problem in mdmon monitor of using removed disk
 from in imsm container.
Date: Mon, 16 Aug 2010 11:05:00 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA27@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 8fe12778b2d8d8f30d9d8914cb71e0d296557cda Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Fri, 2 Jul 2010 17:35:57 +0200
Subject: [PATCH 35/35] Fix problem in mdmon monitor of using removed disk from in imsm container.

Manager thread shall pass the information to monitor thread (mdmon)
that some devices are removed from container. Otherwise, monitor (mdmon)
migth use such devices (spares) to rebuild the array that has gone degraded.

This problem happens for imsm containers, since a list of the container disks
is maintained in intel_super structure. When array goes degraded, the list is
searched to find eligable spare disks to start rebuild.
Without this fix the rebuild could be stared on the spare device that was
a member of the contaiter, but has been removed from it.

New super type function handler has been introduced to prepare metadata
format specific information about removed devices.
int (*remove_from_super)(struct supertype *st, mdu_disk_info_t *dinfo,
                         int fd);
The message prepared in remove_from_super is later procecessed
by proceess_update handler in monitor thread.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 managemon.c   |   38 ++++++++++++++++
 mdadm.h       |    7 +++-
 super-intel.c |  138 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 156 insertions(+), 27 deletions(-)

diff --git a/managemon.c b/managemon.c
index 454c39d..d1de78e 100644
--- a/managemon.c
+++ b/managemon.c
@@ -297,6 +297,43 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
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
+	dprintf("%s: remove %d:%d to container\n",
+		__func__, sd->disk.major, sd->disk.minor);
+
+	sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+	dfd = dev_open(nm, O_RDWR);
+	if (dfd < 0)
+		return;
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
@@ -334,6 +371,7 @@ static void manage_container(struct mdstat_ent *mdstat,
 			if (!found) {
 				cd = *cdp;
 				*cdp = (*cdp)->next;
+				remove_disk_from_container(container, cd);
 				free(cd);
 			} else
 				cdp = &(*cdp)->next;
diff --git a/mdadm.h b/mdadm.h
index 468f9c1..7d3a67c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -653,7 +653,12 @@ extern struct superswitch {
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
index a31ed57..051578c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -233,6 +233,10 @@ struct intel_dev {
 	int index;
 };
 
+enum action {
+  DISK_REMOVE=0,
+  DISK_ADD
+};
 /* internal representation of IMSM metadata */
 struct intel_super {
 	union {
@@ -258,8 +262,9 @@ struct intel_super {
 		int extent_cnt;
 		struct extent *e; /* for determining freespace @ create */
 		int raiddisk; /* slot to fill in autolayout */
+		enum action action;
 	} *disks;
-	struct dl *add; /* list of disks to add while mdmon active */
+	struct dl *disk_mgmt_list; /* list of disks to add/remove while mdmon active */
 	struct dl *missing; /* disks removed while we weren't looking */
 	struct bbm_log *bbm_log;
 	const char *hba; /* device path of the raid controller for this metadata */
@@ -282,7 +287,7 @@ struct extent {
 enum imsm_update_type {
 	update_activate_spare,
 	update_create_array,
-	update_add_disk,
+	update_add_remove_disk,
 };
 
 struct imsm_update_activate_spare {
@@ -303,7 +308,7 @@ struct imsm_update_create_array {
 	struct imsm_dev dev;
 };
 
-struct imsm_update_add_disk {
+struct imsm_update_add_remove_disk {
 	enum imsm_update_type type;
 };
 
@@ -2311,6 +2316,7 @@ static void __free_imsm_disk(struct dl *d)
 	free(d);
 
 }
+
 static void free_imsm_disks(struct intel_super *super)
 {
 	struct dl *d;
@@ -3286,6 +3292,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	dd->devname = devname ? strdup(devname) : NULL;
 	dd->fd = fd;
 	dd->e = NULL;
+	dd->action = DISK_ADD;
 	rv = imsm_read_serial(fd, devname, dd->serial);
 	if (rv) {
 		fprintf(stderr,
@@ -3305,8 +3312,8 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		dd->disk.scsi_id = __cpu_to_le32(0);
 
 	if (st->update_tail) {
-		dd->next = super->add;
-		super->add = dd;
+		dd->next = super->disk_mgmt_list;
+		super->disk_mgmt_list = dd;
 	} else {
 		dd->next = super->disks;
 		super->disks = dd;
@@ -3315,6 +3322,44 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
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
+			Name ": %s shall be used in mdmon context only (line %d).\n", __func__, __LINE__);
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
@@ -3467,13 +3512,13 @@ static int create_array(struct supertype *st, int dev_idx)
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
@@ -3484,7 +3529,7 @@ static int _add_disk(struct supertype *st)
 		return 1;
 	}
 
-	u->type = update_add_disk;
+	u->type = update_add_remove_disk;
 	append_metadata_update(st, u, len);
 
 	return 0;
@@ -3506,10 +3551,10 @@ static int write_init_super_imsm(struct supertype *st)
 
 		/* determine if we are creating a volume or adding a disk */
 		if (current_vol < 0) {
-			/* in the add disk case we are running in mdmon
+			/* in the mgmt (add/remove) disk case we are running in mdmon
 			 * context, so don't close fd's
 			 */
-			return _add_disk(st);
+			return mgmt_disk(st);
 		} else
 			rv = create_array(st, current_vol);
 
@@ -4602,10 +4647,9 @@ static int store_imsm_mpb(int fd, struct imsm_super *mpb)
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
@@ -4894,6 +4938,31 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_
 	return 0;
 }
 
+static int remove_disk_super(struct intel_super *super,  int major, int minor)
+{
+	struct dl *prev = NULL;
+	struct dl *dl;
+
+	prev = NULL;
+	for (dl = super->disks; dl; dl = dl->next) {
+		if ((dl->major == major) &&
+		    (dl->minor == minor)) {
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
 static void imsm_delete(struct intel_super *super, struct dl **dlp, int index);
 
 static void imsm_process_update(struct supertype *st,
@@ -5141,31 +5210,47 @@ static void imsm_process_update(struct supertype *st,
 		}
 		break;
 	}
-	case update_add_disk:
+	case update_add_remove_disk: {
 
 		/* we may be able to repair some arrays if disks are
 		 * being added */
-		if (super->add) {
+
+		/* add/remove some spares to/from the metadata/contrainer */
+		int check_degraded = 0;
+		while (super->disk_mgmt_list) {
+			struct dl *disk_cfg;
+
+			disk_cfg = super->disk_mgmt_list;
+			super->disk_mgmt_list = disk_cfg->next;
+			disk_cfg->next = NULL;
+
+			if (disk_cfg->action == DISK_ADD) {
+				disk_cfg->next = super->disks;
+				super->disks = disk_cfg;
+				check_degraded = 1;
+				dprintf("%s: added %x:%x\n",
+					__func__, disk_cfg->major, disk_cfg->minor);
+			} else if (disk_cfg->action == DISK_REMOVE) {
+				dprintf("Disk remove action processed: %x.%x\n",
+					disk_cfg->major, disk_cfg->minor);
+				remove_disk_super(super,  disk_cfg->major, disk_cfg->minor);
+				__free_imsm_disk(disk_cfg);
+			}
+		}
+		if (check_degraded) {
 			struct active_array *a;
 
 			super->updates_pending++;
  			for (a = st->arrays; a; a = a->next)
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
 
 		break;
 	}
+	default:
+		fprintf(stderr, "error: unsuported process update type: (type: %d)\n",
+			type);
+	}
 }
 
 static void imsm_prepare_update(struct supertype *st,
@@ -5366,6 +5451,7 @@ struct superswitch super_imsm = {
 	.write_init_super = write_init_super_imsm,
 	.validate_geometry = validate_geometry_imsm,
 	.add_to_super	= add_to_super_imsm,
+	.remove_from_super	= remove_from_super_imsm,
 	.detail_platform = detail_platform_imsm,
 #endif
 	.match_home	= match_home_imsm,
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

