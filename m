From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 13/13] imsm: add support for checkpointing via 'curr_migr_unit'
Date: Tue, 22 Dec 2009 17:00:25 -0700
Message-ID: <20091223000025.31628.26018.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Unlike native md checkpointing some data about the geometry and type of
the migration process is coded into curr_migr_unit.  Provide logic to
convert between md/{resync_start|recovery_start} and imsm/curr_migr_unit.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 bitmap.c      |    2 
 mdadm.h       |   17 +++
 super-intel.c |  320 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 util.c        |   15 +++
 4 files changed, 320 insertions(+), 34 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index 850b0ce..088e37d 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -20,8 +20,6 @@
 
 #include "mdadm.h"
 
-#define min(a,b) (((a) < (b)) ? (a) : (b))
-
 inline void sb_le_to_cpu(bitmap_super_t *sb)
 {
 	sb->magic = __le32_to_cpu(sb->magic);
diff --git a/mdadm.h b/mdadm.h
index 27ef693..c1c36af 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -129,6 +129,22 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #endif /* __KLIBC__ */
 
 
+/*
+ * min()/max()/clamp() macros that also do
+ * strict type-checking.. See the
+ * "unnecessary" pointer comparison.
+ */
+#define min(x, y) ({                            \
+	typeof(x) _min1 = (x);                  \
+	typeof(y) _min2 = (y);                  \
+	(void) (&_min1 == &_min2);              \
+	_min1 < _min2 ? _min1 : _min2; })
+
+#define max(x, y) ({                            \
+	typeof(x) _max1 = (x);                  \
+	typeof(y) _max2 = (y);                  \
+	(void) (&_max1 == &_max2);              \
+	_max1 > _max2 ? _max1 : _max2; })
 
 /* general information that might be extracted from a superblock */
 struct mdinfo {
@@ -842,6 +858,7 @@ extern int assemble_container_content(struct supertype *st, int mdfd,
 extern int add_disk(int mdfd, struct supertype *st,
 		    struct mdinfo *sra, struct mdinfo *info);
 extern int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info);
+unsigned long long min_recovery_start(struct mdinfo *array);
 
 extern char *human_size(long long bytes);
 extern char *human_size_brief(long long bytes);
diff --git a/super-intel.c b/super-intel.c
index 9f879c5..609aaf5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -635,6 +635,8 @@ static int is_failed(struct imsm_disk *disk)
 }
 
 #ifndef MDASSEMBLE
+static __u64 blocks_per_migr_unit(struct imsm_dev *dev);
+
 static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 {
 	__u64 sz;
@@ -690,7 +692,11 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 	printf("      Map State : %s", map_state_str[map->map_state]);
 	if (dev->vol.migr_state) {
 		struct imsm_map *map = get_imsm_map(dev, 1);
+
 		printf(" <-- %s", map_state_str[map->map_state]);
+		printf("\n     Checkpoint : %u (%llu)",
+		       __le32_to_cpu(dev->vol.curr_migr_unit),
+		       blocks_per_migr_unit(dev));
 	}
 	printf("\n");
 	printf("    Dirty State : %s\n", dev->vol.dirty ? "dirty" : "clean");
@@ -1216,6 +1222,179 @@ get_imsm_numerical_version(struct imsm_super *mpb, int *m, int *p)
 }
 #endif
 
+static __u32 migr_strip_blocks_resync(struct imsm_dev *dev)
+{
+	/* migr_strip_size when repairing or initializing parity */
+	struct imsm_map *map = get_imsm_map(dev, 0);
+	__u32 chunk = __le32_to_cpu(map->blocks_per_strip);
+
+	switch (get_imsm_raid_level(map)) {
+	case 5:
+	case 10:
+		return chunk;
+	default:
+		return 128*1024 >> 9;
+	}
+}
+
+static __u32 migr_strip_blocks_rebuild(struct imsm_dev *dev)
+{
+	/* migr_strip_size when rebuilding a degraded disk, no idea why
+	 * this is different than migr_strip_size_resync(), but it's good
+	 * to be compatible
+	 */
+	struct imsm_map *map = get_imsm_map(dev, 1);
+	__u32 chunk = __le32_to_cpu(map->blocks_per_strip);
+
+	switch (get_imsm_raid_level(map)) {
+	case 1:
+	case 10:
+		if (map->num_members % map->num_domains == 0)
+			return 128*1024 >> 9;
+		else
+			return chunk;
+	case 5:
+		return max((__u32) 64*1024 >> 9, chunk);
+	default:
+		return 128*1024 >> 9;
+	}
+}
+
+static __u32 num_stripes_per_unit_resync(struct imsm_dev *dev)
+{
+	struct imsm_map *lo = get_imsm_map(dev, 0);
+	struct imsm_map *hi = get_imsm_map(dev, 1);
+	__u32 lo_chunk = __le32_to_cpu(lo->blocks_per_strip);
+	__u32 hi_chunk = __le32_to_cpu(hi->blocks_per_strip);
+
+	return max((__u32) 1, hi_chunk / lo_chunk);
+}
+
+static __u32 num_stripes_per_unit_rebuild(struct imsm_dev *dev)
+{
+	struct imsm_map *lo = get_imsm_map(dev, 0);
+	int level = get_imsm_raid_level(lo);
+
+	if (level == 1 || level == 10) {
+		struct imsm_map *hi = get_imsm_map(dev, 1);
+
+		return hi->num_domains;
+	} else
+		return num_stripes_per_unit_resync(dev);
+}
+
+static __u8 imsm_num_data_members(struct imsm_dev *dev)
+{
+	/* named 'imsm_' because raid0, raid1 and raid10
+	 * counter-intuitively have the same number of data disks
+	 */
+	struct imsm_map *map = get_imsm_map(dev, 0);
+
+	switch (get_imsm_raid_level(map)) {
+	case 0:
+	case 1:
+	case 10:
+		return map->num_members;
+	case 5:
+		return map->num_members - 1;
+	default:
+		dprintf("%s: unsupported raid level\n", __func__);
+		return 0;
+	}
+}
+
+static __u32 parity_segment_depth(struct imsm_dev *dev)
+{
+	struct imsm_map *map = get_imsm_map(dev, 0);
+	__u32 chunk =  __le32_to_cpu(map->blocks_per_strip);
+
+	switch(get_imsm_raid_level(map)) {
+	case 1:
+	case 10:
+		return chunk * map->num_domains;
+	case 5:
+		return chunk * map->num_members;
+	default:
+		return chunk;
+	}
+}
+
+static __u32 map_migr_block(struct imsm_dev *dev, __u32 block)
+{
+	struct imsm_map *map = get_imsm_map(dev, 1);
+	__u32 chunk = __le32_to_cpu(map->blocks_per_strip);
+	__u32 strip = block / chunk;
+
+	switch (get_imsm_raid_level(map)) {
+	case 1:
+	case 10: {
+		__u32 vol_strip = (strip * map->num_domains) + 1;
+		__u32 vol_stripe = vol_strip / map->num_members;
+
+		return vol_stripe * chunk + block % chunk;
+	} case 5: {
+		__u32 stripe = strip / (map->num_members - 1);
+
+		return stripe * chunk + block % chunk;
+	}
+	default:
+		return 0;
+	}
+}
+
+static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
+{
+	/* calculate the conversion factor between per member 'blocks'
+	 * (md/{resync,rebuild}_start) and imsm migration units, return
+	 * 0 for the 'not migrating' and 'unsupported migration' cases
+	 */
+	if (!dev->vol.migr_state)
+		return 0;
+
+	switch (migr_type(dev)) {
+	case MIGR_VERIFY:
+	case MIGR_REPAIR:
+	case MIGR_INIT: {
+		struct imsm_map *map = get_imsm_map(dev, 0);
+		__u32 stripes_per_unit;
+		__u32 blocks_per_unit;
+		__u32 parity_depth;
+		__u32 migr_chunk;
+		__u32 block_map;
+		__u32 block_rel;
+		__u32 segment;
+		__u32 stripe;
+		__u8  disks;
+
+		/* yes, this is really the translation of migr_units to
+		 * per-member blocks in the 'resync' case
+		 */
+		stripes_per_unit = num_stripes_per_unit_resync(dev);
+		migr_chunk = migr_strip_blocks_resync(dev);
+		disks = imsm_num_data_members(dev);
+		blocks_per_unit = stripes_per_unit * migr_chunk * disks;
+		stripe = __le32_to_cpu(map->blocks_per_strip) * disks;
+		segment = blocks_per_unit / stripe;
+		block_rel = blocks_per_unit - segment * stripe;
+		parity_depth = parity_segment_depth(dev);
+		block_map = map_migr_block(dev, block_rel);
+		return block_map + parity_depth * segment;
+	}
+	case MIGR_REBUILD: {
+		__u32 stripes_per_unit;
+		__u32 migr_chunk;
+
+		stripes_per_unit = num_stripes_per_unit_rebuild(dev);
+		migr_chunk = migr_strip_blocks_rebuild(dev);
+		return migr_chunk * stripes_per_unit;
+	}
+	case MIGR_GEN_MIGR:
+	case MIGR_STATE_CHANGE:
+	default:
+		return 0;
+	}
+}
+
 static int imsm_level_to_layout(int level)
 {
 	switch (level) {
@@ -1265,12 +1444,33 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	info->component_size	  = __le32_to_cpu(map->blocks_per_member);
 	memset(info->uuid, 0, sizeof(info->uuid));
 
-	if (map->map_state == IMSM_T_STATE_UNINITIALIZED || dev->vol.dirty)
+	if (map->map_state == IMSM_T_STATE_UNINITIALIZED || dev->vol.dirty) {
 		info->resync_start = 0;
-	else if (dev->vol.migr_state)
-		/* FIXME add curr_migr_unit to resync_start conversion */
-		info->resync_start = 0;
-	else
+	} else if (dev->vol.migr_state) {
+		switch (migr_type(dev)) {
+		case MIGR_REPAIR:
+		case MIGR_INIT: {
+			__u64 blocks_per_unit = blocks_per_migr_unit(dev);
+			__u64 units = __le32_to_cpu(dev->vol.curr_migr_unit);
+
+			info->resync_start = blocks_per_unit * units;
+			break;
+		}
+		case MIGR_VERIFY:
+			/* we could emulate the checkpointing of
+			 * 'sync_action=check' migrations, but for now
+			 * we just immediately complete them
+			 */
+		case MIGR_REBUILD:
+			/* this is handled by container_content_imsm() */
+		case MIGR_GEN_MIGR:
+		case MIGR_STATE_CHANGE:
+			/* FIXME handle other migrations */
+		default:
+			/* we are not dirty, so... */
+			info->resync_start = MaxSector;
+		}
+	} else
 		info->resync_start = MaxSector;
 
 	strncpy(info->name, (char *) dev->volume, MAX_RAID_SERIAL_LEN);
@@ -3782,6 +3982,46 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 }
 #endif /* MDASSEMBLE */
 
+static int is_rebuilding(struct imsm_dev *dev)
+{
+	struct imsm_map *migr_map;
+
+	if (!dev->vol.migr_state)
+		return 0;
+
+	if (migr_type(dev) != MIGR_REBUILD)
+		return 0;
+
+	migr_map = get_imsm_map(dev, 1);
+
+	if (migr_map->map_state == IMSM_T_STATE_DEGRADED)
+		return 1;
+	else
+		return 0;
+}
+
+static void update_recovery_start(struct imsm_dev *dev, struct mdinfo *array)
+{
+	struct mdinfo *rebuild = NULL;
+	struct mdinfo *d;
+	__u32 units;
+
+	if (!is_rebuilding(dev))
+		return;
+
+	/* Find the rebuild target, but punt on the dual rebuild case */
+	for (d = array->devs; d; d = d->next)
+		if (d->recovery_start == 0) {
+			if (rebuild)
+				return;
+			rebuild = d;
+		}
+
+	units = __le32_to_cpu(dev->vol.curr_migr_unit);
+	rebuild->recovery_start = units * blocks_per_migr_unit(dev);
+}
+
+
 static struct mdinfo *container_content_imsm(struct supertype *st)
 {
 	/* Given a container loaded by load_super_imsm_all,
@@ -3829,6 +4069,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 		super->current_vol = i;
 		getinfo_super_imsm_volume(st, this);
 		for (slot = 0 ; slot <  map->num_members; slot++) {
+			unsigned long long recovery_start;
 			struct mdinfo *info_d;
 			struct dl *d;
 			int idx;
@@ -3842,33 +4083,41 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 				if (d->index == idx)
                                         break;
 
+			recovery_start = MaxSector;
 			if (d == NULL)
 				skip = 1;
 			if (d && is_failed(&d->disk))
 				skip = 1;
 			if (ord & IMSM_ORD_REBUILD)
-				skip = 1;
+				recovery_start = 0;
 
 			/* 
 			 * if we skip some disks the array will be assmebled degraded;
-			 * reset resync start to avoid a dirty-degraded situation
+			 * reset resync start to avoid a dirty-degraded
+			 * situation when performing the intial sync
 			 *
 			 * FIXME handle dirty degraded
 			 */
-			if (skip && !dev->vol.dirty)
+			if ((skip || recovery_start == 0) && !dev->vol.dirty)
 				this->resync_start = MaxSector;
 			if (skip)
 				continue;
 
-			info_d = malloc(sizeof(*info_d));
+			info_d = calloc(1, sizeof(*info_d));
 			if (!info_d) {
 				fprintf(stderr, Name ": failed to allocate disk"
 					" for volume %.16s\n", dev->volume);
+				info_d = this->devs;
+				while (info_d) {
+					struct mdinfo *d = info_d->next;
+
+					free(info_d);
+					info_d = d;
+				}
 				free(this);
 				this = rest;
 				break;
 			}
-			memset(info_d, 0, sizeof(*info_d));
 			info_d->next = this->devs;
 			this->devs = info_d;
 
@@ -3876,9 +4125,10 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			info_d->disk.major = d->major;
 			info_d->disk.minor = d->minor;
 			info_d->disk.raid_disk = slot;
-			info_d->recovery_start = MaxSector;
+			info_d->recovery_start = recovery_start;
 
-			this->array.working_disks++;
+			if (info_d->recovery_start == MaxSector)
+				this->array.working_disks++;
 
 			info_d->events = __le32_to_cpu(mpb->generation_num);
 			info_d->data_offset = __le32_to_cpu(map->pba_of_lba0);
@@ -3886,6 +4136,8 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			if (d->devname)
 				strcpy(info_d->name, d->devname);
 		}
+		/* now that the disk list is up-to-date fixup recovery_start */
+		update_recovery_start(dev, this);
 		rest = this;
 	}
 
@@ -4028,24 +4280,6 @@ static int is_resyncing(struct imsm_dev *dev)
 		return 0;
 }
 
-static int is_rebuilding(struct imsm_dev *dev)
-{
-	struct imsm_map *migr_map;
-
-	if (!dev->vol.migr_state)
-		return 0;
-
-	if (migr_type(dev) != MIGR_REBUILD)
-		return 0;
-
-	migr_map = get_imsm_map(dev, 1);
-
-	if (migr_map->map_state == IMSM_T_STATE_DEGRADED)
-		return 1;
-	else
-		return 0;
-}
-
 /* return true if we recorded new information */
 static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 {
@@ -4096,6 +4330,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	int failed = imsm_count_failed(super, dev);
 	__u8 map_state = imsm_check_degraded(super, dev, failed);
+	__u32 blocks_per_unit;
 
 	/* before we activate this array handle any missing disks */
 	if (consistent == 2 && super->missing) {
@@ -4107,7 +4342,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 			mark_missing(dev, &dl->disk, dl->index);
 		super->updates_pending++;
 	}
-		
+
 	if (consistent == 2 &&
 	    (!is_resync_complete(&a->info) ||
 	     map_state != IMSM_T_STATE_NORMAL ||
@@ -4134,7 +4369,28 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		super->updates_pending++;
 	}
 
-	 /* FIXME check if we can update curr_migr_unit from resync_start */
+	/* check if we can update curr_migr_unit from resync_start, recovery_start */
+	blocks_per_unit = blocks_per_migr_unit(dev);
+	if (blocks_per_unit && failed <= 1) {
+		__u32 units32;
+		__u64 units;
+
+		if (migr_type(dev) == MIGR_REBUILD)
+			units = min_recovery_start(&a->info) / blocks_per_unit;
+		else
+			units = a->info.resync_start / blocks_per_unit;
+		units32 = units;
+
+		/* check that we did not overflow 32-bits, and that
+		 * curr_migr_unit needs updating
+		 */
+		if (units32 == units &&
+		    __le32_to_cpu(dev->vol.curr_migr_unit) != units32) {
+			dprintf("imsm: mark checkpoint (%u)\n", units32);
+			dev->vol.curr_migr_unit = __cpu_to_le32(units32);
+			super->updates_pending++;
+		}
+	}
 
 	/* mark dirty / clean */
 	if (dev->vol.dirty != !consistent) {
diff --git a/util.c b/util.c
index 927a0ee..53c21e3 100644
--- a/util.c
+++ b/util.c
@@ -1210,6 +1210,21 @@ int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
 	return rv;
 }
 
+unsigned long long min_recovery_start(struct mdinfo *array)
+{
+	/* find the minimum recovery_start in an array for metadata
+	 * formats that only record per-array recovery progress instead
+	 * of per-device
+	 */
+	unsigned long long recovery_start = MaxSector;
+	struct mdinfo *d;
+
+	for (d = array->devs; d; d = d->next)
+		recovery_start = min(recovery_start, d->recovery_start);
+
+	return recovery_start;
+}
+
 char *devnum2devname(int num)
 {
 	char name[100];

