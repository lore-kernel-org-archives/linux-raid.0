From: Robert LeBlanc <robert@leblancnet.us>
Subject: [PATCH] Reorganize make_request to clean up code.
Date: Tue, 29 Nov 2016 16:07:11 -0700
Message-ID: <20161129230711.9987-1-robert@leblancnet.us>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robert LeBlanc <robert@leblancnet.us>
List-Id: linux-raid.ids

This code only runs during a write, so move it to the write section to
clean up the code.

Signed-off-by: Robert LeBlanc <robert@leblancnet.us>
---
 drivers/md/raid1.c  | 68 ++++++++++++++++++++++++++---------------------------
 drivers/md/raid10.c |  4 ++--
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 21dc00e..f2db4bf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1054,40 +1054,6 @@ static void raid1_make_request(struct mddev *mddev, struct bio * bio)
 	int max_sectors;
 	sector_t start_next_window;
 
-	/*
-	 * Register the new request and wait if the reconstruction
-	 * thread has put up a bar for new requests.
-	 * Continue immediately if no resync is active currently.
-	 */
-
-	md_write_start(mddev, bio); /* wait on superblock update early */
-
-	if (bio_data_dir(bio) == WRITE &&
-	    ((bio_end_sector(bio) > mddev->suspend_lo &&
-	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
-	    (mddev_is_clustered(mddev) &&
-	     md_cluster_ops->area_resyncing(mddev, WRITE,
-		     bio->bi_iter.bi_sector, bio_end_sector(bio))))) {
-		/* As the suspend_* range is controlled by
-		 * userspace, we want an interruptible
-		 * wait.
-		 */
-		DEFINE_WAIT(w);
-		for (;;) {
-			flush_signals(current);
-			prepare_to_wait(&conf->wait_barrier,
-					&w, TASK_INTERRUPTIBLE);
-			if (bio_end_sector(bio) <= mddev->suspend_lo ||
-			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
-			    (mddev_is_clustered(mddev) &&
-			     !md_cluster_ops->area_resyncing(mddev, WRITE,
-				     bio->bi_iter.bi_sector, bio_end_sector(bio))))
-				break;
-			schedule();
-		}
-		finish_wait(&conf->wait_barrier, &w);
-	}
-
 	start_next_window = wait_barrier(conf, bio);
 
 	bitmap = mddev->bitmap;
@@ -1194,6 +1160,40 @@ read_again:
 	/*
 	 * WRITE:
 	 */
+
+	/*
+	 * Register the new request and wait if the reconstruction
+	 * thread has put up a bar for new requests.
+	 * Continue immediately if no resync is active currently.
+	 */
+
+	md_write_start(mddev, bio); /* wait on superblock update early */
+
+	if ((bio_end_sector(bio) > mddev->suspend_lo &&
+	    bio->bi_iter.bi_sector < mddev->suspend_hi) ||
+	    (mddev_is_clustered(mddev) &&
+	     md_cluster_ops->area_resyncing(mddev, WRITE,
+		     bio->bi_iter.bi_sector, bio_end_sector(bio)))) {
+		/* As the suspend_* range is controlled by
+		 * userspace, we want an interruptible
+		 * wait.
+		 */
+		DEFINE_WAIT(w);
+		for (;;) {
+			flush_signals(current);
+			prepare_to_wait(&conf->wait_barrier,
+					&w, TASK_INTERRUPTIBLE);
+			if (bio_end_sector(bio) <= mddev->suspend_lo ||
+			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
+			    (mddev_is_clustered(mddev) &&
+			     !md_cluster_ops->area_resyncing(mddev, WRITE,
+				     bio->bi_iter.bi_sector, bio_end_sector(bio))))
+				break;
+			schedule();
+		}
+		finish_wait(&conf->wait_barrier, &w);
+	}
+
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
 		wait_event(conf->wait_barrier,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be1a9fc..536b61d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1064,8 +1064,6 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
 	int max_sectors;
 	int sectors;
 
-	md_write_start(mddev, bio);
-
 	/*
 	 * Register the new request and wait if the reconstruction
 	 * thread has put up a bar for new requests.
@@ -1190,6 +1188,8 @@ read_again:
 	/*
 	 * WRITE:
 	 */
+	md_write_start(mddev, bio);
+
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
 		wait_event(conf->wait_barrier,
-- 
2.10.2

