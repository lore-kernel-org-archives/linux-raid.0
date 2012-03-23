From: "majianpeng" <majianpeng@gmail.com>
Subject: md/linear: If md_integrity_register() failed,linear_run() must  free the mem.
Date: Fri, 23 Mar 2012 10:29:19 +0800
Message-ID: <201203231029159680193@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From df3b2e15fb325def8f5eaa076b328084dd86c421 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Fri, 23 Mar 2012 10:09:18 +0800
Subject: [PATCH] md/linear: If md_integrity_register() failed,linear_run()
 must  free the mem.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/linear.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b0fcc7d..fa211d8 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -198,6 +198,7 @@ out:
 static int linear_run (struct mddev *mddev)
 {
 	struct linear_conf *conf;
+	int ret;
 
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
@@ -211,7 +212,13 @@ static int linear_run (struct mddev *mddev)
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
-	return md_integrity_register(mddev);
+
+	ret =  md_integrity_register(mddev);
+	if (ret) {
+		kfree(conf);
+		mddev->private = NULL;
+	}
+	return ret;
 }
 
 static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-23

