From: Shaohua Li <shli@kernel.org>
Subject: [patch 6/8] raid5: make_request use batch stripe release
Date: Mon, 04 Jun 2012 16:01:58 +0800
Message-ID: <20120604080335.029329200@kernel.org>
References: <20120604080152.098975870@kernel.org>
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

Below patch makes stripe release batch. When maxium strips of a batch reach,
the batch will be flushed out. Another way to do the flush is when unplug is
called.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-06-01 14:13:46.846909398 +0800
+++ linux/drivers/md/raid5.c	2012-06-01 14:22:07.944611949 +0800
@@ -4023,6 +4023,38 @@ static struct stripe_head *__get_priorit
 	return sh;
 }
 
+struct raid5_plug {
+	struct blk_plug_cb cb;
+	struct stripe_head_batch batch;
+};
+static DEFINE_PER_CPU(struct raid5_plug, raid5_plugs);
+
+static void raid5_do_plug(struct blk_plug_cb *cb)
+{
+	struct raid5_plug *plug = container_of(cb, struct raid5_plug, cb);
+
+	release_stripe_flush_batch(&plug->batch);
+	INIT_LIST_HEAD(&plug->cb.list);
+}
+
+static void release_stripe_plug(struct stripe_head *sh)
+{
+	struct blk_plug *plug = current->plug;
+	struct raid5_plug *raid5_plug;
+
+	if (!plug) {
+		release_stripe(sh);
+		return;
+	}
+	preempt_disable();
+	raid5_plug = &__raw_get_cpu_var(raid5_plugs);
+	release_stripe_add_batch(&raid5_plug->batch, sh);
+
+	if (list_empty(&raid5_plug->cb.list))
+		list_add(&raid5_plug->cb.list, &plug->cb_list);
+	preempt_enable();
+}
+
 static void make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf = mddev->private;
@@ -4153,7 +4185,7 @@ static void make_request(struct mddev *m
 			if ((bi->bi_rw & REQ_SYNC) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
-			release_stripe(sh);
+			release_stripe_plug(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -6170,6 +6202,14 @@ static struct md_personality raid4_perso
 
 static int __init raid5_init(void)
 {
+	int i;
+
+	for_each_present_cpu(i) {
+		struct raid5_plug *plug = &per_cpu(raid5_plugs, i);
+		plug->batch.count = 0;
+		INIT_LIST_HEAD(&plug->cb.list);
+		plug->cb.callback = raid5_do_plug;
+	}
 	register_md_personality(&raid6_personality);
 	register_md_personality(&raid5_personality);
 	register_md_personality(&raid4_personality);

