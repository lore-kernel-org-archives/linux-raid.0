From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V4] md: move bitmap_destroy to the beginning of __md_stop
Date: Tue, 14 Mar 2017 09:40:20 +0800
Message-ID: <1489455620-16306-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since we have switched to sync way to handle METADATA_UPDATED
msg for md-cluster, then process_metadata_update is depended
on mddev->thread->wqueue.

With the new change, clustered raid could possible hang if
array received a METADATA_UPDATED msg after array unregistered
mddev->thread, so we need to stop clustered raid (bitmap_destroy
-> bitmap_free -> md_cluster_stop) earlier than unregister
thread (mddev_detach -> md_unregister_thread).

And this change should be safe for non-clustered raid since
all writes are stopped before the destroy. Also in md_run,
we activate the personality (pers->run()) before activating
the bitmap (bitmap_create()). So it is pleasingly symmetric
to stop the bitmap (bitmap_destroy()) before stopping the
personality (__md_stop() calls pers->free()), we achieve this
by move bitmap_destroy to the beginning of __md_stop.

But we don't want to break the codes for waiting behind IO as
Shaohua mentioned, so introduce bitmap_wait_behind_writes to
call the codes, and call the new fun in both mddev_detach and
bitmap_destroy, then we will not break original behind IO code
and also fit the new condition well.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
Changes from v3:
1. move bitmap_destroy to __md_stop
2. add bitmap_wait_behind_writes to handle behind IO

 drivers/md/bitmap.c | 17 +++++++++++++++++
 drivers/md/bitmap.h |  1 +
 drivers/md/md.c     | 13 ++-----------
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index b6fa55a3cff8..20cad80d6e34 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1764,6 +1764,21 @@ void bitmap_free(struct bitmap *bitmap)
 }
 EXPORT_SYMBOL(bitmap_free);
 
+void bitmap_wait_behind_writes(struct mddev *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+
+	/* wait for behind writes to complete */
+	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
+			 mdname(mddev));
+		/* need to kick something here to make sure I/O goes? */
+		wait_event(bitmap->behind_wait,
+			   atomic_read(&bitmap->behind_writes) == 0);
+	}
+}
+EXPORT_SYMBOL(bitmap_wait_behind_writes);
+
 void bitmap_destroy(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
@@ -1771,6 +1786,8 @@ void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
+	bitmap_wait_behind_writes(mddev);
+
 	mutex_lock(&mddev->bitmap_info.mutex);
 	spin_lock(&mddev->lock);
 	mddev->bitmap = NULL; /* disconnect from the md device */
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 9f761097aab2..d15721ac07a6 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -271,6 +271,7 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int bitmap_copy_from_slot(struct mddev *mddev, int slot,
 				sector_t *lo, sector_t *hi, bool clear_bits);
 void bitmap_free(struct bitmap *bitmap);
+void bitmap_wait_behind_writes(struct mddev *mddev);
 #endif
 
 #endif
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 79a99a1c9ce7..dc131fabfc7c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5534,15 +5534,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 
 static void mddev_detach(struct mddev *mddev)
 {
-	struct bitmap *bitmap = mddev->bitmap;
-	/* wait for behind writes to complete */
-	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
-		pr_debug("md:%s: behind writes in progress - waiting to stop.\n",
-			 mdname(mddev));
-		/* need to kick something here to make sure I/O goes? */
-		wait_event(bitmap->behind_wait,
-			   atomic_read(&bitmap->behind_writes) == 0);
-	}
+	bitmap_wait_behind_writes(mddev);
 	if (mddev->pers && mddev->pers->quiesce) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
@@ -5555,6 +5547,7 @@ static void mddev_detach(struct mddev *mddev)
 static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
+	bitmap_destroy(mddev);
 	mddev_detach(mddev);
 	/* Ensure ->event_work is done */
 	flush_workqueue(md_misc_wq);
@@ -5575,7 +5568,6 @@ void md_stop(struct mddev *mddev)
 	 * This is called from dm-raid
 	 */
 	__md_stop(mddev);
-	bitmap_destroy(mddev);
 	if (mddev->bio_set)
 		bioset_free(mddev->bio_set);
 }
@@ -5713,7 +5705,6 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	if (mode == 0) {
 		pr_info("md: %s stopped.\n", mdname(mddev));
 
-		bitmap_destroy(mddev);
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
 			spin_lock(&mddev->lock);
-- 
2.6.2

