From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 3 of 4 - Fix bug in raid5
Date: Thu, 07 Nov 2002 11:56:10 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E189axu-0008JR-00@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


### Comments for ChangeSet

When analysing a stripe in handle_stripe we set bits
 R5_Wantread or R5_Wantwrite
to indicate if a read or write is needed.  We don't actually schedule the
IO immediately as this is done under a spinlock (sh->lock) and 
generic_make_request can block.  Instead we check these bits after
the lock has been lifted and then schedule the IO.

But once the lock has been lifted we aren't safe against multiple
access, and it is possible that the IO will be scheduled never, or twice.

So, we use test_and_clear to check and potentially schedule the IO.

This wasn't a problem in 2.4 because the equivalent information was
stored on the stack instead of in the stripe.

We also make sure bi_io_vec[0] has correct values as a previous
call to generic_make_request may have changed them.


 ----------- Diffstat output ------------
 ./drivers/md/raid5.c |   92 +++++++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 43 deletions(-)

--- ./drivers/md/raid5.c	2002/11/06 23:04:13	1.1
+++ ./drivers/md/raid5.c	2002/11/06 23:05:40	1.2
@@ -851,8 +851,6 @@ static void handle_stripe(struct stripe_
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		dev = &sh->dev[i];
-		clear_bit(R5_Wantread, &dev->flags);
-		clear_bit(R5_Wantwrite, &dev->flags);
 		clear_bit(R5_Insync, &dev->flags);
 		clear_bit(R5_Syncio, &dev->flags);
 
@@ -1160,48 +1158,56 @@ static void handle_stripe(struct stripe_
 		bi->bi_size = 0;
 		bi->bi_end_io(bi, bytes, 0);
 	}
-	for (i=disks; i-- ;) 
-		if (sh->dev[i].flags & ((1<<R5_Wantwrite)|(1<<R5_Wantread))) {
-			struct bio *bi = &sh->dev[i].req;
-			mdk_rdev_t *rdev ;
-
-			bi->bi_rw = 0;
-			if (test_bit(R5_Wantread, &sh->dev[i].flags))
-				bi->bi_end_io = raid5_end_read_request;
-			else {
-				bi->bi_end_io = raid5_end_write_request;
-				bi->bi_rw = 1;
-			}
-
-			spin_lock_irq(&conf->device_lock);
-			rdev = conf->disks[i].rdev;
-			if (rdev && rdev->faulty)
-				rdev = NULL;
-			if (rdev)
-				atomic_inc(&rdev->nr_pending);
-			spin_unlock_irq(&conf->device_lock);
-
-			if (rdev) {
-				if (test_bit(R5_Syncio, &sh->dev[i].flags))
-					md_sync_acct(rdev, STRIPE_SECTORS);
-
-				bi->bi_bdev = rdev->bdev;
-				PRINTK("for %llu schedule op %ld on disc %d\n", (unsigned long long)sh->sector, bi->bi_rw, i);
-				atomic_inc(&sh->count);
-				bi->bi_sector = sh->sector;
-				bi->bi_flags = 1 << BIO_UPTODATE;
-				bi->bi_vcnt = 1;	
-				bi->bi_idx = 0;
-				bi->bi_io_vec = &sh->dev[i].vec;
-				bi->bi_size = STRIPE_SIZE;
-				bi->bi_next = NULL;
-				generic_make_request(bi);
-			} else {
-				PRINTK("skip op %ld on disc %d for sector %llu\n", bi->bi_rw, i, (unsigned long long)sh->sector);
-				clear_bit(R5_LOCKED, &dev->flags);
-				set_bit(STRIPE_HANDLE, &sh->state);
-			}
+	for (i=disks; i-- ;) {
+		int rw;
+		struct bio *bi;
+		mdk_rdev_t *rdev;
+		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
+			rw = 1;
+		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
+			rw = 0;
+		else
+			continue;
+ 
+		bi = &sh->dev[i].req;
+ 
+		bi->bi_rw = rw;
+		if (rw)
+			bi->bi_end_io = raid5_end_write_request;
+		else
+			bi->bi_end_io = raid5_end_read_request;
+ 
+		spin_lock_irq(&conf->device_lock);
+		rdev = conf->disks[i].rdev;
+		if (rdev && rdev->faulty)
+			rdev = NULL;
+		if (rdev)
+			atomic_inc(&rdev->nr_pending);
+		spin_unlock_irq(&conf->device_lock);
+ 
+		if (rdev) {
+			if (test_bit(R5_Syncio, &sh->dev[i].flags))
+				md_sync_acct(rdev, STRIPE_SECTORS);
+
+			bi->bi_bdev = rdev->bdev;
+			PRINTK("for %llu schedule op %ld on disc %d\n", (unsigned long long)sh->sector, bi->bi_rw, i);
+			atomic_inc(&sh->count);
+			bi->bi_sector = sh->sector;
+			bi->bi_flags = 1 << BIO_UPTODATE;
+			bi->bi_vcnt = 1;	
+			bi->bi_idx = 0;
+			bi->bi_io_vec = &sh->dev[i].vec;
+			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
+			bi->bi_io_vec[0].bv_offset = 0;
+			bi->bi_size = STRIPE_SIZE;
+			bi->bi_next = NULL;
+			generic_make_request(bi);
+		} else {
+			PRINTK("skip op %ld on disc %d for sector %llu\n", bi->bi_rw, i, (unsigned long long)sh->sector);
+			clear_bit(R5_LOCKED, &dev->flags);
+			set_bit(STRIPE_HANDLE, &sh->state);
 		}
+	}
 }
 
 static inline void raid5_activate_delayed(raid5_conf_t *conf)
