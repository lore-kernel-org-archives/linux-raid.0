From: NeilBrown <neilb@suse.de>
Subject: [PATCH 022 of 29] md: md: unify raid5/6 i/o submission
Date: Fri, 27 Jun 2008 16:51:43 +1000
Message-ID: <1080627065143.10671@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids


From: Dan Williams <dan.j.williams@intel.com>

Let the raid6 path call ops_run_io to get pending i/o submitted.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |   63 +--------------------------------------------------
 1 file changed, 2 insertions(+), 61 deletions(-)

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2008-06-27 16:22:04.000000000 +1000
+++ ./drivers/md/raid5.c	2008-06-27 16:22:05.000000000 +1000
@@ -3114,68 +3114,9 @@ static void handle_stripe6(struct stripe
 	if (unlikely(blocked_rdev))
 		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
 
-	return_io(return_bi);
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
-		set_bit(STRIPE_IO_STARTED, &sh->state);
-
-		bi = &sh->dev[i].req;
-
-		bi->bi_rw = rw;
-		if (rw == WRITE)
-			bi->bi_end_io = raid5_end_write_request;
-		else
-			bi->bi_end_io = raid5_end_read_request;
+	ops_run_io(sh, &s);
 
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
+	return_io(return_bi);
 }
 
 static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
