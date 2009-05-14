From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH] md: raid0: Simplify raid0_run().
Date: Thu, 14 May 2009 12:43:53 +0200
Message-ID: <1242297833-13908-7-git-send-email-maan@systemlinux.org>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Get rid of the local variable "conf" and of an unnecessary cast.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/raid0.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 5ff6290..36b747a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -261,7 +261,6 @@ static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 
 static int raid0_run(mddev_t *mddev)
 {
-	raid0_conf_t *conf;
 	int ret;
 
 	if (mddev->chunk_size == 0) {
@@ -276,14 +275,15 @@ static int raid0_run(mddev_t *mddev)
 	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
-	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
-	if (!conf)
+	mddev->private = kmalloc(sizeof(raid0_conf_t), GFP_KERNEL);
+	if (!mddev->private)
 		return -ENOMEM;
-	mddev->private = (void *)conf;
-
 	ret = create_strip_zones(mddev);
-	if (ret < 0)
-		goto out_free_conf;
+	if (ret < 0) {
+		kfree(mddev->private);
+		mddev->private = NULL;
+		return ret;
+	}
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
@@ -305,14 +305,8 @@ static int raid0_run(mddev_t *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	return 0;
-
-out_free_conf:
-	kfree(conf);
-	mddev->private = NULL;
-	return ret;
 }
 
 static int raid0_stop (mddev_t *mddev)
-- 
1.5.4.3

