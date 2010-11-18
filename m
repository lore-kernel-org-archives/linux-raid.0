From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 12/13] External reshape (step 1): container reshape and
	->reshape_super()
Date: Thu, 18 Nov 2010 10:22:59 +0100
Message-ID: <20101118092259.29508.92694.stgit@gklab-170-111.igk.intel.com>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

In the native metadata case Grow_reshape() and the kernel validate what
reshapes are possible / supported and the kernel handles all the metadata
updates.  In the external case the metadata format may have specific
constraints above this baseline.  External formats also introduce the
constraint of only permitting some reshapes at container scope versus subarray
scope.  For exmaple imsm changes to 'raiddisks' must be applied to all arrays
in the container.

This operation assumes that its 'st' parameter has been obtained from
super_by_fd() (such that st->subarray is up to date), and that a snapshot of
the metadata has been loaded from the container.

Why a new method, versus extending an existing one?
->validate_geometry: this routine assumes it is being called from Create(),
adding reshape complicates the cases that this routine needs to handle.  Where
we find that checks can be shared between the two cases those routines
refactored into common code internal to the metadata handler, i.e. no need to
provide a unified external interface.  ->validate_geometry() also does not
expect to update the metadata.

->update_super: this is meant to update single fields at Assembly() and only at
the container scope.  Reshape potentially wants to update multiple fields at
either container or subarray scope.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Grow.c  |  390 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mdadm.h |    9 +
 2 files changed, 391 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index bf634d3..59032ef 100644
--- a/Grow.c
+++ b/Grow.c
@@ -474,8 +474,222 @@ static void wait_reshape(struct mdinfo *sra)
 		}
 	} while  (strncmp(action, "reshape", 7) == 0);
 }
-			
-		
+
+static int reshape_super(struct supertype *st, long long size, int level,
+			 int layout, int chunksize, int raid_disks,
+			 char *backup_file, char *dev, int verbose)
+{
+	/* nothing extra to check in the native case */
+	if (!st->ss->external)
+		return 0;
+	if (!st->ss->reshape_super ||
+	    !st->ss->manage_reshape) {
+		fprintf(stderr, Name ": %s metadata does not support reshape\n",
+			st->ss->name);
+		return 1;
+	}
+
+	return st->ss->reshape_super(st, size, level, layout, chunksize,
+				     raid_disks, backup_file, dev, verbose);
+}
+
+static void sync_metadata(struct supertype *st)
+{
+	if (st->ss->external) {
+		if (st->update_tail)
+			flush_metadata_updates(st);
+		else
+			st->ss->sync_metadata(st);
+	}
+}
+
+static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int n)
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
+	if (rc < 0 && errno == EAGAIN) {
+		ping_monitor(container);
+		/* if we get EAGAIN here then the monitor is not active
+		 * so stop trying
+		 */
+		rc = sysfs_set_num(sra, NULL, name, n);
+	}
+	sysfs_set_str(sra, NULL, "safe_mode_delay", safe);
+	return rc;
+}
+
+static int reshape_container_raid_disks(char *container, int raid_disks)
+{
+	/* for each subarray switch to a raid level that can
+	 * support the reshape, and set raid disks
+	 */
+	struct mdstat_ent *ent, *e;
+	int changed = 0, rv = 0, err = 0;
+
+	ent = mdstat_read(1, 0);
+	if (!ent) {
+		fprintf(stderr, Name ": unable to read /proc/mdstat\n");
+		return -1;
+	}
+
+	changed = 0;
+	for (e = ent; e; e = e->next) {
+		struct mdinfo *sub;
+		unsigned int cache;
+		int level, takeover_delta = 0;
+
+		if (!is_container_member(e, container))
+			continue;
+
+		level = map_name(pers, e->level);
+		if (level == 0) {
+			sub = sysfs_read(-1, e->devnum, GET_VERSION);
+			if (!sub)
+				break;
+			/* metadata records 'orig_level' */
+			rv = sysfs_set_num(sub, NULL, "level", 4);
+			if (rv < 0) {
+				err = errno;
+				break;
+			}
+			/* we want spares to be used for capacity
+			 * expansion, not rebuild
+			 */
+			takeover_delta = 1;
+
+			sysfs_free(sub);
+			level = 4;
+		}
+
+		sub = NULL;
+		switch (level) {
+		default:
+			rv = -1;
+			break;
+		case 4:
+		case 5:
+		case 6:
+			sub = sysfs_read(-1, e->devnum, GET_CHUNK|GET_CACHE);
+			if (!sub)
+				break;
+			cache = (sub->array.chunk_size / 4096) * 4;
+			if (cache > sub->cache_size)
+				rv = subarray_set_num(container, sub,
+						      "stripe_cache_size", cache);
+			if (rv) {
+				err = errno;
+				break;
+			}
+			/* fall through */
+		case 1:
+			if (!sub)
+				sub = sysfs_read(-1, e->devnum, GET_VERSION);
+			if (!sub)
+				break;
+
+			rv = subarray_set_num(container, sub, "raid_disks",
+					      raid_disks + takeover_delta);
+			if (rv)
+				err = errno;
+			else
+				changed++;
+			break;
+		}
+		sysfs_free(sub);
+		if (rv)
+			break;
+	}
+	free_mdstat(ent);
+	if (rv) {
+		fprintf(stderr, Name
+			": failed to initiate container reshape%s%s\n",
+			err ? ": " : "", err ? strerror(err) : "");
+		return rv;
+	}
+
+	return changed;
+}
+
+static void revert_container_raid_disks(struct supertype *st, int fd, char *container)
+{
+	/* we failed to prepare all subarrays in the container for
+	 * reshape, so cancel the changes and restore the nominal raid
+	 * level
+	 */
+	struct mdstat_ent *ent, *e;
+
+	ent = mdstat_read(0, 0);
+	if (!ent) {
+		fprintf(stderr, Name
+			": failed to read /proc/mdstat while aborting reshape\n");
+		return;
+	}
+
+	for (e = ent; e; e = e->next) {
+		int level_fixed = 0, disks_fixed = 0;
+		struct mdinfo *sub, prev;
+
+		if (!is_container_member(e, container))
+			continue;
+
+		st->ss->free_super(st);
+		sprintf(st->subarray, "%s", to_subarray(e, container));
+		if (st->ss->load_super(st, fd, NULL)) {
+			fprintf(stderr, Name
+				": failed read metadata while aborting reshape\n");
+			continue;
+		}
+		st->ss->getinfo_super(st, &prev);
+
+		/* changing level might change raid_disks so we do it
+		 * first and then check if raid_disks still needs fixing
+		 */
+		if (map_name(pers, e->level) != prev.array.level) {
+			sub = sysfs_read(-1, e->devnum, GET_VERSION);
+			if (sub &&
+			    !sysfs_set_num(sub, NULL, "level", prev.array.level))
+				level_fixed = 1;
+			sysfs_free(sub);
+		} else
+			level_fixed = 1;
+
+		sub = sysfs_read(-1, e->devnum, GET_DISKS);
+		if (sub && sub->array.raid_disks != prev.array.raid_disks) {
+			if (!subarray_set_num(container, sub, "raid_disks",
+					      prev.array.raid_disks))
+				disks_fixed = 1;
+		} else if (sub)
+			disks_fixed = 1;
+		sysfs_free(sub);
+
+		if (!disks_fixed || !level_fixed)
+			fprintf(stderr, Name
+				": failed to restore %s to a %d-disk %s array\n",
+				e->dev, prev.array.raid_disks,
+				map_num(pers, prev.array.level));
+	}
+	free_mdstat(ent);
+}
+
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
 		 int level, char *layout_str, int chunksize, int raid_disks)
@@ -518,6 +732,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	unsigned long cache;
 	unsigned long long array_size;
 	int changed = 0;
+	char *container = NULL;
+	int cfd = -1;
 	int done;
 
 	struct mdinfo *sra;
@@ -545,10 +761,65 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			"       Please use a newer kernel\n");
 		return 1;
 	}
+
+	st = super_by_fd(fd);
+	if (!st) {
+		fprintf(stderr, Name ": Unable to determine metadata format for %s\n", devname);
+		return 1;
+	}
+
+	/* in the external case we need to check that the requested reshape is
+	 * supported, and perform an initial check that the container holds the
+	 * pre-requisite spare devices (mdmon owns final validation)
+	 */
+	if (st->ss->external) {
+		int container_dev;
+
+		if (st->subarray[0]) {
+			container_dev = st->container_dev;
+			cfd = open_dev_excl(st->container_dev);
+		} else if (size >= 0 || layout_str != NULL || chunksize != 0 ||
+			   level != UnSet) {
+			fprintf(stderr,
+				Name ": %s is a container, only 'raid-devices' can be changed\n",
+				devname);
+			return 1;
+		} else {
+			container_dev = st->devnum;
+			close(fd);
+			cfd = open_dev_excl(st->devnum);
+			fd = cfd;
+		}
+		if (cfd < 0) {
+			fprintf(stderr, Name ": Unable to open container for %s\n",
+				devname);
+			return 1;
+		}
+
+		container = devnum2devname(st->devnum);
+		if (!container) {
+			fprintf(stderr, Name ": Could not determine container name\n");
+			return 1;
+		}
+
+		if (st->ss->load_super(st, cfd, NULL)) {
+			fprintf(stderr, Name ": Cannot read superblock for %s\n",
+				devname);
+			return 1;
+		}
+
+		if (mdmon_running(container_dev))
+			st->update_tail = &st->updates;
+	}
+
 	sra = sysfs_read(fd, 0, GET_LEVEL);
-	if (sra)
+	if (sra) {
+		if (st->ss->external && st->subarray[0] == 0) {
+			array.level = LEVEL_CONTAINER;
+			sra->array.level = LEVEL_CONTAINER;
+		}
 		frozen = freeze_array(sra);
-	else {
+	} else {
 		fprintf(stderr, Name ": failed to read sysfs parameters for %s\n",
 			devname);
 		return 1;
@@ -559,8 +830,16 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		return 1;
 	}
 
+
 	/* ========= set size =============== */
 	if (size >= 0 && (size == 0 || size != array.size)) {
+		long long orig_size = array.size;
+
+		if (reshape_super(st, size, UnSet, UnSet, 0, 0, NULL, devname, !quiet)) {
+			rv = 1;
+			goto release;
+		}
+		sync_metadata(st);
 		array.size = size;
 		if (array.size != size) {
 			/* got truncated to 32bit, write to
@@ -575,6 +854,11 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			rv = ioctl(fd, SET_ARRAY_INFO, &array);
 		if (rv != 0) {
 			int err = errno;
+
+			/* restore metadata */
+			if (reshape_super(st, orig_size, UnSet, UnSet, 0, 0,
+					  NULL, devname, !quiet) == 0)
+				sync_metadata(st);
 			fprintf(stderr, Name ": Cannot set device size for %s: %s\n",
 				devname, strerror(err));
 			if (err == EBUSY && 
@@ -591,7 +875,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			fprintf(stderr, Name ": component size of %s has been set to %lluK\n",
 				devname, size);
 		changed = 1;
-	} else {
+	} else if (array.level != LEVEL_CONTAINER) {
 		size = get_component_size(fd)/2;
 		if (size == 0)
 			size = array.size;
@@ -674,6 +958,13 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			} else
 				layout_str = "parity-last";
 		} else {
+			/* Level change is a simple takeover.  In the external
+			 * case we don't check with the metadata handler until
+			 * we establish what the final layout will be.  If the
+			 * level change is disallowed we will revert to
+			 * orig_level without disturbing the metadata, otherwise
+			 * we will send an update.
+			 */
 			c = map_num(pers, level);
 			if (c == NULL) {
 				rv = 1;/* not possible */
@@ -706,7 +997,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 	/* ========= set shape (chunk_size / layout / ndisks)  ============== */
 	/* Check if layout change is a no-op */
-	switch(array.level) {
+	switch (array.level) {
 	case 5:
 		if (layout_str && array.layout == map_name(r5layout, layout_str))
 			layout_str = NULL;
@@ -745,6 +1036,11 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	if (layout_str == NULL
 	    && (chunksize == 0 || chunksize*1024 == array.chunk_size)
 	    && (raid_disks == 0 || raid_disks == array.raid_disks)) {
+		if (reshape_super(st, -1, level, UnSet, 0, 0, NULL, devname, !quiet)) {
+			rv = 1;
+			goto release;
+		}
+		sync_metadata(st);
 		rv = 0;
 		if (level != UnSet && level != array.level) {
 			/* Looks like this level change doesn't need
@@ -766,18 +1062,69 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		} else if (!changed && !quiet)
 			fprintf(stderr, Name ": %s: no change requested\n",
 				devname);
+
+		if (st->ss->external && !mdmon_running(st->container_dev) &&
+		    level > 0) {
+			start_mdmon(st->container_dev);
+			ping_monitor(container);
+		}
 		goto release;
 	}
 
 	c = map_num(pers, array.level);
 	if (c == NULL) c = "-unknown-";
-	switch(array.level) {
+	switch (array.level) {
 	default: /* raid0, linear, multipath cannot be reconfigured */
 		fprintf(stderr, Name ": %s array %s cannot be reshaped.\n",
 			c, devname);
+		/* TODO raid0 raiddisks can be reshaped via raid4 */
 		rv = 1;
 		break;
+	case LEVEL_CONTAINER: {
+		int count;
+
+		/* double check that we are not changing anything but raid_disks */
+		if (size >= 0 || layout_str != NULL || chunksize != 0 || level != UnSet) {
+			fprintf(stderr,
+				Name ": %s is a container, only 'raid-devices' can be changed\n",
+				devname);
+			rv = 1;
+			goto release;
+		}
+
+		st->update_tail = &st->updates;
+		if (reshape_super(st, -1, UnSet, UnSet, 0, raid_disks,
+				  backup_file, devname, !quiet)) {
+			rv = 1;
+			goto release;
+		}
+
+		count = reshape_container_raid_disks(container, raid_disks);
+		if (count < 0) {
+			revert_container_raid_disks(st, fd, container);
+			rv = 1;
+			goto release;
+		} else if (count == 0) {
+			if (!quiet)
+				fprintf(stderr, Name
+					": no active subarrays to reshape\n");
+			goto release;
+		}
 
+		if (!mdmon_running(st->devnum)) {
+			start_mdmon(st->devnum);
+			ping_monitor(container);
+		}
+		sync_metadata(st);
+
+		/* give mdmon a chance to allocate spares */
+		ping_manager(container);
+
+		/* manage_reshape takes care of releasing the array(s) */
+		st->ss->manage_reshape(st, backup_file);
+		frozen = 0;
+		goto release;
+	}
 	case LEVEL_FAULTY: /* only 'layout' change is permitted */
 
 		if (chunksize  || raid_disks) {
@@ -813,6 +1160,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			break;
 		}
 		if (raid_disks > 0) {
+			if (reshape_super(st, -1, UnSet, UnSet, 0, raid_disks,
+					  NULL, devname, !quiet)) {
+				rv = 1;
+				goto release;
+			}
+			sync_metadata(st);
 			array.raid_disks = raid_disks;
 			if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
 				fprintf(stderr, Name ": Cannot set raid-devices for %s: %s\n",
@@ -830,7 +1183,6 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 * layout/chunksize/raid_disks can be changed
 		 * though the kernel may not support it all.
 		 */
-		st = super_by_fd(fd);
 
 		/*
 		 * There are three possibilities.
@@ -1024,6 +1376,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			}
 		}
 		if (backup_file == NULL) {
+			if (st->ss->external && !st->ss->manage_reshape) {
+				fprintf(stderr, Name ": %s Grow operation not supported by %s metadata\n",
+					devname, st->ss->name);
+				rv = 1;
+				break;
+			}
 			if (ndata <= odata) {
 				fprintf(stderr, Name ": %s: Cannot grow - need backup-file\n",
 					devname);
@@ -1072,6 +1430,13 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			d++;
 		}
 
+		/* check that the operation is supported by the metadata */
+		if (reshape_super(st, -1, level, nlayout, nchunk, ndisks,
+				  backup_file, devname, !quiet)) {
+			rv = 1;
+			break;
+		}
+
 		/* lastly, check that the internal stripe cache is
 		 * large enough, or it won't work.
 		 */
@@ -1088,6 +1453,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 * If only changing raid_disks, use ioctl, else use
 		 * sysfs.
 		 */
+		sync_metadata(st);
 		if (ochunk == nchunk && olayout == nlayout) {
 			array.raid_disks = ndisks;
 			if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
@@ -1136,6 +1502,14 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			break;
 		}
 
+		if (st->ss->external) {
+			/* metadata handler takes it from here */
+			ping_manager(container);
+			st->ss->manage_reshape(st, backup_file);
+			frozen = 0;
+			break;
+		}
+
 		/* set up the backup-super-block.  This requires the
 		 * uuid from the array.
 		 */
diff --git a/mdadm.h b/mdadm.h
index a4de06f..64b32cc 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -627,6 +627,15 @@ extern struct superswitch {
 	int (*kill_subarray)(struct supertype *st); /* optional */
 	/* Permit subarray's to be modified */
 	int (*update_subarray)(struct supertype *st, char *update, mddev_ident_t ident); /* optional */
+	/* Check if reshape is supported for this external format.
+	 * st is obtained from super_by_fd() where st->subarray[0] is
+	 * initialized to indicate if reshape is being performed at the
+	 * container or subarray level
+	 */
+	int (*reshape_super)(struct supertype *st, long long size, int level,
+			     int layout, int chunksize, int raid_disks,
+			     char *backup, char *dev, int verbose); /* optional */
+	int (*manage_reshape)(struct supertype *st, char *backup); /* optional */
 
 /* for mdmon */
 	int (*open_new)(struct supertype *c, struct active_array *a,

