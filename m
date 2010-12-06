From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 19/27] Migration: raid5->raid0
Date: Mon, 06 Dec 2010 14:23:15 +0100
Message-ID: <20101206132315.21125.1469.stgit@gklab-170-024.igk.intel.com>
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

Add implementation for migration from raid5 to raid0 in one step.
For this migration case (and others for external metadata case)
flow used for Expansion is used. This causes update array parameters
in managemon based on sent metadata update. To do this uptate md parameters
in Grow.c has to be disabled for external metadata case.

In Grow.c instead starting reshape for external metadata case
wait_reshape_start_ext() function is introduced.
Function waits for reshape start initialized by managemon after setting
array parameter as for Expansion case.

In managemon was added subarray_set_num_man() function.
It is similar to function that exists in Grow.c except 2 things:
1. it uses different way to "ping" monitor
2. it tries to set raid_disks more than 2 times as we are more sure that monitor works
   during processing in managemon context

For imsm raid level parameters flow from mdadm (via metadata update)
to managemon was added.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |   61 +++++++-------
 managemon.c   |  104 +++++++++++++++++++++---
 mdadm.h       |    2 
 mdmon.h       |    3 +
 super-intel.c |  251 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 368 insertions(+), 53 deletions(-)

diff --git a/Grow.c b/Grow.c
index b51c4d0..465309c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1752,28 +1752,32 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				break;
 			}
 		} else {
-			/* set them all just in case some old 'new_*' value
-			 * persists from some earlier problem
+			/* set parametes here only if managemon is not responsible for this
 			 */
-			int err = err; /* only used if rv==1, and always set if
-					* rv==1, so initialisation not needed,
-					* despite gcc warning
-					*/
-			if (sysfs_set_num(sra, NULL, "chunk_size", nchunk) < 0)
-				rv = 1, err = errno;
-			if (!rv && sysfs_set_num(sra, NULL, "layout", nlayout) < 0)
-				rv = 1, err = errno;
-			if (!rv && sysfs_set_num(sra, NULL, "raid_disks", ndisks) < 0)
-				rv = 1, err = errno;
-			if (rv) {
-				fprintf(stderr, Name ": Cannot set device shape for %s\n",
-					devname);
-				if (get_linux_version() < 2006030)
-					fprintf(stderr, Name ": linux 2.6.30 or later required\n");
-				if (err == EBUSY && 
-				    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
-					fprintf(stderr, "       Bitmap must be removed before shape can be changed\n");
-				break;
+			if ((st->ss->external == 0) || (st->ss->reshape_super == NULL)) {
+				/* set them all just in case some old 'new_*' value
+				 * persists from some earlier problem
+				 */
+				int err = err; /* only used if rv==1, and always set if
+						* rv==1, so initialisation not needed,
+						* despite gcc warning
+						*/
+				if (sysfs_set_num(sra, NULL, "chunk_size", nchunk) < 0)
+					rv = 1, err = errno;
+				if (!rv && sysfs_set_num(sra, NULL, "layout", nlayout) < 0)
+					rv = 1, err = errno;
+				if (!rv && sysfs_set_num(sra, NULL, "raid_disks", ndisks) < 0)
+					rv = 1, err = errno;
+				if (rv) {
+					fprintf(stderr, Name ": Cannot set device shape for %s\n",
+						devname);
+					if (get_linux_version() < 2006030)
+						fprintf(stderr, Name ": linux 2.6.30 or later required\n");
+					if (err == EBUSY &&
+					    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
+						fprintf(stderr, "       Bitmap must be removed before shape can be changed\n");
+					break;
+				}
 			}
 		}
 
@@ -2204,8 +2208,8 @@ static void validate(int afd, int bfd, unsigned long long offset)
 	}
 }
 
-int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
-	       int *fds, unsigned long long *offsets,
+int child_grow(int afd, struct mdinfo *sra,
+	       unsigned long stripes, int *fds, unsigned long long *offsets,
 	       int disks, int chunk, int level, int layout, int data,
 	       int dests, int *destfd, unsigned long long *destoffsets)
 {
@@ -2268,11 +2272,12 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
 	return 1;
 }
 
-static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
-			   int *fds, unsigned long long *offsets,
-			   unsigned long long start,
-			   int disks, int chunk, int level, int layout, int data,
-			   int dests, int *destfd, unsigned long long *destoffsets)
+int child_same_size(int afd,
+		    struct mdinfo *sra, unsigned long stripes,
+		    int *fds, unsigned long long *offsets,
+		    unsigned long long start,
+		    int disks, int chunk, int level, int layout, int data,
+		    int dests, int *destfd, unsigned long long *destoffsets)
 {
 	unsigned long long size;
 	unsigned long tailstripes = stripes;
diff --git a/managemon.c b/managemon.c
index 5d81623..2739c39 100644
--- a/managemon.c
+++ b/managemon.c
@@ -380,6 +380,43 @@ static int disk_init_and_add(struct mdinfo *disk, struct mdinfo *clone,
 	return 0;
 }
 
+int subarray_set_num_man(char *container, struct mdinfo *sra, char *name, int n)
+{
+	/* when dealing with external metadata subarrays we need to be
+	 * prepared to handle EAGAIN.  The kernel may need to wait for
+	 * mdmon to mark the array active so the kernel can handle
+	 * allocations/writeback when preparing the reshape action
+	 * (md_allow_write()).  We temporarily disable safe_mode_delay
+	 * to close a race with the array_state going clean before the
+	 * next write to raid_disks / stripe_cache_size
+	 */
+	char safe[50];
+	int rc;
+#define MANAGEMON_COUNTER	20
+	int counter = MANAGEMON_COUNTER;
+
+	/* only 'raid_disks' and 'stripe_cache_size' trigger md_allow_write */
+	if (strcmp(name, "raid_disks") != 0 &&
+	    strcmp(name, "stripe_cache_size") != 0)
+		return sysfs_set_num(sra, NULL, name, n);
+
+	rc = sysfs_get_str(sra, NULL, "safe_mode_delay", safe, sizeof(safe));
+	if (rc <= 0)
+		return -1;
+	sysfs_set_num(sra, NULL, "safe_mode_delay", 0);
+	rc = sysfs_set_num(sra, NULL, name, n);
+	while ((rc < 0) && counter) {
+		counter--;
+		dprintf("managemon: Try to set %s to value %i (%i time(s)).\n", name, n, MANAGEMON_COUNTER - counter);
+		wakeup_monitor();
+		usleep(250000);
+		rc = sysfs_set_num(sra, NULL, name, n);
+	}
+	sysfs_set_str(sra, NULL, "safe_mode_delay", safe);
+	return rc;
+}
+
+
 static void manage_member(struct mdstat_ent *mdstat,
 			  struct active_array *a)
 {
@@ -410,6 +447,8 @@ static void manage_member(struct mdstat_ent *mdstat,
 	else
 		frozen = 1; /* can't read metadata_version assume the worst */
 
+
+
 	if ((a->reshape_state != reshape_not_active) &&
 	    (a->reshape_state != reshape_in_progress)) {
 		dprintf("Reshape signals need to manage this member\n");
@@ -418,17 +457,17 @@ static void manage_member(struct mdstat_ent *mdstat,
 			struct mdinfo *newdev = NULL;
 			struct mdinfo *d;
 			int delta_disks = a->reshape_delta_disks;
+			int status_ok = 1;
 
+			newa = duplicate_aa(a);
+			if (newa == NULL) {
+				a->reshape_state = reshape_not_active;
+				goto reshape_out;
+			}
 			newdev = newa->container->ss->reshape_array(newa, reshape_in_progress, &updates);
 			if (newdev) {
-				int status_ok = 1;
-				newa = duplicate_aa(a);
-				if (newa == NULL)
-					goto reshape_out;
-
 				for (d = newdev; d ; d = d->next) {
 					struct mdinfo *newd;
-
 					newd = malloc(sizeof(*newd));
 					if (!newd) {
 						status_ok = 0;
@@ -443,16 +482,49 @@ static void manage_member(struct mdstat_ent *mdstat,
 					}
 					disk_init_and_add(newd, d, newa);
 				}
-				/* go with reshape
+			}
+			if (newa->reshape_state == reshape_in_progress) {
+				/* set reshape parametars
 				 */
-				if (status_ok)
+				if (status_ok) {
+					dprintf("managemon: set sync_max to 0\n");
 					if (sysfs_set_num(&newa->info, NULL, "sync_max", 0) < 0)
 						status_ok = 0;
+				}
+
+				if (status_ok && newa->reshape_raid_disks) {
+					dprintf("managemon: set raid_disks to %i\n", newa->reshape_raid_disks);
+					if (subarray_set_num_man(a->container->devname, &newa->info, "raid_disks", newa->reshape_raid_disks))
+							status_ok = 0;
+				}
+
+				if (status_ok && newa->reshape_level > -1) {
+					char *c = map_num(pers, newa->reshape_level);
+					if (c == NULL)
+						status_ok = 0;
+					else {
+						dprintf("managemon: set level to %s\n", c);
+						if (sysfs_set_str(&newa->info, NULL, "level", c) < 0)
+							status_ok = 0;
+					}
+				}
+
+				if (status_ok && newa->reshape_layout >= 0) {
+					dprintf("managemon: set layout to %i\n", newa->reshape_layout);
+					if (sysfs_set_num(&newa->info, NULL, "layout", newa->reshape_layout) < 0)
+						status_ok = 0;
+				}
+
+				/* go with reshape
+				 */
 				if (status_ok && sysfs_set_str(&newa->info, NULL, "sync_action", "reshape") == 0) {
 					/* reshape executed
 					 */
 					dprintf("Reshape was started\n");
-					newa->new_data_disks = newa->info.array.raid_disks + delta_disks;
+					if (newa->reshape_raid_disks > 0)
+						newa->new_data_disks = newa->reshape_raid_disks;
+					else
+						newa->new_data_disks = newa->info.array.raid_disks + delta_disks;
 					if (a->info.array.level == 4)
 						newa->new_data_disks--;
 					if (a->info.array.level == 5)
@@ -461,28 +533,38 @@ static void manage_member(struct mdstat_ent *mdstat,
 						newa->new_data_disks--;
 					replace_array(a->container, a, newa);
 					a = newa;
+					newa = NULL;
 				} else {
 					/* on problems cancel update
 					 */
-					free_aa(newa);
 					free_updates(&updates);
 					updates = NULL;
+
 					a->container->ss->reshape_array(a, reshape_cancel_request, &updates);
 					sysfs_set_str(&a->info, NULL, "sync_action", "idle");
+					a->reshape_state = reshape_not_active;
 				}
 			}
+reshape_out:
+			if (a->reshape_state == reshape_not_active) {
+				dprintf("Cancel reshape.\n");
+				a->container->ss->reshape_array(a, reshape_cancel_request, &updates);
+				sysfs_set_str(&a->info, NULL, "sync_action", "idle");
+			}
 			dprintf("Send metadata update for reshape.\n");
 
 			queue_metadata_update(updates);
 			updates = NULL;
 			wakeup_monitor();
-reshape_out:
+
 			while (newdev) {
 				d = newdev->next;
 				free(newdev);
 				newdev = d;
 			}
 			free_updates(&updates);
+			if (newa)
+				free_aa(newa);
 		}
 	}
 
diff --git a/mdadm.h b/mdadm.h
index 4563d14..7aba440 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -455,6 +455,8 @@ extern int sysfs_attr_match(const char *attr, const char *str);
 extern int sysfs_match_word(const char *word, char **list);
 extern int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val);
+extern int sysfs_get_ll(struct mdinfo *sra, struct mdinfo *dev,
+			char *name, unsigned long long *val);
 extern int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, unsigned long long val);
 extern int sysfs_uevent(struct mdinfo *sra, char *event);
diff --git a/mdmon.h b/mdmon.h
index b922af4..a31ad97 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -49,6 +49,9 @@ struct active_array {
 	enum state_of_reshape reshape_state;
 	int reshape_delta_disks;
 	int new_data_disks;
+	int reshape_raid_disks;
+	int reshape_level;
+	int reshape_layout;
 
 	int check_degraded; /* flag set by mon, read by manage */
 
diff --git a/super-intel.c b/super-intel.c
index aced38c..2c5331f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -314,6 +314,9 @@ struct imsm_update_reshape {
 	enum imsm_update_type type;
 	int update_memory_size;
 	int reshape_delta_disks;
+	int reshape_raid_disks;
+	int reshape_level;
+	int reshape_layout;
 	int disks_count;
 	int spares_in_update;
 	int devnum;
@@ -5352,6 +5355,7 @@ static void imsm_process_update(struct supertype *st,
 		__u32 new_mpb_size;
 		int new_disk_num;
 		struct intel_dev *current_dev;
+		struct imsm_dev *new_dev;
 
 		dprintf("imsm: imsm_process_update() for update_reshape [u->update_prepared  = %i]\n", u->update_prepared);
 		if ((u->update_prepared == -1) ||
@@ -5409,11 +5413,12 @@ static void imsm_process_update(struct supertype *st,
 		}
 		/* find current dev in intel_super
 		 */
-		dprintf("\t\tLooking  for volume %s\n", (char *)u->devs_mem.dev->volume);
+		new_dev = (struct imsm_dev *)((void *)u + u->upd_devs_offset);
+		dprintf("\t\tLooking  for volume %s\n", (char *)new_dev->volume);
 		current_dev = super->devlist;
 		while (current_dev) {
 			if (strcmp((char *)current_dev->dev->volume,
-				   (char *)u->devs_mem.dev->volume) == 0)
+				   (char *)new_dev->volume) == 0)
 				break;
 			current_dev = current_dev->next;
 		}
@@ -5432,7 +5437,14 @@ static void imsm_process_update(struct supertype *st,
 		/* set reshape_delta_disks
 		 */
 		a->reshape_delta_disks = u->reshape_delta_disks;
+		a->reshape_raid_disks = u->reshape_raid_disks;
 		a->reshape_state = reshape_is_starting;
+		a->reshape_level = u->reshape_level;
+		a->reshape_layout = u->reshape_layout;
+		if (a->reshape_level == 0) {
+			a->reshape_level = 5;
+			a->reshape_layout = 5;
+		}
 
 		super->updates_pending++;
 update_reshape_exit:
@@ -5896,12 +5908,7 @@ static void imsm_prepare_update(struct supertype *st,
 		if (u->reshape_delta_disks < 0)
 			break;
 		u->update_prepared = 1;
-		if (u->reshape_delta_disks == 0) {
-			/* for non growing reshape buffers sizes are not affected
-			 * but check some parameters
-			 */
-			break;
-		}
+
 		/* count HDDs
 		 */
 		u->disks_count = 0;
@@ -6370,6 +6377,106 @@ abort:
 	return ret_val;
 }
 
+/*****************************************************************************
+ * Function: update_geometry
+ * Description: Prepares imsm volume map update in case of volume reshape
+ * Returns: 0 on success, -1 if fail
+ * ***************************************************************************/
+int update_geometry(struct supertype *st,
+		    struct geo_params *geo)
+{
+	int fd = -1, ret_val = -1;
+	struct mdinfo *sra = NULL;
+	char buf[PATH_MAX];
+	char supported = 1;
+
+	snprintf(buf, PATH_MAX, "/dev/md%i", geo->dev_id);
+	fd = open(buf , O_RDONLY | O_DIRECT);
+	if (fd < 0) {
+		dprintf("imsm: cannot open device\n");
+		return -1;
+	}
+
+	sra = sysfs_read(fd, 0, GET_DISKS | GET_LAYOUT | GET_CHUNK | GET_SIZE | GET_LEVEL | GET_DEVS);
+	if (!sra) {
+		dprintf("imsm: Cannot get mdinfo!\n");
+		goto update_geometry_exit;
+	}
+
+	if (sra->devs == NULL) {
+		dprintf("imsm: Cannot load device information.\n");
+		goto update_geometry_exit;
+	}
+	/* is size change possible??? */
+	if (((unsigned long long)geo->size != sra->devs->component_size) && (geo->size != UnSet) && (geo->size > 0)) {
+		geo->size = sra->devs->component_size;
+		dprintf("imsm: Change the array size not supported in imsm!\n");
+		goto update_geometry_exit;
+	}
+
+	if ((geo->level != sra->array.level) && (geo->level >= 0) && (geo->level != UnSet)) {
+		switch (sra->array.level) {
+		case 0:
+			if (geo->level != 5)
+				supported = 0;
+			break;
+		case 5:
+			if (geo->level != 0)
+				supported = 0;
+			break;
+		case 1:
+			if ((geo->level != 5) || (geo->level != 0))
+				supported = 0;
+			break;
+		case 10:
+			if (geo->level != 5)
+				supported = 0;
+			break;
+		default:
+			supported = 0;
+			break;
+		}
+		if (!supported) {
+			dprintf("imsm: Error. Level Migration from %d to %d not supported!\n", sra->array.level, geo->level);
+			goto update_geometry_exit;
+		}
+	} else {
+		geo->level = sra->array.level;
+	}
+
+	if ((geo->layout != sra->array.layout) && ((geo->layout != UnSet) && (geo->layout != -1))) {
+		if ((sra->array.layout == 0) && (sra->array.level == 5) && (geo->layout == 5)) {
+			/* reshape 5 -> 4 */
+			geo->raid_disks++;
+		} else if ((sra->array.layout == 5) && (sra->array.level == 5) && (geo->layout == 0)) {
+			/* reshape 4 -> 5 */
+			geo->layout = 0;
+			geo->level = 5;
+		} else {
+			dprintf("imsm: Error. Layout Migration from %d to %d not supported!\n", sra->array.layout, geo->layout);
+			ret_val = -1;
+			goto update_geometry_exit;
+		}
+	}
+
+	if ((geo->chunksize == 0) || (geo->chunksize == UnSet))
+	    geo->chunksize = sra->array.chunk_size;
+
+	if (!validate_geometry_imsm(st, geo->level, geo->layout, geo->raid_disks,
+					geo->chunksize,  geo->size,
+					0, 0, 1))
+		goto update_geometry_exit;
+
+	ret_val = 0;
+
+update_geometry_exit:
+	sysfs_free(sra);
+	if (fd > -1)
+		close(fd);
+
+	return ret_val;
+}
+
 /******************************************************************************
  * function: imsm_create_metadata_update_for_reshape
  * Function creates update for whole IMSM container.
@@ -6423,6 +6530,9 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	}
 	u->reshape_delta_disks = delta_disks;
 	u->update_prepared = -1;
+	u->reshape_raid_disks = 0;
+	u->reshape_level = -1;
+	u->reshape_layout = -1;
 	u->update_memory_size = update_memory_size;
 	u->type = update_reshape;
 	u->spares_in_update = 0;
@@ -6470,6 +6580,18 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 						set_imsm_ord_tbl_ent(new_map, idx, idx);
 				}
 				u->devnum = geo->dev_id;
+				/* case for reshape without grow */
+				if (u->reshape_delta_disks == 0) {
+					dprintf("imsm: reshape prepate metadata for volume= %d, index= %d\n", geo->dev_id, i);
+					if (update_geometry(st, geo) == -1) {
+						dprintf("imsm: ERROR: Cannot prepare update for volume map!\n");
+						ret_val = NULL;
+						goto exit_imsm_create_metadata_update_for_reshape;
+					} else {
+						new_map->raid_level = geo->level;
+						new_map->blocks_per_strip = geo->chunksize / 512;
+					}
+				}
 				break;
 			}
 		}
@@ -6641,6 +6763,10 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		       char *backup, char *dev, int verbouse)
 {
 	int ret_val = 1;
+	struct mdinfo *sra = NULL;
+	int fd = -1;
+	char buf[PATH_MAX];
+	int delta_disks = -1;
 	struct geo_params geo;
 
 	dprintf("imsm: reshape_super called.\n");
@@ -6690,9 +6816,69 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 			dprintf("imsm: Operation is not allowed on container\n");
 		if (ret_val)
 			unfreeze_container(st);
+		goto imsm_reshape_super_exit;
 	} else
 		dprintf("imsm: not a container operation\n");
 
+	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
+	fd = open(buf , O_RDONLY | O_DIRECT);
+	if (fd < 0) {
+		dprintf("imsm: cannot open device: %s\n", buf);
+		goto imsm_reshape_super_exit;
+	}
+
+	sra = sysfs_read(fd, 0,  GET_VERSION | GET_LEVEL | GET_LAYOUT |
+			 GET_DISKS | GET_DEVS | GET_CHUNK | GET_SIZE);
+	if (sra == NULL) {
+		fprintf(stderr, Name ": Cannot read sysfs info (imsm)\n");
+		goto imsm_reshape_super_exit;
+	}
+
+	geo.dev_id = -1;
+	find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id);
+
+	/* continue volume check - proceed if delta_disk is zero only
+	 */
+	if (geo.raid_disks > 0 && geo.raid_disks != UnSet)
+		delta_disks = geo.raid_disks - sra->array.raid_disks;
+	else
+		delta_disks = 0;
+	dprintf("imsm: imsm_reshape_super() called on array when delta disks = %i\n", delta_disks);
+	if (delta_disks == 0) {
+		struct imsm_update_reshape *u;
+		st->update_tail = &st->updates;
+		dprintf("imsm: imsm_reshape_super(): raid_disks not changed for volume reshape. Reshape allowed.\n");
+
+		if (find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id) > -1) {
+			u = imsm_create_metadata_update_for_reshape(st, &geo);
+			if (u) {
+				if (geo.raid_disks > raid_disks)
+					u->reshape_raid_disks = geo.raid_disks;
+				u->reshape_level = geo.level;
+				u->reshape_layout = geo.layout;
+				ret_val = 0;
+				append_metadata_update(st, u, u->update_memory_size);
+			}
+		}
+		goto imsm_reshape_super_exit;
+	} else {
+		char *devname = devnum2devname(st->devnum);
+		char *devtoprint = devname;
+
+		if (devtoprint == NULL)
+			devtoprint = "Device";
+		fprintf(stderr, Name
+			": %s cannot be reshaped. Command has to be executed on container.\n",
+			devtoprint);
+		if (devname)
+			free(devname);
+	}
+
+imsm_reshape_super_exit:
+	sysfs_free(sra);
+	if (fd >= 0)
+		close(fd);
+
 	dprintf("imsm: reshape_super Exit code = %i\n", ret_val);
 
 	return ret_val;
@@ -6977,7 +7163,8 @@ struct mdinfo *imsm_reshape_array(struct active_array *a, enum state_of_reshape
 
 	if (a->reshape_delta_disks == 0) {
 		dprintf("array parameters has to be changed\n");
-		/* TBD */
+		a->reshape_state = reshape_in_progress;
+		return disk_list;
 	}
 	if (a->reshape_delta_disks > 0) {
 		dprintf("grow is detected.\n");
@@ -7002,17 +7189,14 @@ imsm_reshape_array_exit:
 		sysfs_set_str(&a->info, NULL, "sync_action", "idle");
 		imsm_grow_array_remove_devices_on_cancel(a);
 		u = (struct imsm_update_reshape *)calloc(1, sizeof(struct imsm_update_reshape));
-		if (u) {
+		if (u)
 			u->type = update_reshape_cancel;
-			a->reshape_state = reshape_not_active;
-		}
 	}
 
 	if (u) {
 		/* post any prepared update
 		 */
 		u->devnum = a->devnum;
-
 		u->update_memory_size = sizeof(struct imsm_update_reshape);
 		u->reshape_delta_disks = a->reshape_delta_disks;
 		u->update_prepared = 1;
@@ -7199,7 +7383,8 @@ int imsm_child_grow(struct supertype *st, char *devname, int fd_in, struct mdinf
 
 void return_to_raid0(struct mdinfo *sra)
 {
-	if (sra->array.level == 4) {
+	if ((sra->array.level == 4) ||
+	    (sra->array.level == 0)) {
 		dprintf("Execute backward takeover to raid0\n");
 		sysfs_set_str(sra, NULL, "level", "raid0");
 	}
@@ -7576,8 +7761,45 @@ int imsm_manage_reshape(struct supertype *st, char *backup)
 	 * for single vlolume reshape exit only and reuse Grow_reshape() code
 	 */
 	if (st->container_dev != st->devnum) {
+		char buf[PATH_MAX];
+		int fd;
+
 		dprintf("imsm: manage_reshape() current volume devnum: %i\n", st->devnum);
 
+		snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
+		fd = open(buf , O_RDWR | O_DIRECT);
+		if (fd > -1) {
+			struct mdinfo *info;
+			struct mdinfo sra;
+			char *cont_name;
+
+			sra.devs = NULL;
+			st->ss->getinfo_super(st, &sra, NULL);
+			/* wait for reshape finish
+			* and manage array size based on metadata information
+			*/
+			cont_name = devnum2devname(st->devnum);
+			if (cont_name) {
+				ping_manager(cont_name);
+				ping_monitor(cont_name);
+				free(cont_name);
+			}
+			imsm_grow_manage_size(st, &sra, -1);
+
+			/* for level == 4: execute takeover to raid0 */
+			info = sysfs_read(fd, 0, GET_VERSION | GET_LEVEL | GET_DEVS | GET_LAYOUT);
+			if (info) {
+				/* curently md doesn't support direct translation from raid5 to raid4
+				 * it has be done via raid5 layout5
+				 */
+				if ((info->array.level == 5) &&
+				    (info->array.layout == 5))
+					info->array.level = 4;
+				return_to_raid0(info);
+				sysfs_free(info);
+			}
+			close(fd);
+		}
 		return ret_val;
 	}
 	ret_val = imsm_manage_container_reshape(st, backup);
@@ -7643,3 +7865,4 @@ struct superswitch super_imsm = {
 	.prepare_update = imsm_prepare_update,
 #endif /* MDASSEMBLE */
 };
+

