From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 01/22] imsm: Add migration record to intel_super
Date: Thu, 02 Jun 2011 16:48:18 +0200
Message-ID: <20110602144817.27355.3508.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

IMSM for securing reshape process uses special disk area outside metadata
for reshaped area backup purposes. If just reshaped array area requires
backup, bunch of array stripes prepared for reshape is stored in to
Migration Copy Area. In case of reshape interruption, Option ROM during
restart or mdadm during reshape restart (when no reboot occurs) will
restore Migration Copy Area to designation array. Reshape can be continued form stable
array stable state.

This patch adds support for IMSM migration record structure.
IMSM migration record is stored on the first two disks of IMSM volume
during the migration.

Add function for reading migration record, so mdadm can read (if present)
migration record. Migration record has to be cleared every time
MIGR_GEN_MIGR is started.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |  200 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 189 insertions(+), 11 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e401eb0..ffc41e7 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -51,7 +51,7 @@
 #define MPB_ATTRIB_RAID5   __cpu_to_le32(0x00000010)
 #define MPB_ATTRIB_RAIDCNG __cpu_to_le32(0x00000020)
 
-#define MPB_SECTOR_CNT 418
+#define MPB_SECTOR_CNT 2210
 #define IMSM_RESERVED_SECTORS 4096
 #define SECT_PER_MB_SHIFT 11
 
@@ -194,6 +194,41 @@ struct bbm_log {
 static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed" };
 #endif
 
+#define RAID_DISK_RESERVED_BLOCKS_IMSM_HI 2209
+
+#define GEN_MIGR_AREA_SIZE 2048 /* General Migration Copy Area size in blocks */
+
+#define UNIT_SRC_NORMAL     0   /* Source data for curr_migr_unit must
+				 *  be recovered using srcMap */
+#define UNIT_SRC_IN_CP_AREA 1   /* Source data for curr_migr_unit has
+				 *  already been migrated and must
+				 *  be recovered from checkpoint area */
+struct migr_record {
+	__u32 rec_status;	    /* Status used to determine how to restart
+				     * migration in case it aborts
+				     * in some fashion */
+	__u32 curr_migr_unit;	    /* 0..numMigrUnits-1 */
+	__u32 family_num;	    /* Family number of MPB
+				     * containing the RaidDev
+				     * that is migrating */
+	__u32 ascending_migr;	    /* True if migrating in increasing
+				     * order of lbas */
+	__u32 blocks_per_unit;      /* Num disk blocks per unit of operation */
+	__u32 dest_depth_per_unit;  /* Num member blocks each destMap
+				     * member disk
+				     * advances per unit-of-operation */
+	__u32 ckpt_area_pba;	    /* Pba of first block of ckpt copy area */
+	__u32 dest_1st_member_lba;  /* First member lba on first
+				     * stripe of destination */
+	__u32 num_migr_units;	    /* Total num migration units-of-op */
+	__u32 post_migr_vol_cap;    /* Size of volume after
+				     * migration completes */
+	__u32 post_migr_vol_cap_hi; /* Expansion space for LBA64 */
+	__u32 ckpt_read_disk_num;   /* Which member disk in destSubMap[0] the
+				     * migration ckpt record was read from
+				     * (for recovered migrations) */
+} __attribute__ ((__packed__));
+
 static __u8 migr_type(struct imsm_dev *dev)
 {
 	if (dev->vol.migr_type == MIGR_VERIFY &&
@@ -250,6 +285,10 @@ struct intel_super {
 		void *buf; /* O_DIRECT buffer for reading/writing metadata */
 		struct imsm_super *anchor; /* immovable parameters */
 	};
+	union {
+		void *migr_rec_buf; /* buffer for I/O operations */
+		struct migr_record *migr_rec; /* migration record */
+	};
 	size_t len; /* size of the 'buf' allocation */
 	void *next_buf; /* for realloc'ing buf from the manager */
 	size_t next_len;
@@ -1017,6 +1056,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("    Orig Family : %08x\n", __le32_to_cpu(mpb->orig_family_num));
 	printf("         Family : %08x\n", __le32_to_cpu(mpb->family_num));
 	printf("     Generation : %08x\n", __le32_to_cpu(mpb->generation_num));
+	info.devs = NULL;
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	printf("           UUID : %s\n", nbuf + 5);
@@ -1044,6 +1084,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
 
 		super->current_vol = i;
+		info.devs = NULL;
 		getinfo_super_imsm(st, &info, NULL);
 		fname_from_uuid(st, &info, nbuf, ':');
 		print_imsm_dev(dev, nbuf + 5, super->disks->index);
@@ -1087,6 +1128,7 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 		return;
 	}
 
+	info.devs = NULL;
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	printf("ARRAY metadata=imsm UUID=%s\n", nbuf + 5);
@@ -1104,12 +1146,14 @@ static void brief_examine_subarrays_imsm(struct supertype *st, int verbose)
 	if (!super->anchor->num_raid_devs)
 		return;
 
+	info.devs = NULL;
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
 
 		super->current_vol = i;
+		info.devs = NULL;
 		getinfo_super_imsm(st, &info, NULL);
 		fname_from_uuid(st, &info, nbuf1, ':');
 		printf("ARRAY /dev/md/%.16s container=%s member=%d UUID=%s\n",
@@ -1124,6 +1168,7 @@ static void export_examine_super_imsm(struct supertype *st)
 	struct mdinfo info;
 	char nbuf[64];
 
+	info.devs = NULL;
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	printf("MD_METADATA=imsm\n");
@@ -1137,6 +1182,7 @@ static void detail_super_imsm(struct supertype *st, char *homehost)
 	struct mdinfo info;
 	char nbuf[64];
 
+	info.devs = NULL;
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	printf("\n           UUID : %s\n", nbuf + 5);
@@ -1146,6 +1192,7 @@ static void brief_detail_super_imsm(struct supertype *st)
 {
 	struct mdinfo info;
 	char nbuf[64];
+	info.devs = NULL;
 	getinfo_super_imsm(st, &info, NULL);
 	fname_from_uuid(st, &info, nbuf, ':');
 	printf(" UUID=%s", nbuf + 5);
@@ -1752,6 +1799,92 @@ static int imsm_level_to_layout(int level)
 	return UnSet;
 }
 
+/*******************************************************************************
+ * Function:	read_imsm_migr_rec
+ * Description: Function reads imsm migration record from last sector of disk
+ * Parameters:
+ *	fd	: disk descriptor
+ *	super	: metadata info
+ * Returns:
+ *	 0 : success,
+ *	-1 : fail
+ ******************************************************************************/
+static int read_imsm_migr_rec(int fd, struct intel_super *super)
+{
+	int ret_val = -1;
+	unsigned long long dsize;
+
+	get_dev_size(fd, NULL, &dsize);
+	if (lseek64(fd, dsize - 512, SEEK_SET) < 0) {
+		fprintf(stderr,
+			Name ": Cannot seek to anchor block: %s\n",
+			strerror(errno));
+		goto out;
+	}
+	if (read(fd, super->migr_rec_buf, 512) != 512) {
+		fprintf(stderr,
+			Name ": Cannot read migr record block: %s\n",
+			strerror(errno));
+		goto out;
+	}
+	ret_val = 0;
+
+out:
+	return ret_val;
+}
+
+/*******************************************************************************
+ * Function:	load_imsm_migr_rec
+ * Description:	Function reads imsm migration record (it is stored at the last
+ *		sector of disk)
+ * Parameters:
+ *	super	: imsm internal array info
+ *	info	: general array info
+ * Returns:
+ *	 0 : success
+ *	-1 : fail
+ ******************************************************************************/
+static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
+{
+	struct mdinfo *sd;
+	struct dl *dl = NULL;
+	char nm[30];
+	int retval = -1;
+	int fd = -1;
+
+	if (info) {
+		for (sd = info->devs ; sd ; sd = sd->next) {
+			/* read only from one of the first two slots */
+			if ((sd->disk.raid_disk > 1) ||
+			    (sd->disk.raid_disk < 0))
+				continue;
+			sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+			fd = dev_open(nm, O_RDONLY);
+			if (fd >= 0)
+				break;
+		}
+	}
+	if (fd < 0) {
+		for (dl = super->disks; dl; dl = dl->next) {
+			/* read only from one of the first two slots */
+			if (dl->index > 1)
+				continue;
+			sprintf(nm, "%d:%d", dl->major, dl->minor);
+			fd = dev_open(nm, O_RDONLY);
+			if (fd >= 0)
+				break;
+		}
+	}
+	if (fd < 0)
+		goto out;
+	retval = read_imsm_migr_rec(fd, super);
+
+out:
+	if (fd >= 0)
+		close(fd);
+	return retval;
+}
+
 static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info, char *dmap)
 {
 	struct intel_super *super = st->sb;
@@ -1883,11 +2016,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 
 			info->reshape_progress = blocks_per_unit * units;
 
-			/* checkpoint is written per disks unit
-			 * recalculate it to reshape position
-			 */
-			used_disks = imsm_num_data_members(dev, 0);
-			info->reshape_progress *= used_disks;
 			dprintf("IMSM: General Migration checkpoint : %llu "
 			       "(%llu) -> read reshape progress : %llu\n",
 				units, blocks_per_unit, info->reshape_progress);
@@ -2534,8 +2662,11 @@ load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
  *    map1state=normal)
  * 4/ Rebuild (migr_state=1 migr_type=MIGR_REBUILD map0state=normal
  *    map1state=degraded)
+ * 5/ Migration (mig_state=1 migr_type=MIGR_GEN_MIGR map0state=normal
+ *    map1state=normal)
  */
-static void migrate(struct imsm_dev *dev, __u8 to_state, int migr_type)
+static void migrate(struct imsm_dev *dev, struct intel_super *super,
+		    __u8 to_state, int migr_type)
 {
 	struct imsm_map *dest;
 	struct imsm_map *src = get_imsm_map(dev, 0);
@@ -2558,6 +2689,10 @@ static void migrate(struct imsm_dev *dev, __u8 to_state, int migr_type)
 		}
 	}
 
+	if (migr_type == MIGR_GEN_MIGR)
+		/* Clear migration record */
+		memset(super->migr_rec, 0, sizeof(struct migr_record));
+
 	src->map_state = to_state;
 }
 
@@ -2732,6 +2867,14 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 
 	sectors = mpb_sectors(anchor) - 1;
 	free(anchor);
+
+	if (posix_memalign(&super->migr_rec_buf, 512, 512) != 0) {
+		fprintf(stderr, Name
+			": %s could not allocate migr_rec buffer\n", __func__);
+		free(super->buf);
+		return 2;
+	}
+
 	if (!sectors) {
 		check_sum = __gen_imsm_checksum(super->anchor);
 		if (check_sum != __le32_to_cpu(super->anchor->check_sum)) {
@@ -2783,6 +2926,8 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	return 0;
 }
 
+static int read_imsm_migr_rec(int fd, struct intel_super *super);
+
 static int
 load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd)
 {
@@ -2844,6 +2989,10 @@ static void __free_imsm(struct intel_super *super, int free_disks)
 	}
 	/* unlink capability description */
 	super->orom = NULL;
+	if (super->migr_rec_buf) {
+		free(super->migr_rec_buf);
+		super->migr_rec_buf = NULL;
+	}
 	if (free_disks)
 		free_imsm_disks(super);
 	free_devlist(super);
@@ -3368,6 +3517,13 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		err = 2;
 		goto error;
 	}
+
+	/* load migration record */
+	err = load_imsm_migr_rec(super, NULL);
+	if (err) {
+		err = 4;
+		goto error;
+	}
 	err = 0;
 
  error:
@@ -3446,6 +3602,10 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 		st->minor_version = 0;
 		st->max_devs = IMSM_MAX_DEVICES;
 	}
+
+	/* load migration record */
+	load_imsm_migr_rec(super, NULL);
+
 	return 0;
 }
 
@@ -3581,6 +3741,14 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 			fprintf(stderr, Name": could not allocate new mpb\n");
 			return 0;
 		}
+		if (posix_memalign(&super->migr_rec_buf, 512, 512) != 0) {
+			fprintf(stderr, Name
+				": %s could not allocate migr_rec buffer\n",
+				__func__);
+			free(super->buf);
+			free(super);
+			return 0;
+		}
 		memcpy(mpb_new, mpb, size_old);
 		free(mpb);
 		mpb = mpb_new;
@@ -3709,6 +3877,13 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 			": %s could not allocate superblock\n", __func__);
 		return 0;
 	}
+	if (posix_memalign(&super->migr_rec_buf, 512, 512) != 0) {
+		fprintf(stderr, Name
+			": %s could not allocate migr_rec buffer\n", __func__);
+		free(super->buf);
+		free(super);
+		return 0;
+	}
 	memset(super->buf, 0, mpb_size);
 	mpb = super->buf;
 	mpb->mpb_size = __cpu_to_le32(mpb_size);
@@ -5475,9 +5650,9 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		/* mark the start of the init process if nothing is failed */
 		dprintf("imsm: mark resync start\n");
 		if (map->map_state == IMSM_T_STATE_UNINITIALIZED)
-			migrate(dev, IMSM_T_STATE_NORMAL, MIGR_INIT);
+			migrate(dev, super, IMSM_T_STATE_NORMAL, MIGR_INIT);
 		else
-			migrate(dev, IMSM_T_STATE_NORMAL, MIGR_REPAIR);
+			migrate(dev, super, IMSM_T_STATE_NORMAL, MIGR_REPAIR);
 		super->updates_pending++;
 	}
 
@@ -6141,7 +6316,7 @@ static int apply_reshape_migration_update(struct imsm_update_reshape_migration *
 				} else
 					to_state = IMSM_T_STATE_NORMAL;
 			}
-			migrate(new_dev, to_state, MIGR_GEN_MIGR);
+			migrate(new_dev, super, to_state, MIGR_GEN_MIGR);
 			if (u->new_level > -1)
 				map->raid_level = u->new_level;
 			migr_map = get_imsm_map(new_dev, 1);
@@ -6305,6 +6480,9 @@ static int apply_reshape_container_disks_update(struct imsm_update_reshape *u,
 		id->dev = newdev;
 		*sp = tofree;
 		tofree = sp;
+
+		/* Clear migration record */
+		memset(super->migr_rec, 0, sizeof(struct migr_record));
 	}
 	if (tofree)
 		*space_list = tofree;
@@ -6536,7 +6714,7 @@ static void imsm_process_update(struct supertype *st,
 		/* mark rebuild */
 		to_state = imsm_check_degraded(super, dev, failed);
 		map->map_state = IMSM_T_STATE_DEGRADED;
-		migrate(dev, to_state, MIGR_REBUILD);
+		migrate(dev, super, to_state, MIGR_REBUILD);
 		migr_map = get_imsm_map(dev, 1);
 		set_imsm_ord_tbl_ent(map, u->slot, dl->index);
 		set_imsm_ord_tbl_ent(migr_map, u->slot, dl->index | IMSM_ORD_REBUILD);

