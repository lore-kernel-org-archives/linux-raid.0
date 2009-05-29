From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 2/2] md: Move check for bitmap presence to personality code.
Date: Fri, 29 May 2009 15:18:42 +0200
Message-ID: <1243603122-11116-3-git-send-email-maan@systemlinux.org>
References: <1243603122-11116-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243603122-11116-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

If the superblock of a component device indicates the presence of a
bitmap but the corresponding raid personality does not support bitmaps
(raid0, linear, multipath, faulty), then something is seriously wrong
and we'd better refuse to run such an array.

Currently, this check is performed while the superblocks are examined,
i.e. before entering personality code. Therefore the generic md layer
must know which raid levels support bitmaps and which do not.

This patch avoids this layer violation without adding identical code
to various personalities. This is accomplished by introducing a new
public function to md.c, md_bitmap_present(), which replaces the
hard-coded checks in the superblock loading functions.

A call to md_bitmap_present() is added to the ->run method of each
personality which does not support bitmaps and assembly is aborted
if at least one component device contains a bitmap.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/faulty.c    |    6 +++-
 drivers/md/linear.c    |    2 +
 drivers/md/md.c        |   64 +++++++++++++++++++++++++++++++----------------
 drivers/md/md.h        |    1 +
 drivers/md/multipath.c |    3 ++
 drivers/md/raid0.c     |    2 +
 6 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 8695809..cec5d1e 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -298,8 +298,12 @@ static int run(mddev_t *mddev)
 {
 	mdk_rdev_t *rdev;
 	int i;
+	conf_t *conf;
 
-	conf_t *conf = kmalloc(sizeof(*conf), GFP_KERNEL);
+	if (md_bitmap_present(mddev))
+		return -EINVAL;
+
+	conf = kmalloc(sizeof(*conf), GFP_KERNEL);
 	if (!conf)
 		return -ENOMEM;
 
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index ead1051..2ca5514 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -183,6 +183,8 @@ static int linear_run (mddev_t *mddev)
 {
 	linear_conf_t *conf;
 
+	if (md_bitmap_present(mddev))
+		return -EINVAL;
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 	conf = linear_conf(mddev, mddev->raid_disks);
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1d71cc2..32e3197 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -748,6 +748,48 @@ struct super_type  {
 };
 
 /*
+ * Determine if at least one rdev contains a bitmap.
+ *
+ * Iterate over the component devices in mddev, print an error message and
+ * return non-zero on the first rdev whose superblock indicates the presence of
+ * a bitmap. Return 0 if no component device of mddev contains a bitmap.
+ *
+ * This is supposed to be called in the run method of all personalities that do
+ * not support bitmaps.
+ */
+int md_bitmap_present(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	char b[BDEVNAME_SIZE];
+
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (!rdev->sb_loaded || !rdev->sb_page)
+			continue;
+		switch (mddev->major_version) {
+		case 0: {
+			mdp_super_t *sb = page_address(rdev->sb_page);
+			if (sb->state & (1 << MD_SB_BITMAP_PRESENT))
+				goto whine;
+			}
+		case 1: {
+			struct mdp_superblock_1 *sb =
+				page_address(rdev->sb_page);
+			if ((le32_to_cpu(sb->feature_map) &
+					MD_FEATURE_BITMAP_OFFSET))
+				goto whine;
+			}
+		}
+	}
+	return 0;
+whine:
+	printk(KERN_ERR "%s: %s contains a bitmap but"
+		"bitmaps are not supported for %s\n", mdname(mddev),
+		bdevname(rdev->bdev, b), mddev->pers->name);
+	return 1;
+}
+EXPORT_SYMBOL(md_bitmap_present);
+
+/*
  * load_super for 0.90.0 
  */
 static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
@@ -800,17 +842,6 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 	rdev->data_offset = 0;
 	rdev->sb_size = MD_SB_BYTES;
 
-	if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
-		if (sb->level != 1 && sb->level != 4
-		    && sb->level != 5 && sb->level != 6
-		    && sb->level != 10) {
-			/* FIXME use a better test */
-			printk(KERN_WARNING
-			       "md: bitmaps not supported for this level.\n");
-			goto abort;
-		}
-	}
-
 	if (sb->level == LEVEL_MULTIPATH)
 		rdev->desc_nr = -1;
 	else
@@ -1188,17 +1219,6 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 		       bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
-	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET)) {
-		if (sb->level != cpu_to_le32(1) &&
-		    sb->level != cpu_to_le32(4) &&
-		    sb->level != cpu_to_le32(5) &&
-		    sb->level != cpu_to_le32(6) &&
-		    sb->level != cpu_to_le32(10)) {
-			printk(KERN_WARNING
-			       "md: bitmaps not supported for this level.\n");
-			return -EINVAL;
-		}
-	}
 
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4274cdc..903479f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -438,5 +438,6 @@ extern void md_new_event(mddev_t *mddev);
 extern int md_allow_write(mddev_t *mddev);
 extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
+extern int md_bitmap_present(mddev_t *mddev);
 
 #endif /* _MD_MD_H */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index ca387ba..d11285c 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -421,6 +421,9 @@ static int multipath_run (mddev_t *mddev)
 	struct multipath_info *disk;
 	mdk_rdev_t *rdev;
 
+	if (md_bitmap_present(mddev))
+		return -EINVAL;
+
 	if (mddev->level != LEVEL_MULTIPATH) {
 		printk("multipath: %s: raid level not set to multipath IO (%d)\n",
 		       mdname(mddev), mddev->level);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7d680bc..9d6f14e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -311,6 +311,8 @@ static int raid0_run(mddev_t *mddev)
 		printk(KERN_ERR "md/raid0: chunk size must be a power of 2.\n");
 		return -EINVAL;
 	}
+	if (md_bitmap_present(mddev))
+		return -EINVAL;
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
-- 
1.5.4.3

