From: Yuri Tikhonov <yur@emcraft.com>
Subject: [md-raid6-accel PATCH 10/12] md: req/comp logic for async I/O operations
Date: Tue, 4 Dec 2007 14:37:21 +0300
Message-ID: <200712041437.21763.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 I/O submission requests were already handled outside of the stripe lock in
handle_stripe. Now that handle_stripe is only tasked with finding work,
this logic belongs in raid5_run_ops

 Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
 Signed-off-by: Mikhail Cherkashin <mike@emcraft.com>
--
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9b4db93..9b6336f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3188,6 +3188,8 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 				 (unsigned long long)sh->sector, i);
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantread, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 			s->locked++;
 		}
 	/* now if nothing is locked, and if we have enough data, we can start a
@@ -3484,6 +3486,8 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 			set_bit(R5_Wantwrite, &dev->flags);
 			BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		}
+		if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+			sh->ops.count++;
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 
 		set_bit(STRIPE_INSYNC, &sh->state);
@@ -3889,11 +3893,12 @@ static void handle_stripe6(struct stripe_head *sh)
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
+		if (test_bit(R5_Wantfill, &dev->flags)) s.to_fill++;
+		else if (dev_q->toread) s.to_read++;
+
 		if (test_bit(R5_Wantcompute, &dev->flags))
 			BUG_ON(++s.compute > 2);
 
-		if (dev_q->toread)
-			s.to_read++;
 		if (dev_q->towrite) {
 			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
@@ -4021,6 +4026,9 @@ static void handle_stripe6(struct stripe_head *sh)
 					set_bit(R5_Wantread, &dev->flags);
 					set_bit(R5_LOCKED, &dev->flags);
 				}
+				if (!test_and_set_bit(STRIPE_OP_IO,
+							&sh->ops.pending))
+					sh->ops.count++;
 			}
 		}
 
@@ -4068,65 +4076,6 @@ static void handle_stripe6(struct stripe_head *sh)
 		raid_run_ops(sh, pending);
 
 	return_io(return_bi);
-
-	for (i=disks; i-- ;) {
-		int rw;
-		struct bio *bi;
-		mdk_rdev_t *rdev;
-		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
-			rw = WRITE;
-		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
-			rw = READ;
-		else
-			continue;
-
-		bi = &sh->dev[i].req;
-
-		bi->bi_rw = rw;
-		if (rw == WRITE)
-			bi->bi_end_io = raid5_end_write_request;
-		else
-			bi->bi_end_io = raid5_end_read_request;
-
-		rcu_read_lock();
-		rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && test_bit(Faulty, &rdev->flags))
-			rdev = NULL;
-		if (rdev)
-			atomic_inc(&rdev->nr_pending);
-		rcu_read_unlock();
-
-		if (rdev) {
-			if (s.syncing || s.expanding || s.expanded)
-				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
-
-			bi->bi_bdev = rdev->bdev;
-			pr_debug("for %llu schedule op %ld on disc %d\n",
-				(unsigned long long)sh->sector, bi->bi_rw, i);
-			atomic_inc(&sh->count);
-			bi->bi_sector = sh->sector + rdev->data_offset;
-			bi->bi_flags = 1 << BIO_UPTODATE;
-			bi->bi_vcnt = 1;
-			bi->bi_max_vecs = 1;
-			bi->bi_idx = 0;
-			bi->bi_io_vec = &sh->dev[i].vec;
-			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
-			bi->bi_io_vec[0].bv_offset = 0;
-			bi->bi_size = STRIPE_SIZE;
-			bi->bi_next = NULL;
-			if (rw == WRITE &&
-			    test_bit(R5_ReWrite, &sh->dev[i].flags))
-				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
-			generic_make_request(bi);
-		} else {
-			if (rw == WRITE)
-				set_bit(STRIPE_DEGRADED, &sh->state);
-			pr_debug("skip op %ld on disc %d for sector %llu\n",
-				bi->bi_rw, i, (unsigned long long)sh->sector);
-			clear_bit(R5_LOCKED, &sh->dev[i].flags);
-			set_bit(STRIPE_HANDLE, &sh->state);
-		}
-	}
 }
 
 static void handle_stripe(struct stripe_head *sh)

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
