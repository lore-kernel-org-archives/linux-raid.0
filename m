From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH v2 4/4] IMSM: 4Kn drives support - adapt general migration record
Date: Thu, 17 Nov 2016 14:58:38 +0100
Message-ID: <1479391118-31600-5-git-send-email-pawel.baldysiak@intel.com>
References: <1479391118-31600-1-git-send-email-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1479391118-31600-1-git-send-email-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Pawel Baldysiak <pawel.baldysiak@intel.com>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Convert general migration record for 4Kn drives prior to write and post
read. Calculate record location based on sector size, don't just assume
it's 512. Assure buffer address is aligned to 4096 so write operation
avoids caching.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 99 +++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 26 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index a1114ac..1f79eab 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -244,9 +244,9 @@ static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed"
 
 #define GEN_MIGR_AREA_SIZE 2048 /* General Migration Copy Area size in blocks */
 
-#define MIGR_REC_BUF_SIZE 512 /* size of migr_record i/o buffer */
-#define MIGR_REC_POSITION 512 /* migr_record position offset on disk,
-			       * MIGR_REC_BUF_SIZE <= MIGR_REC_POSITION
+#define MIGR_REC_BUF_SECTORS 1 /* size of migr_record i/o buffer in sectors */
+#define MIGR_REC_SECTOR_POSITION 1 /* migr_record position offset on disk,
+			       * MIGR_REC_BUF_SECTORS <= MIGR_REC_SECTOR_POS
 			       */
 
 #define UNIT_SRC_NORMAL     0   /* Source data for curr_migr_unit must
@@ -1257,6 +1257,19 @@ static void print_imsm_disk(struct imsm_disk *disk, int index, __u32 reserved)
 	       human_size(sz * 512));
 }
 
+void convert_to_4k_imsm_migr_rec(struct intel_super *super)
+{
+	struct migr_record *migr_rec = super->migr_rec;
+
+	migr_rec->blocks_per_unit /= IMSM_4K_DIV;
+	migr_rec->ckpt_area_pba /= IMSM_4K_DIV;
+	migr_rec->dest_1st_member_lba /= IMSM_4K_DIV;
+	migr_rec->dest_depth_per_unit /= IMSM_4K_DIV;
+	split_ull((join_u32(migr_rec->post_migr_vol_cap,
+		 migr_rec->post_migr_vol_cap_hi) / IMSM_4K_DIV),
+		 &migr_rec->post_migr_vol_cap, &migr_rec->post_migr_vol_cap_hi);
+}
+
 void convert_to_4k_imsm_disk(struct imsm_disk *disk)
 {
 	set_total_blocks(disk, (total_blocks(disk)/IMSM_4K_DIV));
@@ -1357,6 +1370,20 @@ void examine_migr_rec_imsm(struct intel_super *super)
 }
 #endif /* MDASSEMBLE */
 
+void convert_from_4k_imsm_migr_rec(struct intel_super *super)
+{
+	struct migr_record *migr_rec = super->migr_rec;
+
+	migr_rec->blocks_per_unit *= IMSM_4K_DIV;
+	migr_rec->ckpt_area_pba *= IMSM_4K_DIV;
+	migr_rec->dest_1st_member_lba *= IMSM_4K_DIV;
+	migr_rec->dest_depth_per_unit *= IMSM_4K_DIV;
+	split_ull((join_u32(migr_rec->post_migr_vol_cap,
+		 migr_rec->post_migr_vol_cap_hi) * IMSM_4K_DIV),
+		 &migr_rec->post_migr_vol_cap,
+		 &migr_rec->post_migr_vol_cap_hi);
+}
+
 void convert_from_4k(struct intel_super *super)
 {
 	struct imsm_super *mpb = super->anchor;
@@ -1629,7 +1656,7 @@ static int copy_metadata_imsm(struct supertype *st, int from, int to)
 	unsigned int sector_size = super->sector_size;
 	unsigned int written = 0;
 
-	if (posix_memalign(&buf, 4096, 4096) != 0)
+	if (posix_memalign(&buf, MAX_SECTOR_SIZE, MAX_SECTOR_SIZE) != 0)
 		return 1;
 
 	if (!get_dev_size(from, NULL, &dsize))
@@ -2499,21 +2526,26 @@ static int imsm_level_to_layout(int level)
 static int read_imsm_migr_rec(int fd, struct intel_super *super)
 {
 	int ret_val = -1;
+	unsigned int sector_size = super->sector_size;
 	unsigned long long dsize;
 
 	get_dev_size(fd, NULL, &dsize);
-	if (lseek64(fd, dsize - MIGR_REC_POSITION, SEEK_SET) < 0) {
+	if (lseek64(fd, dsize - (sector_size*MIGR_REC_SECTOR_POSITION),
+		   SEEK_SET) < 0) {
 		pr_err("Cannot seek to anchor block: %s\n",
 		       strerror(errno));
 		goto out;
 	}
-	if (read(fd, super->migr_rec_buf, MIGR_REC_BUF_SIZE) !=
-							    MIGR_REC_BUF_SIZE) {
+	if (read(fd, super->migr_rec_buf,
+	    MIGR_REC_BUF_SECTORS*sector_size) !=
+	    MIGR_REC_BUF_SECTORS*sector_size) {
 		pr_err("Cannot read migr record block: %s\n",
 		       strerror(errno));
 		goto out;
 	}
 	ret_val = 0;
+	if (sector_size == 4096)
+		convert_from_4k_imsm_migr_rec(super);
 
 out:
 	return ret_val;
@@ -2659,6 +2691,7 @@ static void imsm_update_metadata_locally(struct supertype *st,
 static int write_imsm_migr_rec(struct supertype *st)
 {
 	struct intel_super *super = st->sb;
+	unsigned int sector_size = super->sector_size;
 	unsigned long long dsize;
 	char nm[30];
 	int fd = -1;
@@ -2680,6 +2713,8 @@ static int write_imsm_migr_rec(struct supertype *st)
 
 	map = get_imsm_map(dev, MAP_0);
 
+	if (sector_size == 4096)
+		convert_to_4k_imsm_migr_rec(super);
 	for (sd = super->disks ; sd ; sd = sd->next) {
 		int slot = -1;
 
@@ -2697,13 +2732,15 @@ static int write_imsm_migr_rec(struct supertype *st)
 		if (fd < 0)
 			continue;
 		get_dev_size(fd, NULL, &dsize);
-		if (lseek64(fd, dsize - MIGR_REC_POSITION, SEEK_SET) < 0) {
+		if (lseek64(fd, dsize - (MIGR_REC_SECTOR_POSITION*sector_size),
+		    SEEK_SET) < 0) {
 			pr_err("Cannot seek to anchor block: %s\n",
 			       strerror(errno));
 			goto out;
 		}
-		if (write(fd, super->migr_rec_buf, MIGR_REC_BUF_SIZE) !=
-							    MIGR_REC_BUF_SIZE) {
+		if (write(fd, super->migr_rec_buf,
+		    MIGR_REC_BUF_SECTORS*sector_size) !=
+		    MIGR_REC_BUF_SECTORS*sector_size) {
 			pr_err("Cannot write migr record block: %s\n",
 			       strerror(errno));
 			goto out;
@@ -2711,9 +2748,10 @@ static int write_imsm_migr_rec(struct supertype *st)
 		close(fd);
 		fd = -1;
 	}
+	if (sector_size == 4096)
+		convert_from_4k_imsm_migr_rec(super);
 	/* update checkpoint information in metadata */
 	len = imsm_create_metadata_checkpoint_update(super, &u);
-
 	if (len <= 0) {
 		dprintf("imsm: Cannot prepare update\n");
 		goto out;
@@ -3837,7 +3875,8 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	sectors = mpb_sectors(anchor, sector_size) - 1;
 	free(anchor);
 
-	if (posix_memalign(&super->migr_rec_buf, 512, MIGR_REC_BUF_SIZE) != 0) {
+	if (posix_memalign(&super->migr_rec_buf, sector_size,
+	    MIGR_REC_BUF_SECTORS*sector_size) != 0) {
 		pr_err("could not allocate migr_rec buffer\n");
 		free(super->buf);
 		return 2;
@@ -4855,8 +4894,8 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 			pr_err("could not allocate new mpb\n");
 			return 0;
 		}
-		if (posix_memalign(&super->migr_rec_buf, 512,
-				   MIGR_REC_BUF_SIZE) != 0) {
+		if (posix_memalign(&super->migr_rec_buf, sector_size,
+				   MIGR_REC_BUF_SECTORS*sector_size) != 0) {
 			pr_err("could not allocate migr_rec buffer\n");
 			free(super->buf);
 			free(super);
@@ -5018,7 +5057,8 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,
 		pr_err("could not allocate superblock\n");
 		return 0;
 	}
-	if (posix_memalign(&super->migr_rec_buf, 512, MIGR_REC_BUF_SIZE) != 0) {
+	if (posix_memalign(&super->migr_rec_buf, MAX_SECTOR_SIZE,
+	    MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
 		pr_err("could not allocate migr_rec buffer\n");
 		free(super->buf);
 		free(super);
@@ -5296,10 +5336,12 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	}
 
 	/* clear migr_rec when adding disk to container */
-	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
-	if (lseek64(fd, size - MIGR_REC_POSITION, SEEK_SET) >= 0) {
+	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SECTORS*super->sector_size);
+	if (lseek64(fd, size - MIGR_REC_SECTOR_POSITION*super->sector_size,
+	    SEEK_SET) >= 0) {
 		if (write(fd, super->migr_rec_buf,
-			MIGR_REC_BUF_SIZE) != MIGR_REC_BUF_SIZE)
+		    MIGR_REC_BUF_SECTORS*super->sector_size) !=
+		    MIGR_REC_BUF_SECTORS*super->sector_size)
 			perror("Write migr_rec failed");
 	}
 
@@ -5475,7 +5517,8 @@ static int write_super_imsm(struct supertype *st, int doclose)
 		super->clean_migration_record_by_mdmon = 0;
 	}
 	if (clear_migration_record)
-		memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
+		memset(super->migr_rec_buf, 0,
+		    MIGR_REC_BUF_SECTORS*sector_size);
 
 	if (sector_size == 4096)
 		convert_to_4k(super);
@@ -5489,9 +5532,11 @@ static int write_super_imsm(struct supertype *st, int doclose)
 			unsigned long long dsize;
 
 			get_dev_size(d->fd, NULL, &dsize);
-			if (lseek64(d->fd, dsize - 512, SEEK_SET) >= 0) {
+			if (lseek64(d->fd, dsize - sector_size,
+			    SEEK_SET) >= 0) {
 				if (write(d->fd, super->migr_rec_buf,
-					MIGR_REC_BUF_SIZE) != MIGR_REC_BUF_SIZE)
+				    MIGR_REC_BUF_SECTORS*sector_size) !=
+				    MIGR_REC_BUF_SECTORS*sector_size)
 					perror("Write migr_rec failed");
 			}
 		}
@@ -10715,6 +10760,7 @@ static int imsm_manage_reshape(
 	int ret_val = 0;
 	struct intel_super *super = st->sb;
 	struct intel_dev *dv;
+	unsigned int sector_size = super->sector_size;
 	struct imsm_dev *dev = NULL;
 	struct imsm_map *map_src;
 	int migr_vol_qan = 0;
@@ -10792,8 +10838,8 @@ static int imsm_manage_reshape(
 	buf_size += __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
 	/* add space for stripe aligment */
 	buf_size += old_data_stripe_length;
-	if (posix_memalign((void **)&buf, 4096, buf_size)) {
-		dprintf("imsm: Cannot allocate checpoint buffer\n");
+	if (posix_memalign((void **)&buf, MAX_SECTOR_SIZE, buf_size)) {
+		dprintf("imsm: Cannot allocate checkpoint buffer\n");
 		goto abort;
 	}
 
@@ -10909,17 +10955,18 @@ static int imsm_manage_reshape(
 	/* clear migr_rec on disks after successful migration */
 	struct dl *d;
 
-	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SIZE);
+	memset(super->migr_rec_buf, 0, MIGR_REC_BUF_SECTORS*sector_size);
 	for (d = super->disks; d; d = d->next) {
 		if (d->index < 0 || is_failed(&d->disk))
 			continue;
 		unsigned long long dsize;
 
 		get_dev_size(d->fd, NULL, &dsize);
-		if (lseek64(d->fd, dsize - MIGR_REC_POSITION,
+		if (lseek64(d->fd, dsize - MIGR_REC_SECTOR_POSITION*sector_size,
 			    SEEK_SET) >= 0) {
 			if (write(d->fd, super->migr_rec_buf,
-				MIGR_REC_BUF_SIZE) != MIGR_REC_BUF_SIZE)
+			    MIGR_REC_BUF_SECTORS*sector_size) !=
+			    MIGR_REC_BUF_SECTORS*sector_size)
 				perror("Write migr_rec failed");
 		}
 	}
-- 
2.7.4

