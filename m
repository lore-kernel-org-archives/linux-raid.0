From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/16] mdadm: Add IMSM migration record to intel_super
Date: Mon, 13 Dec 2010 15:45:57 +0100
Message-ID: <20101213144557.4384.79810.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Add support for IMSM migration record structure.
IMSM migration record is stored on the first two disks of IMSM volume during the migration.

Add function for reading/writing migration record - they will be used by the next checkpointing patches.
Clear migration record every time MIGR_GEN_MIGR is started.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 167 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5971991..82371d5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -195,6 +195,37 @@ struct bbm_log {
 static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed" };
 #endif
 
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
@@ -240,6 +271,10 @@ struct intel_super {
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
@@ -1553,6 +1588,104 @@ static int imsm_level_to_layout(int level)
 	return UnSet;
 }
 
+/*
+ * load_imsm_migr_rec - read imsm migration record
+ */
+__attribute__((unused))
+static int load_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
+{
+	unsigned long long dsize;
+	struct mdinfo *sd;
+	struct dl *dl;
+	char nm[30];
+	int retval = -1;
+	int fd = -1;
+
+	for (sd = info->devs ; sd ; sd = sd->next) {
+		/* read only from one of the first two slots */
+		if (sd->disk.raid_disk > 1)
+			continue;
+		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+		fd = dev_open(nm, O_RDONLY);
+		if (fd >= 0)
+			break;
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
+	retval = 0;
+ out:
+	if (fd >= 0)
+		close(fd);
+	return retval;
+}
+
+/*
+ * write_imsm_migr_rec - write imsm migration record
+ */
+__attribute__((unused))
+static int write_imsm_migr_rec(struct intel_super *super, struct mdinfo *info)
+{
+	unsigned long long dsize;
+	struct mdinfo *sd;
+	char nm[30];
+	int fd = -1;
+	int retval = -1;
+
+	for (sd = info->devs ; sd ; sd = sd->next) {
+		/* read only from one of the first two slots */
+		if (sd->disk.raid_disk > 1)
+			continue;
+		sprintf(nm, "%d:%d", sd->disk.major, sd->disk.minor);
+		fd = dev_open(nm, O_RDWR);
+		if (fd < 0)
+			continue;
+		get_dev_size(fd, NULL, &dsize);
+		if (lseek64(fd, dsize - 512, SEEK_SET) < 0) {
+			fprintf(stderr,
+				Name ": Cannot seek to anchor block: %s\n",
+				strerror(errno));
+			goto out;
+		}
+		if (write(fd, super->migr_rec_buf, 512) != 512) {
+			fprintf(stderr,
+				Name ": Cannot write migr record block: %s\n",
+				strerror(errno));
+			goto out;
+		}
+		close(fd);
+		fd = -1;
+	}
+	retval = 0;
+ out:
+	if (fd >= 0)
+		close(fd);
+	return retval;
+}
+
 static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info, char *dmap)
 {
 	struct intel_super *super = st->sb;
@@ -2265,8 +2398,11 @@ load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
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
@@ -2289,6 +2425,10 @@ static void migrate(struct imsm_dev *dev, __u8 to_state, int migr_type)
 		}
 	}
 
+	if (migr_type == MIGR_GEN_MIGR)
+		/* Clear migration record */
+		memset(super->migr_rec, 0, sizeof(struct migr_record));
+
 	src->map_state = to_state;
 }
 
@@ -2454,6 +2594,14 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 
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
@@ -2556,6 +2704,10 @@ static void __free_imsm(struct intel_super *super, int free_disks)
 		free(super->buf);
 		super->buf = NULL;
 	}
+	if (super->migr_rec_buf) {
+		free(super->migr_rec_buf);
+		super->migr_rec_buf = NULL;
+	}
 	if (free_disks)
 		free_imsm_disks(super);
 	free_devlist(super);
@@ -3364,6 +3516,13 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
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
@@ -4887,9 +5046,9 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
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
 
@@ -5508,6 +5667,9 @@ static void imsm_process_update(struct supertype *st,
 		}
 		a->reshape_chunk_size = u->reshape_chunk_size;
 
+		/* Clear migration record */
+		memset(super->migr_rec, 0, sizeof(struct migr_record));
+
 		super->updates_pending++;
 update_reshape_exit:
 		if (u->devs_mem.dev)
@@ -5806,7 +5968,7 @@ update_reshape_exit:
 		/* mark rebuild */
 		to_state = imsm_check_degraded(super, dev, failed);
 		map->map_state = IMSM_T_STATE_DEGRADED;
-		migrate(dev, to_state, MIGR_REBUILD);
+		migrate(dev, super, to_state, MIGR_REBUILD);
 		migr_map = get_imsm_map(dev, 1);
 		set_imsm_ord_tbl_ent(map, u->slot, dl->index);
 		set_imsm_ord_tbl_ent(migr_map, u->slot, dl->index | IMSM_ORD_REBUILD);
@@ -7030,7 +7192,7 @@ struct imsm_update_reshape *imsm_create_metadata_update_for_reshape(
 			 */
 
 			to_state = imsm_check_degraded(super, old_dev, 0);
-			migrate(upd_devs, to_state, MIGR_GEN_MIGR);
+			migrate(upd_devs, super, to_state, MIGR_GEN_MIGR);
 			/* second map length is equal to first map
 			* correct second map length to old value
 			*/

