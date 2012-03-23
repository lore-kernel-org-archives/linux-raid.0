From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid1: If md_integrity_register() failed,run() must  free the mem
Date: Fri, 23 Mar 2012 10:30:59 +0800
Message-ID: <201203231030548909882@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 8a7f9d02f3e7151ecfd05ca9b1734d6e62414c03 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Fri, 23 Mar 2012 10:25:41 +0800
Subject: [PATCH] md/raid1: If md_integrity_register() failed,run() must  free
 the mem.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4a40a20..f71d8a0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2641,6 +2641,7 @@ static int run(struct mddev *mddev)
 	struct r1conf *conf;
 	int i;
 	struct md_rdev *rdev;
+	int ret;
 
 	if (mddev->level != 1) {
 		printk(KERN_ERR "md/raid1:%s: raid level not set to mirroring (%d)\n",
@@ -2705,7 +2706,18 @@ static int run(struct mddev *mddev)
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
 	}
-	return md_integrity_register(mddev);
+
+	ret =  md_integrity_register(mddev);
+	if (ret) {
+		md_unregister_thread(&mddev->thread);
+		if (conf->r1bio_pool)
+			mempool_destroy(conf->r1bio_pool);
+		kfree(conf->mirrors);
+		kfree(conf->poolinfo);
+		kfree(conf);
+		mddev->private = NULL;
+	}
+	return ret;
 }
 
 static int stop(struct mddev *mddev)
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-23

