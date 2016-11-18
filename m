From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 2/6] md: Use REQ_FAILFAST_* on metadata writes where
 appropriate
Date: Fri, 18 Nov 2016 16:16:11 +1100
Message-ID: <147944617167.3302.15513574606815740403.stgit@noble>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

This can only be supported on personalities which ensure
that md_error() never causes an array to enter the 'failed'
state.  i.e. if marking a device Faulty would cause some
data to be inaccessible, the device is status is left as
non-Faulty.  This is true for RAID1 and RAID10.

If we get a failure writing metadata but the device doesn't
fail, it must be the last device so we re-write without
FAILFAST to improve chance of success.  We also flag the
device as LastDev so that future metadata updates don't
waste time on failfast writes.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/bitmap.c |   15 ++++++++++++---
 drivers/md/md.c     |   44 ++++++++++++++++++++++++++++++++++----------
 drivers/md/md.h     |   21 ++++++++++++++++++++-
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 5 files changed, 68 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index cf77cbf9ed22..c4621571b718 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -209,11 +209,13 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
 
 static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct md_rdev *rdev = NULL;
+	struct md_rdev *rdev;
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
 
+restart:
+	rdev = NULL;
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
 		int size = PAGE_SIZE;
 		loff_t offset = mddev->bitmap_info.offset;
@@ -269,8 +271,8 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 			       page);
 	}
 
-	if (wait)
-		md_super_wait(mddev);
+	if (wait && md_super_wait(mddev) < 0)
+		goto restart;
 	return 0;
 
  bad_alignment:
@@ -428,6 +430,13 @@ static void bitmap_wait_writes(struct bitmap *bitmap)
 		wait_event(bitmap->write_wait,
 			   atomic_read(&bitmap->pending_writes)==0);
 	else
+		/* Note that we ignore the return value.  The writes
+		 * might have failed, but that would just mean that
+		 * some bits which should be cleared haven't been,
+		 * which is safe.  The relevant bitmap blocks will
+		 * probably get written again, but there is no great
+		 * loss if they aren't.
+		 */
 		md_super_wait(bitmap->mddev);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0d1a9fd9d1c1..047e7db1381b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -726,7 +726,13 @@ static void super_written(struct bio *bio)
 	if (bio->bi_error) {
 		pr_err("md: super_written gets error=%d\n", bio->bi_error);
 		md_error(mddev, rdev);
-	}
+		if (!test_bit(Faulty, &rdev->flags)
+		    && (bio->bi_opf & MD_FAILFAST)) {
+			set_bit(MD_NEED_REWRITE, &mddev->flags);
+			set_bit(LastDev, &rdev->flags);
+		}
+	} else
+		clear_bit(LastDev, &rdev->flags);
 
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
@@ -743,7 +749,13 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	 * if zero is reached.
 	 * If an error occurred, call md_error
 	 */
-	struct bio *bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
+	struct bio *bio;
+	int ff = 0;
+
+	if (test_bit(Faulty, &rdev->flags))
+		return;
+
+	bio = bio_alloc_mddev(GFP_NOIO, 1, mddev);
 
 	atomic_inc(&rdev->nr_pending);
 
@@ -752,16 +764,24 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
-	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_FLUSH_FUA);
+
+	if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
+	    test_bit(FailFast, &rdev->flags) &&
+	    !test_bit(LastDev, &rdev->flags))
+		ff = MD_FAILFAST;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_FLUSH_FUA | ff);
 
 	atomic_inc(&mddev->pending_writes);
 	submit_bio(bio);
 }
 
-void md_super_wait(struct mddev *mddev)
+int md_super_wait(struct mddev *mddev)
 {
 	/* wait for all superblock writes that were scheduled to complete */
 	wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
+	if (test_and_clear_bit(MD_NEED_REWRITE, &mddev->flags))
+		return -EAGAIN;
+	return 0;
 }
 
 int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
@@ -1333,9 +1353,10 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	if (IS_ENABLED(CONFIG_LBDAF) && (u64)num_sectors >= (2ULL << 32) &&
 	    rdev->mddev->level >= 1)
 		num_sectors = (sector_t)(2ULL << 32) - 2;
-	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
+	do
+		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
-	md_super_wait(rdev->mddev);
+	while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 }
 
@@ -1876,9 +1897,10 @@ super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	sb->data_size = cpu_to_le64(num_sectors);
 	sb->super_offset = rdev->sb_start;
 	sb->sb_csum = calc_sb_1_csum(sb);
-	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
-		       rdev->sb_page);
-	md_super_wait(rdev->mddev);
+	do
+		md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
+			       rdev->sb_page);
+	while (md_super_wait(rdev->mddev) < 0);
 	return num_sectors;
 
 }
@@ -2413,6 +2435,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	pr_debug("md: updating %s RAID superblock on device (in sync %d)\n",
 		 mdname(mddev), mddev->in_sync);
 
+rewrite:
 	bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
 		char b[BDEVNAME_SIZE];
@@ -2444,7 +2467,8 @@ void md_update_sb(struct mddev *mddev, int force_change)
 			/* only need to write one superblock... */
 			break;
 	}
-	md_super_wait(mddev);
+	if (md_super_wait(mddev) < 0)
+		goto rewrite;
 	/* if there was a failure, MD_CHANGE_DEVS was set, and we re-write super */
 
 	if (mddev_is_clustered(mddev) && ret == 0)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bc6712ef8c81..5c08f84101fa 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -30,6 +30,16 @@
 #define MaxSector (~(sector_t)0)
 
 /*
+ * These flags should really be called "NO_RETRY" rather than
+ * "FAILFAST" because they don't make any promise about time lapse,
+ * only about the number of retries, which will be zero.
+ * REQ_FAILFAST_DRIVER is not included because
+ * Commit: 4a27446f3e39 ("[SCSI] modify scsi to handle new fail fast flags.")
+ * seems to suggest that the errors it avoids retrying should usually
+ * be retried.
+ */
+#define	MD_FAILFAST	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT)
+/*
  * MD's 'extended' device
  */
 struct md_rdev {
@@ -177,6 +187,10 @@ enum flag_bits {
 				 * It is expects that no bad block log
 				 * is present.
 				 */
+	LastDev,		/* Seems to be the last working dev as
+				 * it didn't fail, so don't use FailFast
+				 * any more for metadata
+				 */
 };
 
 static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sectors,
@@ -213,6 +227,11 @@ enum mddev_flags {
 	MD_CLUSTER_RESYNC_LOCKED, /* cluster raid only, which means node
 				   * already took resync lock, need to
 				   * release the lock */
+	MD_FAILFAST_SUPPORTED,	/* Using MD_FAILFAST on metadata writes is
+				 * supported as calls to md_error() will
+				 * never cause the array to become failed.
+				 */
+	MD_NEED_REWRITE,	/* metadata write needs to be repeated */
 };
 #define MD_UPDATE_SB_FLAGS (BIT(MD_CHANGE_DEVS) | \
 			    BIT(MD_CHANGE_CLEAN) | \
@@ -628,7 +647,7 @@ extern int mddev_congested(struct mddev *mddev, int bits);
 extern void md_flush_request(struct mddev *mddev, struct bio *bio);
 extern void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 			   sector_t sector, int size, struct page *page);
-extern void md_super_wait(struct mddev *mddev);
+extern int md_super_wait(struct mddev *mddev);
 extern int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 			struct page *page, int op, int op_flags,
 			bool metadata_op);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 96474f0af1b8..cfd73730e6af 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2989,6 +2989,7 @@ static int raid1_run(struct mddev *mddev)
 	mddev->thread = conf->thread;
 	conf->thread = NULL;
 	mddev->private = conf;
+	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
 
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b53610c59104..763ca45b6b32 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3728,6 +3728,7 @@ static int raid10_run(struct mddev *mddev)
 	size = raid10_size(mddev, 0, 0);
 	md_set_array_sectors(mddev, size);
 	mddev->resync_max_sectors = size;
+	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
 
 	if (mddev->queue) {
 		int stripe = conf->geo.raid_disks *
