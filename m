From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Thu, 20 Sep 2012 10:27:17 +0800
Message-ID: <20120920022717.GD6798@kernel.org>
References: <20120918082511.GA6298@kernel.org>
 <20120920111517.54d05380@notabene.brown>
 <20120920013642.GA6798@kernel.org>
 <20120920114740.7e2c2d1f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120920114740.7e2c2d1f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 20, 2012 at 11:47:40AM +1000, NeilBrown wrote:
> On Thu, 20 Sep 2012 09:36:42 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Thu, Sep 20, 2012 at 11:15:17AM +1000, NeilBrown wrote:
> > > On Tue, 18 Sep 2012 16:25:11 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > Discard for raid4/5/6 has limitation. If discard request size is small, we do
> > > > discard for one disk, but we need calculate parity and write parity disk.  To
> > > > correctly calculate parity, zero_after_discard must be guaranteed. Even it's
> > > > true, we need do discard for one disk but write another disks, which makes the
> > > > parity disks wear out fast. This doesn't make sense. So an efficient discard
> > > > for raid4/5/6 should discard all data disks and parity disks, which requires
> > > > the write pattern to be (A, A+chunk_size, A+chunk_size*2...). If A's size is
> > > > smaller than chunk_size, such pattern is almost impossible in practice. So in
> > > > this patch, I only handle the case that A's size equals to chunk_size. That is
> > > > discard request should be aligned to stripe size and its size is multiple of
> > > > stripe size.
> > > > 
> > > > Since we can only handle request with specific alignment and size (or part of
> > > > the request fitting stripes), we can't guarantee zero_after_discard even
> > > > zero_after_discard is true in low level drives.
> > > > 
> > > > The block layer doesn't send down correctly aligned requests even correct
> > > > discard alignment is set, so I must filter out.
> > > > 
> > > > For raid4/5/6 parity calculation, if data is 0, parity is 0. So if
> > > > zero_after_discard is true for all disks, data is consistent after discard.
> > > > Otherwise, data might be lost. Let's consider a scenario: discard a stripe,
> > > > write data to one disk and write parity disk. The stripe could be still
> > > > inconsistent till then depending on using data from other data disks or parity
> > > > disks to calculate new parity. If the disk is broken, we can't restore it. So
> > > > in this patch, we only enable discard support if all disks have
> > > > zero_after_discard.
> > > > 
> > > > If discard fails in one disk, we face the similar inconsistent issue above. The
> > > > patch will make discard follow the same path as normal write request. If
> > > > discard fails, a resync will be scheduled to make the data consistent. This
> > > > isn't good to have extra writes, but data consistency is important.
> > > > 
> > > > If a subsequent read/write request hits raid5 cache of a discarded stripe, the
> > > > discarded dev page should have zero filled, so the data is consistent. This
> > > > patch will always zero dev page for discarded request stripe. This isn't
> > > > optimal because discard request doesn't need such payload. Next patch will
> > > > avoid it.
> > > > 
> > > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > > ---
> > > >  drivers/md/raid5.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > > >  drivers/md/raid5.h |    1 
> > > >  2 files changed, 174 insertions(+), 3 deletions(-)
> > > > 
> > > > Index: linux/drivers/md/raid5.c
> > > > ===================================================================
> > > > --- linux.orig/drivers/md/raid5.c	2012-09-18 16:15:51.219353357 +0800
> > > > +++ linux/drivers/md/raid5.c	2012-09-18 16:15:55.471299904 +0800
> > > > @@ -547,6 +547,8 @@ static void ops_run_io(struct stripe_hea
> > > >  				rw = WRITE_FUA;
> > > >  			else
> > > >  				rw = WRITE;
> > > > +			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
> > > > +				rw |= REQ_DISCARD;
> > > >  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
> > > >  			rw = READ;
> > > >  		else if (test_and_clear_bit(R5_WantReplace,
> > > > @@ -1170,8 +1172,13 @@ ops_run_biodrain(struct stripe_head *sh,
> > > >  					set_bit(R5_WantFUA, &dev->flags);
> > > >  				if (wbi->bi_rw & REQ_SYNC)
> > > >  					set_bit(R5_SyncIO, &dev->flags);
> > > > -				tx = async_copy_data(1, wbi, dev->page,
> > > > -					dev->sector, tx);
> > > > +				if (wbi->bi_rw & REQ_DISCARD) {
> > > > +					memset(page_address(dev->page), 0,
> > > > +						STRIPE_SECTORS << 9);
> > > > +					set_bit(R5_Discard, &dev->flags);
> > > > +				} else
> > > > +					tx = async_copy_data(1, wbi, dev->page,
> > > > +						dev->sector, tx);
> > > >  				wbi = r5_next_bio(wbi, dev->sector);
> > > >  			}
> > > >  		}
> > > > @@ -1237,6 +1244,20 @@ ops_run_reconstruct5(struct stripe_head
> > > >  	pr_debug("%s: stripe %llu\n", __func__,
> > > >  		(unsigned long long)sh->sector);
> > > >  
> > > > +	for (i = 0; i < sh->disks; i++) {
> > > > +		if (pd_idx == i)
> > > > +			continue;
> > > > +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> > > > +			break;
> > > > +	}
> > > > +	if (i >= sh->disks) {
> > > > +		atomic_inc(&sh->count);
> > > > +		memset(page_address(sh->dev[pd_idx].page), 0,
> > > > +			STRIPE_SECTORS << 9);
> > > > +		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
> > > > +		ops_complete_reconstruct(sh);
> > > > +		return;
> > > > +	}
> > > >  	/* check if prexor is active which means only process blocks
> > > >  	 * that are part of a read-modify-write (written)
> > > >  	 */
> > > > @@ -1281,10 +1302,28 @@ ops_run_reconstruct6(struct stripe_head
> > > >  {
> > > >  	struct async_submit_ctl submit;
> > > >  	struct page **blocks = percpu->scribble;
> > > > -	int count;
> > > > +	int count, i;
> > > >  
> > > >  	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
> > > >  
> > > > +	for (i = 0; i < sh->disks; i++) {
> > > > +		if (sh->pd_idx == i || sh->qd_idx == i)
> > > > +			continue;
> > > > +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> > > > +			break;
> > > > +	}
> > > > +	if (i >= sh->disks) {
> > > > +		atomic_inc(&sh->count);
> > > > +		memset(page_address(sh->dev[sh->pd_idx].page), 0,
> > > > +			STRIPE_SECTORS << 9);
> > > > +		memset(page_address(sh->dev[sh->qd_idx].page), 0,
> > > > +			STRIPE_SECTORS << 9);
> > > > +		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
> > > > +		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
> > > > +		ops_complete_reconstruct(sh);
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	count = set_syndrome_sources(blocks, sh);
> > > >  
> > > >  	atomic_inc(&sh->count);
> > > > @@ -4067,6 +4106,96 @@ static void release_stripe_plug(struct m
> > > >  		release_stripe(sh);
> > > >  }
> > > >  
> > > > +static void make_discard_request(struct mddev *mddev, struct bio *bi)
> > > > +{
> > > > +	struct r5conf *conf = mddev->private;
> > > > +	sector_t logical_sector, last_sector;
> > > > +	struct stripe_head *sh;
> > > > +	int remaining;
> > > > +	int stripe_sectors;
> > > > +
> > > > +	if (mddev->reshape_position != MaxSector)
> > > > +		/* Skip discard while reshape is happening */
> > > > +		return;
> > > > +
> > > > +	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
> > > > +	last_sector = bi->bi_sector + (bi->bi_size>>9);
> > > > +
> > > > +	bi->bi_next = NULL;
> > > > +	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
> > > > +
> > > > +	stripe_sectors = conf->chunk_sectors *
> > > > +		(conf->raid_disks - conf->max_degraded);
> > > > +	logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
> > > > +			stripe_sectors);
> > > > +	sector_div(last_sector, stripe_sectors);
> > > > +
> > > > +	logical_sector *= stripe_sectors;
> > > > +	last_sector *= stripe_sectors;
> > > > +
> > > > +	for (;logical_sector < last_sector;
> > > > +					logical_sector += STRIPE_SECTORS) {
> > > > +		DEFINE_WAIT(w);
> > > > +		sector_t new_sector;
> > > > +		int d;
> > > > +
> > > > +		new_sector = raid5_compute_sector(conf, logical_sector,
> > > > +						  0, &d, NULL);
> > > 
> > > This is pointless.  Look at the patch I posted again.  You don't need to call
> > > raid5_compute_sector().  It essentially just divides logical_sector by
> > > stripe_sectors.  It is cleaner not to do the multiple in the first place.
> > 
> > in my test, without it, wrong sectors are trimmed.
> 
> Which tells me that the code you tested was wrong.
> However the code you posted was wrong too.
> 
> Maybe if you post the code you tested and which looked more like mine, and
> explain which wrong sectors were trimmed....

Ok, just confirmed, delete raid5_compute_sector is ok if I adjust
logical_sector calculation. Here is the new patch.


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
 drivers/md/raid5.c |  168 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.h |    1 
 2 files changed, 166 insertions(+), 3 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2012-09-18 16:15:51.219353357 +0800
+++ linux/drivers/md/raid5.c	2012-09-20 10:22:35.551887189 +0800
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
@@ -4067,6 +4106,88 @@ static void release_stripe_plug(struct m
 		release_stripe(sh);
 }
 
+static void make_discard_request(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+	sector_t logical_sector, last_sector;
+	struct stripe_head *sh;
+	int remaining;
+	int stripe_sectors;
+
+	if (mddev->reshape_position != MaxSector)
+		/* Skip discard while reshape is happening */
+		return;
+
+	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	last_sector = bi->bi_sector + (bi->bi_size>>9);
+
+	bi->bi_next = NULL;
+	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
+
+	stripe_sectors = conf->chunk_sectors *
+		(conf->raid_disks - conf->max_degraded);
+	logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
+			stripe_sectors);
+	sector_div(last_sector, stripe_sectors);
+
+	logical_sector *= conf->chunk_sectors;
+	last_sector *= conf->chunk_sectors;
+
+	for (;logical_sector < last_sector;
+					logical_sector += STRIPE_SECTORS) {
+		DEFINE_WAIT(w);
+		int d;
+
+again:
+		sh = get_active_stripe(conf, logical_sector, 0, 0, 0);
+		prepare_to_wait(&conf->wait_for_overlap, &w,
+						TASK_UNINTERRUPTIBLE);
+		spin_lock_irq(&sh->stripe_lock);
+		for (d = 0; d < conf->raid_disks; d++) {
+			if (d == sh->pd_idx || d == sh->qd_idx)
+				continue;
+			if (sh->dev[d].towrite || sh->dev[d].toread) {
+				set_bit(R5_Overlap, &sh->dev[d].flags);
+				spin_unlock_irq(&sh->stripe_lock);
+				release_stripe(sh);
+				schedule();
+				goto again;
+			}
+		}
+		finish_wait(&conf->wait_for_overlap, &w);
+		for (d = 0; d < conf->raid_disks; d++) {
+			if (d == sh->pd_idx || d == sh->qd_idx)
+				continue;
+			sh->dev[d].towrite = bi;
+			set_bit(R5_OVERWRITE, &sh->dev[d].flags);
+			raid5_inc_bi_active_stripes(bi);
+		}
+		spin_unlock_irq(&sh->stripe_lock);
+		if (conf->mddev->bitmap) {
+			for (d = 0; d < conf->raid_disks - conf->max_degraded;
+									d++)
+				bitmap_startwrite(mddev->bitmap,
+						sh->sector,
+						STRIPE_SECTORS,
+						0);
+			sh->bm_seq = conf->seq_flush + 1;
+			set_bit(STRIPE_BIT_DELAY, &sh->state);
+		}
+
+		set_bit(STRIPE_HANDLE, &sh->state);
+		clear_bit(STRIPE_DELAYED, &sh->state);
+		if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+			atomic_inc(&conf->preread_active_stripes);
+		release_stripe_plug(mddev, sh);
+	}
+
+	remaining = raid5_dec_bi_active_stripes(bi);
+	if (remaining == 0) {
+		md_write_end(mddev);
+		bio_endio(bi, 0);
+	}
+}
+
 static void make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf = mddev->private;
@@ -4089,6 +4210,11 @@ static void make_request(struct mddev *m
 	     chunk_aligned_read(mddev,bi))
 		return;
 
+	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
+		make_discard_request(mddev, bi);
+		return;
+	}
+
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	last_sector = bi->bi_sector + (bi->bi_size>>9);
 	bi->bi_next = NULL;
@@ -5361,6 +5487,7 @@ static int run(struct mddev *mddev)
 
 	if (mddev->queue) {
 		int chunk_size;
+		bool discard_supported = true;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
 		 * number of raid devices
@@ -5380,13 +5507,48 @@ static int run(struct mddev *mddev)
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
--- linux.orig/drivers/md/raid5.h	2012-09-18 16:15:51.235353157 +0800
+++ linux/drivers/md/raid5.h	2012-09-20 10:21:24.072786455 +0800
@@ -298,6 +298,7 @@ enum r5dev_flags {
 	R5_WantReplace, /* We need to update the replacement, we have read
 			 * data in, and now is a good time to write it out.
 			 */
+	R5_Discard,	/* Discard the stripe */
 };
 
 /*
