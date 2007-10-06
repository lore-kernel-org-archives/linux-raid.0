From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH -mm 3/4] raid5: convert add_stripe_bio to add_queue_bio
Date: Sat, 06 Oct 2007 10:06:54 -0700
Message-ID: <20071006170654.23741.84018.stgit@dwillia2-linux.ch.intel.com>
References: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The stripe_queue object collects i/o requests before they are handled by
the stripe-cache (via the stripe_head object).  add_stripe_bio currently
looks at the state of the stripe-cache to implement bitmap support,
reimplement this using stripe_queue attributes.

Introduce the STRIPE_QUEUE_FIRSTWRITE flag to track when a stripe is first
written.  When a stripe_head is available record the bitmap batch sequence
number and set STRIPE_BIT_DELAY.  For now a stripe_head will always be
available at 'add_queue_bio' time, going forward the 'sh' field of the
stripe_queue will indicate whether a stripe_head is attached.

Tested-by: Mr. James W. Laferriere <babydr@baby-dragons.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |   53 ++++++++++++++++++++++++++++----------------
 include/linux/raid/raid5.h |    6 +++++
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7bc206c..d566fc9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -31,8 +31,10 @@
  * conf->bm_flush is the number of the last batch that was closed to
  *    new additions.
  * When we discover that we will need to write to any block in a stripe
- * (in add_stripe_bio) we update the in-memory bitmap and record in sh->bm_seq
- * the number of the batch it will be in. This is bm_flush+1.
+ * (in add_queue_bio) we update the in-memory bitmap and record in the
+ * stripe_queue that a bitmap write was started.  Then, in handle_stripe when
+ * we have a stripe_head available, we update sh->bm_seq to record the
+ * sequence number (target batch number) of this request.  This is bm_flush+1.
  * When we are ready to do a write, if that batch hasn't been written yet,
  *   we plug the array and queue the stripe for later.
  * When an unplug happens, we increment bm_flush, thus closing the current
@@ -360,8 +362,14 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 		}
 	} while (sh == NULL);
 
-	if (sh)
+	if (sh) {
 		atomic_inc(&sh->count);
+		if (test_and_clear_bit(STRIPE_QUEUE_FIRSTWRITE,
+					&sh->sq->state)) {
+			sh->bm_seq = conf->seq_flush+1;
+			set_bit(STRIPE_BIT_DELAY, &sh->state);
+		}
+	}
 
 	spin_unlock_irq(&conf->device_lock);
 	return sh;
@@ -1991,26 +1999,34 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int add_queue_bio(struct stripe_queue *sq, struct bio *bi, int dd_idx,
+			  int forwrite)
 {
 	struct bio **bip;
-	struct stripe_queue *sq = sh->sq;
 	raid5_conf_t *conf = sq->raid_conf;
 	int firstwrite=0;
 
-	pr_debug("adding bh b#%llu to stripe s#%llu\n",
+	pr_debug("adding bio (%llu) to queue (%llu)\n",
 		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector);
-
+		(unsigned long long)sq->sector);
 
 	spin_lock(&sq->lock);
 	spin_lock_irq(&conf->device_lock);
 	if (forwrite) {
 		bip = &sq->dev[dd_idx].towrite;
-		if (*bip == NULL && sq->dev[dd_idx].written == NULL)
+		set_bit(dd_idx, sq->to_write);
+		if (*bip == NULL && sq->dev[dd_idx].written == NULL) {
+			/* flag the queue to be assigned a bitmap
+			 * sequence number
+			 */
+			set_bit(STRIPE_QUEUE_FIRSTWRITE, &sq->state);
 			firstwrite = 1;
-	} else
+		}
+	} else {
 		bip = &sq->dev[dd_idx].toread;
+		set_bit(dd_idx, sq->to_read);
+	}
+
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
@@ -2024,19 +2040,17 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		bi->bi_next = *bip;
 	*bip = bi;
 	bi->bi_phys_segments ++;
+
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sq->lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector, dd_idx);
+		(unsigned long long)sq->sector, dd_idx);
 
-	if (conf->mddev->bitmap && firstwrite) {
-		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
+	if (conf->mddev->bitmap && firstwrite)
+		bitmap_startwrite(conf->mddev->bitmap, sq->sector,
 				  STRIPE_SECTORS, 0);
-		sh->bm_seq = conf->seq_flush+1;
-		set_bit(STRIPE_BIT_DELAY, &sh->state);
-	}
 
 	if (forwrite) {
 		/* check if page is covered */
@@ -2049,7 +2063,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 				sector = bi->bi_sector + (bi->bi_size>>9);
 		}
 		if (sector >= sq->dev[dd_idx].sector + STRIPE_SECTORS)
-			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
+			set_bit(dd_idx, sq->overwrite);
 	}
 
 	return 1;
@@ -3827,7 +3841,8 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			}
 
 			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+			    !add_queue_bio(sh->sq, bi, dd_idx,
+					   bi->bi_rw & RW_MASK)) {
 				/* Stripe is busy expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
@@ -4128,7 +4143,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 		}
 
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
-		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
+		if (!add_queue_bio(sh->sq, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
 			raid_bio->bi_hw_segments = scnt;
 			conf->retry_read_aligned = raid_bio;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index fbe622c..3d4938c 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -218,6 +218,7 @@ struct stripe_queue {
 	unsigned long *overlap; /* There is a pending overlapping request */
 	spinlock_t lock; /* protect bio lists and stripe_head state */
 	struct raid5_private_data *raid_conf;
+	unsigned long state;
 	struct list_head list_node;
 	int pd_idx; /* parity disk index */
 	int disks; /* disks in stripe */
@@ -288,6 +289,11 @@ struct stripe_queue {
 #define STRIPE_OP_MOD_DMA_CHECK 8
 
 /*
+ * Stripe-queue state
+ */
+#define STRIPE_QUEUE_FIRSTWRITE 0
+
+/*
  * Plugging:
  *
  * To improve write throughput, we need to delay the handling of some
