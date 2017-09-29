From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/2] md-cluster: fix wrong condition check in raid1_write_request
Date: Fri, 29 Sep 2017 09:16:43 +0800
Message-ID: <1506647804-469-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The check used here is to avoid conflict between write and
resync, however we used the wrong logic, it should be the
inverse of the checking inside "if".

Fixes: 589a1c4 ("Suspend writes in RAID1 if within range")
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid1.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f3f3e40..35264ad 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1325,12 +1325,12 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			sigset_t full, old;
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_INTERRUPTIBLE);
-			if (bio_end_sector(bio) <= mddev->suspend_lo ||
-			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
-			    (mddev_is_clustered(mddev) &&
+			if ((bio_end_sector(bio) <= mddev->suspend_lo ||
+			     bio->bi_iter.bi_sector >= mddev->suspend_hi) &&
+			    (!mddev_is_clustered(mddev) ||
 			     !md_cluster_ops->area_resyncing(mddev, WRITE,
-				     bio->bi_iter.bi_sector,
-				     bio_end_sector(bio))))
+							bio->bi_iter.bi_sector,
+							bio_end_sector(bio))))
 				break;
 			sigfillset(&full);
 			sigprocmask(SIG_BLOCK, &full, &old);
-- 
2.6.6

