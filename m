From: shli@kernel.org
Subject: [patch v2 2/6] raid5: add a new flag to track if a stripe can be batched
Date: Wed, 10 Sep 2014 20:40:11 +0800
Message-ID: <20140910124301.148694855@kernel.org>
References: <20140910124009.810771309@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid5-add-new-flag-for-batching.patch
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A freshly new stripe with write request can be batched. Any time the stripe is
handled or new read is queued, the flag will be cleared.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   12 +++++++++---
 drivers/md/raid5.h |    1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-09-10 19:21:08.183378868 +0800
+++ linux/drivers/md/raid5.c	2014-09-10 19:21:08.179378919 +0800
@@ -558,6 +558,7 @@ retry:
 		goto retry;
 	insert_hash(conf, sh);
 	sh->cpu = smp_processor_id();
+	set_bit(STRIPE_BATCH_READY, &sh->state);
 }
 
 static struct stripe_head *__find_stripe(struct r5conf *conf, sector_t sector,
@@ -2653,7 +2654,8 @@ schedule_reconstruction(struct stripe_he
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
+	int forwrite, int previous)
 {
 	struct bio **bip;
 	struct r5conf *conf = sh->raid_conf;
@@ -2686,6 +2688,9 @@ static int add_stripe_bio(struct stripe_
 	if (*bip && (*bip)->bi_iter.bi_sector < bio_end_sector(bi))
 		goto overlap;
 
+	if (!forwrite || previous)
+		clear_bit(STRIPE_BATCH_READY, &sh->state);
+
 	BUG_ON(*bip && bi->bi_next && (*bip) != bi->bi_next);
 	if (*bip)
 		bi->bi_next = *bip;
@@ -3754,6 +3759,7 @@ static void handle_stripe(struct stripe_
 		return;
 	}
 
+	clear_bit(STRIPE_BATCH_READY, &sh->state);
 	if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state)) {
 		spin_lock(&sh->stripe_lock);
 		/* Cannot process 'sync' concurrently with 'discard' */
@@ -4739,7 +4745,7 @@ static void make_request(struct mddev *m
 			}
 
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_stripe_bio(sh, bi, dd_idx, rw)) {
+			    !add_stripe_bio(sh, bi, dd_idx, rw, previous)) {
 				/* Stripe is busy expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
@@ -5148,7 +5154,7 @@ static int  retry_aligned_read(struct r5
 			return handled;
 		}
 
-		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
+		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0, 0)) {
 			release_stripe(sh);
 			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned = raid_bio;
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2014-09-10 19:21:08.183378868 +0800
+++ linux/drivers/md/raid5.h	2014-09-10 19:21:08.179378919 +0800
@@ -327,6 +327,7 @@ enum {
 	STRIPE_ON_UNPLUG_LIST,
 	STRIPE_DISCARD,
 	STRIPE_ON_RELEASE_LIST,
+	STRIPE_BATCH_READY,
 };
 
 /*

