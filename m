From: Shaohua Li <shli@kernel.org>
Subject: [RFC 1/2] MD: raid5 trim support
Date: Tue, 17 Apr 2012 16:35:53 +0800
Message-ID: <20120417084632.306032602@kernel.org>
References: <20120417083552.483324288@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-raid5-discard-support.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@intel.com, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

Discard for raid4/5/6 has limitation. If discard request size is small, we do
discard for one disk, but we need calculate parity and write parity disk.  To
correctly calculate parity, zero_after_discard must be guaranteed. Even it's
true, we need do discard for one disk but write another disks, which makes the
parity disks wear out fast. This doesn't make sense. So an efficient discard
for raid4/5/6 should discard all data disks and parity disks, which requires
the write pattern to be (A, A+chunk_size, A+chunk_size*2...). If A's size is
smaller than chunk_size, such pattern is almost impossible in practice. So in
this patch, I only handle the case that A's size equals to chunk_size. That is
discard request should be aligned to stripe size and its size is multiple of
stripe size.

Since we can only handle request with specific alignment and size (or part of
the request fitting stripes), we can't guarantee zero_after_discard even
zero_after_discard is true in low level drives.

The block layer doesn't send down correctly aligned requests even correct
discard alignment is set, so I must filter out.

For raid4/5/6 parity calculation, if data is 0, parity is 0. So if
zero_after_discard is true for all disks, data is consistent after discard.
Otherwise, data might be lost. Let's consider a scenario: discard a stripe,
write data to one disk and write parity disk. The stripe could be still
inconsistent till then depending on using data from other data disks or parity
disks to calculate new parity. If the disk is broken, we can't restore it. So
in this patch, we only enable discard support if all disks have
zero_after_discard.

If discard fails in one disk, we face the similar inconsistent issue above. The
patch will make discard follow the same path as normal write request. If
discard fails, a resync will be scheduled to make the data consistent. This
isn't good to have extra writes, but data consistency is important.

If a subsequent read/write request hits raid5 cache of a discarded stripe, the
discarded dev page should have zero filled, so the data is consistent. This
patch will always zero dev page for discarded request stripe. This isn't
optimal because discard request doesn't need such payload. Next patch will
avoid it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |  133 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid5.h |    1 
 2 files changed, 128 insertions(+), 6 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-04-17 14:15:38.546074804 +0800
+++ linux/drivers/md/raid5.c	2012-04-17 16:02:49.776046739 +0800
@@ -510,6 +510,8 @@ static void ops_run_io(struct stripe_hea
 				rw = WRITE_FUA;
 			else
 				rw = WRITE;
+			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
+				rw |= REQ_DISCARD;
 		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			rw = READ;
 		else if (test_and_clear_bit(R5_WantReplace,
@@ -1114,8 +1116,13 @@ ops_run_biodrain(struct stripe_head *sh,
 				dev->sector + STRIPE_SECTORS) {
 				if (wbi->bi_rw & REQ_FUA)
 					set_bit(R5_WantFUA, &dev->flags);
-				tx = async_copy_data(1, wbi, dev->page,
-					dev->sector, tx);
+				if (wbi->bi_rw & REQ_DISCARD) {
+					memset(page_address(dev->page), 0,
+						STRIPE_SECTORS << 9);
+					set_bit(R5_Discard, &dev->flags);
+				} else
+					tx = async_copy_data(1, wbi, dev->page,
+						dev->sector, tx);
 				wbi = r5_next_bio(wbi, dev->sector);
 			}
 		}
@@ -1177,6 +1184,20 @@ ops_run_reconstruct5(struct stripe_head
 	pr_debug("%s: stripe %llu\n", __func__,
 		(unsigned long long)sh->sector);
 
+	for (i = 0; i < sh->disks; i++) {
+		if (pd_idx == i)
+			continue;
+		if (!test_bit(R5_Discard, &sh->dev[i].flags))
+			break;
+	}
+	if (i >= sh->disks) {
+		atomic_inc(&sh->count);
+		memset(page_address(sh->dev[pd_idx].page), 0,
+			STRIPE_SECTORS << 9);
+		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
+		ops_complete_reconstruct(sh);
+		return;
+	}
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (written)
 	 */
@@ -1221,10 +1242,28 @@ ops_run_reconstruct6(struct stripe_head
 {
 	struct async_submit_ctl submit;
 	struct page **blocks = percpu->scribble;
-	int count;
+	int count, i;
 
 	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
 
+	for (i = 0; i < sh->disks; i++) {
+		if (sh->pd_idx == i || sh->qd_idx == i)
+			continue;
+		if (!test_bit(R5_Discard, &sh->dev[i].flags))
+			break;
+	}
+	if (i >= sh->disks) {
+		atomic_inc(&sh->count);
+		memset(page_address(sh->dev[sh->pd_idx].page), 0,
+			STRIPE_SECTORS << 9);
+		memset(page_address(sh->dev[sh->qd_idx].page), 0,
+			STRIPE_SECTORS << 9);
+		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
+		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
+		ops_complete_reconstruct(sh);
+		return;
+	}
+
 	count = set_syndrome_sources(blocks, sh);
 
 	atomic_inc(&sh->count);
@@ -2278,7 +2317,7 @@ schedule_reconstruction(struct stripe_he
  */
 static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
-	struct bio **bip;
+	struct bio **bip, *orig_bi = bi;
 	struct r5conf *conf = sh->raid_conf;
 	int firstwrite=0;
 
@@ -2288,6 +2327,23 @@ static int add_stripe_bio(struct stripe_
 
 
 	spin_lock_irq(&conf->device_lock);
+
+	if (bi->bi_rw & REQ_DISCARD) {
+		int i;
+		dd_idx = -1;
+		for (i = 0; i < sh->disks; i++) {
+			if (i == sh->pd_idx || i == sh->qd_idx)
+				continue;
+			if (dd_idx == -1)
+				dd_idx = i;
+			if (sh->dev[i].towrite) {
+				dd_idx = i;
+				goto overlap;
+			}
+		}
+	}
+
+again:
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
 		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
@@ -2321,6 +2377,15 @@ static int add_stripe_bio(struct stripe_
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
+
+	bi = orig_bi;
+	if (bi->bi_rw & REQ_DISCARD) {
+		dd_idx++;
+		while (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
+			dd_idx++;
+		if (dd_idx < sh->disks)
+			goto again;
+	}
 	spin_unlock_irq(&conf->device_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
@@ -3950,6 +4015,19 @@ static void make_request(struct mddev *m
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
+	/* block layer doesn't correctly do alignment even we set correct alignment */
+	if (bi->bi_rw & REQ_DISCARD) {
+		int stripe_sectors = conf->chunk_sectors *
+			(conf->raid_disks - conf->max_degraded);
+
+		logical_sector = (logical_sector + stripe_sectors - 1);
+		sector_div(logical_sector, stripe_sectors);
+		sector_div(last_sector, stripe_sectors);
+
+		logical_sector *= stripe_sectors;
+		last_sector *= stripe_sectors;
+	}
+
 	plugged = mddev_check_plugged(mddev);
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
@@ -3973,6 +4051,11 @@ static void make_request(struct mddev *m
 			if (mddev->delta_disks < 0
 			    ? logical_sector < conf->reshape_progress
 			    : logical_sector >= conf->reshape_progress) {
+				/* The stripe will be reshaped soon, ignore it */
+				if (bi->bi_rw & REQ_DISCARD) {
+					spin_unlock_irq(&conf->device_lock);
+					continue;
+				}
 				disks = conf->previous_raid_disks;
 				previous = 1;
 			} else {
@@ -4063,7 +4146,11 @@ static void make_request(struct mddev *m
 			finish_wait(&conf->wait_for_overlap, &w);
 			break;
 		}
-			
+		/* For discard, we always discard one stripe */
+		if ((bi->bi_rw & REQ_DISCARD) &&
+		   !((logical_sector + STRIPE_SECTORS) % conf->chunk_sectors))
+			logical_sector += conf->chunk_sectors *
+				(conf->raid_disks - conf->max_degraded - 1);
 	}
 	if (!plugged)
 		md_wakeup_thread(mddev->thread);
@@ -5162,6 +5249,7 @@ static int run(struct mddev *mddev)
 
 	if (mddev->queue) {
 		int chunk_size;
+		bool discard_supported = true;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
 		 * number of raid devices
@@ -5182,9 +5270,42 @@ static int run(struct mddev *mddev)
 		blk_queue_io_opt(mddev->queue, chunk_size *
 				 (conf->raid_disks - conf->max_degraded));
 
-		rdev_for_each(rdev, mddev)
+		/*
+		 * We can only discard a whole stripe. It doesn't make sense to
+		 * discard data disk but write parity disk
+		 */
+		stripe = stripe * PAGE_SIZE;
+		mddev->queue->limits.discard_alignment = stripe;
+		mddev->queue->limits.discard_granularity = stripe;
+		/*
+		 * unaligned part of discard request will be ignored, so can't
+		 * guarantee discard_zerors_data
+		 */
+		mddev->queue->limits.discard_zeroes_data = 0;
+
+		rdev_for_each(rdev, mddev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
+			/*
+			 * discard_zeroes_data is required, otherwise data
+			 * could be lost. Consider a scenario: discard a stripe
+			 * (the stripe could be inconsistent); write one disk
+			 * of the stripe (the stripe could be inconsistent
+			 * again depending on which disks are used to calculate
+			 * parity); the disk is broken; This stripe data of
+			 * the disk is lost.
+			 */
+			if (!blk_queue_discard(bdev_get_queue(rdev->bdev)) ||
+			   !bdev_get_queue(rdev->bdev)->limits.discard_zeroes_data)
+				discard_supported = false;
+		}
+
+		if (discard_supported &&
+		   mddev->queue->limits.max_discard_sectors >= stripe &&
+		   mddev->queue->limits.discard_granularity >= stripe)
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+		else
+			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 	}
 
 	return 0;
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-04-17 14:15:38.506074977 +0800
+++ linux/drivers/md/raid5.h	2012-04-17 14:16:50.206075090 +0800
@@ -295,6 +295,7 @@ enum r5dev_flags {
 	R5_WantReplace, /* We need to update the replacement, we have read
 			 * data in, and now is a good time to write it out.
 			 */
+	R5_Discard,	/* Discard the stripe */
 };
 
 /*

