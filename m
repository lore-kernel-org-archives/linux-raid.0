From: Shaohua Li <shli@kernel.org>
Subject: [patch 08/10 v3] raid5: make_request use batch stripe release
Date: Mon, 25 Jun 2012 15:24:55 +0800
Message-ID: <20120625072702.921605418@kernel.org>
References: <20120625072447.268095276@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-make_request-relase_stripe-batch.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

make_request() does stripe release for every stripe and the stripe usually has
count 1, which makes previous release_stripe() optimization not work. In my
test, this release_stripe() becomes the heaviest pleace to take
conf->device_lock after previous patches applied.

Below patch makes stripe release batch. All the stripes will be released in
unplug. The STRIPE_ON_UNPLUG_LIST bit is to protect concurrent access stripe
lru.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/raid5.h |    1 
 2 files changed, 60 insertions(+), 5 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-25 14:38:33.110889008 +0800
+++ linux/drivers/md/raid5.c	2012-06-25 14:38:37.378835415 +0800
@@ -484,7 +484,8 @@ get_active_stripe(struct r5conf *conf, s
 		} else {
 			if (atomic_read(&sh->count)) {
 				BUG_ON(!list_empty(&sh->lru)
-				    && !test_bit(STRIPE_EXPANDING, &sh->state));
+				    && !test_bit(STRIPE_EXPANDING, &sh->state)
+				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state));
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
@@ -3984,6 +3985,51 @@ static struct stripe_head *__get_priorit
 	return sh;
 }
 
+#define raid5_unplug_list(mdcb) (struct list_head *)(mdcb + 1)
+static void raid5_unplug(struct md_plug_cb *mdcb)
+{
+	struct list_head *list = raid5_unplug_list(mdcb);
+	struct stripe_head *sh;
+	struct r5conf *conf = mdcb->mddev->private;
+
+	if (list->next == NULL || list_empty(list))
+		return;
+	spin_lock_irq(&conf->device_lock);
+	while (!list_empty(list)) {
+		sh = list_entry(list->next, struct stripe_head, lru);
+		list_del_init(&sh->lru);
+		/*
+		 * avoid race release_stripe_plug() sees STRIPE_ON_UNPLUG_LIST
+		 * clear but the stripe is still in our list
+		 */
+		smp_mb__before_clear_bit();
+		clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
+		__release_stripe(conf, sh);
+	}
+	spin_unlock_irq(&conf->device_lock);
+}
+
+static void release_stripe_plug(struct md_plug_cb *mdcb,
+				struct stripe_head *sh)
+{
+	struct list_head *list = raid5_unplug_list(mdcb);
+
+	if (!mdcb) {
+		release_stripe(sh);
+		return;
+	}
+
+	if (list->next == NULL) {
+		INIT_LIST_HEAD(list);
+		mdcb->unplug = raid5_unplug;
+	}
+
+	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
+		list_add_tail(&sh->lru, list);
+	else
+		release_stripe(sh);
+}
+
 static void make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf = mddev->private;
@@ -3993,7 +4039,7 @@ static void make_request(struct mddev *m
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
 	int remaining;
-	int plugged;
+	struct md_plug_cb *mdcb;
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
 		md_flush_request(mddev, bi);
@@ -4012,7 +4058,8 @@ static void make_request(struct mddev *m
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
-	plugged = !!mddev_check_plugged(mddev, NULL, 0);
+	mdcb = mddev_check_plugged(mddev, raid5_unplug,
+				   sizeof(struct list_head));
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int previous;
@@ -4114,7 +4161,14 @@ static void make_request(struct mddev *m
 			if ((bi->bi_rw & REQ_SYNC) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
-			release_stripe(sh);
+			/*
+			 * We must recheck here. schedule() might be called
+			 * above which makes unplug invoked already, so the old
+			 * mdcb is invalid
+			 */
+			mdcb = mddev_check_plugged(mddev, raid5_unplug,
+						   sizeof(struct list_head));
+			release_stripe_plug(mdcb, sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -4123,7 +4177,7 @@ static void make_request(struct mddev *m
 		}
 			
 	}
-	if (!plugged)
+	if (!mdcb)
 		md_wakeup_thread(mddev->thread);
 
 	remaining = raid5_dec_bi_active_stripes(bi);
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-06-25 14:37:13.651888057 +0800
+++ linux/drivers/md/raid5.h	2012-06-25 14:38:37.382835318 +0800
@@ -320,6 +320,7 @@ enum {
 	STRIPE_BIOFILL_RUN,
 	STRIPE_COMPUTE_RUN,
 	STRIPE_OPS_REQ_PENDING,
+	STRIPE_ON_UNPLUG_LIST,
 };
 
 /*

