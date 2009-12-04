From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/22] md/bitmap: protect against bitmap removal while
	being updated.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.91287.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: stable@kernel.org
List-Id: linux-raid.ids

A write intent bitmap can be removed from an array while the
array is active.
When this happens, all IO is suspended and flushed before the
bitmap is removed.
However it is possible that bitmap_daemon_work is still running to
clear old bits from the bitmap.  If it is, it can dereference the
bitmap after it has been freed.

So borrow mddev->open_mutex to protect bitmap_daemon_work and
get it before destroying a bitmap.

This is suitable for any current -stable kernel.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: stable@kernel.org
---
 drivers/md/bitmap.c |   24 ++++++++++++++++++------
 drivers/md/bitmap.h |    2 +-
 drivers/md/md.c     |    4 ++--
 drivers/md/md.h     |    3 ++-
 4 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 60e2b32..a39f632 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1078,23 +1078,31 @@ static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
  *			out to disk
  */
 
-void bitmap_daemon_work(struct bitmap *bitmap)
+void bitmap_daemon_work(mddev_t *mddev)
 {
+	struct bitmap *bitmap;
 	unsigned long j;
 	unsigned long flags;
 	struct page *page = NULL, *lastpage = NULL;
 	int blocks;
 	void *paddr;
 
-	if (bitmap == NULL)
+	/* Borrow open_mutex to guard daemon_work against
+	 * bitmap_destroy.
+	 */
+	mutex_lock(&mddev->open_mutex);
+	bitmap = mddev->bitmap;
+	if (bitmap == NULL) {
+		mutex_unlock(&mddev->open_mutex);
 		return;
+	}
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
 		goto done;
 
 	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
 		bitmap->mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
-		return;
+		goto done;
 	}
 	bitmap->allclean = 1;
 
@@ -1203,6 +1211,7 @@ void bitmap_daemon_work(struct bitmap *bitmap)
  done:
 	if (bitmap->allclean == 0)
 		bitmap->mddev->thread->timeout = bitmap->daemon_sleep * HZ;
+	mutex_unlock(&mddev->open_mutex);
 }
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1541,9 +1550,9 @@ void bitmap_flush(mddev_t *mddev)
 	 */
 	sleep = bitmap->daemon_sleep;
 	bitmap->daemon_sleep = 0;
-	bitmap_daemon_work(bitmap);
-	bitmap_daemon_work(bitmap);
-	bitmap_daemon_work(bitmap);
+	bitmap_daemon_work(mddev);
+	bitmap_daemon_work(mddev);
+	bitmap_daemon_work(mddev);
 	bitmap->daemon_sleep = sleep;
 	bitmap_update_sb(bitmap);
 }
@@ -1574,6 +1583,7 @@ static void bitmap_free(struct bitmap *bitmap)
 	kfree(bp);
 	kfree(bitmap);
 }
+
 void bitmap_destroy(mddev_t *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
@@ -1581,7 +1591,9 @@ void bitmap_destroy(mddev_t *mddev)
 	if (!bitmap) /* there was no bitmap */
 		return;
 
+	mutex_lock(&mddev->open_mutex);
 	mddev->bitmap = NULL; /* disconnect from the md device */
+	mutex_unlock(&mddev->open_mutex);
 	if (mddev->thread)
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index e989006..7e38d13 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -282,7 +282,7 @@ void bitmap_close_sync(struct bitmap *bitmap);
 void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
 
 void bitmap_unplug(struct bitmap *bitmap);
-void bitmap_daemon_work(struct bitmap *bitmap);
+void bitmap_daemon_work(mddev_t *mddev);
 #endif
 
 #endif
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b182f86..69af3b8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4314,7 +4314,7 @@ static int deny_bitmap_write_access(struct file * file)
 	return 0;
 }
 
-static void restore_bitmap_write_access(struct file *file)
+void restore_bitmap_write_access(struct file *file)
 {
 	struct inode *inode = file->f_mapping->host;
 
@@ -6629,7 +6629,7 @@ void md_check_recovery(mddev_t *mddev)
 
 
 	if (mddev->bitmap)
-		bitmap_daemon_work(mddev->bitmap);
+		bitmap_daemon_work(mddev);
 
 	if (mddev->ro)
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f184b69..57ae80c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -443,6 +443,7 @@ extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 extern void md_set_array_sectors(mddev_t *mddev, sector_t array_sectors);
 extern int md_check_no_bitmap(mddev_t *mddev);
 extern int md_integrity_register(mddev_t *mddev);
-void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
+extern void md_integrity_add_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
+extern void restore_bitmap_write_access(struct file *file);
 
 #endif /* _MD_MD_H */


