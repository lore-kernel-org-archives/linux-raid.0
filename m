From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/16] md/raid5: preferentially read from replacement
 device if possible.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.46497.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a replacement device is present and has been recovered far enough,
then use it for reading into the stripe cache.

If we get an error we don't try to repair it, we just fail the device.
A replacement device that gives errors does not sound sensible.

This requires removing the setting of R5_ReadError when we get
a read error during a read that bypasses the cache.  It was probably
a bad idea anyway as we don't know that every block in the read
caused an error, and it could cause ReadError to be set for the
replacement device, which is bad.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   69 +++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 12e54c0..7d77a38 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -512,7 +512,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_end_io = raid5_end_read_request;
 
 		rcu_read_lock();
-		rdev = rcu_dereference(conf->disks[i].rdev);
+		if (rw == READ &&
+		    test_bit(R5_ReadRepl, &sh->dev[i].flags))
+			rdev = rcu_dereference(conf->disks[i].replacement);
+		else
+			rdev = rcu_dereference(conf->disks[i].rdev);
 		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = NULL;
 		if (rdev)
@@ -1593,11 +1597,18 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		BUG();
 		return;
 	}
+	if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
+		rdev = conf->disks[i].replacement;
+	else
+		rdev = conf->disks[i].rdev;
 
 	if (uptodate) {
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
-			rdev = conf->disks[i].rdev;
+			/* Note that this cannot happen on a
+			 * replacement device.  We just fail those on
+			 * any error
+			 */
 			printk_ratelimited(
 				KERN_INFO
 				"md/raid:%s: read error corrected"
@@ -1610,16 +1621,24 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
-		if (atomic_read(&conf->disks[i].rdev->read_errors))
-			atomic_set(&conf->disks[i].rdev->read_errors, 0);
+		if (atomic_read(&rdev->read_errors))
+			atomic_set(&rdev->read_errors, 0);
 	} else {
-		const char *bdn = bdevname(conf->disks[i].rdev->bdev, b);
+		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
-		rdev = conf->disks[i].rdev;
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
-		if (conf->mddev->degraded >= conf->max_degraded)
+		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
+			printk_ratelimited(
+				KERN_WARNING
+				"md/raid:%s: read error on replacement device "
+				"(sector %llu on %s).\n",
+				mdname(conf->mddev),
+				(unsigned long long)(sh->sector
+						     + rdev->data_offset),
+				bdn);
+		else if (conf->mddev->degraded >= conf->max_degraded)
 			printk_ratelimited(
 				KERN_WARNING
 				"md/raid:%s: read error not correctable "
@@ -1653,7 +1672,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			md_error(conf->mddev, rdev);
 		}
 	}
-	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
+	rdev_dec_pending(rdev, conf->mddev);
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -3027,7 +3046,19 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 		if (dev->written)
 			s->written++;
-		rdev = rcu_dereference(conf->disks[i].rdev);
+		/* Prefer to use the replacement for reads, but only
+		 * if it is recovered enough and has no bad blocks.
+		 */
+		rdev = rcu_dereference(conf->disks[i].replacement);
+		if (rdev && !test_bit(Faulty, &rdev->flags) &&
+		    rdev->recovery_offset >= sh->sector + STRIPE_SECTORS &&
+		    !is_badblock(rdev, sh->sector, STRIPE_SECTORS,
+				 &first_bad, &bad_sectors))
+			set_bit(R5_ReadRepl, &dev->flags);
+		else {
+			rdev = rcu_dereference(conf->disks[i].rdev);
+			clear_bit(R5_ReadRepl, &dev->flags);
+		}
 		if (rdev) {
 			is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
 					     &first_bad, &bad_sectors);
@@ -3061,17 +3092,26 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 				set_bit(R5_Insync, &dev->flags);
 		}
 		if (test_bit(R5_WriteError, &dev->flags)) {
-			clear_bit(R5_Insync, &dev->flags);
-			if (!test_bit(Faulty, &rdev->flags)) {
+			/* This flag does not apply to '.replacement'
+			 * only to .rdev, so make sure to check that*/
+			struct md_rdev *rdev2 = rcu_dereference(
+				conf->disks[i].rdev);
+			if (rdev2 == rdev)
+				clear_bit(R5_Insync, &dev->flags);
+			if (!test_bit(Faulty, &rdev2->flags)) {
 				s->handle_bad_blocks = 1;
-				atomic_inc(&rdev->nr_pending);
+				atomic_inc(&rdev2->nr_pending);
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
 		if (test_bit(R5_MadeGood, &dev->flags)) {
-			if (!test_bit(Faulty, &rdev->flags)) {
+			/* This flag does not apply to '.replacement'
+			 * only to .rdev, so make sure to check that*/
+			struct md_rdev *rdev2 = rcu_dereference(
+				conf->disks[i].rdev);
+			if (rdev2 && !test_bit(Faulty, &rdev2->flags)) {
 				s->handle_bad_blocks = 1;
-				atomic_inc(&rdev->nr_pending);
+				atomic_inc(&rdev2->nr_pending);
 			} else
 				clear_bit(R5_MadeGood, &dev->flags);
 		}
@@ -4201,7 +4241,6 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 			return handled;
 		}
 
-		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
 			raid5_set_bi_hw_segments(raid_bio, scnt);


