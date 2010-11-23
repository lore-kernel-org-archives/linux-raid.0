From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 19/21] Migration: raid5->raid0
Date: Tue, 23 Nov 2010 13:42:11 +0100
Message-ID: <20101123124211.17770.37025.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
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

 mdadm/mdadm/Grow.c        |   93 ++++++++++++++++++++++--------
 mdadm/mdadm/managemon.c   |  107 ++++++++++++++++++++++++++++++----
 mdadm/mdadm/mdadm.h       |    2 +
 mdadm/mdadm/mdmon.h       |    3 +
 mdadm/mdadm/super-intel.c |  141 +++++++++++++++++++++++++++++++++++++--------
 5 files changed, 283 insertions(+), 63 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c
index eaa10c1..5347847 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -1699,28 +1699,32 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
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
 
@@ -2199,6 +2203,42 @@ int wait_reshape_completed_ext(struct supertype *st,
 	return 0;
 }
 
+int wait_reshape_start_ext(struct supertype *st, struct mdinfo *sra)
+{
+#define WAIT_FOR_RESHAPE_START 20
+	int wait_time = WAIT_FOR_RESHAPE_START;
+	int ret_val = -1;
+	char *container = devnum2devname(st->devnum);
+
+	if (container == NULL) {
+		dprintf("wait_reshape_start_ext: cannot find container.\n");
+		return ret_val;
+	}
+	ping_manager(container);
+	ping_monitor(container);
+	while (wait_time) {
+		char action[20];
+		dprintf("wait_reshape_start_ext Waiting for reshape state (%i) ...\n", WAIT_FOR_RESHAPE_START - wait_time + 1);
+		if (sysfs_get_str(sra, NULL, "sync_action",  action, 20) < 0) {
+			dprintf("Error: wait_reshape_start_ext cannot read sync_action\n");
+			break;
+		}
+		dprintf("wait_reshape_start_ext: read from sysfs: %s\n", action);
+		if (strncmp(action, "reshape", 7) == 0) {
+			dprintf("wait_reshape_start_ext: reshape started.\n");
+			ret_val = 0;
+			break;
+		}
+		ping_manager(container);
+		ping_monitor(container);
+		sleep(1);
+		wait_time--;
+	}
+
+	free(container);
+	return ret_val;
+}
+
 void send_resync_max_to_mdmon(struct supertype *st,
 			      struct mdinfo *sra,
 			      unsigned long long resync_max)
@@ -2437,10 +2477,13 @@ static int child_same_size_ext(struct supertype *st, int afd, struct mdinfo *sra
 	sysfs_get_ll(sra, NULL, "sync_speed_min", &speed);
 	sysfs_set_num(sra, NULL, "sync_speed_min", 200000);
 
-	/* Start the reshape - give a chance to update the metadata */
-	sysfs_set_num(sra, NULL, "sync_max", 0);
-	sysfs_set_str(sra, NULL, "sync_action", "reshape");
-	flush_metadata_updates(st);
+	/* wait reshape is starteb by managemon
+	 * - give a chance to update the metadata */
+	if (wait_reshape_start_ext(st, sra)) {
+		dprintf("Error: Reshape not started\n");
+		free(buf);
+		return -1;
+	}
 
 	size = sra->component_size / (chunk/512);
 	while (start < size) {
diff --git a/mdadm/mdadm/managemon.c b/mdadm/mdadm/managemon.c
index 2c7be12..8b2d73c 100644
--- a/mdadm/mdadm/managemon.c
+++ b/mdadm/mdadm/managemon.c
@@ -109,6 +109,8 @@
 #include	<signal.h>
 #include	<limits.h>
 
+extern char *map_num(mapping_t *map, int num);
+
 static void close_aa(struct active_array *aa)
 {
 	struct mdinfo *d;
@@ -380,6 +382,43 @@ static int disk_init_and_add(struct mdinfo *disk, struct mdinfo *clone,
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
@@ -431,17 +470,17 @@ static void manage_member(struct mdstat_ent *mdstat,
 			struct mdinfo *newdev = NULL;
 			struct mdinfo *d;
 			int delta_disks = a->reshape_delta_disks;
+			int status_ok = 1;
 
-			newdev = a->container->ss->reshape_array(a, RESHAPE_IN_PROGRESS, &updates);
+			newa = duplicate_aa(a);
+			if (newa == NULL) {
+				a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
+				goto reshape_out;
+			}
+			newdev = newa->container->ss->reshape_array(newa, RESHAPE_IN_PROGRESS, &updates);
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
@@ -456,11 +495,41 @@ static void manage_member(struct mdstat_ent *mdstat,
 					}
 					disk_init_and_add(newd, d, newa);
 				}
-				/* go with reshape
+			}
+			if (newa->reshape_delta_disks == RESHAPE_IN_PROGRESS) {
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
@@ -475,7 +544,10 @@ static void manage_member(struct mdstat_ent *mdstat,
 						newa->old_data_disks--;
 					if (newa->info.array.level == 6)
 						newa->old_data_disks--;
-					newa->new_data_disks = newa->info.array.raid_disks + delta_disks;
+					if (newa->reshape_raid_disks > 0)
+						newa->new_data_disks = newa->reshape_raid_disks;
+					else
+						newa->new_data_disks = newa->info.array.raid_disks + delta_disks;
 					if (level == 4)
 						newa->new_data_disks--;
 					if (level == 5)
@@ -487,28 +559,35 @@ static void manage_member(struct mdstat_ent *mdstat,
 
 					replace_array(a->container, a, newa);
 					a = newa;
+					newa = NULL;
 				} else {
 					/* on problems cancelupdate
 					 */
-					free_aa(newa);
 					free_updates(&updates);
 					updates = NULL;
-					a->container->ss->reshape_array(a, RESHAPE_CANCEL_REQUEST, &updates);
-					sysfs_set_str(&a->info, NULL, "sync_action", "idle");
+					a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
 				}
 			}
+reshape_out:
+			if (a->reshape_delta_disks == RESHAPE_NOT_ACTIVE) {
+				dprintf("Cancel reshape.\n");
+				a->container->ss->reshape_array(a, RESHAPE_CANCEL_REQUEST, &updates);
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
 
diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h
index ddff47a..32db716 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -429,6 +429,8 @@ extern int sysfs_attr_match(const char *attr, const char *str);
 extern int sysfs_match_word(const char *word, char **list);
 extern int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, char *val);
+extern int sysfs_get_ll(struct mdinfo *sra, struct mdinfo *dev,
+			char *name, unsigned long long *val);
 extern int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
 			 char *name, unsigned long long val);
 extern int sysfs_uevent(struct mdinfo *sra, char *event);
diff --git a/mdadm/mdadm/mdmon.h b/mdadm/mdadm/mdmon.h
index 8362dbd..18bd780 100644
--- a/mdadm/mdadm/mdmon.h
+++ b/mdadm/mdadm/mdmon.h
@@ -59,6 +59,9 @@ struct active_array {
 #define RESHAPE_CANCEL_REQUEST	(RESHAPE_IN_PROGRESS-1)
 
 	int reshape_delta_disks;
+	int reshape_raid_disks;
+	int reshape_level;
+	int reshape_layout;
 	unsigned long long grow_sync_max; /* sync_max from mdadm Grow */
 	enum reshape_wait waiting_for; /* we can wait for grow backup event
 					  or for md reshape completed */
diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index 113c3bb..f874f2f 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -344,6 +344,9 @@ struct imsm_update_reshape {
 	enum imsm_update_type type;
 	int update_memory_size;
 	int reshape_delta_disks;
+	int reshape_raid_disks;
+	int reshape_level;
+	int reshape_layout;
 	int disks_count;
 	int spares_in_update;
 	int devnum;
@@ -5684,6 +5687,7 @@ static void imsm_process_update(struct supertype *st,
 		__u32 new_mpb_size;
 		int new_disk_num;
 		struct intel_dev *current_dev;
+		struct imsm_dev *new_dev;
 
 		dprintf("imsm: imsm_process_update() for update_reshape [u->update_prepared  = %i]\n", u->update_prepared);
 		if ((u->update_prepared == -1) ||
@@ -5741,11 +5745,12 @@ static void imsm_process_update(struct supertype *st,
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
@@ -5764,7 +5769,13 @@ static void imsm_process_update(struct supertype *st,
 		/* set reshape_delta_disks
 		 */
 		a->reshape_delta_disks = u->reshape_delta_disks;
-
+		a->reshape_raid_disks = u->reshape_raid_disks;
+		a->reshape_level = u->reshape_level;
+		a->reshape_layout = u->reshape_layout;
+		if (a->reshape_level == 0) {
+			a->reshape_level = 5;
+			a->reshape_layout = 5;
+		}
 
 		/* Clear migration record */
 		memset(super->migr_rec, 0, sizeof(struct migr_record));
@@ -6280,12 +6291,7 @@ static void imsm_prepare_update(struct supertype *st,
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
@@ -7215,6 +7221,9 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
 	}
 	u->reshape_delta_disks = delta_disks;
 	u->update_prepared = -1;
+	u->reshape_raid_disks = 0;
+	u->reshape_level = -1;
+	u->reshape_layout = -1;
 	u->update_memory_size = update_memory_size;
 	u->type = update_reshape;
 	u->spares_in_update = 0;
@@ -7262,6 +7271,18 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(struct super
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
@@ -7433,6 +7454,7 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	struct mdinfo *sra = NULL;
 	int fd = -1;
 	char buf[PATH_MAX];
+	int delta_disks = -1;
 	struct geo_params geo;
 
 	memset(&geo, sizeof (struct geo_params), 0);
@@ -7493,6 +7515,13 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	} else
 		dprintf("imsm: not a container operation\n");
 
+	sra = sysfs_read(fd, 0,  GET_VERSION | GET_LEVEL | GET_LAYOUT |
+			 GET_DISKS | GET_DEVS | GET_CHUNK | GET_SIZE);
+	if (sra == NULL) {
+		fprintf(stderr, Name ": Cannot read sysfs info (imsm)\n");
+		goto imsm_reshape_super_exit;
+	}
+
 	geo.dev_id = -1;
 	find_array_minor(geo.dev_name, 1, st->devnum, &geo.dev_id);
 
@@ -7505,12 +7534,6 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 		int dn;
 		int err;
 
-		sra = sysfs_read(fd, 0,  GET_VERSION | GET_LEVEL |
-				 GET_LAYOUT | GET_DISKS | GET_DEVS);
-		if (sra == NULL) {
-			fprintf(stderr, Name ": Cannot read sysfs info (imsm)\n");
-			goto imsm_reshape_super_exit;
-		}
 		dn = devname2devnum(sra->text_version + 1);
 		container_fd = open_dev_excl(dn);
 		if (container_fd < 0) {
@@ -7538,11 +7561,49 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 				goto imsm_reshape_super_exit;
 			}
 			ret_val = 0;
+			goto imsm_reshape_super_exit;
 		}
-		sysfs_free(sra);
-		sra = NULL;
 	}
 
+	/* this is not takeover
+	 * continue volume check - proceed if delta_disk is zero only
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
+
 imsm_reshape_super_exit:
 	sysfs_free(sra);
 	if (fd >= 0)
@@ -7829,7 +7890,8 @@ struct mdinfo *imsm_reshape_array(struct active_array *a, int request_type,
 
 	if (a->reshape_delta_disks == 0) {
 		dprintf("array parameters has to be changed\n");
-		/* TBD */
+		a->reshape_delta_disks = RESHAPE_IN_PROGRESS;
+		return disk_list;
 	}
 	if (a->reshape_delta_disks > 0) {
 		dprintf("grow is detected.\n");
@@ -7850,20 +7912,18 @@ struct mdinfo *imsm_reshape_array(struct active_array *a, int request_type,
 imsm_reshape_array_exit:
 	if (u == NULL) {
 		dprintf("imsm: send update update_reshape_cancel\n");
+		a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
 		sysfs_set_str(&a->info, NULL, "sync_action", "idle");
 		imsm_grow_array_remove_devices_on_cancel(a);
 		u = (struct imsm_update_reshape *)calloc(1, sizeof(struct imsm_update_reshape));
-		if (u) {
+		if (u)
 			u->type = update_reshape_cancel;
-			a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
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
@@ -7876,11 +7936,11 @@ imsm_reshape_array_exit:
 			mu->next = *updates;
 			*updates = mu;
 		} else {
+			a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
 			free(u);
 			u = NULL;
 		}
 	}
-	a->reshape_delta_disks = RESHAPE_NOT_ACTIVE;
 
 	if ((disk_list) && (u == NULL)) {
 		while (disk_list) {
@@ -8026,7 +8086,8 @@ int imsm_child_grow(struct supertype *st, char *devname, int validate_fd, struct
 
 void return_to_raid0(struct mdinfo *sra)
 {
-	if (sra->array.level == 4) {
+	if ((sra->array.level == 4) ||
+	    (sra->array.level == 0)) {
 		dprintf("Execute backward takeover to raid0\n");
 		sysfs_set_str(sra, NULL, "level", "raid0");
 	}
@@ -8392,7 +8453,38 @@ int imsm_manage_reshape(struct supertype *st, char *backup)
 	 * for single vlolume reshape exit only and reuse Grow_reshape() code
 	 */
 	if (st->subarray[0] != 0) {
+		char buf[PATH_MAX];
+		int fd;
+
 		dprintf("imsm: manage_reshape() current volume: %s (devnum = %i)\n", st->subarray, st->devnum);
+
+		snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
+		fd = open(buf , O_RDWR | O_DIRECT);
+		if (fd > -1) {
+			struct mdinfo *info;
+			struct mdinfo sra;
+
+			sra.devs = NULL;
+			st->ss->getinfo_super(st, &sra);
+			/* wait for reshape finish
+			* and manage array size based on metadata information
+			*/
+			imsm_grow_manage_size(st, &sra);
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
 	ret_val = imsm_manage_container_reshape(st);
@@ -8460,3 +8552,4 @@ struct superswitch super_imsm = {
 	.prepare_update = imsm_prepare_update,
 #endif /* MDASSEMBLE */
 };
+

