From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 11/16] md/raid5: writes should get directed to replacement
 as well as original.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.32951.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When writing, we need to submit two writes, one to the original, and
one to the replacement - if there is a replacement.

If the write to the replacement results in a write error, we just fail
the device.  We only try to record write errors to the original.

When writing for recovery, we shouldn't write to the original.  This
will be addressed in a subsequent patch that generally addresses
recovery.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |  119 ++++++++++++++++++++++++++++++++++++++++++----------
 drivers/md/raid5.h |    1 
 2 files changed, 97 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 20f42f6..4ba4b8c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -491,8 +491,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	for (i = disks; i--; ) {
 		int rw;
-		struct bio *bi;
-		struct md_rdev *rdev;
+		struct bio *bi, *rbi;
+		struct md_rdev *rdev, *rrdev = NULL;
 		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags)) {
 			if (test_and_clear_bit(R5_WantFUA, &sh->dev[i].flags))
 				rw = WRITE_FUA;
@@ -504,27 +504,36 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			continue;
 
 		bi = &sh->dev[i].req;
+		rbi = &sh->dev[i].rreq; /* For writing to replacement */
 
 		bi->bi_rw = rw;
-		if (rw & WRITE)
+		rbi->bi_rw = rw;
+		if (rw & WRITE) {
 			bi->bi_end_io = raid5_end_write_request;
-		else
+			rbi->bi_end_io = raid5_end_write_request;
+		} else
 			bi->bi_end_io = raid5_end_read_request;
 
 		rcu_read_lock();
-		if (rw == READ &&
-		    test_bit(R5_ReadRepl, &sh->dev[i].flags))
+		rdev = rcu_dereference(conf->disks[i].rdev);
+		if (rw & WRITE)
+			rrdev = rcu_dereference(conf->disks[i].replacement);
+		else if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
 			rdev = rcu_dereference(conf->disks[i].replacement);
-		else
-			rdev = rcu_dereference(conf->disks[i].rdev);
+
 		if (rdev && test_bit(Faulty, &rdev->flags))
 			rdev = NULL;
 		if (rdev)
 			atomic_inc(&rdev->nr_pending);
+		if (rrdev && test_bit(Faulty, &rrdev->flags))
+			rrdev = NULL;
+		if (rrdev)
+			atomic_inc(&rrdev->nr_pending);
 		rcu_read_unlock();
 
 		/* We have already checked bad blocks for reads.  Now
-		 * need to check for writes.
+		 * need to check for writes.  We never accept write errors
+		 * on the replacement, so we don't to check rrdev.
 		 */
 		while ((rw & WRITE) && rdev &&
 		       test_bit(WriteErrorSeen, &rdev->flags)) {
@@ -571,8 +580,32 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
+			if (rrdev)
+				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 			generic_make_request(bi);
-		} else {
+		}
+		if (rrdev) {
+			if (s->syncing || s->expanding || s->expanded)
+				md_sync_acct(rrdev->bdev, STRIPE_SECTORS);
+
+			set_bit(STRIPE_IO_STARTED, &sh->state);
+
+			rbi->bi_bdev = rrdev->bdev;
+			pr_debug("%s: for %llu schedule op %ld on "
+				 "replacement disc %d\n",
+				__func__, (unsigned long long)sh->sector,
+				rbi->bi_rw, i);
+			atomic_inc(&sh->count);
+			rbi->bi_sector = sh->sector + rrdev->data_offset;
+			rbi->bi_flags = 1 << BIO_UPTODATE;
+			rbi->bi_idx = 0;
+			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
+			rbi->bi_io_vec[0].bv_offset = 0;
+			rbi->bi_size = STRIPE_SIZE;
+			rbi->bi_next = NULL;
+			generic_make_request(rbi);
+		}
+		if (!rdev && !rrdev) {
 			if (rw & WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
@@ -1683,14 +1716,23 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks, i;
+	struct md_rdev *uninitialized_var(rdev);
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	sector_t first_bad;
 	int bad_sectors;
+	int replacement = 0;
 
-	for (i=0 ; i<disks; i++)
-		if (bi == &sh->dev[i].req)
+	for (i = 0 ; i < disks; i++) {
+		if (bi == &sh->dev[i].req) {
+			rdev = conf->disks[i].rdev;
 			break;
-
+		}
+		if (bi == &sh->dev[i].rreq) {
+			rdev = conf->disks[i].replacement;
+			replacement = 1;
+			break;
+		}
+	}
 	pr_debug("end_write_request %llu/%d, count %d, uptodate: %d.\n",
 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
 		uptodate);
@@ -1699,21 +1741,30 @@ static void raid5_end_write_request(struct bio *bi, int error)
 		return;
 	}
 
-	if (!uptodate) {
-		set_bit(WriteErrorSeen, &conf->disks[i].rdev->flags);
-		set_bit(R5_WriteError, &sh->dev[i].flags);
-	} else if (is_badblock(conf->disks[i].rdev, sh->sector, STRIPE_SECTORS,
-			       &first_bad, &bad_sectors))
-		set_bit(R5_MadeGood, &sh->dev[i].flags);
+	if (replacement) {
+		if (!uptodate)
+			md_error(conf->mddev, rdev);
+		else if (is_badblock(rdev, sh->sector,
+				     STRIPE_SECTORS,
+				     &first_bad, &bad_sectors))
+			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
+	} else {
+		if (!uptodate) {
+			set_bit(WriteErrorSeen, &rdev->flags);
+			set_bit(R5_WriteError, &sh->dev[i].flags);
+		} else if (is_badblock(rdev, sh->sector,
+				       STRIPE_SECTORS,
+				       &first_bad, &bad_sectors))
+			set_bit(R5_MadeGood, &sh->dev[i].flags);
+	}
+	rdev_dec_pending(rdev, conf->mddev);
 
-	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
-	
-	clear_bit(R5_LOCKED, &sh->dev[i].flags);
+	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
+		clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 }
 
-
 static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
 	
 static void raid5_build_block(struct stripe_head *sh, int i, int previous)
@@ -1727,6 +1778,13 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 	dev->req.bi_private = sh;
 	dev->vec.bv_page = dev->page;
 
+	bio_init(&dev->rreq);
+	dev->rreq.bi_io_vec = &dev->rvec;
+	dev->rreq.bi_vcnt++;
+	dev->rreq.bi_max_vecs++;
+	dev->rreq.bi_private = sh;
+	dev->rvec.bv_page = dev->page;
+
 	dev->flags = 0;
 	dev->sector = compute_blocknr(sh, i, previous);
 }
@@ -3115,6 +3173,15 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			} else
 				clear_bit(R5_MadeGood, &dev->flags);
 		}
+		if (test_bit(R5_MadeGoodRepl, &dev->flags)) {
+			struct md_rdev *rdev2 = rcu_dereference(
+				conf->disks[i].replacement);
+			if (rdev2 && !test_bit(Faulty, &rdev2->flags)) {
+				s->handle_bad_blocks = 1;
+				atomic_inc(&rdev2->nr_pending);
+			} else
+				clear_bit(R5_MadeGoodRepl, &dev->flags);
+		}
 		if (!test_bit(R5_Insync, &dev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
@@ -3383,6 +3450,12 @@ finish:
 						     STRIPE_SECTORS);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
+			if (test_and_clear_bit(R5_MadeGoodRepl, &dev->flags)) {
+				rdev = conf->disks[i].replacement;
+				rdev_clear_badblocks(rdev, sh->sector,
+						     STRIPE_SECTORS);
+				rdev_dec_pending(rdev, conf->mddev);
+			}
 		}
 
 	if (s.ops_request)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 4cfd801..f6faaa1 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -259,6 +259,7 @@ struct stripe_head_state {
 enum r5dev_flags {
 	R5_UPTODATE,	/* page contains current data */
 	R5_LOCKED,	/* IO has been submitted on "req" */
+	R5_DOUBLE_LOCKED,/* Cannot clear R5_LOCKED until 2 writes complete */
 	R5_OVERWRITE,	/* towrite covers whole page */
 /* and some that are internal to handle_stripe */
 	R5_Insync,	/* rdev && rdev->in_sync at start */


