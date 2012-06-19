From: Shaohua Li <shli@kernel.org>
Subject: [patch 8/9 v2] raid5: raid5d handle stripe in batch way
Date: Tue, 19 Jun 2012 09:59:49 +0800
Message-ID: <20120619020150.973797041@kernel.org>
References: <20120619015941.891400722@kernel.org>
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
--- linux.orig/drivers/md/raid5.c	2012-06-18 08:34:54.735195847 +0800
+++ linux/drivers/md/raid5.c	2012-06-18 08:36:47.833775907 +0800
@@ -4563,6 +4563,30 @@ static int  retry_aligned_read(struct r5
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
@@ -4573,7 +4597,6 @@ static int  retry_aligned_read(struct r5
  */
 static void raid5d(struct mddev *mddev)
 {
-	struct stripe_head *sh;
 	struct r5conf *conf = mddev->private;
 	int handled;
 	struct blk_plug plug;
@@ -4587,6 +4610,7 @@ static void raid5d(struct mddev *mddev)
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct bio *bio;
+		int batch_size;
 
 		if (atomic_read(&mddev->plug_cnt) == 0 &&
 		    !list_empty(&conf->bitmap_list)) {
@@ -4611,21 +4635,16 @@ static void raid5d(struct mddev *mddev)
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
 

