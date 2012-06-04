From: Shaohua Li <shli@kernel.org>
Subject: [patch 5/8] raid5: add batch stripe release
Date: Mon, 04 Jun 2012 16:01:57 +0800
Message-ID: <20120604080328.104071243@kernel.org>
References: <20120604080152.098975870@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-stripe-batch.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

Add stripe batch and corresponding batch stripe release. Next patch will use it
to reduce device_lock locking.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/md/raid5.h |    6 ++++++
 2 files changed, 41 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-01 14:03:17.062826938 +0800
+++ linux/drivers/md/raid5.c	2012-06-01 14:13:46.846909398 +0800
@@ -262,6 +262,41 @@ static void release_stripe(struct stripe
 	__release_stripe(conf, sh, 1);
 }
 
+static void __release_stripe_flush_batch(struct stripe_head_batch *batch)
+{
+	int i;
+
+	for (i = 0; i < batch->count; i++) {
+		struct stripe_head *sh = batch->stripes[i];
+		__release_stripe(sh->raid_conf, sh, 0);
+	}
+	batch->count = 0;
+}
+
+static void release_stripe_flush_batch(struct stripe_head_batch *batch)
+{
+	struct r5conf *conf = batch->stripes[0]->raid_conf;
+
+	spin_lock_irq(&conf->device_lock);
+	__release_stripe_flush_batch(batch);
+	spin_unlock_irq(&conf->device_lock);
+}
+
+static void release_stripe_add_batch(struct stripe_head_batch *batch,
+	struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+
+	preempt_disable();
+	if (batch->count > 0 && batch->stripes[0]->raid_conf != conf)
+		release_stripe_flush_batch(batch);
+	batch->stripes[batch->count] = sh;
+	batch->count++;
+	if (batch->count >= MAX_STRIPE_BATCH)
+		release_stripe_flush_batch(batch);
+	preempt_enable();
+}
+
 static inline void remove_hash(struct stripe_head *sh)
 {
 	pr_debug("remove_hash(), stripe %llu\n",
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-06-01 13:44:19.229127709 +0800
+++ linux/drivers/md/raid5.h	2012-06-01 14:13:46.846909398 +0800
@@ -239,6 +239,12 @@ struct stripe_head {
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
+#define MAX_STRIPE_BATCH 8
+struct stripe_head_batch {
+	struct stripe_head *stripes[MAX_STRIPE_BATCH];
+	int count;
+};
+
 /* stripe_head_state - collects and tracks the dynamic state of a stripe_head
  *     for handle_stripe.
  */

