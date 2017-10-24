From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] raid1: remove obsolete code in raid1_write_request
Date: Tue, 24 Oct 2017 15:33:33 +0800
Message-ID: <20171024073333.7902-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There are some lines could be removed due to recent
change for raid1 such as commit 3956df15d634 ("md:
move suspend_hi/lo handling into core md code").

Also, seems some comments are put to wrong place,
move them before wait_barrier.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid1.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 038f5eb299ce..cc9d337a1ed3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1286,27 +1286,15 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int first_clone;
 	int max_sectors;
 
-	/*
-	 * Register the new request and wait if the reconstruction
-	 * thread has put up a bar for new requests.
-	 * Continue immediately if no resync is active currently.
-	 */
-
-
 	if (mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
 		     bio->bi_iter.bi_sector, bio_end_sector(bio))) {
 
-		/*
-		 * As the suspend_* range is controlled by userspace, we want
-		 * an interruptible wait.
-		 */
 		DEFINE_WAIT(w);
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_IDLE);
-			if (!mddev_is_clustered(mddev) ||
-			    !md_cluster_ops->area_resyncing(mddev, WRITE,
+			if (!md_cluster_ops->area_resyncing(mddev, WRITE,
 							bio->bi_iter.bi_sector,
 							bio_end_sector(bio)))
 				break;
@@ -1314,6 +1302,12 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		}
 		finish_wait(&conf->wait_barrier, &w);
 	}
+
+	/*
+	 * Register the new request and wait if the reconstruction
+	 * thread has put up a bar for new requests.
+	 * Continue immediately if no resync is active currently.
+	 */
 	wait_barrier(conf, bio->bi_iter.bi_sector);
 
 	r1_bio = alloc_r1bio(mddev, bio);
-- 
2.10.0

