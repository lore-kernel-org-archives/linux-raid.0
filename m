From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V3] md: move bitmap_destroy before __md_stop
Date: Wed,  8 Mar 2017 10:31:32 +0800
Message-ID: <1488940292-8555-1-git-send-email-gqjiang@suse.com>
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
personality (__md_stop() calls pers->free()).

But we don't want to break the codes for waiting behind IO as
Shaohua mentioned, so move those codes from mddev_detach to
bitmap_destroy. Since we already check bitmap at the beginning
of bitmap_destroy, just wait for behind_writes to be zero if
it existed.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
This version move waiting behind IO codes into bitmap_destroy
so we can safely call bitmap_destroy before __md_stop now.

 drivers/md/bitmap.c |  9 +++++++++
 drivers/md/md.c     | 13 ++-----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index b6fa55a3cff8..89a35bc092dd 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1771,6 +1771,15 @@ void bitmap_destroy(struct mddev *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
+	/* wait for behind writes to complete */
+	if (atomic_read(&bitmap->behind_writes) > 0) {
+		printk(KERN_INFO "md:%s: behind writes in progress - waiting to stop.\n",
+		       mdname(mddev));
+		/* need to kick something here to make sure I/O goes? */
+		wait_event(bitmap->behind_wait,
+			   atomic_read(&bitmap->behind_writes) == 0);
+	}
+
 	mutex_lock(&mddev->bitmap_info.mutex);
 	spin_lock(&mddev->lock);
 	mddev->bitmap = NULL; /* disconnect from the md device */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 79a99a1c9ce7..b63ab4f33892 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5534,15 +5534,6 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 
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
 	if (mddev->pers && mddev->pers->quiesce) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
@@ -5574,8 +5565,8 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
-	__md_stop(mddev);
 	bitmap_destroy(mddev);
+	__md_stop(mddev);
 	if (mddev->bio_set)
 		bioset_free(mddev->bio_set);
 }
@@ -5688,6 +5679,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 			set_disk_ro(disk, 0);
 
 		__md_stop_writes(mddev);
+		bitmap_destroy(mddev);
 		__md_stop(mddev);
 		mddev->queue->backing_dev_info->congested_fn = NULL;
 
@@ -5713,7 +5705,6 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	if (mode == 0) {
 		pr_info("md: %s stopped.\n", mdname(mddev));
 
-		bitmap_destroy(mddev);
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
 			spin_lock(&mddev->lock);
-- 
2.6.2

