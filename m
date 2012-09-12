From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 6/7 v2] MD: raid5 trim support
Date: Wed, 12 Sep 2012 12:09:53 +0800
Message-ID: <20120912040953.GA10047@kernel.org>
References: <20120810025113.050392766@kernel.org>
 <20120810025255.292192477@kernel.org>
 <20120813115051.64d5d44e@notabene.brown>
 <20120813020454.GA447@kernel.org>
 <20120813135831.284d721d@notabene.brown>
 <20120813054347.GA20261@kernel.org>
 <20120911141008.10dd0a50@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120911141008.10dd0a50@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@fusionio.com>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On Tue, Sep 11, 2012 at 02:10:08PM +1000, NeilBrown wrote:
> > +	bi = orig_bi;
> > +	if (bi->bi_rw & REQ_DISCARD) {
> > +		dd_idx++;
> > +		while (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
> > +			dd_idx++;
> > +		if (dd_idx < sh->disks)
> > +			goto again;
> > +	}
> 
> I'm afraid there there is something else here that I can't make my self happy
> with.
> 
> You added a new "goto again" loop inside add_stripe_bio, and to compensate
> the increase logical_sector in make_request so that it doesn't call
> add_stripe_bio so many times.
> This means that to control flow between make_request and add_stripe_bio is
> very different depending on whether it is a discard or not.  That make the
> code harder to understand and easier to break later.
> 
> I think it would to create a completely separate "make_trim_request()" which
> handles the trim/discard case, and leave the current code as it is.
> 
> If/when you do send a patch to do that, please also resend the other raid5
> patch which comes after this one.  I tend not to keep patches once I've
> devices not to apply them immediately.  It also reduces the chance of
> confusion if you just send whatever you want me to apply.

I'm afraid there will be a lot of duplicate code doing this way. How about
below patch? I made it clearer for discard. If you like it, I'll send other
patches.

Thanks,
Shaohua

Subject: MD: raid5 trim support

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
 drivers/md/raid5.c |  219 ++++++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid5.h |    1 
 2 files changed, 176 insertions(+), 44 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-09-11 17:36:30.619148566 +0800
+++ linux/drivers/md/raid5.c	2012-09-12 12:03:18.952735349 +0800
@@ -547,6 +547,8 @@ static void ops_run_io(struct stripe_hea
 				rw = WRITE_FUA;
 			else
 				rw = WRITE;
+			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
+				rw |= REQ_DISCARD;
 		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			rw = READ;
 		else if (test_and_clear_bit(R5_WantReplace,
@@ -1170,8 +1172,13 @@ ops_run_biodrain(struct stripe_head *sh,
 					set_bit(R5_WantFUA, &dev->flags);
 				if (wbi->bi_rw & REQ_SYNC)
 					set_bit(R5_SyncIO, &dev->flags);
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
@@ -1237,6 +1244,20 @@ ops_run_reconstruct5(struct stripe_head
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
@@ -1281,10 +1302,28 @@ ops_run_reconstruct6(struct stripe_head
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
@@ -2351,38 +2390,24 @@ schedule_reconstruction(struct stripe_he
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
+	int dd_idx, int forwrite, int *firstwrite)
 {
 	struct bio **bip;
-	struct r5conf *conf = sh->raid_conf;
-	int firstwrite=0;
-
-	pr_debug("adding bi b#%llu to stripe s#%llu\n",
-		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector);
 
-	/*
-	 * If several bio share a stripe. The bio bi_phys_segments acts as a
-	 * reference count to avoid race. The reference count should already be
-	 * increased before this function is called (for example, in
-	 * make_request()), so other bio sharing this stripe will not free the
-	 * stripe. If a stripe is owned by one stripe, the stripe lock will
-	 * protect it.
-	 */
-	spin_lock_irq(&sh->stripe_lock);
 	if (forwrite) {
 		bip = &sh->dev[dd_idx].towrite;
 		if (*bip == NULL)
-			firstwrite = 1;
+			*firstwrite |= 1;
 	} else
 		bip = &sh->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
-			goto overlap;
+			return 0;
 		bip = & (*bip)->bi_next;
 	}
 	if (*bip && (*bip)->bi_sector < bi->bi_sector + ((bi->bi_size)>>9))
-		goto overlap;
+		return 0;
 
 	BUG_ON(*bip && bi->bi_next && (*bip) != bi->bi_next);
 	if (*bip)
@@ -2403,10 +2428,48 @@ static int add_stripe_bio(struct stripe_
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
+	return 1;
+}
+
+static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+{
+	struct r5conf *conf = sh->raid_conf;
+	int firstwrite=0;
+
+	pr_debug("adding bi b#%llu to stripe s#%llu\n",
+		(unsigned long long)bi->bi_sector,
+		(unsigned long long)sh->sector);
+
+	/*
+	 * If several bio share a stripe. The bio bi_phys_segments acts as a
+	 * reference count to avoid race. The reference count should already be
+	 * increased before this function is called (for example, in
+	 * make_request()), so other bio sharing this stripe will not free the
+	 * stripe. If a stripe is owned by one stripe, the stripe lock will
+	 * protect it.
+	 */
+	spin_lock_irq(&sh->stripe_lock);
+
+	if (!(bi->bi_rw & REQ_DISCARD)) {
+		if (!__add_stripe_bio(sh, bi, dd_idx, forwrite, &firstwrite))
+			goto overlap;
+	} else {
+		/* Discard always handles the whole strip */
+		for (dd_idx = 0; dd_idx < sh->disks; dd_idx++) {
+			if (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
+				continue;
+			if (sh->dev[dd_idx].towrite)
+				goto overlap;
+			if (!__add_stripe_bio(sh, bi, dd_idx, forwrite,
+						&firstwrite))
+				goto overlap;
+		}
+	}
+
 	spin_unlock_irq(&sh->stripe_lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
-		(unsigned long long)(*bip)->bi_sector,
+		(unsigned long long)bi->bi_sector,
 		(unsigned long long)sh->sector, dd_idx);
 
 	if (conf->mddev->bitmap && firstwrite) {
@@ -4067,32 +4130,14 @@ static void release_stripe_plug(struct m
 		release_stripe(sh);
 }
 
-static void make_request(struct mddev *mddev, struct bio * bi)
+static void make_request_range(struct mddev *mddev, struct bio *bi,
+			sector_t logical_sector, sector_t last_sector)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
 	sector_t new_sector;
-	sector_t logical_sector, last_sector;
-	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
-	int remaining;
-
-	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
-		md_flush_request(mddev, bi);
-		return;
-	}
-
-	md_write_start(mddev, bi);
-
-	if (rw == READ &&
-	     mddev->reshape_position == MaxSector &&
-	     chunk_aligned_read(mddev,bi))
-		return;
-
-	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
-	last_sector = bi->bi_sector + (bi->bi_size>>9);
-	bi->bi_next = NULL;
-	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+	struct stripe_head *sh;
 
 	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
@@ -4114,6 +4159,11 @@ static void make_request(struct mddev *m
 			if (mddev->reshape_backwards
 			    ? logical_sector < conf->reshape_progress
 			    : logical_sector >= conf->reshape_progress) {
+				/* The stripe will be reshaped soon, ignore it */
+				if (bi->bi_rw & REQ_DISCARD) {
+					spin_unlock_irq(&conf->device_lock);
+					continue;
+				}
 				previous = 1;
 			} else {
 				if (mddev->reshape_backwards
@@ -4203,6 +4253,51 @@ static void make_request(struct mddev *m
 			break;
 		}
 	}
+}
+
+static void make_request(struct mddev *mddev, struct bio * bi)
+{
+	struct r5conf *conf = mddev->private;
+	sector_t logical_sector, last_sector;
+	const int rw = bio_data_dir(bi);
+	int remaining;
+
+	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bi);
+		return;
+	}
+
+	md_write_start(mddev, bi);
+
+	if (rw == READ &&
+	     mddev->reshape_position == MaxSector &&
+	     chunk_aligned_read(mddev,bi))
+		return;
+
+	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	last_sector = bi->bi_sector + (bi->bi_size>>9);
+
+	bi->bi_next = NULL;
+	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
+
+	if (likely(!(bi->bi_rw & REQ_DISCARD))) {
+		make_request_range(mddev, bi, logical_sector, last_sector);
+	} else {
+		int stripe_sectors = conf->chunk_sectors *
+			(conf->raid_disks - conf->max_degraded);
+		logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
+						       stripe_sectors);
+		sector_div(last_sector, stripe_sectors);
+
+		logical_sector *= stripe_sectors;
+		last_sector *= stripe_sectors;
+
+		while (logical_sector < last_sector) {
+			make_request_range(mddev, bi, logical_sector,
+				logical_sector + conf->chunk_sectors);
+			logical_sector += stripe_sectors;
+		}
+	}
 
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
@@ -5361,6 +5456,7 @@ static int run(struct mddev *mddev)
 
 	if (mddev->queue) {
 		int chunk_size;
+		bool discard_supported = true;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
 		 * number of raid devices
@@ -5380,13 +5476,48 @@ static int run(struct mddev *mddev)
 		blk_queue_io_min(mddev->queue, chunk_size);
 		blk_queue_io_opt(mddev->queue, chunk_size *
 				 (conf->raid_disks - conf->max_degraded));
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
 
 		rdev_for_each(rdev, mddev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->new_data_offset << 9);
+			/*
+			 * discard_zeroes_data is required, otherwise data
+			 * could be lost. Consider a scenario: discard a stripe
+			 * (the stripe could be inconsistent if
+			 * discard_zeroes_data is 0); write one disk of the
+			 * stripe (the stripe could be inconsistent again
+			 * depending on which disks are used to calculate
+			 * parity); the disk is broken; The stripe data of this
+			 * disk is lost.
+			 */
+			if (!blk_queue_discard(bdev_get_queue(rdev->bdev)) ||
+			    !bdev_get_queue(rdev->bdev)->
+						limits.discard_zeroes_data)
+				discard_supported = false;
 		}
+
+		if (discard_supported &&
+		   mddev->queue->limits.max_discard_sectors >= stripe &&
+		   mddev->queue->limits.discard_granularity >= stripe)
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
+						mddev->queue);
+		else
+			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD,
+						mddev->queue);
 	}
 
 	return 0;
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2012-09-11 17:36:30.631148325 +0800
+++ linux/drivers/md/raid5.h	2012-09-12 12:01:10.654354592 +0800
@@ -298,6 +298,7 @@ enum r5dev_flags {
 	R5_WantReplace, /* We need to update the replacement, we have read
 			 * data in, and now is a good time to write it out.
 			 */
+	R5_Discard,	/* Discard the stripe */
 };
 
 /*
