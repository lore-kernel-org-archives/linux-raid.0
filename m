From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/22] md: change daemon_sleep to be in 'jiffies' rather
	than 'seconds'.
Date: Fri, 04 Dec 2009 17:48:02 +1100
Message-ID: <20091204064802.10264.2934.stgit@notabene.brown>
References: <20091204064559.10264.37619.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091204064559.10264.37619.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This removes a lot of multiplications by HZ.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |   14 +++++++-------
 drivers/md/raid10.c |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 921b084..5e6fd37 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -565,7 +565,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
 
 	chunksize = le32_to_cpu(sb->chunksize);
-	daemon_sleep = le32_to_cpu(sb->daemon_sleep);
+	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
 	write_behind = le32_to_cpu(sb->write_behind);
 
 	/* verify that the bitmap-specific fields are valid */
@@ -578,7 +578,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		reason = "bitmap chunksize too small";
 	else if ((1 << ffz(~chunksize)) != chunksize)
 		reason = "bitmap chunksize not a power of 2";
-	else if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT / HZ)
+	else if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT)
 		reason = "daemon sleep period out of range";
 	else if (write_behind > COUNTER_MAX)
 		reason = "write-behind limit out of range (0 - 16383)";
@@ -1100,7 +1100,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 		return;
 	}
 	if (time_before(jiffies, bitmap->daemon_lastrun
-			+ bitmap->mddev->bitmap_info.daemon_sleep*HZ))
+			+ bitmap->mddev->bitmap_info.daemon_sleep))
 		goto done;
 
 	bitmap->daemon_lastrun = jiffies;
@@ -1215,7 +1215,7 @@ void bitmap_daemon_work(mddev_t *mddev)
  done:
 	if (bitmap->allclean == 0)
 		bitmap->mddev->thread->timeout = 
-			bitmap->mddev->bitmap_info.daemon_sleep * HZ;
+			bitmap->mddev->bitmap_info.daemon_sleep;
 	mutex_unlock(&mddev->open_mutex);
 }
 
@@ -1484,7 +1484,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 		return;
 	}
 	if (time_before(jiffies, (bitmap->last_end_sync
-				  + bitmap->mddev->bitmap_info.daemon_sleep * HZ)))
+				  + bitmap->mddev->bitmap_info.daemon_sleep)))
 		return;
 	wait_event(bitmap->mddev->recovery_wait,
 		   atomic_read(&bitmap->mddev->recovery_active) == 0);
@@ -1553,7 +1553,7 @@ void bitmap_flush(mddev_t *mddev)
 	/* run the daemon_work three time to ensure everything is flushed
 	 * that can be
 	 */
-	sleep = mddev->bitmap_info.daemon_sleep * HZ * 2;
+	sleep = mddev->bitmap_info.daemon_sleep * 2;
 	bitmap->daemon_lastrun -= sleep;
 	bitmap_daemon_work(mddev);
 	bitmap->daemon_lastrun -= sleep;
@@ -1694,7 +1694,7 @@ int bitmap_create(mddev_t *mddev)
 
 	mddev->bitmap = bitmap;
 
-	mddev->thread->timeout = mddev->bitmap_info.daemon_sleep * HZ;
+	mddev->thread->timeout = mddev->bitmap_info.daemon_sleep;
 
 	bitmap_update_sb(bitmap);
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2255e33..064c2bb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2277,7 +2277,7 @@ static void raid10_quiesce(mddev_t *mddev, int state)
 	}
 	if (mddev->thread) {
 		if (mddev->bitmap)
-			mddev->thread->timeout = mddev->bitmap_info.daemon_sleep * HZ;
+			mddev->thread->timeout = mddev->bitmap_info.daemon_sleep;
 		else
 			mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
 		md_wakeup_thread(mddev->thread);


