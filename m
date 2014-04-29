From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Tue, 29 Apr 2014 19:13:58 +0800
Message-ID: <20140429111358.GA10584@kernel.org>
References: <20140428065841.GA28726@kernel.org>
 <20140428101748.GA17026@infradead.org>
 <20140428204407.226c88e4@notabene.brown>
 <20140429020124.GA24123@kernel.org>
 <20140429170725.0b4687a8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140429170725.0b4687a8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 29, 2014 at 05:07:25PM +1000, NeilBrown wrote:
> On Tue, 29 Apr 2014 10:01:24 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Mon, Apr 28, 2014 at 08:44:07PM +1000, NeilBrown wrote:
> > > On Mon, 28 Apr 2014 03:17:48 -0700 Christoph Hellwig <hch@infradead.org>
> > > wrote:
> > > 
> > > > On Mon, Apr 28, 2014 at 02:58:41PM +0800, Shaohua Li wrote:
> > > > > 
> > > > > The stripe cache has two goals:
> > > > > 1. cache data, so next time if data can be found in stripe cache, disk access
> > > > > can be avoided.
> > > > 
> > > > I think this is mostly a side effect.  We have a much larger and better
> > > > tuned page cache to take care of this.
> > > > 
> > > > > 2. stable data. data is copied from bio to stripe cache and calculated parity.
> > > > > data written to disk is from stripe cache, so if upper layer changes bio data,
> > > > > data written to disk isn't impacted.
> > > > > 
> > > > > In my environment, I can guarantee 2 will not happen.
> > > > 
> > > > Why just in your environment?  Now that we got stable pages in the page
> > > > cache this should always be the case.
> > > 
> > > Hmm... I hadn't realised that we were guaranteed stabled pages always (if
> > > requested).  It seems that we are.
> > > 
> > > > 
> > > > > Of course, this shouldn't be enabled by default, so I added an option to
> > > > > control it.
> > > > 
> > > > Unless careful benchmarking in various scenarious shows adverse effects
> > > > this should be the default.  And if we can find adverse effects we need
> > > > to look into them.
> > > 
> > > Certainly some benchmarking is needed.
> > > 
> > > We should set
> > > 
> > >  mddev->queue->backing_dev_info.capabilities |= BDI_CAP_STABLE_WRITES
> > > 
> > > if and only iff 'skip_copy' is set. Then test various cases just to confirm
> > > that it is generally an improvement.
> > 
> > IIRC, we switched from 'force wait page writeback' to 'wait page writeback if
> > required' because of performance issues reported, so we shoudn't always enable
> > BDI_CAP_STABLE_WRITES. Is it safe to set/clear BDI_CAP_STABLE_WRITES at
> > runtime, if we use 'skip_copy' to control it? Ofcourse, we don't need runtime
> > changing the setting, but we need a mechanism to setup it before array runs.
> 
> So for md/RAID5 the trade off is:
>  - If we set BDI_CAP_STABLE_WRITES then processes might sometimes have to wait
>    for the writeout to complete where otherwise they would not
>  - If we don't then RAID5 *always* has to copy the page into the stripe cache.
> 
> It isn't at all clear to me which is best.  It is very possible that copying
> costs a lot.  But then waiting for read-modify-write cycles can be a real
> cost too....
> 
> I think it is perfectly safe to change BDI_CAP_STABLE_WRITES while the array
> is suspended. So
>   mddev_suspend(mddev);
>   change BDI_CAP_STABLE_WRITES
>   mddev_resume(mddev);
> 
> should be safe.

sounds good.
 
> > 
> > As of performance, the 'skip_copy' is very helpful (> 30% boost) for my raid5
> > array (with 6 fast PCIe SSD) for 1M request size workload. Nothing changed for
> > 4k randwrite workload.
> 
> It would be really good to see comparison for sequential and random loads on
> various filesytems with both rotating and SSD devices, in RAID5 and RAID6,
> with various numbers of devices.
> :-)
> 
> If you'd like to update your patch to adjust BDI_CAP_STABLE_WRITES when
> skip_copy is changed, I'll apply it so that people can test it.

Here it is.


Subject: raid5: add an option to avoid copy data from bio to stripe cache

The stripe cache has two goals:
1. cache data, so next time if data can be found in stripe cache, disk access
can be avoided.
2. stable data. data is copied from bio to stripe cache and calculated parity.
data written to disk is from stripe cache, so if upper layer changes bio data,
data written to disk isn't impacted.

In my environment, I can guarantee 2 will not happen. And BDI_CAP_STABLE_WRITES
can guarantee 2 too. For 1, it's not common too. block plug mechanism will
dispatch a bunch of sequentail small requests together. And since I'm using
SSD, I'm using small chunk size. It's rare case stripe cache is really useful.

So I'd like to avoid the copy from bio to stripe cache and it's very helpful
for performance. In my 1M randwrite tests, avoid the copy can increase the
performance more than 30%.

Of course, this shouldn't be enabled by default. It's reported enabling
BDI_CAP_STABLE_WRITES can harm some workloads before, so I added an option to
control it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid5.h |    4 +-
 2 files changed, 94 insertions(+), 14 deletions(-)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2014-04-28 14:02:18.025349590 +0800
+++ linux/drivers/md/raid5.c	2014-04-29 15:59:59.052311648 +0800
@@ -479,6 +479,7 @@ static void shrink_buffers(struct stripe
 	int num = sh->raid_conf->pool_size;
 
 	for (i = 0; i < num ; i++) {
+		BUG_ON(sh->dev[i].page != sh->dev[i].orig_page);
 		p = sh->dev[i].page;
 		if (!p)
 			continue;
@@ -499,6 +500,7 @@ static int grow_buffers(struct stripe_he
 			return 1;
 		}
 		sh->dev[i].page = page;
+		sh->dev[i].orig_page = page;
 	}
 	return 0;
 }
@@ -855,6 +857,9 @@ static void ops_run_io(struct stripe_hea
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 				bi->bi_rw |= REQ_NOMERGE;
 
+			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
+				BUG_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
+			sh->dev[i].vec.bv_page = sh->dev[i].page;
 			bi->bi_vcnt = 1;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
@@ -899,6 +904,9 @@ static void ops_run_io(struct stripe_hea
 			else
 				rbi->bi_iter.bi_sector = (sh->sector
 						  + rrdev->data_offset);
+			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
+				BUG_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
+			sh->dev[i].rvec.bv_page = sh->dev[i].page;
 			rbi->bi_vcnt = 1;
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
@@ -927,8 +935,9 @@ static void ops_run_io(struct stripe_hea
 }
 
 static struct dma_async_tx_descriptor *
-async_copy_data(int frombio, struct bio *bio, struct page *page,
-	sector_t sector, struct dma_async_tx_descriptor *tx)
+async_copy_data(int frombio, struct bio *bio, struct page **page,
+	sector_t sector, struct dma_async_tx_descriptor *tx,
+	struct stripe_head *sh)
 {
 	struct bio_vec bvl;
 	struct bvec_iter iter;
@@ -965,11 +974,16 @@ async_copy_data(int frombio, struct bio
 		if (clen > 0) {
 			b_offset += bvl.bv_offset;
 			bio_page = bvl.bv_page;
-			if (frombio)
-				tx = async_memcpy(page, bio_page, page_offset,
+			if (frombio) {
+				if (sh->raid_conf->skip_copy &&
+				    b_offset == 0 && page_offset == 0 &&
+				    clen == STRIPE_SIZE)
+					*page = bio_page;
+				else
+					tx = async_memcpy(*page, bio_page, page_offset,
 						  b_offset, clen, &submit);
-			else
-				tx = async_memcpy(bio_page, page, b_offset,
+			} else
+				tx = async_memcpy(bio_page, *page, b_offset,
 						  page_offset, clen, &submit);
 		}
 		/* chain the operations */
@@ -1045,8 +1059,8 @@ static void ops_run_biofill(struct strip
 			spin_unlock_irq(&sh->stripe_lock);
 			while (rbi && rbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
-				tx = async_copy_data(0, rbi, dev->page,
-					dev->sector, tx);
+				tx = async_copy_data(0, rbi, &dev->page,
+					dev->sector, tx, sh);
 				rbi = r5_next_bio(rbi, dev->sector);
 			}
 		}
@@ -1384,6 +1398,7 @@ ops_run_biodrain(struct stripe_head *sh,
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
 			spin_unlock_irq(&sh->stripe_lock);
+			BUG_ON(dev->page != dev->orig_page);
 
 			while (wbi && wbi->bi_iter.bi_sector <
 				dev->sector + STRIPE_SECTORS) {
@@ -1393,9 +1408,15 @@ ops_run_biodrain(struct stripe_head *sh,
 					set_bit(R5_SyncIO, &dev->flags);
 				if (wbi->bi_rw & REQ_DISCARD)
 					set_bit(R5_Discard, &dev->flags);
-				else
-					tx = async_copy_data(1, wbi, dev->page,
-						dev->sector, tx);
+				else {
+					tx = async_copy_data(1, wbi, &dev->page,
+						dev->sector, tx, sh);
+					if (dev->page != dev->orig_page) {
+						set_bit(R5_SkipCopy, &dev->flags);
+						clear_bit(R5_UPTODATE, &dev->flags);
+						clear_bit(R5_OVERWRITE, &dev->flags);
+					}
+				}
 				wbi = r5_next_bio(wbi, dev->sector);
 			}
 		}
@@ -1426,7 +1447,7 @@ static void ops_complete_reconstruct(voi
 		struct r5dev *dev = &sh->dev[i];
 
 		if (dev->written || i == pd_idx || i == qd_idx) {
-			if (!discard)
+			if (!discard && !test_bit(R5_SkipCopy, &dev->flags))
 				set_bit(R5_UPTODATE, &dev->flags);
 			if (fua)
 				set_bit(R5_WantFUA, &dev->flags);
@@ -2750,6 +2771,11 @@ handle_failed_stripe(struct r5conf *conf
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
+		if (test_and_clear_bit(R5_SkipCopy, &sh->dev[i].flags)) {
+			BUG_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
+			sh->dev[i].page = sh->dev[i].orig_page;
+		}
+
 		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_iter.bi_sector <
 		       sh->dev[i].sector + STRIPE_SECTORS) {
@@ -2991,12 +3017,17 @@ static void handle_stripe_clean_event(st
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) &&
 			    (test_bit(R5_UPTODATE, &dev->flags) ||
-			     test_bit(R5_Discard, &dev->flags))) {
+			     test_bit(R5_Discard, &dev->flags) ||
+			     test_bit(R5_SkipCopy, &dev->flags))) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
 				pr_debug("Return write for disc %d\n", i);
 				if (test_and_clear_bit(R5_Discard, &dev->flags))
 					clear_bit(R5_UPTODATE, &dev->flags);
+				if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
+					BUG_ON(test_bit(R5_UPTODATE, &dev->flags));
+					dev->page = dev->orig_page;
+				}
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_iter.bi_sector <
@@ -3015,6 +3046,8 @@ static void handle_stripe_clean_event(st
 						0);
 			} else if (test_bit(R5_Discard, &dev->flags))
 				discard_pending = 1;
+			BUG_ON(test_bit(R5_SkipCopy, &dev->flags));
+			BUG_ON(dev->page != dev->orig_page);
 		}
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
@@ -5355,6 +5388,50 @@ raid5_preread_bypass_threshold = __ATTR(
 					raid5_store_preread_threshold);
 
 static ssize_t
+raid5_show_skip_copy(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf)
+		return sprintf(page, "%d\n", conf->skip_copy);
+	else
+		return 0;
+}
+
+static ssize_t
+raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new;
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+	new = !!new;
+	if (new == conf->skip_copy)
+		return len;
+
+	mddev_suspend(mddev);
+	conf->skip_copy = new;
+	if (new)
+		mddev->queue->backing_dev_info.capabilities |=
+						BDI_CAP_STABLE_WRITES;
+	else
+		mddev->queue->backing_dev_info.capabilities &=
+						~BDI_CAP_STABLE_WRITES;
+	mddev_resume(mddev);
+	return len;
+}
+
+static struct md_sysfs_entry
+raid5_skip_copy = __ATTR(skip_copy, S_IRUGO | S_IWUSR,
+					raid5_show_skip_copy,
+					raid5_store_skip_copy);
+
+
+static ssize_t
 stripe_cache_active_show(struct mddev *mddev, char *page)
 {
 	struct r5conf *conf = mddev->private;
@@ -5439,6 +5516,7 @@ static struct attribute *raid5_attrs[] =
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
 	&raid5_group_thread_cnt.attr,
+	&raid5_skip_copy.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
Index: linux/drivers/md/raid5.h
===================================================================
--- linux.orig/drivers/md/raid5.h	2014-04-28 14:02:18.025349590 +0800
+++ linux/drivers/md/raid5.h	2014-04-28 14:02:18.009349792 +0800
@@ -232,7 +232,7 @@ struct stripe_head {
 		 */
 		struct bio	req, rreq;
 		struct bio_vec	vec, rvec;
-		struct page	*page;
+		struct page	*page, *orig_page;
 		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
@@ -299,6 +299,7 @@ enum r5dev_flags {
 			 * data in, and now is a good time to write it out.
 			 */
 	R5_Discard,	/* Discard the stripe */
+	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
 };
 
 /*
@@ -436,6 +437,7 @@ struct r5conf {
 	atomic_t		pending_full_writes; /* full write backlog */
 	int			bypass_count; /* bypassed prereads */
 	int			bypass_threshold; /* preread nice */
+	int			skip_copy; /* Don't copy data from bio to stripe cache */
 	struct list_head	*last_hold; /* detect hold_list promotions */
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
