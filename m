From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/12] md: move raid5 io requests to raid5_run_ops
Date: Mon, 22 Jan 2007 20:29:45 -0700
Message-ID: <20070123032945.29114.66627.stgit@dwillia2-linux.ch.intel.com>
References: <1169522364.8362.113.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1169522364.8362.113.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: johnpol@2ka.mipt.ru, christopher.leech@intel.com, arjan@infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

handle_stripe now only updates the state of stripes.  All execution of
operations is moved to raid5_run_ops.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c |   68 ++++++++--------------------------------------------
 1 files changed, 10 insertions(+), 58 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1956b3c..8af084f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2360,6 +2360,8 @@ static void handle_stripe5(struct stripe_head *sh)
 						PRINTK("Read_old block %d for r-m-w\n", i);
 						set_bit(R5_LOCKED, &dev->flags);
 						set_bit(R5_Wantread, &dev->flags);
+						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+							sh->ops.count++;
 						locked++;
 					} else {
 						set_bit(STRIPE_DELAYED, &sh->state);
@@ -2380,6 +2382,8 @@ static void handle_stripe5(struct stripe_head *sh)
 						PRINTK("Read_old block %d for Reconstruct\n", i);
 						set_bit(R5_LOCKED, &dev->flags);
 						set_bit(R5_Wantread, &dev->flags);
+						if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+							sh->ops.count++;
 						locked++;
 					} else {
 						set_bit(STRIPE_DELAYED, &sh->state);
@@ -2479,6 +2483,8 @@ static void handle_stripe5(struct stripe_head *sh)
 
 			set_bit(R5_LOCKED, &dev->flags);
 			set_bit(R5_Wantwrite, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 			clear_bit(STRIPE_DEGRADED, &sh->state);
 			locked++;
 			set_bit(STRIPE_INSYNC, &sh->state);
@@ -2500,12 +2506,16 @@ static void handle_stripe5(struct stripe_head *sh)
 		dev = &sh->dev[failed_num];
 		if (!test_bit(R5_ReWrite, &dev->flags)) {
 			set_bit(R5_Wantwrite, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 			set_bit(R5_ReWrite, &dev->flags);
 			set_bit(R5_LOCKED, &dev->flags);
 			locked++;
 		} else {
 			/* let's read it back */
 			set_bit(R5_Wantread, &dev->flags);
+			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
+				sh->ops.count++;
 			set_bit(R5_LOCKED, &dev->flags);
 			locked++;
 		}
@@ -2615,64 +2625,6 @@ static void handle_stripe5(struct stripe_head *sh)
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
-			if (syncing || expanding || expanded)
-				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
-
-			bi->bi_bdev = rdev->bdev;
-			PRINTK("for %llu schedule op %ld on disc %d\n",
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
-			PRINTK("skip op %ld on disc %d for sector %llu\n",
-				bi->bi_rw, i, (unsigned long long)sh->sector);
-			clear_bit(R5_LOCKED, &sh->dev[i].flags);
-			set_bit(STRIPE_HANDLE, &sh->state);
-		}
-	}
 }
 
 static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
