From: Shaohua Li <shli@kernel.org>
Subject: [patch 09/10 v3] raid5: raid5d handle stripe in batch way
Date: Mon, 25 Jun 2012 15:24:56 +0800
Message-ID: <20120625072712.004553385@kernel.org>
References: <20120625072447.268095276@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-raid5d-fetch-stripe-batch.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Let raid5d handle stripe in batch way to reduce conf->device_lock locking.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-25 14:38:37.378835415 +0800
+++ linux/drivers/md/raid5.c	2012-06-25 14:38:40.150800523 +0800
@@ -4568,6 +4568,30 @@ static int  retry_aligned_read(struct r5
 	return handled;
 }
 
+#define MAX_STRIPE_BATCH 8
+static int handle_active_stripes(struct r5conf *conf)
+{
+	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
+	int i, batch_size = 0;
+
+	while (batch_size < MAX_STRIPE_BATCH &&
+			(sh = __get_priority_stripe(conf)) != NULL)
+		batch[batch_size++] = sh;
+
+	if (batch_size == 0)
+		return batch_size;
+	spin_unlock_irq(&conf->device_lock);
+
+	for (i = 0; i < batch_size; i++)
+		handle_stripe(batch[i]);
+
+	cond_resched();
+
+	spin_lock_irq(&conf->device_lock);
+	for (i = 0; i < batch_size; i++)
+		__release_stripe(conf, batch[i]);
+	return batch_size;
+}
 
 /*
  * This is our raid5 kernel thread.
@@ -4578,7 +4602,6 @@ static int  retry_aligned_read(struct r5
  */
 static void raid5d(struct mddev *mddev)
 {
-	struct stripe_head *sh;
 	struct r5conf *conf = mddev->private;
 	int handled;
 	struct blk_plug plug;
@@ -4592,6 +4615,7 @@ static void raid5d(struct mddev *mddev)
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct bio *bio;
+		int batch_size;
 
 		if (atomic_read(&mddev->plug_cnt) == 0 &&
 		    !list_empty(&conf->bitmap_list)) {
@@ -4616,21 +4640,16 @@ static void raid5d(struct mddev *mddev)
 			handled++;
 		}
 
-		sh = __get_priority_stripe(conf);
-
-		if (!sh)
+		batch_size = handle_active_stripes(conf);
+		if (!batch_size)
 			break;
-		spin_unlock_irq(&conf->device_lock);
-		
-		handled++;
-		handle_stripe(sh);
-		release_stripe(sh);
-		cond_resched();
+		handled += batch_size;
 
-		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
+		if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
+			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
-
-		spin_lock_irq(&conf->device_lock);
+			spin_lock_irq(&conf->device_lock);
+		}
 	}
 	pr_debug("%d stripes handled\n", handled);
 

