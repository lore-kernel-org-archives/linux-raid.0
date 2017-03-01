From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 2/5] md: move bitmap_destroy before __md_stop
Date: Wed,  1 Mar 2017 16:42:37 +0800
Message-ID: <1488357760-7893-3-git-send-email-gqjiang@suse.com>
References: <1488357760-7893-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488357760-7893-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since we have switched to sync way to handle METADATA_UPDATED
msg for md-cluster, then process_metadata_update is depended
on mddev->thread->wqueue.

With the new change, clustered raid could possible hang if
array received a METADATA_UPDATED msg after array unregistered
mddev->thread, so we need to stop clustered raid earlier
than before.

And this change should be safe for non-clustered raid since
all writes are stopped before the destroy. Also in md_run,
we activate the personality (pers->run()) before activating
the bitmap (bitmap_create()). So it is pleasingly symmetric
to stop the bitmap (bitmap_destroy()) before stopping the
personality (__md_stop() calls pers->free()).

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 44206bc6e3aa..e1d9116044ae 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5574,8 +5574,8 @@ void md_stop(struct mddev *mddev)
 	/* stop the array and free an attached data structures.
 	 * This is called from dm-raid
 	 */
-	__md_stop(mddev);
 	bitmap_destroy(mddev);
+	__md_stop(mddev);
 	if (mddev->bio_set)
 		bioset_free(mddev->bio_set);
 }
@@ -5688,6 +5688,22 @@ static int do_md_stop(struct mddev *mddev, int mode,
 			set_disk_ro(disk, 0);
 
 		__md_stop_writes(mddev);
+
+		/*
+		 * Destroy bitmap after all writes are stopped
+		 */
+		if (mode == 0) {
+			bitmap_destroy(mddev);
+			if (mddev->bitmap_info.file) {
+				struct file *f = mddev->bitmap_info.file;
+				spin_lock(&mddev->lock);
+				mddev->bitmap_info.file = NULL;
+				spin_unlock(&mddev->lock);
+				fput(f);
+			}
+			mddev->bitmap_info.offset = 0;
+		}
+
 		__md_stop(mddev);
 		mddev->queue->backing_dev_info->congested_fn = NULL;
 
@@ -5712,19 +5728,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 	 */
 	if (mode == 0) {
 		pr_info("md: %s stopped.\n", mdname(mddev));
-
-		bitmap_destroy(mddev);
-		if (mddev->bitmap_info.file) {
-			struct file *f = mddev->bitmap_info.file;
-			spin_lock(&mddev->lock);
-			mddev->bitmap_info.file = NULL;
-			spin_unlock(&mddev->lock);
-			fput(f);
-		}
-		mddev->bitmap_info.offset = 0;
-
 		export_array(mddev);
-
 		md_clean(mddev);
 		if (mddev->hold_active == UNTIL_STOP)
 			mddev->hold_active = 0;
-- 
2.6.2

