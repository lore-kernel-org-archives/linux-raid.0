From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.23-rc7 3/3] raid5: fix ops_complete_biofill
Date: Thu, 20 Sep 2007 18:27:50 -0700
Message-ID: <20070921012750.17157.26889.stgit@dwillia2-linux.ch.intel.com>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
Cc: akpm@linux-foundation.org, yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
List-Id: linux-raid.ids

ops_complete_biofill tried to avoid calling handle_stripe since all the
state necessary to return read completions is available.  However the
process of determining whether more read requests are pending requires
locking the stripe (to block add_stripe_bio from updating dev->toead).
ops_complete_biofill can run in tasklet context, so rather than upgrading
all the stripe locks from spin_lock to spin_lock_bh this patch just moves
read completion handling back into handle_stripe.

Found-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   90 +++++++++++++++++++++++++++-------------------------
 1 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4d63773..38c8893 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -512,54 +512,12 @@ async_copy_data(int frombio, struct bio *bio, struct page *page,
 static void ops_complete_biofill(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	struct bio *return_bi = NULL;
-	raid5_conf_t *conf = sh->raid_conf;
-	int i, more_to_read = 0;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
-	/* clear completed biofills */
-	for (i = sh->disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
-		/* check if this stripe has new incoming reads */
-		if (dev->toread)
-			more_to_read++;
-
-		/* acknowledge completion of a biofill operation */
-		/* and check if we need to reply to a read request
-		*/
-		if (test_bit(R5_Wantfill, &dev->flags) && !dev->toread) {
-			struct bio *rbi, *rbi2;
-			clear_bit(R5_Wantfill, &dev->flags);
-
-			/* The access to dev->read is outside of the
-			 * spin_lock_irq(&conf->device_lock), but is protected
-			 * by the STRIPE_OP_BIOFILL pending bit
-			 */
-			BUG_ON(!dev->read);
-			rbi = dev->read;
-			dev->read = NULL;
-			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
-				rbi2 = r5_next_bio(rbi, dev->sector);
-				spin_lock_irq(&conf->device_lock);
-				if (--rbi->bi_phys_segments == 0) {
-					rbi->bi_next = return_bi;
-					return_bi = rbi;
-				}
-				spin_unlock_irq(&conf->device_lock);
-				rbi = rbi2;
-			}
-		}
-	}
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
-	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
-
-	return_io(return_bi);
-
-	if (more_to_read)
-		set_bit(STRIPE_HANDLE, &sh->state);
+	set_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
@@ -2112,6 +2070,42 @@ static void handle_issuing_new_read_requests6(struct stripe_head *sh,
 }
 
 
+/* handle_completed_read_requests - return completion for reads and allow
+ * new read operations to be submitted to the stripe.
+ */
+static void handle_completed_read_requests(raid5_conf_t *conf,
+					    struct stripe_head *sh,
+					    struct bio **return_bi)
+{
+	int i;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	/* check if we need to reply to a read request */
+	for (i = sh->disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+
+		if (test_and_clear_bit(R5_Wantfill, &dev->flags)) {
+			struct bio *rbi, *rbi2;
+
+			rbi = dev->read;
+			dev->read = NULL;
+			while (rbi && rbi->bi_sector <
+				dev->sector + STRIPE_SECTORS) {
+				rbi2 = r5_next_bio(rbi, dev->sector);
+				spin_lock_irq(&conf->device_lock);
+				if (--rbi->bi_phys_segments == 0) {
+					rbi->bi_next = *return_bi;
+					*return_bi = rbi;
+				}
+				spin_unlock_irq(&conf->device_lock);
+				rbi = rbi2;
+			}
+		}
+	}
+}
+
 /* handle_completed_write_requests
  * any written block on an uptodate or failed drive can be returned.
  * Note that if we 'wrote' to a failed drive, it will be UPTODATE, but
@@ -2633,6 +2627,14 @@ static void handle_stripe5(struct stripe_head *sh)
 	s.expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
+	if (test_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete);
+
+		handle_completed_read_requests(conf, sh, &return_bi);
+	}
+
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
