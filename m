From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 14/19] md: handle_stripe5 - request io processing in
	raid5_run_ops
Date: Tue, 26 Jun 2007 18:51:45 -0700
Message-ID: <20070627015145.18962.45060.stgit@dwillia2-linux.ch.intel.com>
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

I/O submission requests were already handled outside of the stripe lock in
handle_stripe.  Now that handle_stripe is only tasked with finding work,
this logic belongs in raid5_run_ops.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   71 ++++++++++------------------------------------------
 1 files changed, 13 insertions(+), 58 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e0ae26d..a09bc5f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2319,6 +2319,9 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 						"%d for r-m-w\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
+					if (!test_and_set_bit(
+						STRIPE_OP_IO, &sh->ops.pending))
+						sh->ops.count++;
 					s->locked++;
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
@@ -2342,6 +2345,9 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 						"%d for Reconstruct\n", i);
 					set_bit(R5_LOCKED, &dev->flags);
 					set_bit(R5_Wantread, &dev->flags);
+					if (!test_and_set_bit(
+						STRIPE_OP_IO, &sh->ops.pending))
+						sh->ops.count++;
 					s->locked++;
 				} else {
 					set_bit(STRIPE_DELAYED, &sh->state);
@@ -2538,6 +2544,9 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 
 		set_bit(R5_LOCKED, &dev->flags);
 		set_bit(R5_Wantwrite, &dev->flags);
+		if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+			sh->ops.count++;
+
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 		s->locked++;
 		set_bit(STRIPE_INSYNC, &sh->state);
@@ -2923,12 +2932,16 @@ static void handle_stripe5(struct stripe_head *sh)
 		dev = &sh->dev[s.failed_num];
 		if (!test_bit(R5_ReWrite, &dev->flags)) {
 			set_bit(R5_Wantwrite, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 			set_bit(R5_ReWrite, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
 			s.locked++;
 		} else {
 			/* let's read it back */
 			set_bit(R5_Wantread, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 			set_bit(R5_LOCKED, &dev->flags);
 			s.locked++;
 		}
@@ -2989,64 +3002,6 @@ static void handle_stripe5(struct stripe_head *sh)
 			      test_bit(BIO_UPTODATE, &bi->bi_flags)
 			        ? 0 : -EIO);
 	}
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
 
 static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
