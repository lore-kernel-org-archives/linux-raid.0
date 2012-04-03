From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/10] md: add possibility to change data-offset for
 devices.
Date: Tue, 03 Apr 2012 15:53:01 +1000
Message-ID: <20120403055301.19495.7164.stgit@notabene.brown>
References: <20120403054656.19495.36380.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120403054656.19495.36380.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When reshaping we can avoid costly intermediate backup by
changing the 'start' address of the array on the device
(if there is enough room).

So as a first step, allow such a change to be requested
through sysfs, and recorded in v1.x metadata.

(As we didn't previous check that all 'pad' fields were zero,
 we need a new FEATURE flag for this.
 A (belatedly) check that all remaining 'pad' fields are
 zero to avoid a repeat of this)

The new data offset must be requested separately for each device.
This allows each to have a different change in the data offset.
This is not likely to be used often but as data_offset can be
set per-device, new_data_offset should be too.

This patch also removes the 'acknowledged' arg to rdev_set_badblocks as
it is never used and never will be.  At the same time we add a new
arg ('in_new') which is currently always zero but will be used more
soon.

When a reshape finishes we will need to update the data_offset
and rdev->sectors.  So provide an exported function to do that.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c           |  220 +++++++++++++++++++++++++++++++++++++++++----
 drivers/md/md.h           |    7 +
 drivers/md/raid1.c        |    4 -
 drivers/md/raid10.c       |    8 +-
 drivers/md/raid5.c        |   10 +-
 include/linux/raid/md_p.h |   10 ++
 6 files changed, 225 insertions(+), 34 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1ea2e26..0db613d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1033,12 +1033,17 @@ static unsigned int calc_sb_csum(mdp_super_t * sb)
 struct super_type  {
 	char		    *name;
 	struct module	    *owner;
-	int		    (*load_super)(struct md_rdev *rdev, struct md_rdev *refdev,
+	int		    (*load_super)(struct md_rdev *rdev,
+					  struct md_rdev *refdev,
 					  int minor_version);
-	int		    (*validate_super)(struct mddev *mddev, struct md_rdev *rdev);
-	void		    (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
+	int		    (*validate_super)(struct mddev *mddev,
+					      struct md_rdev *rdev);
+	void		    (*sync_super)(struct mddev *mddev,
+					  struct md_rdev *rdev);
 	unsigned long long  (*rdev_size_change)(struct md_rdev *rdev,
 						sector_t num_sectors);
+	int		    (*allow_new_offset)(struct md_rdev *rdev,
+						unsigned long long new_offset);
 };
 
 /*
@@ -1110,6 +1115,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 
 	rdev->preferred_minor = sb->md_minor;
 	rdev->data_offset = 0;
+	rdev->new_data_offset = 0;
 	rdev->sb_size = MD_SB_BYTES;
 	rdev->badblocks.shift = -1;
 
@@ -1436,6 +1442,12 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	return num_sectors;
 }
 
+static int
+super_90_allow_new_offset(struct md_rdev *rdev, unsigned long long new_offset)
+{
+	/* non-zero offset changes not possible with v0.90 */
+	return new_offset == 0;
+}
 
 /*
  * version 1 superblock
@@ -1471,6 +1483,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	struct mdp_superblock_1 *sb;
 	int ret;
 	sector_t sb_start;
+	sector_t sectors;
 	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	int bmask;
 
@@ -1525,9 +1538,18 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		       bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
+	if (sb->pad0 ||
+	    sb->pad3[0] ||
+	    memcmp(sb->pad3, sb->pad3+1, sizeof(sb->pad3) - sizeof(sb->pad3[1])))
+		/* Some padding is non-zero, might be a new feature */
+		return -EINVAL;
 
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
+	rdev->new_data_offset = rdev->data_offset;
+	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE) &&
+	    (le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
+		rdev->new_data_offset += (s32)le32_to_cpu(sb->new_offset);
 	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
 
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
@@ -1538,6 +1560,9 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	if (minor_version
 	    && rdev->data_offset < sb_start + (rdev->sb_size/512))
 		return -EINVAL;
+	if (minor_version
+	    && rdev->new_data_offset < sb_start + (rdev->sb_size/512))
+		return -EINVAL;
 
 	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
 		rdev->desc_nr = -1;
@@ -1609,16 +1634,17 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		else
 			ret = 0;
 	}
-	if (minor_version)
-		rdev->sectors = (i_size_read(rdev->bdev->bd_inode) >> 9) -
-			le64_to_cpu(sb->data_offset);
-	else
-		rdev->sectors = rdev->sb_start;
-	if (rdev->sectors < le64_to_cpu(sb->data_size))
+	if (minor_version) {
+		sectors = (i_size_read(rdev->bdev->bd_inode) >> 9);
+		if (rdev->data_offset > rdev->new_data_offset)
+			sectors -= rdev->data_offset;
+		else
+			sectors -= rdev->new_data_offset;
+	} else
+		sectors = rdev->sb_start;
+	if (sectors < le64_to_cpu(sb->data_size))
 		return -EINVAL;
 	rdev->sectors = le64_to_cpu(sb->data_size);
-	if (le64_to_cpu(sb->size) > rdev->sectors)
-		return -EINVAL;
 	return ret;
 }
 
@@ -1743,7 +1769,6 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->feature_map = 0;
 	sb->pad0 = 0;
 	sb->recovery_offset = cpu_to_le64(0);
-	memset(sb->pad1, 0, sizeof(sb->pad1));
 	memset(sb->pad3, 0, sizeof(sb->pad3));
 
 	sb->utime = cpu_to_le64((__u64)mddev->utime);
@@ -1765,6 +1790,8 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->devflags |= WriteMostly1;
 	else
 		sb->devflags &= ~WriteMostly1;
+	sb->data_offset = cpu_to_le64(rdev->data_offset);
+	sb->data_size = cpu_to_le64(rdev->sectors);
 
 	if (mddev->bitmap && mddev->bitmap_info.file == NULL) {
 		sb->bitmap_offset = cpu_to_le32((__u32)mddev->bitmap_info.offset);
@@ -1793,6 +1820,12 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		    mddev->reshape_backwards)
 			sb->feature_map
 				|= cpu_to_le32(MD_FEATURE_RESHAPE_BACKWARDS);
+		if (rdev->new_data_offset != rdev->data_offset) {
+			sb->feature_map
+				|= cpu_to_le32(MD_FEATURE_NEW_OFFSET);
+			sb->new_offset = cpu_to_le32((__u32)(rdev->new_data_offset
+							     - rdev->data_offset));
+		}
 	}
 
 	if (rdev->badblocks.count == 0)
@@ -1869,6 +1902,8 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	sector_t max_sectors;
 	if (num_sectors && num_sectors < rdev->mddev->dev_sectors)
 		return 0; /* component must fit device */
+	if (rdev->data_offset != rdev->new_data_offset)
+		return 0; /* too confusing */
 	if (rdev->sb_start < rdev->data_offset) {
 		/* minor versions 1 and 2; superblock before data */
 		max_sectors = i_size_read(rdev->bdev->bd_inode) >> 9;
@@ -1896,6 +1931,40 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);
 	return num_sectors;
+
+}
+
+static int
+super_1_allow_new_offset(struct md_rdev *rdev,
+			 unsigned long long new_offset)
+{
+	/* All necessary checks on new >= old have been done */
+	struct bitmap *bitmap;
+	if (new_offset >= rdev->data_offset)
+		return 1;
+
+	/* with 1.0 metadata, there is no metadata to tread on
+	 * so we can always move back */
+	if (rdev->mddev->minor_version == 0)
+		return 1;
+
+	/* otherwise we must be sure not to step on
+	 * any metadata, so stay:
+	 * 36K beyond start of superblock
+	 * beyond end of badblocks
+	 * beyond write-intent bitmap
+	 */
+	if (rdev->sb_start + (32+4)*2 > new_offset)
+		return 0;
+	bitmap = rdev->mddev->bitmap;
+	if (bitmap && !rdev->mddev->bitmap_info.file &&
+	    rdev->sb_start + rdev->mddev->bitmap_info.offset +
+	    bitmap->file_pages * (PAGE_SIZE>>9) > new_offset)
+		return 0;
+	if (rdev->badblocks.sector + rdev->badblocks.size > new_offset)
+		return 0;
+
+	return 1;
 }
 
 static struct super_type super_types[] = {
@@ -1906,6 +1975,7 @@ static struct super_type super_types[] = {
 		.validate_super	    = super_90_validate,
 		.sync_super	    = super_90_sync,
 		.rdev_size_change   = super_90_rdev_size_change,
+		.allow_new_offset   = super_90_allow_new_offset,
 	},
 	[1] = {
 		.name	= "md-1",
@@ -1914,6 +1984,7 @@ static struct super_type super_types[] = {
 		.validate_super	    = super_1_validate,
 		.sync_super	    = super_1_sync,
 		.rdev_size_change   = super_1_rdev_size_change,
+		.allow_new_offset   = super_1_allow_new_offset,
 	},
 };
 
@@ -2821,9 +2892,8 @@ offset_show(struct md_rdev *rdev, char *page)
 static ssize_t
 offset_store(struct md_rdev *rdev, const char *buf, size_t len)
 {
-	char *e;
-	unsigned long long offset = simple_strtoull(buf, &e, 10);
-	if (e==buf || (*e && *e != '\n'))
+	unsigned long long offset;
+	if (strict_strtoull(buf, 10, &offset) < 0)
 		return -EINVAL;
 	if (rdev->mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
@@ -2838,6 +2908,63 @@ offset_store(struct md_rdev *rdev, const char *buf, size_t len)
 static struct rdev_sysfs_entry rdev_offset =
 __ATTR(offset, S_IRUGO|S_IWUSR, offset_show, offset_store);
 
+static ssize_t new_offset_show(struct md_rdev *rdev, char *page)
+{
+	return sprintf(page, "%llu\n",
+		       (unsigned long long)rdev->new_data_offset);
+}
+
+static ssize_t new_offset_store(struct md_rdev *rdev,
+				const char *buf, size_t len)
+{
+	unsigned long long new_offset;
+	struct mddev *mddev = rdev->mddev;
+
+	if (strict_strtoull(buf, 10, &new_offset) < 0)
+		return -EINVAL;
+
+	if (mddev->sync_thread)
+		return -EBUSY;
+	if (new_offset == rdev->data_offset)
+		/* reset is always permitted */
+		;
+	else if (new_offset > rdev->data_offset) {
+		/* must not push array size beyond rdev_sectors */
+		if (new_offset - rdev->data_offset
+		    + mddev->dev_sectors > rdev->sectors)
+				return -E2BIG;
+	}
+	/* Metadata worries about other space details. */
+
+	/* decreasing the offset is inconsistent with a backwards
+	 * reshape.
+	 */
+	if (new_offset < rdev->data_offset &&
+	    mddev->reshape_backwards)
+		return -EINVAL;
+	/* Increasing offset is inconsistent with forwards
+	 * reshape.  reshape_direction should be set to
+	 * 'backwards' first.
+	 */
+	if (new_offset > rdev->data_offset &&
+	    !mddev->reshape_backwards)
+		return -EINVAL;
+
+	if (mddev->pers && mddev->persistent &&
+	    !super_types[mddev->major_version]
+	    .allow_new_offset(rdev, new_offset))
+		return -E2BIG;
+	rdev->new_data_offset = new_offset;
+	if (new_offset > rdev->data_offset)
+		mddev->reshape_backwards = 1;
+	else if (new_offset < rdev->data_offset)
+		mddev->reshape_backwards = 0;
+
+	return len;
+}
+static struct rdev_sysfs_entry rdev_new_offset =
+__ATTR(new_offset, S_IRUGO|S_IWUSR, new_offset_show, new_offset_store);
+
 static ssize_t
 rdev_size_show(struct md_rdev *rdev, char *page)
 {
@@ -2882,6 +3009,8 @@ rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 
 	if (strict_blocks_to_sectors(buf, &sectors) < 0)
 		return -EINVAL;
+	if (rdev->data_offset != rdev->new_data_offset)
+		return -EINVAL; /* too confusing */
 	if (my_mddev->pers && rdev->raid_disk >= 0) {
 		if (my_mddev->persistent) {
 			sectors = super_types[my_mddev->major_version].
@@ -3018,6 +3147,7 @@ static struct attribute *rdev_default_attrs[] = {
 	&rdev_errors.attr,
 	&rdev_slot.attr,
 	&rdev_offset.attr,
+	&rdev_new_offset.attr,
 	&rdev_size.attr,
 	&rdev_recovery_start.attr,
 	&rdev_bad_blocks.attr,
@@ -3092,6 +3222,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	rdev->raid_disk = -1;
 	rdev->flags = 0;
 	rdev->data_offset = 0;
+	rdev->new_data_offset = 0;
 	rdev->sb_events = 0;
 	rdev->last_read_error.tv_sec  = 0;
 	rdev->last_read_error.tv_nsec = 0;
@@ -3596,7 +3727,17 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->pers)
 		rv = update_raid_disks(mddev, n);
 	else if (mddev->reshape_position != MaxSector) {
+		struct md_rdev *rdev;
 		int olddisks = mddev->raid_disks - mddev->delta_disks;
+
+		rdev_for_each(rdev, mddev) {
+			if (olddisks < n &&
+			    rdev->data_offset < rdev->new_data_offset)
+				return -EINVAL;
+			if (olddisks > n &&
+			    rdev->data_offset > rdev->new_data_offset)
+				return -EINVAL;
+		}
 		mddev->delta_disks = n - olddisks;
 		mddev->raid_disks = n;
 		mddev->reshape_backwards = (mddev->delta_disks < 0);
@@ -4443,6 +4584,7 @@ reshape_position_show(struct mddev *mddev, char *page)
 static ssize_t
 reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 {
+	struct md_rdev *rdev;
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
 	if (mddev->pers)
@@ -4455,6 +4597,8 @@ reshape_position_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->new_level = mddev->level;
 	mddev->new_layout = mddev->layout;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	rdev_for_each(rdev, mddev)
+		rdev->new_data_offset = rdev->data_offset;
 	return len;
 }
 
@@ -5999,6 +6143,7 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 static int update_raid_disks(struct mddev *mddev, int raid_disks)
 {
 	int rv;
+	struct md_rdev *rdev;
 	/* change the number of raid disks */
 	if (mddev->pers->check_reshape == NULL)
 		return -EINVAL;
@@ -6007,6 +6152,16 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
 		return -EINVAL;
 	if (mddev->sync_thread || mddev->reshape_position != MaxSector)
 		return -EBUSY;
+
+	rdev_for_each(rdev, mddev) {
+		if (mddev->raid_disks < raid_disks &&
+		    rdev->data_offset < rdev->new_data_offset)
+			return -EINVAL;
+		if (mddev->raid_disks > raid_disks &&
+		    rdev->data_offset > rdev->new_data_offset)
+			return -EINVAL;
+	}
+
 	mddev->delta_disks = raid_disks - mddev->raid_disks;
 	if (mddev->delta_disks < 0)
 		mddev->reshape_backwards = 1;
@@ -7707,6 +7862,20 @@ void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_wait_for_blocked_rdev);
 
+void md_finish_reshape(struct mddev *mddev)
+{
+	/* called be personality module when reshape completes. */
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev) {
+		if (rdev->data_offset > rdev->new_data_offset)
+			rdev->sectors += rdev->data_offset - rdev->new_data_offset;
+		else
+			rdev->sectors -= rdev->new_data_offset - rdev->data_offset;
+		rdev->data_offset = rdev->new_data_offset;
+	}
+}
+EXPORT_SYMBOL(md_finish_reshape);
 
 /* Bad block management.
  * We can record which blocks on each device are 'bad' and so just
@@ -7955,10 +8124,15 @@ static int md_set_badblocks(struct badblocks *bb, sector_t s, int sectors,
 }
 
 int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
-		       int acknowledged)
+		       int is_new)
 {
-	int rv = md_set_badblocks(&rdev->badblocks,
-				  s + rdev->data_offset, sectors, acknowledged);
+	int rv;
+	if (is_new)
+		s += rdev->new_data_offset;
+	else
+		s += rdev->data_offset;
+	rv = md_set_badblocks(&rdev->badblocks,
+			      s, sectors, 0);
 	if (rv) {
 		/* Make sure they get written out promptly */
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
@@ -8064,11 +8238,15 @@ out:
 	return rv;
 }
 
-int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors)
+int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+			 int is_new)
 {
+	if (is_new)
+		s += rdev->new_data_offset;
+	else
+		s += rdev->data_offset;
 	return md_clear_badblocks(&rdev->badblocks,
-				  s + rdev->data_offset,
-				  sectors);
+				  s, sectors);
 }
 EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d51c0ca..98913e8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -55,6 +55,7 @@ struct md_rdev {
 	int		sb_loaded;
 	__u64		sb_events;
 	sector_t	data_offset;	/* start of data in array */
+	sector_t	new_data_offset;/* only relevant while reshaping */
 	sector_t 	sb_start;	/* offset of the super block (in 512byte sectors) */
 	int		sb_size;	/* bytes in the superblock */
 	int		preferred_minor;	/* autorun support */
@@ -193,8 +194,9 @@ static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
 	return 0;
 }
 extern int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
-			      int acknowledged);
-extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors);
+			      int is_new);
+extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
+				int is_new);
 extern void md_ack_all_badblocks(struct badblocks *bb);
 
 struct mddev {
@@ -592,6 +594,7 @@ extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
+extern void md_finish_reshape(struct mddev *mddev);
 
 extern int mddev_congested(struct mddev *mddev, int bits);
 extern void md_flush_request(struct mddev *mddev, struct bio *bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d35e4c9..90bba78 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2023,7 +2023,7 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 			continue;
 		if (test_bit(BIO_UPTODATE, &bio->bi_flags) &&
 		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
-			rdev_clear_badblocks(rdev, r1_bio->sector, s);
+			rdev_clear_badblocks(rdev, r1_bio->sector, s, 0);
 		}
 		if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
 		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
@@ -2043,7 +2043,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			struct md_rdev *rdev = conf->mirrors[m].rdev;
 			rdev_clear_badblocks(rdev,
 					     r1_bio->sector,
-					     r1_bio->sectors);
+					     r1_bio->sectors, 0);
 			rdev_dec_pending(rdev, conf->mddev);
 		} else if (r1_bio->bios[m] != NULL) {
 			/* This drive got a write error.  We need to
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fff7821..b642841 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2480,7 +2480,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
-					r10_bio->sectors);
+					r10_bio->sectors, 0);
 			} else {
 				if (!rdev_set_badblocks(
 					    rdev,
@@ -2496,7 +2496,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
-					r10_bio->sectors);
+					r10_bio->sectors, 0);
 			} else {
 				if (!rdev_set_badblocks(
 					    rdev,
@@ -2515,7 +2515,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
-					r10_bio->sectors);
+					r10_bio->sectors, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL &&
 				   !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
@@ -2532,7 +2532,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
-					r10_bio->sectors);
+					r10_bio->sectors, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0abbd34..3705585 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3561,7 +3561,7 @@ finish:
 			if (test_and_clear_bit(R5_MadeGood, &dev->flags)) {
 				rdev = conf->disks[i].rdev;
 				rdev_clear_badblocks(rdev, sh->sector,
-						     STRIPE_SECTORS);
+						     STRIPE_SECTORS, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			if (test_and_clear_bit(R5_MadeGoodRepl, &dev->flags)) {
@@ -3570,7 +3570,7 @@ finish:
 					/* rdev have been moved down */
 					rdev = conf->disks[i].rdev;
 				rdev_clear_badblocks(rdev, sh->sector,
-						     STRIPE_SECTORS);
+						     STRIPE_SECTORS, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 		}
@@ -5505,10 +5505,14 @@ static int raid5_start_reshape(struct mddev *mddev)
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
-	rdev_for_each(rdev, mddev)
+	rdev_for_each(rdev, mddev) {
+		/* Don't support changing data_offset yet */
+		if (rdev->new_data_offset != rdev->data_offset)
+			return -EINVAL;
 		if (!test_bit(In_sync, &rdev->flags)
 		    && !test_bit(Faulty, &rdev->flags))
 			spares++;
+	}
 
 	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
 		/* Not enough devices even to make a degraded array
diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 07e05f9..ee75353 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -233,7 +233,10 @@ struct mdp_superblock_1 {
 	__le32	delta_disks;	/* change in number of raid_disks		*/
 	__le32	new_layout;	/* new layout					*/
 	__le32	new_chunk;	/* new chunk size (512byte sectors)		*/
-	__u8	pad1[128-124];	/* set to 0 when written */
+	__le32  new_offset;	/* signed number to add to data_offset in new
+				 * layout.  0 == no-change.  This can be
+				 * different on each device in the array.
+				 */
 
 	/* constant this-device information - 64 bytes */
 	__le64	data_offset;	/* sector start of data, often 0 */
@@ -285,11 +288,14 @@ struct mdp_superblock_1 {
 					    * of devices, but is going
 					    * backwards anyway.
 					    */
+#define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
 					|MD_FEATURE_BAD_BLOCKS		\
 					|MD_FEATURE_REPLACEMENT		\
-					|MD_FEATURE_RESHAPE_BACKWARDS)
+					|MD_FEATURE_RESHAPE_BACKWARDS	\
+					|MD_FEATURE_NEW_OFFSET		\
+					)
 
 #endif 


