From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 24/27] Add takeover support for external meta
Date: Mon, 06 Dec 2010 14:23:54 +0100
Message-ID: <20101206132354.21125.90742.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This patch introduces 0->10 and 10->0 takeover operations for external
metadata. It defines all neccessary functions, interfaces and structures.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 Grow.c        |   55 +++++++++++++++++++++++++++-------
 super-intel.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 133 insertions(+), 13 deletions(-)

diff --git a/Grow.c b/Grow.c
index 465309c..cf37288 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1012,7 +1012,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	 *
 	 */
 	struct mdu_array_info_s array, orig;
-	char *c;
+	char *c = NULL;
 	int rv = 0;
 	struct supertype *st;
 	char *subarray = NULL;
@@ -1305,17 +1305,47 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				rv = 1;/* not possible */
 				goto release;
 			}
-			err = sysfs_set_str(sra, NULL, "level", c);
-			if (err) {
-				err = errno;
-				fprintf(stderr, Name ": %s: could not set level to %s\n",
-					devname, c);
-				if (err == EBUSY && 
-				    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
-					fprintf(stderr, "       Bitmap must be removed before level can be changed\n");
+			if (level > 0) {
+				err = sysfs_set_str(sra, NULL, "level", c);
+				if (err) {
+					err = errno;
+					fprintf(stderr, Name ": %s: could not set level to %s\n",
+						devname, c);
+					if (err == EBUSY &&
+					    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
+						fprintf(stderr, "       Bitmap must be removed before level can be changed\n");
+					rv = 1;
+					goto release;
+				}
+			}
+
+			if (st && reshape_super(st, -1, level, UnSet, 0, 0, NULL, devname, !quiet)) {
 				rv = 1;
 				goto release;
 			}
+			/* before sending update make sure that for external metadata
+			 * and after changing raid level mdmon is running
+			 */
+			if (st->ss->external && !mdmon_running(st->container_dev) &&
+			    level > 0) {
+				start_mdmon(st->container_dev);
+				if (container)
+					ping_monitor(container);
+			}
+			sync_metadata(st);
+			if (level == 0) {
+				err = sysfs_set_str(sra, NULL, "level", c);
+				if (err) {
+					err = errno;
+					fprintf(stderr, Name ": %s: could not set level to %s\n",
+						devname, c);
+					if (err == EBUSY &&
+					    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
+						fprintf(stderr, "       Bitmap must be removed before level can be changed\n");
+					rv = 1;
+				}
+				goto release;
+			}
 			orig = array;
 			orig_level = orig.level;
 			ioctl(fd, GET_ARRAY_INFO, &array);
@@ -1327,6 +1357,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				fprintf(stderr, Name " level of %s changed to %s\n",
 					devname, c);
 			changed = 1;
+
 		}
 	}
 
@@ -1381,8 +1412,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			/* Looks like this level change doesn't need
 			 * a reshape after all.
 			 */
-			c = map_num(pers, level);
-			if (c) {
+			if ((c) && (level == 0)) {
 				rv = sysfs_set_str(sra, NULL, "level", c);
 				if (rv) {
 					int err = errno;
@@ -1401,7 +1431,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		if (st->ss->external && !mdmon_running(st->container_dev) &&
 		    level > 0) {
 			start_mdmon(st->container_dev);
-			ping_monitor(container);
+			if (container)
+				ping_monitor(container);
 		}
 		goto release;
 	}
diff --git a/super-intel.c b/super-intel.c
index 5779129..27196d7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -289,6 +289,7 @@ enum imsm_update_type {
 	update_reshape,
 	update_reshape_set_slots,
 	update_reshape_cancel,
+	update_level,
 };
 
 struct imsm_update_activate_spare {
@@ -365,6 +366,30 @@ struct imsm_update_add_disk {
 	enum imsm_update_type type;
 };
 
+struct imsm_disk_changes {
+	int major;
+	int minor;
+	int index;
+};
+
+struct imsm_update_level {
+	enum imsm_update_type type;
+	struct dl *disk_list;
+	int delta_disks;
+	int container_member;
+	int disk_qan;
+	int changes_offset;
+	int rm_qan;
+	int add_qan;
+	struct imsm_dev dev;
+	/* here goes the table with disk changes
+	 */
+	/* and here goes imsm_disk_changes pointed by changes_offset
+	 * disk_changes are put here as row data every sizeof(struct imsm_disk_changes)
+	 *
+	 */
+};
+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
 	struct supertype *st;
@@ -5575,6 +5600,9 @@ update_reshape_exit:
 		super->updates_pending++;
 		break;
 	}
+	case update_level: {
+		break;
+	}
 	case update_activate_spare: {
 		struct imsm_update_activate_spare *u = (void *) update->buf; 
 		struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -5955,6 +5983,9 @@ static void imsm_prepare_update(struct supertype *st,
 		u->update_prepared = -1;
 		break;
 	}
+	case update_level: {
+		break;
+	}
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
@@ -6108,6 +6139,13 @@ static const char *imsm_get_disk_controller_domain(const char *path)
 		return NULL;
 }
 
+static int update_level_imsm(struct supertype *st, struct mdinfo *info,
+			     struct geo_params *geo, int verbose,
+			     int uuid_set, char *homehost)
+{
+	return 0;
+}
+
 int imsm_reshape_is_allowed_on_container(struct supertype *st,
 					 struct geo_params *geo)
 {
@@ -6777,6 +6815,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 {
 	int ret_val = 1;
 	struct mdinfo *sra = NULL;
+	struct mdinfo *srac = NULL;
 	int fd = -1;
 	int fdc = -1;
 	char buf[PATH_MAX];
@@ -6830,6 +6869,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 			dprintf("imsm: Operation is not allowed on container\n");
 		if (ret_val)
 			unfreeze_container(st);
+
 		goto imsm_reshape_super_exit;
 	} else
 		dprintf("imsm: not a container operation\n");
@@ -6841,6 +6881,13 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		goto imsm_reshape_super_exit;
 	}
 
+	srac = sysfs_read(fdc, 0,  GET_VERSION | GET_LEVEL | GET_LAYOUT |
+			  GET_DISKS | GET_DEVS | GET_CHUNK | GET_SIZE);
+	if (srac == NULL) {
+		fprintf(stderr, Name ": Cannot read sysfs info (imsm)\n");
+		goto imsm_reshape_super_exit;
+	}
+
 	fd = open(geo.dev_name , O_RDONLY | O_DIRECT);
 	if (fd < 0) {
 		dprintf("imsm: cannot open device: %s\n", geo.dev_name);
@@ -6857,7 +6904,48 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	geo.dev_id = -1;
 	find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id);
 
-	/* continue volume check - proceed if delta_disk is zero only
+	/* we have volume so takeover can be performed for single volume only
+	 */
+	if ((geo.size == -1) && (geo.layout == UnSet) && (geo.raid_disks == 0) && (geo.level != UnSet) &&
+	    (geo.dev_id > -1)) {
+		/* ok - this is takeover */
+		struct intel_super *super;
+
+		/* takeover raid0<->raid5 doesn't need meta update
+		 * this can be handled by migrations if necessary
+		 */
+		if ((geo.level == 5) && (sra->array.level == 5)) {
+			ret_val = 0;
+			goto imsm_reshape_super_exit;
+		}
+		st->ss->load_super(st, fdc, NULL);
+		super = st->sb;
+		if (!super) {
+			fprintf(stderr, Name ": Super pointer is NULL.\n");
+			goto imsm_reshape_super_exit;
+		}
+		if (super->anchor->num_raid_devs > 1) {
+			fprintf(stderr, Name ": Cannot perform raid10 takeover on multiarray container for imsm.\n");
+			goto imsm_reshape_super_exit;
+		}
+		super->current_vol = 0;
+		st->ss->getinfo_super(st, sra, NULL);
+
+		/* send metadata update for
+		 * raid10 -> raid0 or raid0 -> raid10 takeover */
+		if (((geo.level == 0) && (sra->array.level == 10)) ||
+		   ((geo.level == 10) && (sra->array.level == 0))) {
+			st->update_tail = &st->updates;
+			if (update_level_imsm(st, sra, &geo, 0, 0, NULL) == 0)
+				ret_val = 0;
+			else
+				ret_val = 1;
+			goto imsm_reshape_super_exit;
+		}
+	}
+
+	/* this is not takeover
+	 * continue volume check - proceed if delta_disk is zero only
 	 */
 	if (geo.raid_disks > 0 && geo.raid_disks != UnSet)
 		delta_disks = geo.raid_disks - sra->array.raid_disks;
@@ -6910,6 +6998,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 
 imsm_reshape_super_exit:
 	sysfs_free(sra);
+	sysfs_free(srac);
 	if (fd >= 0)
 		close(fd);
 	if (fdc >= 0)

