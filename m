From: "majianpeng" <majianpeng@gmail.com>
Subject: md/raid0: If md_integrity_register() failed,raid0_run() must free the mem.
Date: Fri, 23 Mar 2012 10:30:09 +0800
Message-ID: <201203231030029373801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 3d07b1d34ee2dcb1abd599a90855f1a5c30c3de6 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Fri, 23 Mar 2012 10:04:57 +0800
Subject: [PATCH] md/raid0: If md_integrity_register() failed,raid0_run() must
  free the mem.


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid0.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6f31f55..5a99cde 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -454,7 +454,15 @@ static int raid0_run(struct mddev *mddev)
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
-	return md_integrity_register(mddev);
+
+	ret = md_integrity_register(mddev);
+	if (ret) {
+		kfree(conf->strip_zone);
+		kfree(conf->devlist);
+		kfree(conf);
+		mddev->private = NULL;
+	}
+	return ret;
 }
 
 static int raid0_stop(struct mddev *mddev)
-- 
1.7.5.4

 				
--------------
majianpeng
2012-03-23

