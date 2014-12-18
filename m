From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 12/24] bitmap_create returns bitmap pointer
Date: Thu, 18 Dec 2014 10:17:24 -0600
Message-ID: <20141218161723.GA29622@shrek.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: lzhong@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is done to have multiple bitmaps open at the same time.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/bitmap.c | 59 ++++++++++++++++++++++++++++++-----------------------
 drivers/md/bitmap.h |  2 +-
 drivers/md/md.c     | 22 +++++++++++++-------
 3 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 23a71a7..49b7e33 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -540,7 +540,6 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	unsigned long sectors_reserved = 0;
 	int err = -EINVAL;
 	struct page *sb_page;
-	int cluster_setup_done = 0;
 
 	if (!bitmap->storage.file && !bitmap->mddev->bitmap_info.offset) {
 		chunksize = 128 * 1024 * 1024;
@@ -557,6 +556,16 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	bitmap->storage.sb_page = sb_page;
 
 re_read:
+	/* If cluster_slot is set, the cluster is setup */
+	if (bitmap->cluster_slot >= 0) {
+		long long bm_blocks = bitmap->mddev->resync_max_sectors / (bitmap->mddev->bitmap_info.chunksize >> 9);
+		bm_blocks = bm_blocks << 3;
+		bm_blocks = DIV_ROUND_UP(bm_blocks, 4096);
+		bitmap->mddev->bitmap_info.offset += bitmap->cluster_slot * (bm_blocks << 3);
+		pr_info("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
+			bitmap->cluster_slot, (unsigned long long)bitmap->mddev->bitmap_info.offset);
+	}
+
 	if (bitmap->storage.file) {
 		loff_t isize = i_size_read(bitmap->storage.file->f_mapping->host);
 		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
@@ -637,12 +646,9 @@ re_read:
 
 out:
 	kunmap_atomic(sb);
-	if (nodes && !cluster_setup_done) {
-		sector_t bm_blocks = sector_div(bitmap->mddev->resync_max_sectors,(chunksize >> 9));
-		bm_blocks = bm_blocks << 3;
-		/* We have bitmap supers at 4k boundaries, hence this
-		 * is hardcoded */
-		bm_blocks = DIV_ROUND_UP(bm_blocks, 4096);
+	/* Assiging chunksize is required for "re_read" */
+	bitmap->mddev->bitmap_info.chunksize = chunksize;
+	if (nodes && (bitmap->cluster_slot < 0)) {
 		err = md_setup_cluster(bitmap->mddev, nodes);
 		if (err) {
 			pr_err("%s: Could not setup cluster service (%d)\n",
@@ -650,12 +656,6 @@ out:
 			goto out_no_sb;
 		}
 		bitmap->cluster_slot = md_cluster_ops->slot_number(bitmap->mddev);
-		bitmap->mddev->bitmap_info.offset +=
-			bitmap->cluster_slot * (bm_blocks << 3);
-		printk("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
-			bitmap->cluster_slot,
-			(unsigned long long)bitmap->mddev->bitmap_info.offset);
-		cluster_setup_done = 1;
 		goto re_read;
 	}
 
@@ -672,7 +672,7 @@ out_no_sb:
 		bitmap->mddev->bitmap_info.space = sectors_reserved;
 	if (err) {
 		bitmap_print_sb(bitmap);
-		if (cluster_setup_done)
+		if (bitmap->cluster_slot < 0)
 			md_cluster_stop(bitmap->mddev);
 	}
 	return err;
@@ -1631,7 +1631,8 @@ static void bitmap_free(struct bitmap *bitmap)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
-	if (mddev_is_clustered(bitmap->mddev) && bitmap->mddev->cluster_info)
+	if (mddev_is_clustered(bitmap->mddev) && bitmap->mddev->cluster_info &&
+		bitmap->cluster_slot == md_cluster_ops->slot_number(bitmap->mddev))
 		md_cluster_stop(bitmap->mddev);
 
 	/* Shouldn't be needed - but just in case.... */
@@ -1677,7 +1678,7 @@ void bitmap_destroy(struct mddev *mddev)
  * initialize the bitmap structure
  * if this returns an error, bitmap_destroy must be called to do clean up
  */
-int bitmap_create(struct mddev *mddev)
+struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 {
 	struct bitmap *bitmap;
 	sector_t blocks = mddev->resync_max_sectors;
@@ -1691,7 +1692,7 @@ int bitmap_create(struct mddev *mddev)
 
 	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
 	if (!bitmap)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&bitmap->counts.lock);
 	atomic_set(&bitmap->pending_writes, 0);
@@ -1700,6 +1701,7 @@ int bitmap_create(struct mddev *mddev)
 	init_waitqueue_head(&bitmap->behind_wait);
 
 	bitmap->mddev = mddev;
+	bitmap->cluster_slot = slot;
 
 	if (mddev->kobj.sd)
 		bm = sysfs_get_dirent(mddev->kobj.sd, "bitmap");
@@ -1747,12 +1749,14 @@ int bitmap_create(struct mddev *mddev)
 	printk(KERN_INFO "created bitmap (%lu pages) for device %s\n",
 	       bitmap->counts.pages, bmname(bitmap));
 
-	mddev->bitmap = bitmap;
-	return test_bit(BITMAP_WRITE_ERROR, &bitmap->flags) ? -EIO : 0;
+	err = test_bit(BITMAP_WRITE_ERROR, &bitmap->flags) ? -EIO : 0;
+	if (err)
+		goto error;
 
+	return bitmap;
  error:
 	bitmap_free(bitmap);
-	return err;
+	return ERR_PTR(err);
 }
 
 int bitmap_load(struct mddev *mddev)
@@ -2064,13 +2068,18 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 				return -EINVAL;
 			mddev->bitmap_info.offset = offset;
 			if (mddev->pers) {
+				struct bitmap *bitmap;
 				mddev->pers->quiesce(mddev, 1);
-				rv = bitmap_create(mddev);
-				if (!rv)
+				bitmap = bitmap_create(mddev, -1);
+				if (IS_ERR(bitmap))
+					rv = PTR_ERR(bitmap);
+				else {
+					mddev->bitmap = bitmap;
 					rv = bitmap_load(mddev);
-				if (rv) {
-					bitmap_destroy(mddev);
-					mddev->bitmap_info.offset = 0;
+					if (rv) {
+						bitmap_destroy(mddev);
+						mddev->bitmap_info.offset = 0;
+					}
 				}
 				mddev->pers->quiesce(mddev, 0);
 				if (rv)
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 2e0f540..ac3fc40 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -233,7 +233,7 @@ struct bitmap {
 /* the bitmap API */
 
 /* these are used only by md/bitmap */
-int  bitmap_create(struct mddev *mddev);
+struct bitmap *bitmap_create(struct mddev *mddev, int slot);
 int bitmap_load(struct mddev *mddev);
 void bitmap_flush(struct mddev *mddev);
 void bitmap_destroy(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a2c1cac..6ac6609 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5087,12 +5087,15 @@ int md_run(struct mddev *mddev)
 	}
 	if (err == 0 && mddev->pers->sync_request &&
 	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
-		err = bitmap_create(mddev);
-		if (err) {
+		struct bitmap *bitmap = bitmap_create(mddev, -1);
+		if (IS_ERR(bitmap)) {
+			err = PTR_ERR(bitmap);
 			printk(KERN_ERR "%s: failed to create bitmap (%d)\n",
 			       mdname(mddev), err);
 			mddev->pers->stop(mddev);
-		}
+		} else
+			mddev->bitmap = bitmap;
+
 	}
 	if (err) {
 		module_put(mddev->pers->owner);
@@ -6028,9 +6031,11 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 	if (mddev->pers) {
 		mddev->pers->quiesce(mddev, 1);
 		if (fd >= 0) {
-			err = bitmap_create(mddev);
-			if (!err)
+			struct bitmap *bitmap = bitmap_create(mddev, -1);
+			if (!IS_ERR(bitmap)) {
+				mddev->bitmap = bitmap;
 				err = bitmap_load(mddev);
+			}
 		}
 		if (fd < 0 || err) {
 			bitmap_destroy(mddev);
@@ -6287,6 +6292,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		if (mddev->recovery || mddev->sync_thread)
 			return -EBUSY;
 		if (info->state & (1<<MD_SB_BITMAP_PRESENT)) {
+			struct bitmap *bitmap;
 			/* add the bitmap */
 			if (mddev->bitmap)
 				return -EEXIST;
@@ -6297,9 +6303,11 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
 			mddev->pers->quiesce(mddev, 1);
-			rv = bitmap_create(mddev);
-			if (!rv)
+			bitmap = bitmap_create(mddev, -1);
+			if (!IS_ERR(bitmap)) {
+				mddev->bitmap = bitmap;
 				rv = bitmap_load(mddev);
+			}
 			if (rv)
 				bitmap_destroy(mddev);
 			mddev->pers->quiesce(mddev, 0);
-- 
2.1.2

