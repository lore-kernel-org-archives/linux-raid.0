From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm GIT PULL] rebuild checkpoints, incremental assembly, volume
 delete/rename, and fixes
Date: Wed, 26 May 2010 17:50:52 -0700
Message-ID: <1274921452.17973.253.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, marcin.labun@intel.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

A collection of updates that have been separated onto individual topic
branches.  I provide a url, summary, and full diff for each topic if you
want to do piecemeal pulls, otherwise the merged set is available here:

	git://github.com/djbw/mdadm.git master

Dan Williams (10):
      mdmon: fix missing open of md/<dev>/recovery_start
      mdmon: periodically checkpoint recovery
      imsm: dump each disk's view of the slot state
      Kill subarray
      Rename subarray
      Incremental: honor an 'enough' flag from external handlers
      Revert "Incremental: honor --no-degraded to delay assembly"
      Merge branch 'subarray' into for-neil
      imsm: robustify recovery-start detection
      Merge branches 'fixes' and 'hotplug' into for-neil

Dave Jiang (1):
      create: Check with OROM limit before setting default chunk size

Przemyslaw Hawrylewicz Czarnowski (1):
      fix: memory leak in mdmon_pid()

 Create.c         |    8 +-
 Incremental.c    |   14 ++-
 Kill.c           |   57 ++++++++++
 Manage.c         |   48 +++++++++
 ReadMe.c         |    2 +
 managemon.c      |   45 ++++-----
 mdadm.8          |    5 -
 mdadm.c          |   48 ++++++++-
 mdadm.h          |   20 +++-
 mdmon.c          |   25 +----
 mdmon.h          |    9 ++
 monitor.c        |   33 ++++++
 platform-intel.h |   49 +++++++++
 super-ddf.c      |   26 ++++-
 super-intel.c    |  311 ++++++++++++++++++++++++++++++++++++++++++++++--------
 util.c           |  144 +++++++++++++++++++++++++-
 16 files changed, 731 insertions(+), 113 deletions(-)




Four topics:
1/ 	git://github.com/djbw/mdadm.git checkpoint

Mdmon now watches sync_completed and records a checkpoint at 1/16
array-size intervals.  This branch also has a fixup to allow the
platform firmware to override the default chunksize, otherwise we get:

	mdadm: platform does not support a chunk size of: 512

Dan Williams (3):
      mdmon: fix missing open of md/<dev>/recovery_start
      mdmon: periodically checkpoint recovery
      imsm: dump each disk's view of the slot state

Dave Jiang (1):
      create: Check with OROM limit before setting default chunk size

 Create.c         |    8 ++++++--
 managemon.c      |   45 ++++++++++++++++++++-------------------------
 mdadm.h          |    2 ++
 mdmon.h          |    9 +++++++++
 monitor.c        |   33 +++++++++++++++++++++++++++++++++
 platform-intel.h |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 super-intel.c    |   24 +++++++++++++++++++++++-
 7 files changed, 142 insertions(+), 28 deletions(-)

diff --git a/Create.c b/Create.c
index b04388f..43e5f37 100644
--- a/Create.c
+++ b/Create.c
@@ -235,9 +235,13 @@ int Create(struct supertype *st, char *mddev,
 	case 6:
 	case 0:
 		if (chunk == 0) {
-			chunk = 512;
+			if (st && st->ss->default_chunk)
+				chunk = st->ss->default_chunk(st);
+
+			chunk = chunk ? : 512;
+
 			if (verbose > 0)
-				fprintf(stderr, Name ": chunk size defaults to 512K\n");
+				fprintf(stderr, Name ": chunk size defaults to %dK\n", chunk);
 		}
 		break;
 	case LEVEL_LINEAR:
diff --git a/managemon.c b/managemon.c
index 037406f..d5ba6d6 100644
--- a/managemon.c
+++ b/managemon.c
@@ -361,6 +361,23 @@ static void manage_container(struct mdstat_ent *mdstat,
 	}
 }
 
+static int disk_init_and_add(struct mdinfo *disk, struct mdinfo *clone,
+			     struct active_array *aa)
+{
+	if (!disk || !clone)
+		return -1;
+
+	*disk = *clone;
+	disk->recovery_fd = sysfs_open(aa->devnum, disk->sys_name, "recovery_start");
+	disk->state_fd = sysfs_open(aa->devnum, disk->sys_name, "state");
+	disk->prev_state = read_dev_state(disk->state_fd);
+	disk->curr_state = disk->prev_state;
+	disk->next = aa->info.devs;
+	aa->info.devs = disk;
+
+	return 0;
+}
+
 static void manage_member(struct mdstat_ent *mdstat,
 			  struct active_array *a)
 {
@@ -414,14 +431,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 				free(newd);
 				continue;
 			}
-			*newd = *d;
-			newd->next = newa->info.devs;
-			newa->info.devs = newd;
-
-			newd->state_fd = sysfs_open(a->devnum, newd->sys_name,
-						    "state");
-			newd->prev_state = read_dev_state(newd->state_fd);
-			newd->curr_state = newd->prev_state;
+			disk_init_and_add(newd, d, newa);
 		}
 		queue_metadata_update(updates);
 		updates = NULL;
@@ -513,19 +523,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 			if (i == di->disk.raid_disk)
 				break;
 
-		if (di && newd) {
-			memcpy(newd, di, sizeof(*newd));
-
-			newd->state_fd = sysfs_open(new->devnum,
-						    newd->sys_name,
-						    "state");
-			newd->recovery_fd = sysfs_open(new->devnum,
-						      newd->sys_name,
-						      "recovery_start");
-
-			newd->prev_state = read_dev_state(newd->state_fd);
-			newd->curr_state = newd->prev_state;
-		} else {
+		if (disk_init_and_add(newd, di, new) != 0) {
 			if (newd)
 				free(newd);
 
@@ -535,17 +533,14 @@ static void manage_new(struct mdstat_ent *mdstat,
 				new->container = NULL;
 				break;
 			}
-			continue;
 		}
-		sprintf(newd->sys_name, "rd%d", i);
-		newd->next = new->info.devs;
-		new->info.devs = newd;
 	}
 
 	new->action_fd = sysfs_open(new->devnum, NULL, "sync_action");
 	new->info.state_fd = sysfs_open(new->devnum, NULL, "array_state");
 	new->resync_start_fd = sysfs_open(new->devnum, NULL, "resync_start");
 	new->metadata_fd = sysfs_open(new->devnum, NULL, "metadata_version");
+	new->sync_completed_fd = sysfs_open(new->devnum, NULL, "sync_completed");
 	dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
 		new->action_fd, new->info.state_fd);
 
diff --git a/mdadm.h b/mdadm.h
index 1bf5ac0..142868a 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -609,6 +609,8 @@ extern struct superswitch {
 	struct mdinfo *(*container_content)(struct supertype *st);
 	/* Allow a metadata handler to override mdadm's default layouts */
 	int (*default_layout)(int level); /* optional */
+	/* query the supertype for default chunk size */
+	int (*default_chunk)(struct supertype *st); /* optional */
 
 /* for mdmon */
 	int (*open_new)(struct supertype *c, struct active_array *a,
diff --git a/mdmon.h b/mdmon.h
index 20a0a01..5c51566 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -32,6 +32,15 @@ struct active_array {
 	int action_fd;
 	int resync_start_fd;
 	int metadata_fd; /* for monitoring rw/ro status */
+	int sync_completed_fd; /* for checkpoint notification events */
+	unsigned long long last_checkpoint; /* sync_completed fires for many
+					     * reasons this field makes sure the
+					     * kernel has made progress before
+					     * moving the checkpoint.  It is
+					     * cleared by the metadata handler
+					     * when it determines recovery is
+					     * terminated.
+					     */
 
 	enum array_state prev_state, curr_state, next_state;
 	enum sync_action prev_action, curr_action, next_action;
diff --git a/monitor.c b/monitor.c
index e43e545..12f8d3e 100644
--- a/monitor.c
+++ b/monitor.c
@@ -80,6 +80,24 @@ static unsigned long long read_resync_start(int fd)
 		return strtoull(buf, NULL, 10);
 }
 
+static unsigned long long read_sync_completed(int fd)
+{
+	unsigned long long val;
+	char buf[50];
+	int n;
+	char *ep;
+
+	n = read_attr(buf, 50, fd);
+
+	if (n <= 0)
+		return 0;
+	buf[n] = 0;
+	val = strtoull(buf, &ep, 0);
+	if (ep == buf || (*ep != 0 && *ep != '\n' && *ep != ' '))
+		return 0;
+	return val;
+}
+
 static enum array_state read_state(int fd)
 {
 	char buf[20];
@@ -195,6 +213,7 @@ static void signal_manager(void)
 
 static int read_and_act(struct active_array *a)
 {
+	unsigned long long sync_completed;
 	int check_degraded = 0;
 	int deactivate = 0;
 	struct mdinfo *mdi;
@@ -206,6 +225,7 @@ static int read_and_act(struct active_array *a)
 	a->curr_state = read_state(a->info.state_fd);
 	a->curr_action = read_action(a->action_fd);
 	a->info.resync_start = read_resync_start(a->resync_start_fd);
+	sync_completed = read_sync_completed(a->sync_completed_fd);
 	for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
 		mdi->next_state = 0;
 		if (mdi->state_fd >= 0) {
@@ -307,6 +327,18 @@ static int read_and_act(struct active_array *a)
 		}
 	}
 
+	/* Check for recovery checkpoint notifications.  We need to be a
+	 * minimum distance away from the last checkpoint to prevent
+	 * over checkpointing.  Note reshape checkpointing is not
+	 * handled here.
+	 */
+	if (sync_completed > a->last_checkpoint &&
+	    sync_completed - a->last_checkpoint > a->info.component_size >> 4 &&
+	    a->curr_action > reshape && a->next_action == bad_action) {
+		a->last_checkpoint = sync_completed;
+		a->next_action = idle;
+	}
+
 	a->container->ss->sync_metadata(a->container);
 	dprintf("%s(%d): state:%s action:%s next(", __func__, a->info.container_member,
 		array_states[a->curr_state], sync_actions[a->curr_action]);
@@ -461,6 +493,7 @@ static int wait_and_act(struct supertype *container, int nowait)
 
 		add_fd(&rfds, &maxfd, a->info.state_fd);
 		add_fd(&rfds, &maxfd, a->action_fd);
+		add_fd(&rfds, &maxfd, a->sync_completed_fd);
 		for (mdi = a->info.devs ; mdi ; mdi = mdi->next)
 			add_fd(&rfds, &maxfd, mdi->state_fd);
 
diff --git a/platform-intel.h b/platform-intel.h
index bbdc9f9..9088436 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -115,6 +115,55 @@ static inline int imsm_orom_has_chunk(const struct imsm_orom *orom, int chunk)
 	return !!(orom->sss & (1 << (fs - 1)));
 }
 
+/**
+ * fls - find last (most-significant) bit set
+ * @x: the word to search
+ * The funciton is borrowed from Linux kernel code
+ * include/asm-generic/bitops/fls.h
+ */
+static inline int fls(int x)
+{
+	int r = 32;
+
+	if (!x)
+		return 0;
+	if (!(x & 0xffff0000u)) {
+		x <<= 16;
+		r -= 16;
+	}
+	if (!(x & 0xff000000u)) {
+		x <<= 8;
+		r -= 8;
+	}
+	if (!(x & 0xf0000000u)) {
+		x <<= 4;
+		r -= 4;
+	}
+	if (!(x & 0xc0000000u)) {
+		x <<= 2;
+		r -= 2;
+	}
+	if (!(x & 0x80000000u)) {
+		x <<= 1;
+		r -= 1;
+	}
+	return r;
+}
+
+/**
+ * imsm_orom_default_chunk - return the largest chunk size supported via orom
+ * @orom: orom pointer from find_imsm_orom
+ */
+static inline int imsm_orom_default_chunk(const struct imsm_orom *orom)
+{
+	int fs = fls(orom->sss);
+
+	if (!fs)
+		return 0;
+
+	return min(512, (1 << fs));
+}
+
 struct sys_dev {
 	char *path;
 	struct sys_dev *next;
diff --git a/super-intel.c b/super-intel.c
index 677396c..e29491e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -641,7 +641,7 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev);
 static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 {
 	__u64 sz;
-	int slot;
+	int slot, i;
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	__u32 ord;
 
@@ -650,6 +650,12 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 	printf("           UUID : %s\n", uuid);
 	printf("     RAID Level : %d\n", get_imsm_raid_level(map));
 	printf("        Members : %d\n", map->num_members);
+	printf("          Slots : [");
+	for (i = 0; i < map->num_members; i++) {
+		ord = get_imsm_ord_tbl_ent(dev, i);
+		printf("%s", ord & IMSM_ORD_REBUILD ? "_" : "U");
+	}
+	printf("]\n");
 	slot = get_imsm_disk_slot(map, disk_idx);
 	if (slot >= 0) {
 		ord = get_imsm_ord_tbl_ent(dev, slot);
@@ -4003,6 +4009,17 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	close(cfd);
 	return 0;
 }
+
+int default_chunk_imsm(struct supertype *st)
+{
+	struct intel_super *super = st->sb;
+
+	if (!super->orom)
+		return 0;
+
+	return imsm_orom_default_chunk(super->orom);
+}
+
 #endif /* MDASSEMBLE */
 
 static int is_rebuilding(struct imsm_dev *dev)
@@ -4384,6 +4401,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			dprintf("imsm: mark resync done\n");
 			end_migration(dev, map_state);
 			super->updates_pending++;
+			a->last_checkpoint = 0;
 		}
 	} else if (!is_resyncing(dev) && !failed) {
 		/* mark the start of the init process if nothing is failed */
@@ -4476,17 +4494,20 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
 		map = get_imsm_map(dev, 0);
 		map->failed_disk_num = ~0;
 		super->updates_pending++;
+		a->last_checkpoint = 0;
 	} else if (map_state == IMSM_T_STATE_DEGRADED &&
 		   map->map_state != map_state &&
 		   !dev->vol.migr_state) {
 		dprintf("imsm: mark degraded\n");
 		map->map_state = map_state;
 		super->updates_pending++;
+		a->last_checkpoint = 0;
 	} else if (map_state == IMSM_T_STATE_FAILED &&
 		   map->map_state != map_state) {
 		dprintf("imsm: mark failed\n");
 		end_migration(dev, map_state);
 		super->updates_pending++;
+		a->last_checkpoint = 0;
 	}
 }
 
@@ -5236,6 +5257,7 @@ struct superswitch super_imsm = {
 	.brief_detail_super = brief_detail_super_imsm,
 	.write_init_super = write_init_super_imsm,
 	.validate_geometry = validate_geometry_imsm,
+	.default_chunk	= default_chunk_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.detail_platform = detail_platform_imsm,
 #endif

----
2/	git://github.com/djbw/mdadm.git subarray

This is a reworked version of the volume delete and rename patches
posted earlier.  The major change, as previously detailed, is
disallowing these operations on active containers.  If we can get
immutable volume-ids in a future version of the metadata, or
infrastructure to notify the rest of the OS about the modified UUID(s)
perhaps we can revisit this restriction.  Two new superswitch methods
are added kill_subarray() and update_subarray(). update_subarray() may
be useful in the future for changing spare-group identifiers in the
metadata.

Dan Williams (2):
      Kill subarray
      Rename subarray

 Kill.c        |   57 ++++++++++++++++++
 Manage.c      |   48 +++++++++++++++
 ReadMe.c      |    2 +
 mdadm.c       |   47 ++++++++++++++-
 mdadm.h       |   14 ++++-
 mdmon.c       |   25 +-------
 super-ddf.c   |   25 +++++++-
 super-intel.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 util.c        |  138 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 483 insertions(+), 53 deletions(-)
diff --git a/Kill.c b/Kill.c
index e738978..032c2d2 100644
--- a/Kill.c
+++ b/Kill.c
@@ -79,3 +79,60 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
 	close(fd);
 	return rv;
 }
+
+int Kill_subarray(char *dev, char *subarray, int quiet)
+{
+	/* Delete a subarray out of a container, the container must be
+	 * inactive.  The subarray string must be a subarray index
+	 * number.
+	 *
+	 * 0 = successfully deleted subarray from all container members
+	 * 1 = failed to sync metadata to one or more devices
+	 * 2 = failed to find the container, subarray, or other resource
+	 *     issue
+	 */
+	struct supertype supertype, *st = &supertype;
+	int fd, rv = 2;
+
+	memset(st, 0, sizeof(*st));
+
+	if (snprintf(st->subarray, sizeof(st->subarray), "%s", subarray) >=
+	    sizeof(st->subarray)) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Input overflow for subarray '%s' > %zu bytes\n",
+				subarray, sizeof(st->subarray) - 1);
+		return 2;
+	}
+
+	fd = open_subarray(dev, st, quiet);
+	if (fd < 0)
+		return 2;
+
+	if (!st->ss->kill_subarray) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Operation not supported for %s metadata\n",
+				st->ss->name);
+		goto free_super;
+	}
+
+	/* ok we've found our victim, drop the axe */
+	st->ss->kill_subarray(st);
+
+	/* FIXME ->sync_metadata() does not report success/failure */
+	st->ss->sync_metadata(st);
+
+	if (!quiet)
+		fprintf(stderr,
+			Name ": Deleted subarray-%s from %s, UUIDs may have changed\n",
+			subarray, dev);
+
+	rv = 0;
+
+ free_super:
+	st->ss->free_super(st);
+	close(fd);
+
+	return rv;
+}
diff --git a/Manage.c b/Manage.c
index f6fb3ef..5c27ddc 100644
--- a/Manage.c
+++ b/Manage.c
@@ -869,4 +869,52 @@ int autodetect(void)
 	}
 	return rv;
 }
+
+int Update_subarray(char *dev, char *subarray, char *update, mddev_ident_t ident, int quiet)
+{
+	struct supertype supertype, *st = &supertype;
+	int fd, rv = 2;
+
+	memset(st, 0, sizeof(*st));
+	if (snprintf(st->subarray, sizeof(st->subarray), "%s", subarray) >=
+	    sizeof(st->subarray)) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Input overflow for subarray '%s' > %zu bytes\n",
+				subarray, sizeof(st->subarray) - 1);
+		return 2;
+	}
+
+	fd = open_subarray(dev, st, quiet);
+	if (fd < 0)
+		return 2;
+
+	if (!st->ss->update_subarray) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Operation not supported for %s metadata\n",
+				st->ss->name);
+		goto free_super;
+	}
+
+	rv = st->ss->update_subarray(st, update, ident);
+
+	if (rv) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to update %s of subarray-%s in %s\n",
+				update, subarray, dev);
+	} else /* FIXME add plumbing to report errors from ->sync_metadata */
+		st->ss->sync_metadata(st);
+
+	if (rv == 0 && strcmp(update, "name") == 0 && !quiet)
+		fprintf(stderr,
+			Name ": Updated subarray-%s name from %s, UUIDs may have changed\n",
+			subarray, dev);
+
+ free_super:
+	st->ss->free_super(st);
+	close(fd);
+
+	return rv;
+}
 #endif
diff --git a/ReadMe.c b/ReadMe.c
index 9d5a211..fa33310 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -108,6 +108,8 @@ struct option long_options[] = {
     {"examine-bitmap", 0, 0, 'X'},
     {"auto-detect", 0, 0, AutoDetect},
     {"detail-platform", 0, 0, DetailPlatform},
+    {"kill-subarray", 1, 0, KillSubarray},
+    {"update-subarray", 1, 0, UpdateSubarray},
 
     /* synonyms */
     {"monitor",   0, 0, 'F'},
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..e7435fd 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -103,6 +103,7 @@ int main(int argc, char *argv[])
 	int dosyslog = 0;
 	int rebuild_map = 0;
 	int auto_update_home = 0;
+	char *subarray = NULL;
 
 	int print_help = 0;
 	FILE *outf;
@@ -216,6 +217,15 @@ int main(int argc, char *argv[])
 		case 'W':
 		case Waitclean:
 		case DetailPlatform:
+		case KillSubarray:
+		case UpdateSubarray:
+			if (opt == KillSubarray || opt == UpdateSubarray) {
+				if (subarray) {
+					fprintf(stderr, Name ": subarray can only be specified once\n");
+					exit(2);
+				}
+				subarray = optarg;
+			}
 		case 'K': if (!mode) newmode = MISC; break;
 		}
 		if (mode && newmode == mode) {
@@ -589,11 +599,16 @@ int main(int argc, char *argv[])
 
 		case O(CREATE,'N'):
 		case O(ASSEMBLE,'N'):
+		case O(MISC,'N'):
 			if (ident.name[0]) {
 				fprintf(stderr, Name ": name cannot be set twice.   "
 					"Second value %s.\n", optarg);
 				exit(2);
 			}
+			if (mode == MISC && !subarray) {
+				fprintf(stderr, Name ": -N/--name only valid with --update-subarray in misc mode\n");
+				exit(2);
+			}
 			if (strlen(optarg) > 32) {
 				fprintf(stderr, Name ": name '%s' is too long, 32 chars max.\n",
 					optarg);
@@ -620,11 +635,16 @@ int main(int argc, char *argv[])
 			continue;
 
 		case O(ASSEMBLE,'U'): /* update the superblock */
+		case O(MISC,'U'):
 			if (update) {
 				fprintf(stderr, Name ": Can only update one aspect of superblock, both %s and %s given.\n",
 					update, optarg);
 				exit(2);
 			}
+			if (mode == MISC && !subarray) {
+				fprintf(stderr, Name ": Only subarrays can be updated in misc mode\n");
+				exit(2);
+			}
 			update = optarg;
 			if (strcmp(update, "sparc2.2")==0)
 				continue;
@@ -807,10 +827,21 @@ int main(int argc, char *argv[])
 		case O(MISC,'W'):
 		case O(MISC, Waitclean):
 		case O(MISC, DetailPlatform):
+		case O(MISC, KillSubarray):
+		case O(MISC, UpdateSubarray):
 			if (devmode && devmode != opt &&
 			    (devmode == 'E' || (opt == 'E' && devmode != 'Q'))) {
-				fprintf(stderr, Name ": --examine/-E cannot be given with -%c\n",
-					devmode =='E'?opt:devmode);
+				fprintf(stderr, Name ": --examine/-E cannot be given with ");
+				if (devmode == 'E') {
+					if (option_index >= 0)
+						fprintf(stderr, "--%s\n",
+							long_options[option_index].name);
+					else
+						fprintf(stderr, "-%c\n", opt);
+				} else if (isalpha(devmode))
+					fprintf(stderr, "-%c\n", devmode);
+				else
+					fprintf(stderr, "previous option\n");
 				exit(2);
 			}
 			devmode = opt;
@@ -1403,6 +1434,18 @@ int main(int argc, char *argv[])
 					rv |= Wait(dv->devname); continue;
 				case Waitclean:
 					rv |= WaitClean(dv->devname, -1, verbose-quiet); continue;
+				case KillSubarray:
+					rv |= Kill_subarray(dv->devname, subarray, quiet);
+					continue;
+				case UpdateSubarray:
+					if (update == NULL) {
+						fprintf(stderr,
+							Name ": -U/--update must be specified with --update-subarray\n");
+						rv |= 1;
+						continue;
+					}
+					rv |= Update_subarray(dv->devname, subarray, update, &ident, quiet);
+					continue;
 				}
 				mdfd = open_mddev(dv->devname, 1);
 				if (mdfd>=0) {
diff --git a/mdadm.h b/mdadm.h
index d9d17b0..515da0d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -258,6 +258,7 @@ extern char Version[], Usage[], Help[], OptionHelp[],
 
 /* for option that don't have short equivilents, we assign arbitrary
  * small numbers.  '1' means an undecorated option, so we start at '2'.
+ * (note we must stop before we get to 65 i.e. 'A')
  */
 enum special_options {
 	AssumeClean = 2,
@@ -266,13 +267,15 @@ enum special_options {
 	ReAdd,
 	NoDegraded,
 	Sparc22,
-	BackupFile,
+	BackupFile, /* 8 */
 	HomeHost,
 	AutoHomeHost,
 	Symlinks,
 	AutoDetect,
 	Waitclean,
 	DetailPlatform,
+	KillSubarray,
+	UpdateSubarray, /* 16 */
 };
 
 /* structures read from config file */
@@ -609,6 +612,10 @@ extern struct superswitch {
 	struct mdinfo *(*container_content)(struct supertype *st);
 	/* Allow a metadata handler to override mdadm's default layouts */
 	int (*default_layout)(int level); /* optional */
+	/* Permit subarray's to be deleted from inactive containers */
+	void (*kill_subarray)(struct supertype *st); /* optional */
+	/* Permit subarray's to be modified */
+	int (*update_subarray)(struct supertype *st, char *update, mddev_ident_t ident); /* optional */
 
 /* for mdmon */
 	int (*open_new)(struct supertype *c, struct active_array *a,
@@ -805,6 +812,8 @@ extern int Monitor(mddev_dev_t devlist,
 		   int dosyslog, int test, char *pidfile, int increments);
 
 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
+extern int Kill_subarray(char *dev, char *subarray, int quiet);
+extern int Update_subarray(char *dev, char *subarray, char *update, mddev_ident_t ident, int quiet);
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int sock, int verbose);
 
@@ -911,6 +920,9 @@ extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
 #define	METADATA 3
 extern int open_mddev(char *dev, int report_errors);
 extern int open_container(int fd);
+extern int is_container_member(struct mdstat_ent *ent, char *devname);
+extern int open_subarray(char *dev, struct supertype *st, int quiet);
+extern struct superswitch *version_to_superswitch(char *vers);
 
 extern char *pid_dir;
 extern int mdmon_running(int devnum);
diff --git a/mdmon.c b/mdmon.c
index 69c320e..beb39cf 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -104,15 +104,6 @@ int __clone2(int (*fn)(void *),
 	return mon_tid;
 }
 
-static struct superswitch *find_metadata_methods(char *vers)
-{
-	if (strcmp(vers, "ddf") == 0)
-		return &super_ddf;
-	if (strcmp(vers, "imsm") == 0)
-		return &super_imsm;
-	return NULL;
-}
-
 static int make_pidfile(char *devname)
 {
 	char path[100];
@@ -136,18 +127,6 @@ static int make_pidfile(char *devname)
 	return 0;
 }
 
-int is_container_member(struct mdstat_ent *mdstat, char *container)
-{
-	if (mdstat->metadata_version == NULL ||
-	    strncmp(mdstat->metadata_version, "external:", 9) != 0 ||
-	    !is_subarray(mdstat->metadata_version+9) ||
-	    strncmp(mdstat->metadata_version+10, container, strlen(container)) != 0 ||
-	    mdstat->metadata_version[10+strlen(container)] != '/')
-		return 0;
-
-	return 1;
-}
-
 static void try_kill_monitor(pid_t pid, char *devname, int sock)
 {
 	char buf[100];
@@ -414,9 +393,9 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
 		exit(3);
 	}
 
-	container->ss = find_metadata_methods(mdi->text_version);
+	container->ss = version_to_superswitch(mdi->text_version);
 	if (container->ss == NULL) {
-		fprintf(stderr, "mdmon: %s uses unknown metadata: %s\n",
+		fprintf(stderr, "mdmon: %s uses unsupported metadata: %s\n",
 			devname, mdi->text_version);
 		exit(3);
 	}
diff --git a/super-ddf.c b/super-ddf.c
index 0e6f1e5..736e07f 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -845,10 +845,18 @@ static int load_super_ddf(struct supertype *st, int fd,
 	}
 
 	if (st->subarray[0]) {
+		unsigned long val;
 		struct vcl *v;
+		char *ep;
+
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free(super);
+			return 1;
+		}
 
 		for (v = super->conflist; v; v = v->next)
-			if (v->vcnum == atoi(st->subarray))
+			if (v->vcnum == val)
 				super->currentconf = v;
 		if (!super->currentconf) {
 			free(super);
@@ -2870,14 +2878,25 @@ static int load_super_ddf_all(struct supertype *st, int fd,
 			return 1;
 	}
 	if (st->subarray[0]) {
+		unsigned long val;
 		struct vcl *v;
+		char *ep;
+
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free(super);
+			return 1;
+		}
 
 		for (v = super->conflist; v; v = v->next)
-			if (v->vcnum == atoi(st->subarray))
+			if (v->vcnum == val)
 				super->currentconf = v;
-		if (!super->currentconf)
+		if (!super->currentconf) {
+			free(super);
 			return 1;
+		}
 	}
+
 	*sbp = super;
 	if (st->ss == NULL) {
 		st->ss = &super_ddf;
diff --git a/super-intel.c b/super-intel.c
index bdd7a96..f63e737 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2753,11 +2753,20 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 	}
 
 	if (st->subarray[0]) {
-		if (atoi(st->subarray) <= super->anchor->num_raid_devs)
-			super->current_vol = atoi(st->subarray);
+		unsigned long val;
+		char *ep;
+
+		err = 1;
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free_imsm(super);
+			goto error;
+		}
+
+		if (val < super->anchor->num_raid_devs)
+			super->current_vol = val;
 		else {
 			free_imsm(super);
-			err = 1;
 			goto error;
 		}
 	}
@@ -2824,8 +2833,17 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	}
 
 	if (st->subarray[0]) {
-		if (atoi(st->subarray) <= super->anchor->num_raid_devs)
-			super->current_vol = atoi(st->subarray);
+		unsigned long val;
+		char *ep;
+
+		val = strtoul(st->subarray, &ep, 10);
+		if (*ep != '\0') {
+			free_imsm(super);
+			return 1;
+		}
+
+		if (val < super->anchor->num_raid_devs)
+			super->current_vol = val;
 		else {
 			free_imsm(super);
 			return 1;
@@ -2915,6 +2933,43 @@ static void imsm_update_version_info(struct intel_super *super)
 	}
 }
 
+static int check_name(struct intel_super *super, char *name)
+{
+	struct imsm_super *mpb = super->anchor;
+	char *reason = NULL; 
+	int i;
+
+	if (check_env("IMSM_NO_PLATFORM"))
+		return 1;
+
+	if (!isalpha(name[0]))
+		reason = "must start with a letter";
+
+	for (i = 0; name[i]; i++) {
+		if (isalnum(name[i]) || name[i] == '_' || name[i] == ':')
+			continue;
+		reason = "must only contain characters 'A-Za-z0-9_:'";
+		break;
+	}
+
+	if (i > MAX_RAID_SERIAL_LEN)
+		reason = "must be 16 characters or less";
+
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct imsm_dev *dev = get_imsm_dev(super, i);
+
+		if (strncmp((char *) dev->volume, name, MAX_RAID_SERIAL_LEN) == 0) {
+			reason = "already exists";
+			break;
+		}
+	}
+
+	if (reason)
+		fprintf(stderr, Name ": imsm volume name %s\n", reason);
+
+	return !reason;
+}
+
 static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 				  unsigned long long size, char *name,
 				  char *homehost, int *uuid)
@@ -2966,16 +3021,8 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	if (super->current_vol == 0)
 		mpb->num_disks = 0;
 
-	for (i = 0; i < super->current_vol; i++) {
-		dev = get_imsm_dev(super, i);
-		if (strncmp((char *) dev->volume, name,
-			     MAX_RAID_SERIAL_LEN) == 0) {
-			fprintf(stderr, Name": '%s' is already defined for this container\n",
-				name);
-			return 0;
-		}
-	}
-
+	if (!check_name(super, name))
+		return 0;
 	sprintf(st->subarray, "%d", idx);
 	dv = malloc(sizeof(*dv));
 	if (!dv) {
@@ -4007,6 +4054,78 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 	close(cfd);
 	return 0;
 }
+
+static void handle_missing(struct intel_super *super, struct imsm_dev *dev);
+
+static void kill_subarray_imsm(struct supertype *st)
+{
+	/* remove the subarray currently referenced by ->current_vol */
+	struct intel_dev **dp;
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super->anchor;
+
+	if (super->current_vol < 0)
+		return;
+
+	for (dp = &super->devlist; *dp;)
+		if ((*dp)->index == super->current_vol) {
+			*dp = (*dp)->next;
+		} else {
+			handle_missing(super, (*dp)->dev);
+			if ((*dp)->index > super->current_vol)
+				(*dp)->index--;
+			dp = &(*dp)->next;
+		}
+
+	/* no more raid devices, all active components are now spares,
+	 * but of course failed are still failed
+	 */
+	if (--mpb->num_raid_devs == 0) {
+		struct dl *d;
+
+		for (d = super->disks; d; d = d->next)
+			if (d->index > -2) {
+				d->index = -1;
+				d->disk.status = SPARE_DISK;
+			}
+	}
+
+	super->current_vol = -1;
+	super->updates_pending++;
+}
+
+static int update_subarray_imsm(struct supertype *st, char *update, mddev_ident_t ident)
+{
+	/* update the subarray currently referenced by ->current_vol */
+	int i;
+	struct imsm_dev *dev;
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super->anchor;
+
+	if (super->current_vol < 0)
+		return 2;
+
+	if (strcmp(update, "name") == 0) {
+		char *name = ident->name;
+
+		if (!check_name(super, name))
+			return 2;
+
+		dev = get_imsm_dev(super, super->current_vol);
+		snprintf((char *) dev->volume, MAX_RAID_SERIAL_LEN, "%s", name);
+	} else
+		return 2;
+
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		dev = get_imsm_dev(super, i);
+		handle_missing(super, dev);
+	}
+
+	super->current_vol = -1;
+	super->updates_pending++;
+
+	return 0;
+}
 #endif /* MDASSEMBLE */
 
 static int is_rebuilding(struct imsm_dev *dev)
@@ -4347,6 +4466,24 @@ static void mark_missing(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 	memmove(&disk->serial[0], &disk->serial[1], MAX_RAID_SERIAL_LEN - 1);
 }
 
+static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
+{
+	__u8 map_state;
+	struct dl *dl;
+	int failed;
+
+	if (!super->missing)
+		return;
+	failed = imsm_count_failed(super, dev);
+	map_state = imsm_check_degraded(super, dev, failed);
+
+	dprintf("imsm: mark missing\n");
+	end_migration(dev, map_state);
+	for (dl = super->missing; dl; dl = dl->next)
+		mark_missing(dev, &dl->disk, dl->index);
+	super->updates_pending++;
+}
+
 /* Handle dirty -> clean transititions and resync.  Degraded and rebuild
  * states are handled in imsm_set_disk() with one exception, when a
  * resync is stopped due to a new failure this routine will set the
@@ -4363,15 +4500,8 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	__u32 blocks_per_unit;
 
 	/* before we activate this array handle any missing disks */
-	if (consistent == 2 && super->missing) {
-		struct dl *dl;
-
-		dprintf("imsm: mark missing\n");
-		end_migration(dev, map_state);
-		for (dl = super->missing; dl; dl = dl->next)
-			mark_missing(dev, &dl->disk, dl->index);
-		super->updates_pending++;
-	}
+	if (consistent == 2)
+		handle_missing(super, dev);
 
 	if (consistent == 2 &&
 	    (!is_resync_complete(&a->info) ||
@@ -5242,6 +5372,8 @@ struct superswitch super_imsm = {
 	.validate_geometry = validate_geometry_imsm,
 	.add_to_super	= add_to_super_imsm,
 	.detail_platform = detail_platform_imsm,
+	.kill_subarray = kill_subarray_imsm,
+	.update_subarray = update_subarray_imsm,
 #endif
 	.match_home	= match_home_imsm,
 	.uuid_from_super= uuid_from_super_imsm,
diff --git a/util.c b/util.c
index 25f1e56..1ef181d 100644
--- a/util.c
+++ b/util.c
@@ -1392,6 +1392,144 @@ int open_container(int fd)
 	return -1;
 }
 
+struct superswitch *version_to_superswitch(char *vers)
+{
+	int i;
+
+	for (i = 0; superlist[i]; i++) {
+		struct superswitch *ss = superlist[i];
+
+		if (strcmp(vers, ss->name) == 0)
+			return ss;
+	}
+
+	return NULL;
+}
+
+int is_container_member(struct mdstat_ent *mdstat, char *container)
+{
+	if (mdstat->metadata_version == NULL ||
+	    strncmp(mdstat->metadata_version, "external:", 9) != 0 ||
+	    !is_subarray(mdstat->metadata_version+9) ||
+	    strncmp(mdstat->metadata_version+10, container, strlen(container)) != 0 ||
+	    mdstat->metadata_version[10+strlen(container)] != '/')
+		return 0;
+
+	return 1;
+}
+
+/* open_subarray - opens a subarray within an inactive container
+ * @dev: container device name
+ * @st: supertype with only ->subarray set
+ * @quiet: block reporting errors flag
+ *
+ * On success returns an fd to a container and fills in *st
+ */
+int open_subarray(char *dev, struct supertype *st, int quiet)
+{
+	struct mdstat_ent *mdstat, *ent;
+	struct mdinfo *mdi;
+	int fd, err = 1;
+
+	fd = open(dev, O_RDWR|O_EXCL);
+	if (fd < 0) {
+		if (!quiet)
+			fprintf(stderr, Name ": Couldn't open %s, aborting\n",
+				dev);
+		return 2;
+	}
+
+	st->devnum = fd2devnum(fd);
+	if (st->devnum == NoMdDev) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Failed to determine device number for %s\n",
+				dev);
+		goto close_fd;
+	}
+
+	mdi = sysfs_read(fd, st->devnum, GET_VERSION|GET_LEVEL);
+	if (!mdi) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to read sysfs for %s\n",
+				dev);
+		goto close_fd;
+	}
+
+	if (mdi->array.level != UnSet) {
+		if (!quiet)
+			fprintf(stderr, Name ": %s is not a container\n", dev);
+		goto free_sysfs;
+	}
+
+	st->ss = version_to_superswitch(mdi->text_version);
+	if (!st->ss) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": Operation not supported for %s metadata\n",
+				mdi->text_version);
+		goto free_sysfs;
+	}
+
+	st->devname = devnum2devname(st->devnum);
+	if (!st->devname) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to allocate device name\n");
+		goto free_sysfs;
+	}
+
+	if (st->ss->load_super(st, fd, NULL)) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to find subarray-%s in %s\n",
+				st->subarray, dev);
+		goto free_name;
+	}
+
+	if (!st->loaded_container) {
+		if (!quiet)
+			fprintf(stderr, Name ": %s is not a container\n", dev);
+		goto free_super;
+	}
+
+	mdstat = mdstat_read(0, 0);
+	if (!mdstat) {
+		if (!quiet)
+			fprintf(stderr, Name ": Failed to read /proc/mdstat\n");
+		goto free_super;
+	}
+
+	for (ent = mdstat; ent; ent = ent->next)
+		if (is_container_member(ent, st->devname))
+			break;
+	if (ent) {
+		if (!quiet)
+			fprintf(stderr,
+				Name ": %s has active subarray(s), aborting\n",
+				dev);
+		goto free_mdstat;
+	}
+
+	err = 0;
+
+ free_mdstat:
+	free_mdstat(mdstat);
+ free_super:
+	if (err)
+		st->ss->free_super(st);
+ free_name:
+	free(st->devname);
+ free_sysfs:
+	sysfs_free(mdi);
+ close_fd:
+	if (err)
+		close(fd);
+
+	if (err)
+		return -1;
+	else
+		return fd;
+}
+
 int add_disk(int mdfd, struct supertype *st,
 	     struct mdinfo *sra, struct mdinfo *info)
 {

----
3/	git://github.com/djbw/mdadm.git hotplug

This branch addresses a long standing problem with imsm incremental
assembly.  The current count_active() and enough() routines are unable
to capture all the corner cases of determining when a container is ready
to be assembled, so I add a ->container_enough flag to allow external
metadata handlers to self report.  Note that I punted on ddf.  This now
does the 'right thing' when hot plugging various members of a raid10
array i.e. like allow -R when one of each mirror has arrived, and catch
single-degraded to double-degraded transitions.

Dan Williams (2):
      Incremental: honor an 'enough' flag from external handlers
      Revert "Incremental: honor --no-degraded to delay assembly"

 Incremental.c |   14 ++++++--
 mdadm.8       |    5 ---
 mdadm.c       |    1 -
 mdadm.h       |    4 ++-
 super-ddf.c   |    1 +
 super-intel.c |   99 +++++++++++++++++++++++++++++++++++++++++++++-----------
 6 files changed, 93 insertions(+), 31 deletions(-)
diff --git a/Incremental.c b/Incremental.c
index 7ad648a..d6dd0f4 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -258,6 +258,15 @@ int Incremental(char *devname, int verbose, int runstop,
 		autof = ci->autof;
 
 	if (st->ss->container_content && st->loaded_container) {
+		if ((runstop > 0 && info.container_enough >= 0) ||
+		    info.container_enough > 0)
+			/* pass */;
+		else {
+			if (verbose)
+				fprintf(stderr, Name ": not enough devices to start the container\n");
+			return 1;
+		}
+
 		/* This is a pre-built container array, so we do something
 		 * rather different.
 		 */
@@ -428,8 +437,6 @@ int Incremental(char *devname, int verbose, int runstop,
 				chosen_name, info.array.working_disks);
 		wait_for(chosen_name, mdfd);
 		close(mdfd);
-		if (runstop < 0)
-			return 0; /* don't try to assemble */
 		rv = Incremental(chosen_name, verbose, runstop,
 				 NULL, homehost, require_homehost, autof);
 		if (rv == 1)
@@ -443,8 +450,7 @@ int Incremental(char *devname, int verbose, int runstop,
 	active_disks = count_active(st, mdfd, &avail, &info);
 	if (enough(info.array.level, info.array.raid_disks,
 		   info.array.layout, info.array.state & 1,
-		   avail, active_disks) == 0 ||
-	    (runstop < 0 && active_disks < info.array.raid_disks)) {
+		   avail, active_disks) == 0) {
 		free(avail);
 		if (verbose >= 0)
 			fprintf(stderr, Name
diff --git a/mdadm.8 b/mdadm.8
index 4edfc41..90470d9 100644
--- a/mdadm.8
+++ b/mdadm.8
@@ -1219,11 +1219,6 @@ Run any array assembled as soon as a minimal number of devices are
 available, rather than waiting until all expected devices are present.
 
 .TP
-.B \-\-no\-degraded
-This allows the hot-plug system to prevent arrays from running when it knows
-that more disks may arrive later in the discovery process.
-
-.TP
 .BR \-\-scan ", " \-s
 Only meaningful with
 .B \-R
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..a401be2 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -671,7 +671,6 @@ int main(int argc, char *argv[])
 		"     'summaries', 'homehost', 'byteorder', 'devicesize'.\n");
 			exit(outf == stdout ? 0 : 2);
 
-		case O(INCREMENTAL,NoDegraded):
 		case O(ASSEMBLE,NoDegraded): /* --no-degraded */
 			runstop = -1; /* --stop isn't allowed for --assemble,
 				       * so we overload slightly */
diff --git a/mdadm.h b/mdadm.h
index d9d17b0..a0797e8 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -205,7 +205,9 @@ struct mdinfo {
 	int container_member; /* for assembling external-metatdata arrays
 			       * This is to be used internally by metadata
 			       * handler only */
-
+	int container_enough; /* flag external handlers can set to
+			       * indicate that subarrays have not enough (-1),
+			       * enough to start (0), or all expected disks (1) */
 	char 		sys_name[20];
 	struct mdinfo *devs;
 	struct mdinfo *next;
diff --git a/super-ddf.c b/super-ddf.c
index 0e6f1e5..b01c68d 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1357,6 +1357,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info)
 							 (ddf->anchor.guid+16));
 	info->array.utime	  = 0;
 	info->array.chunk_size	  = 0;
+	info->container_enough	  = 0;
 
 
 	info->disk.major = 0;
diff --git a/super-intel.c b/super-intel.c
index bdd7a96..88ffb52 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -344,7 +344,6 @@ static struct imsm_disk *__get_imsm_disk(struct imsm_super *mpb, __u8 index)
 	return &mpb->disk[index];
 }
 
-#ifndef MDASSEMBLE
 /* retrieve a disk from the parsed metadata */
 static struct imsm_disk *get_imsm_disk(struct intel_super *super, __u8 index)
 {
@@ -356,7 +355,6 @@ static struct imsm_disk *get_imsm_disk(struct intel_super *super, __u8 index)
 	
 	return NULL;
 }
-#endif
 
 /* generate a checksum directly from the anchor when the anchor is known to be
  * up-to-date, currently only at load or write_super after coalescing
@@ -1528,6 +1526,20 @@ static void fixup_container_spare_uuid(struct mdinfo *inf)
 	}
 }
 
+
+static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev, int failed);
+static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev);
+
+static struct imsm_disk *get_imsm_missing(struct intel_super *super, __u8 index)
+{
+	struct dl *d;
+
+	for (d = super->missing; d; d = d->next)
+		if (d->index == index)
+			return &d->disk;
+	return NULL;
+}
+
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 {
 	struct intel_super *super = st->sb;
@@ -1562,6 +1574,53 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
 	info->name[0] = 0;
 	info->recovery_start = MaxSector;
 
+	/* do we have the all the insync disks that we expect? */
+	if (st->loaded_container) {
+		struct imsm_super *mpb = super->anchor;
+		int max_enough = -1, i;
+
+		for (i = 0; i < mpb->num_raid_devs; i++) {
+			struct imsm_dev *dev = get_imsm_dev(super, i);
+			int failed, enough, j, missing = 0;
+			struct imsm_map *map;
+			__u8 state;
+
+			failed = imsm_count_failed(super, dev);
+			state = imsm_check_degraded(super, dev, failed);
+			map = get_imsm_map(dev, dev->vol.migr_state);
+
+			/* any newly missing disks?
+			 * (catches single-degraded vs double-degraded)
+			 */
+			for (j = 0; j < map->num_members; j++) {
+				__u32 ord = get_imsm_ord_tbl_ent(dev, i);
+				__u32 idx = ord_to_idx(ord);
+
+				if (!(ord & IMSM_ORD_REBUILD) &&
+				    get_imsm_missing(super, idx)) {
+					missing = 1;
+					break;
+				}
+			}
+
+			if (state == IMSM_T_STATE_FAILED)
+				enough = -1;
+			else if (state == IMSM_T_STATE_DEGRADED &&
+				 (state != map->map_state || missing))
+				enough = 0;
+			else /* we're normal, or already degraded */
+				enough = 1;
+
+			/* in the missing/failed disk case check to see
+			 * if at least one array is runnable
+			 */
+			max_enough = max(max_enough, enough);
+		}
+		dprintf("%s: enough: %d\n", __func__, max_enough);
+		info->container_enough = max_enough;
+	} else
+		info->container_enough = -1;
+
 	if (super->disks) {
 		__u32 reserved = imsm_reserved_sectors(super, super->disks);
 
@@ -4175,24 +4234,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 }
 
 
-#ifndef MDASSEMBLE
-static int imsm_open_new(struct supertype *c, struct active_array *a,
-			 char *inst)
-{
-	struct intel_super *super = c->sb;
-	struct imsm_super *mpb = super->anchor;
-	
-	if (atoi(inst) >= mpb->num_raid_devs) {
-		fprintf(stderr, "%s: subarry index %d, out of range\n",
-			__func__, atoi(inst));
-		return -ENODEV;
-	}
-
-	dprintf("imsm: open_new %s\n", inst);
-	a->info.container_member = atoi(inst);
-	return 0;
-}
-
 static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev, int failed)
 {
 	struct imsm_map *map = get_imsm_map(dev, 0);
@@ -4291,6 +4332,24 @@ static int imsm_count_failed(struct intel_super *super, struct imsm_dev *dev)
 	return failed;
 }
 
+#ifndef MDASSEMBLE
+static int imsm_open_new(struct supertype *c, struct active_array *a,
+			 char *inst)
+{
+	struct intel_super *super = c->sb;
+	struct imsm_super *mpb = super->anchor;
+	
+	if (atoi(inst) >= mpb->num_raid_devs) {
+		fprintf(stderr, "%s: subarry index %d, out of range\n",
+			__func__, atoi(inst));
+		return -ENODEV;
+	}
+
+	dprintf("imsm: open_new %s\n", inst);
+	a->info.container_member = atoi(inst);
+	return 0;
+}
+
 static int is_resyncing(struct imsm_dev *dev)
 {
 	struct imsm_map *migr_map;

----
4/	git://github.com/djbw/mdadm.git fixes

Miscellaneous fixes.

Dan Williams (1):
      imsm: robustify recovery-start detection

Przemyslaw Hawrylewicz Czarnowski (1):
      fix: memory leak in mdmon_pid()

 super-intel.c |    9 +++++++++
 util.c        |    6 +++++-
 2 files changed, 14 insertions(+), 1 deletions(-)
diff --git a/super-intel.c b/super-intel.c
index bdd7a96..dd9699d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4044,6 +4044,15 @@ static void update_recovery_start(struct imsm_dev *dev, struct mdinfo *array)
 			rebuild = d;
 		}
 
+	if (!rebuild) {
+		/* (?) none of the disks are marked with
+		 * IMSM_ORD_REBUILD, so assume they are missing and the
+		 * disk_ord_tbl was not correctly updated
+		 */
+		dprintf("%s: failed to locate out-of-sync disk\n", __func__);
+		return;
+	}
+
 	units = __le32_to_cpu(dev->vol.curr_migr_unit);
 	rebuild->recovery_start = units * blocks_per_migr_unit(dev);
 }
diff --git a/util.c b/util.c
index 25f1e56..8315200 100644
--- a/util.c
+++ b/util.c
@@ -1532,7 +1532,11 @@ int mdmon_pid(int devnum)
 	char pid[10];
 	int fd;
 	int n;
-	sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
+	char *devname = devnum2devname(devnum);
+
+	sprintf(path, "%s/%s.pid", pid_dir, devname);
+	free(devname);
+
 	fd = open(path, O_RDONLY | O_NOATIME, 0);
 
 	if (fd < 0)


