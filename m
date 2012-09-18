From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/2]MD: raid5 avoid unnecessary zero page for trim
Date: Tue, 18 Sep 2012 16:25:33 +0800
Message-ID: <20120918082533.GB6298@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

We want to avoid zero discarded dev page, because it's useless for discard.
But if we don't zero it, another read/write hit such page in the cache and
will get inconsistent data. To avoid zero the page, we set R5_WantZeroFill
for discarded dev page. Every time before the page is accessed and the
flag is set, we zero the page and clear the flag. If the page will be
drained or computed, we just clear the flag for it. In this way, the dev
page data is alway consistent. And since the chance discarded data is
accessed soon is low, zero discard dev page is largely avoided.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   83 +++++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5.h |    1 
 2 files changed, 69 insertions(+), 15 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-09-18 16:15:55.471299904 +0800
+++ linux/drivers/md/raid5.c	2012-09-18 16:16:02.531211118 +0800
@@ -824,6 +824,10 @@ static void ops_run_biofill(struct strip
 			dev->read = rbi = dev->toread;
 			dev->toread = NULL;
 			spin_unlock_irq(&sh->stripe_lock);
+
+			if (test_and_clear_bit(R5_WantZeroFill, &dev->flags))
+				memset(page_address(dev->page), 0, STRIPE_SIZE);
+
 			while (rbi && rbi->bi_sector <
 				dev->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
@@ -893,9 +897,16 @@ ops_run_compute5(struct stripe_head *sh,
 		__func__, (unsigned long long)sh->sector, target);
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
-	for (i = disks; i--; )
-		if (i != target)
+	for (i = disks; i--; ) {
+		if (i != target) {
 			xor_srcs[count++] = sh->dev[i].page;
+			if (test_and_clear_bit(R5_WantZeroFill,
+			   &sh->dev[i].flags))
+				memset(page_address(sh->dev[i].page), 0,
+					STRIPE_SIZE);
+		}
+		clear_bit(R5_WantZeroFill, &sh->dev[i].flags);
+	}
 
 	atomic_inc(&sh->count);
 
@@ -972,6 +983,10 @@ ops_run_compute6_1(struct stripe_head *s
 
 	atomic_inc(&sh->count);
 
+	for (i = 0; i < sh->disks; i++)
+		if (test_and_clear_bit(R5_WantZeroFill, &sh->dev[i].flags))
+			memset(page_address(sh->dev[i].page), 0, STRIPE_SIZE);
+
 	if (target == qd_idx) {
 		count = set_syndrome_sources(blocks, sh);
 		blocks[count] = NULL; /* regenerating p is not necessary */
@@ -1022,8 +1037,11 @@ ops_run_compute6_2(struct stripe_head *s
 	/* we need to open-code set_syndrome_sources to handle the
 	 * slot number conversion for 'faila' and 'failb'
 	 */
-	for (i = 0; i < disks ; i++)
+	for (i = 0; i < disks ; i++) {
 		blocks[i] = NULL;
+		if (test_and_clear_bit(R5_WantZeroFill, &sh->dev[i].flags))
+			memset(page_address(sh->dev[i].page), 0, STRIPE_SIZE);
+	}
 	count = 0;
 	i = d0_idx;
 	do {
@@ -1134,6 +1152,9 @@ ops_run_prexor(struct stripe_head *sh, s
 		/* Only process blocks that are known to be uptodate */
 		if (test_bit(R5_Wantdrain, &dev->flags))
 			xor_srcs[count++] = dev->page;
+		if ((i == pd_idx || test_bit(R5_Wantdrain, &dev->flags)) &&
+		   test_and_clear_bit(R5_WantZeroFill, &dev->flags))
+			memset(page_address(dev->page), 0, STRIPE_SIZE);
 	}
 
 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_DROP_DST, tx,
@@ -1173,12 +1194,13 @@ ops_run_biodrain(struct stripe_head *sh,
 				if (wbi->bi_rw & REQ_SYNC)
 					set_bit(R5_SyncIO, &dev->flags);
 				if (wbi->bi_rw & REQ_DISCARD) {
-					memset(page_address(dev->page), 0,
-						STRIPE_SECTORS << 9);
+					set_bit(R5_WantZeroFill, &dev->flags);
 					set_bit(R5_Discard, &dev->flags);
-				} else
+				} else {
+					clear_bit(R5_WantZeroFill, &dev->flags);
 					tx = async_copy_data(1, wbi, dev->page,
 						dev->sector, tx);
+				}
 				wbi = r5_next_bio(wbi, dev->sector);
 			}
 		}
@@ -1252,8 +1274,7 @@ ops_run_reconstruct5(struct stripe_head
 	}
 	if (i >= sh->disks) {
 		atomic_inc(&sh->count);
-		memset(page_address(sh->dev[pd_idx].page), 0,
-			STRIPE_SECTORS << 9);
+		set_bit(R5_WantZeroFill, &sh->dev[pd_idx].flags);
 		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
 		ops_complete_reconstruct(sh);
 		return;
@@ -1268,13 +1289,21 @@ ops_run_reconstruct5(struct stripe_head
 			struct r5dev *dev = &sh->dev[i];
 			if (dev->written)
 				xor_srcs[count++] = dev->page;
+			if ((i == pd_idx || dev->written) &&
+			   test_and_clear_bit(R5_WantZeroFill, &dev->flags))
+				memset(page_address(dev->page), 0, STRIPE_SIZE);
 		}
 	} else {
 		xor_dest = sh->dev[pd_idx].page;
+		clear_bit(R5_WantZeroFill, &sh->dev[pd_idx].flags);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (i != pd_idx)
+			if (i != pd_idx) {
 				xor_srcs[count++] = dev->page;
+			   	if (test_and_clear_bit(R5_WantZeroFill, &dev->flags))
+					memset(page_address(dev->page), 0,
+					      STRIPE_SIZE);
+			}
 		}
 	}
 
@@ -1314,16 +1343,23 @@ ops_run_reconstruct6(struct stripe_head
 	}
 	if (i >= sh->disks) {
 		atomic_inc(&sh->count);
-		memset(page_address(sh->dev[sh->pd_idx].page), 0,
-			STRIPE_SECTORS << 9);
-		memset(page_address(sh->dev[sh->qd_idx].page), 0,
-			STRIPE_SECTORS << 9);
+		set_bit(R5_WantZeroFill, &sh->dev[sh->pd_idx].flags);
 		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
+		set_bit(R5_WantZeroFill, &sh->dev[sh->qd_idx].flags);
 		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
 		ops_complete_reconstruct(sh);
 		return;
 	}
 
+	for (i = 0; i < sh->disks; i++) {
+		if (sh->pd_idx == i || sh->qd_idx == i) {
+			clear_bit(R5_WantZeroFill, &sh->dev[i].flags);
+			continue;
+		}
+		if (test_and_clear_bit(R5_WantZeroFill, &sh->dev[i].flags))
+			memset(page_address(sh->dev[i].page), 0, STRIPE_SIZE);
+	}
+
 	count = set_syndrome_sources(blocks, sh);
 
 	atomic_inc(&sh->count);
@@ -1364,8 +1400,13 @@ static void ops_run_check_p(struct strip
 	xor_dest = sh->dev[pd_idx].page;
 	xor_srcs[count++] = xor_dest;
 	for (i = disks; i--; ) {
-		if (i == pd_idx || i == qd_idx)
+		if (i != qd_idx &&
+		   test_and_clear_bit(R5_WantZeroFill, &sh->dev[i].flags))
+			memset(page_address(sh->dev[i].page), 0, STRIPE_SIZE);
+		if (i == pd_idx || i == qd_idx) {
+			clear_bit(R5_WantZeroFill, &sh->dev[i].flags);
 			continue;
+		}
 		xor_srcs[count++] = sh->dev[i].page;
 	}
 
@@ -1383,11 +1424,20 @@ static void ops_run_check_pq(struct stri
 {
 	struct page **srcs = percpu->scribble;
 	struct async_submit_ctl submit;
-	int count;
+	int count, i;
 
 	pr_debug("%s: stripe %llu checkp: %d\n", __func__,
 		(unsigned long long)sh->sector, checkp);
 
+	for (i = 0; i < sh->disks; i++) {
+		if (sh->pd_idx == i || sh->qd_idx == i) {
+			clear_bit(R5_WantZeroFill, &sh->dev[i].flags);
+			continue;
+		}
+		if (test_and_clear_bit(R5_WantZeroFill, &sh->dev[i].flags))
+			memset(page_address(sh->dev[i].page), 0, STRIPE_SIZE);
+	}
+
 	count = set_syndrome_sources(srcs, sh);
 	if (!checkp)
 		srcs[count] = NULL;
@@ -3187,6 +3237,9 @@ static void handle_stripe_expansion(stru
 				release_stripe(sh2);
 				continue;
 			}
+			if (test_and_clear_bit(R5_WantZeroFill, &sh->dev[i].flags))
+				memset(page_address(sh->dev[i].page),
+					0, STRIPE_SIZE);
 
 			/* place all the copies on one channel */
 			init_async_submit(&submit, 0, tx, NULL, NULL, NULL);
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-09-18 16:15:55.471299904 +0800
+++ linux/drivers/md/raid5.h	2012-09-18 16:16:02.531211118 +0800
@@ -299,6 +299,7 @@ enum r5dev_flags {
 			 * data in, and now is a good time to write it out.
 			 */
 	R5_Discard,	/* Discard the stripe */
+	R5_WantZeroFill, /* should be zero filled before read */
 };
 
 /*
