From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 12/19] md: handle_stripe5 - add request/completion
	logic for async read ops
Date: Tue, 26 Jun 2007 18:51:35 -0700
Message-ID: <20070627015135.18962.52646.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

When a read bio is attached to the stripe and the corresponding block is
marked R5_UPTODATE, then a read (biofill) operation is scheduled to copy
the data from the stripe cache to the bio buffer.  handle_stripe flags the
blocks to be operated on with the R5_Wantfill flag.  If new read requests
arrive while raid5_run_ops is running they will not be handled until
handle_stripe is scheduled to run again.

Changelog:
* cleanup to_read and to_fill accounting
* do not fail reads that have reached the cache

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c         |   53 +++++++++++++++++++++-----------------------
 include/linux/raid/raid5.h |    2 +-
 2 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 89d3890..3d0dca9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2042,9 +2042,12 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 			bi = bi2;
 		}
 
-		/* fail any reads if this device is non-operational */
-		if (!test_bit(R5_Insync, &sh->dev[i].flags) ||
-		    test_bit(R5_ReadError, &sh->dev[i].flags)) {
+		/* fail any reads if this device is non-operational and
+		 * the data has not reached the cache yet.
+		 */
+		if (!test_bit(R5_Wantfill, &sh->dev[i].flags) &&
+		    (!test_bit(R5_Insync, &sh->dev[i].flags) ||
+		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
 			bi = sh->dev[i].toread;
 			sh->dev[i].toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
@@ -2733,37 +2736,27 @@ static void handle_stripe5(struct stripe_head *sh)
 		struct r5dev *dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
-		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev->flags, dev->toread, dev->towrite, dev->written);
-		/* maybe we can reply to a read */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
-			struct bio *rbi, *rbi2;
-			pr_debug("Return read for disc %d\n", i);
-			spin_lock_irq(&conf->device_lock);
-			rbi = dev->toread;
-			dev->toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &dev->flags))
-				wake_up(&conf->wait_for_overlap);
-			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-				copy_data(0, rbi, dev->page, dev->sector);
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
+		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
+			"written %p\n",	i, dev->flags, dev->toread, dev->read,
+			dev->towrite, dev->written);
+
+		/* maybe we can request a biofill operation
+		 *
+		 * new wantfill requests are only permitted while
+		 * STRIPE_OP_BIOFILL is clear
+		 */
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
+			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 		if (test_bit(R5_Wantcompute, &dev->flags)) s.compute++;
 
-		if (dev->toread)
+		if (test_bit(R5_Wantfill, &dev->flags))
+			s.to_fill++;
+		else if (dev->toread)
 			s.to_read++;
 		if (dev->towrite) {
 			s.to_write++;
@@ -2786,6 +2779,10 @@ static void handle_stripe5(struct stripe_head *sh)
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
+
+	if (s.to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+		sh->ops.count++;
+
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 		" to_write=%d failed=%d failed_num=%d\n",
 		s.locked, s.uptodate, s.to_read, s.to_write,
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 2d45eba..e9dfb2d 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -200,7 +200,7 @@ struct stripe_head {
 struct stripe_head_state {
 	int syncing, expanding, expanded;
 	int locked, uptodate, to_read, to_write, failed, written;
-	int compute, req_compute, non_overwrite, dirty;
+	int to_fill, compute, req_compute, non_overwrite, dirty;
 	int failed_num;
 };
 
