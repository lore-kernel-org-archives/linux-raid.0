From: Shaohua Li <shli@kernel.org>
Subject: [patch 7/8] raid5: raid5d handle stripe in batch way
Date: Mon, 04 Jun 2012 16:01:59 +0800
Message-ID: <20120604080344.262680737@kernel.org>
References: <20120604080152.098975870@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-raid5d-fetch-stripe-batch.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Let raid5d handle stripe in batch way to reduce conf->device_lock locking.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-01 14:34:03.987606911 +0800
+++ linux/drivers/md/raid5.c	2012-06-01 14:49:26.388010973 +0800
@@ -4585,6 +4585,22 @@ static int  retry_aligned_read(struct r5
 	return handled;
 }
 
+static int __get_stripe_batch(struct r5conf *conf,
+		struct stripe_head_batch *batch)
+{
+	struct stripe_head *sh;
+
+	batch->count = 0;
+	do {
+		sh = __get_priority_stripe(conf);
+		if (sh) {
+			batch->stripes[batch->count] = sh;
+			batch->count++;
+		}
+	} while (sh && batch->count < MAX_STRIPE_BATCH);
+
+	return batch->count;
+}
 
 /*
  * This is our raid5 kernel thread.
@@ -4595,10 +4611,10 @@ static int  retry_aligned_read(struct r5
  */
 static void raid5d(struct mddev *mddev)
 {
-	struct stripe_head *sh;
 	struct r5conf *conf = mddev->private;
-	int handled;
+	int handled, i;
 	struct blk_plug plug;
+	struct stripe_head_batch batch;
 
 	pr_debug("+++ raid5d active\n");
 
@@ -4633,15 +4649,16 @@ static void raid5d(struct mddev *mddev)
 			handled++;
 		}
 
-		sh = __get_priority_stripe(conf);
-
-		if (!sh)
+		if (!__get_stripe_batch(conf, &batch))
 			break;
 		spin_unlock_irq(&conf->device_lock);
-		
-		handled++;
-		handle_stripe(sh);
-		release_stripe(sh);
+
+		for (i = 0; i < batch.count; i++) {
+			handled++;
+			handle_stripe(batch.stripes[i]);
+		}
+
+		release_stripe_flush_batch(&batch);
 		cond_resched();
 
 		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))

