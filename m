From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD RAID5: Avoid accessing gendisk or queue structs when not
 available
Date: Thu, 07 Mar 2013 16:22:01 -0600
Message-ID: <1362694921.28152.4.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

MD RAID5:  Fix kernel oops when RAID4/5/6 is used via device-mapper

Commit a9add5d (v3.8-rc1) added blktrace calls to the RAID4/5/6 driver.
However, when device-mapper is used to create RAID4/5/6 arrays, the
mddev->gendisk and mddev->queue fields are not setup.  Therefore, calling
things like trace_block_bio_remap will cause a kernel oops.  This patch
conditionalizes those calls on whether the proper fields exist to make
the calls.  (Device-mapper will call trace_block_bio_remap on its own.)

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid5.c
===================================================================
--- linux-upstream.orig/drivers/md/raid5.c
+++ linux-upstream/drivers/md/raid5.c
@@ -671,9 +671,11 @@ static void ops_run_io(struct stripe_hea
 			bi->bi_next = NULL;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
-			trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
-					      bi, disk_devt(conf->mddev->gendisk),
-					      sh->dev[i].sector);
+
+			if (conf->mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
+						      bi, disk_devt(conf->mddev->gendisk),
+						      sh->dev[i].sector);
 			generic_make_request(bi);
 		}
 		if (rrdev) {
@@ -701,9 +703,10 @@ static void ops_run_io(struct stripe_hea
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_size = STRIPE_SIZE;
 			rbi->bi_next = NULL;
-			trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
-					      rbi, disk_devt(conf->mddev->gendisk),
-					      sh->dev[i].sector);
+			if (conf->mddev->gendisk)
+				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
+						      rbi, disk_devt(conf->mddev->gendisk),
+						      sh->dev[i].sector);
 			generic_make_request(rbi);
 		}
 		if (!rdev && !rrdev) {
@@ -2862,8 +2865,10 @@ static void handle_stripe_dirtying(struc
 	set_bit(STRIPE_HANDLE, &sh->state);
 	if (rmw < rcw && rmw > 0) {
 		/* prefer read-modify-write, but need to get some data */
-		blk_add_trace_msg(conf->mddev->queue, "raid5 rmw %llu %d",
-				  (unsigned long long)sh->sector, rmw);
+		if (conf->mddev->queue)
+			blk_add_trace_msg(conf->mddev->queue,
+					  "raid5 rmw %llu %d",
+					  (unsigned long long)sh->sector, rmw);
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if ((dev->towrite || i == sh->pd_idx) &&
@@ -2913,7 +2918,7 @@ static void handle_stripe_dirtying(struc
 				}
 			}
 		}
-		if (rcw)
+		if (rcw && conf->mddev->queue)
 			blk_add_trace_msg(conf->mddev->queue, "raid5 rcw %llu %d %d %d",
 					  (unsigned long long)sh->sector,
 					  rcw, qread, test_bit(STRIPE_DELAYED, &sh->state));
@@ -4018,9 +4023,10 @@ static int chunk_aligned_read(struct mdd
 		atomic_inc(&conf->active_aligned_reads);
 		spin_unlock_irq(&conf->device_lock);
 
-		trace_block_bio_remap(bdev_get_queue(align_bi->bi_bdev),
-				      align_bi, disk_devt(mddev->gendisk),
-				      raid_bio->bi_sector);
+		if (mddev->gendisk)
+			trace_block_bio_remap(bdev_get_queue(align_bi->bi_bdev),
+					      align_bi, disk_devt(mddev->gendisk),
+					      raid_bio->bi_sector);
 		generic_make_request(align_bi);
 		return 1;
 	} else {
@@ -4114,7 +4120,8 @@ static void raid5_unplug(struct blk_plug
 		}
 		spin_unlock_irq(&conf->device_lock);
 	}
-	trace_block_unplug(mddev->queue, cnt, !from_schedule);
+	if (mddev->queue)
+		trace_block_unplug(mddev->queue, cnt, !from_schedule);
 	kfree(cb);
 }
 


