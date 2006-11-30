From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 09/12] md: satisfy raid5 read requests via raid5_run_ops
Date: Thu, 30 Nov 2006 13:10:45 -0700
Message-ID: <20061130201045.21313.73053.stgit@dwillia2-linux.ch.intel.com>
References: <e9c3a7c20611301155p4069c642j276d7705b0f81447@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20611301155p4069c642j276d7705b0f81447@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, jeff@garzik.org, christopher.leech@intel.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, olof@lixom.net
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Use raid5_run_ops to carry out the memory copies for a raid5 read request.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   57 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1764fbb..3c793dc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2020,7 +2020,7 @@ static void handle_stripe5(struct stripe
 	int i;
 	int syncing, expanding, expanded;
 	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
-	int compute=0, req_compute=0, non_overwrite=0;
+	int to_fill=0, compute=0, req_compute=0, non_overwrite=0;
 	int failed_num=0;
 	struct r5dev *dev;
 
@@ -2035,42 +2035,45 @@ static void handle_stripe5(struct stripe
 	syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
-	/* Now to look around and see what can be done */
 
+	/* clear completed biofills */
+	if (test_and_clear_bit(STRIPE_OP_BIOFILL, &sh->ops.complete)) {
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+		clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+	}
+
+	/* Now to look around and see what can be done */
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
-		PRINTK("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev->flags, dev->toread, dev->towrite, dev->written);
+		PRINTK("check %d: state 0x%lx toread %p read %p write %p written %p\n",
+		i, dev->flags, dev->toread, dev->read, dev->towrite, dev->written);
+
+		/* maybe we can acknowledge completion of a biofill operation */
+		if (test_bit(R5_Wantfill, &dev->flags) && !dev->toread)
+			clear_bit(R5_Wantfill, &dev->flags);
+
 		/* maybe we can reply to a read */
+		if (dev->read && !test_bit(R5_Wantfill, &dev->flags) &&
+			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending)) {
+			return_bi = dev->read;
+			dev->read = NULL;
+		}
+
+		/* maybe we can start a biofill operation */
 		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
-			struct bio *rbi, *rbi2;
-			PRINTK("Return read for disc %d\n", i);
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
+			to_read--;
+			if (!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+				set_bit(R5_Wantfill, &dev->flags);
 		}
 
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) uptodate++;
+		if (test_bit(R5_Wantfill, &dev->flags)) to_fill++;
 		if (test_bit(R5_Wantcompute, &dev->flags)) BUG_ON(++compute > 1);
 
 		if (dev->toread) to_read++;
@@ -2094,9 +2097,13 @@ static void handle_stripe5(struct stripe
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
+
+	if (to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
+		sh->ops.count++;
+
 	PRINTK("locked=%d uptodate=%d to_read=%d"
-		" to_write=%d failed=%d failed_num=%d\n",
-		locked, uptodate, to_read, to_write, failed, failed_num);
+		" to_write=%d to_fill=%d failed=%d failed_num=%d\n",
+		locked, uptodate, to_read, to_write, to_fill, failed, failed_num);
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
