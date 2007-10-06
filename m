From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH -mm 1/4] raid5: add the stripe_queue object for tracking raid
	io requests (rev3)
Date: Sat, 06 Oct 2007 10:06:44 -0700
Message-ID: <20071006170644.23741.35604.stgit@dwillia2-linux.ch.intel.com>
References: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071006170538.23741.75193.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The raid5 stripe cache object, struct stripe_head, serves two purposes:
	1/ front-end: queuing incoming requests
	2/ back-end: transitioning requests through the cache state machine
	   to the backing devices
The problem with this model is that queuing decisions are directly tied to
cache availability.  There is no facility to determine that a request or
group of requests 'deserves' usage of the cache and disks at any given time.

This patch separates the object members needed for queuing from the object
members used for caching.  The stripe_queue object takes over the incoming
bio lists, the io completion bio lists, and the parameters needed for
expansion.

The following fields are moved from struct stripe_head to struct
stripe_queue:
	raid5_private_data *raid_conf
	int pd_idx
	spinlock_t lock
	int disks

The following fields are moved from struct r5dev to struct r5_queue_dev:
	sector_t sector
	struct bio *toread, *read, *towrite, *written

This (first) commit just moves fields around subsequent commits take
advantage of the split for performance gains.

--- Performance Data ---
Platform: SMP x4 IA, sata_vsc, 7200RPM SATA Drives x4
Test1: tiobench --size 2048 --numruns 5 --block 4096 --block 131072 --dir /mnt/raid
=====pre-patch=====
Sequential Writes:
File   Blk      Num     Avg
Size   Size     Thread  Rate (MiB/s)
----   -----    ---     ------
2048   131072   1        72.02
2048   131072   8        41.51

=====post-patch=====
Sequential Writes:
File   Blk      Num     Avg
Size   Size     Thr     Rate (MiB/s)
----   -----    ---     ------
2048   131072   1       140.86 (+96%)
2048   131072   8        50.18 (+21%)

Test2: blktrace of: dd if=/dev/zero of=/dev/md0 bs=1024k count=1024
=====pre-patch=====
Total (sdd):
 Reads Queued:       1,383,    5,532KiB  Writes Queued:      80,186, 320,744KiB
 Reads Completed:      276,    4,888KiB  Writes Completed:   12,677, 294,324KiB
 IO unplugs:             0               Timer unplugs:           0

=====post-patch=====
Total (sdd):
 Reads Queued:          61,      244KiB  Writes Queued:      66,330, 265,320KiB
 Reads Completed:        4,      112KiB  Writes Completed:    3,562, 285,912KiB
 IO unplugs:            16               Timer unplugs:          17

Platform: SMP x4 IA, mptsas, 15000RPM SAS Drives x4
Test: tiobench --size 2048 --numruns 5 --block 4096 --block 131072 --dir /mnt/raid
=====pre-patch=====
Sequential Writes:
File   Blk      Num     Avg
Size   Size     Thr     Rate (MiB/s)
----   -----    ---     ------
2048   131072   1       132.51
2048   131072   8        86.92

=====post-patch=====
Sequential Writes:
File   Blk      Num     Avg
Size   Size     Thr     Rate (MiB/s)
----   -----    ---     ------
2048   131072   1       172.26 (+30%)
2048   131072   8       114.82 (+32%)

Changes in rev2:
* leave the flags with the buffers, prevents a data corruption issue
  whereby stale buffer state flags are attached to newly initialized
  buffers

Changes in rev3:
* move bm_seq back into the stripe_head, since the bitmap sequencing
  matters at write-out time (after cache attach)  Thanks to Mr. James W.
  Laferriere for his bug reports and testing of bitmap support.
* move 'int disks' into stripe_queue since expansion details are recorded
  at make_request() time (i.e. pre stripe_head availability)
* move dev->read, dev->written to dev_q->read and dev_q->written.  Allow
  sq->sh back references to be killed, and removes need to handle sh
  details in add_queue_bio

Tested-by: Mr. James W. Laferriere <babydr@baby-dragons.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |  564 +++++++++++++++++++++++++++-----------------
 include/linux/raid/raid5.h |   28 +-
 2 files changed, 364 insertions(+), 228 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f96dea9..a13de7d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -159,7 +159,7 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 }
 static void release_stripe(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
@@ -238,7 +238,7 @@ static void raid5_build_block (struct stripe_head *sh, int i);
 
 static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int i;
 
 	BUG_ON(atomic_read(&sh->count) != 0);
@@ -252,19 +252,20 @@ static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int
 	remove_hash(sh);
 
 	sh->sector = sector;
-	sh->pd_idx = pd_idx;
+	sh->sq->pd_idx = pd_idx;
 	sh->state = 0;
 
-	sh->disks = disks;
+	sh->sq->disks = disks;
 
-	for (i = sh->disks; i--; ) {
+	for (i = disks; i--;) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
-		if (dev->toread || dev->read || dev->towrite || dev->written ||
-		    test_bit(R5_LOCKED, &dev->flags)) {
+		if (dev_q->toread || dev_q->read || dev_q->towrite ||
+		    dev_q->written || test_bit(R5_LOCKED, &dev->flags)) {
 			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
-			       (unsigned long long)sh->sector, i, dev->toread,
-			       dev->read, dev->towrite, dev->written,
+			       (unsigned long long)sh->sector, i, dev_q->toread,
+			       dev_q->read, dev_q->towrite, dev_q->written,
 			       test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
@@ -282,12 +283,15 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, in
 	CHECK_DEVLOCK();
 	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
 	hlist_for_each_entry(sh, hn, stripe_hash(conf, sector), hash)
-		if (sh->sector == sector && sh->disks == disks)
+		if (sh->sector == sector && sh->sq->disks == disks)
 			return sh;
 	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
 	return NULL;
 }
 
+static sector_t compute_blocknr(raid5_conf_t *conf, int raid_disks,
+	sector_t sector, int pd_idx, int i);
+
 static void unplug_slaves(mddev_t *mddev);
 static void raid5_unplug_device(struct request_queue *q);
 
@@ -389,12 +393,13 @@ raid5_end_write_request (struct bio *bi, unsigned int bytes_done, int error);
 
 static void ops_run_io(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
-	int i, disks = sh->disks;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
+	int i, disks = sq->disks;
 
 	might_sleep();
 
-	for (i = disks; i--; ) {
+	for (i = disks; i--;) {
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
@@ -513,15 +518,17 @@ static void ops_complete_biofill(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 	struct bio *return_bi = NULL;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
 	/* clear completed biofills */
-	for (i = sh->disks; i--; ) {
+	for (i = sq->disks; i--;) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 
 		/* acknowledge completion of a biofill operation */
 		/* and check if we need to reply to a read request,
@@ -531,16 +538,16 @@ static void ops_complete_biofill(void *stripe_head_ref)
 		if (test_and_clear_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi, *rbi2;
 
-			/* The access to dev->read is outside of the
+			/* The access to dev_q->read is outside of the
 			 * spin_lock_irq(&conf->device_lock), but is protected
 			 * by the STRIPE_OP_BIOFILL pending bit
 			 */
-			BUG_ON(!dev->read);
-			rbi = dev->read;
-			dev->read = NULL;
+			BUG_ON(!dev_q->read);
+			rbi = dev_q->read;
+			dev_q->read = NULL;
 			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
-				rbi2 = r5_next_bio(rbi, dev->sector);
+				dev_q->sector + STRIPE_SECTORS) {
+				rbi2 = r5_next_bio(rbi, dev_q->sector);
 				spin_lock_irq(&conf->device_lock);
 				if (--rbi->bi_phys_segments == 0) {
 					rbi->bi_next = return_bi;
@@ -563,25 +570,27 @@ static void ops_complete_biofill(void *stripe_head_ref)
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
-	for (i = sh->disks; i--; ) {
+	for (i = sh->sq->disks; i--;) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
+
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
 			spin_lock_irq(&conf->device_lock);
-			dev->read = rbi = dev->toread;
-			dev->toread = NULL;
+			dev_q->read = rbi = dev_q->toread;
+			dev_q->toread = NULL;
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
+				dev_q->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
-					dev->sector, tx);
-				rbi = r5_next_bio(rbi, dev->sector);
+					dev_q->sector, tx);
+				rbi = r5_next_bio(rbi, dev_q->sector);
 			}
 		}
 	}
@@ -612,7 +621,7 @@ static struct dma_async_tx_descriptor *
 ops_run_compute5(struct stripe_head *sh, unsigned long pending)
 {
 	/* kernel stack size limits the total number of disks */
-	int disks = sh->disks;
+	int disks = sh->sq->disks;
 	struct page *xor_srcs[disks];
 	int target = sh->ops.target;
 	struct r5dev *tgt = &sh->dev[target];
@@ -660,9 +669,10 @@ static struct dma_async_tx_descriptor *
 ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	/* kernel stack size limits the total number of disks */
-	int disks = sh->disks;
+	int disks = sh->sq->disks;
 	struct page *xor_srcs[disks];
-	int count = 0, pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int count = 0, pd_idx = sq->pd_idx, i;
 
 	/* existing parity data subtracted */
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
@@ -672,8 +682,9 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (dev->towrite && test_bit(R5_Wantprexor, &dev->flags))
+		if (dev_q->towrite && test_bit(R5_Wantprexor, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -687,8 +698,9 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
-	int disks = sh->disks;
-	int pd_idx = sh->pd_idx, i;
+	int disks = sh->sq->disks;
+	struct stripe_queue *sq = sh->sq;
+	int pd_idx = sq->pd_idx, i;
 
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
@@ -700,16 +712,17 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		struct bio *chosen;
 		int towrite;
 
 		towrite = 0;
 		if (prexor) { /* rmw */
-			if (dev->towrite &&
+			if (dev_q->towrite &&
 			    test_bit(R5_Wantprexor, &dev->flags))
 				towrite = 1;
 		} else { /* rcw */
-			if (i != pd_idx && dev->towrite &&
+			if (i != pd_idx && dev_q->towrite &&
 				test_bit(R5_LOCKED, &dev->flags))
 				towrite = 1;
 		}
@@ -717,18 +730,18 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 		if (towrite) {
 			struct bio *wbi;
 
-			spin_lock(&sh->lock);
-			chosen = dev->towrite;
-			dev->towrite = NULL;
-			BUG_ON(dev->written);
-			wbi = dev->written = chosen;
-			spin_unlock(&sh->lock);
+			spin_lock(&sq->lock);
+			chosen = dev_q->towrite;
+			dev_q->towrite = NULL;
+			BUG_ON(dev_q->written);
+			wbi = dev_q->written = chosen;
+			spin_unlock(&sq->lock);
 
 			while (wbi && wbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
+				dev_q->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(1, wbi, dev->page,
-					dev->sector, tx);
-				wbi = r5_next_bio(wbi, dev->sector);
+					dev_q->sector, tx);
+				wbi = r5_next_bio(wbi, dev_q->sector);
 			}
 		}
 	}
@@ -751,14 +764,17 @@ static void ops_complete_postxor(void *stripe_head_ref)
 static void ops_complete_write(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int disks = sh->disks, i, pd_idx = sh->pd_idx;
+	struct stripe_queue *sq = sh->sq;
+	int disks = sq->disks, i, pd_idx = sq->pd_idx;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		if (dev->written || i == pd_idx)
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
+		if (dev_q->written || i == pd_idx)
 			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
@@ -773,10 +789,11 @@ static void
 ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	/* kernel stack size limits the total number of disks */
-	int disks = sh->disks;
+	struct stripe_queue *sq = sh->sq;
+	int disks = sq->disks;
 	struct page *xor_srcs[disks];
 
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count = 0, pd_idx = sh->sq->pd_idx, i;
 	struct page *xor_dest;
 	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 	unsigned long flags;
@@ -792,7 +809,9 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if (dev->written)
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+
+			if (dev_q->written)
 				xor_srcs[count++] = dev->page;
 		}
 	} else {
@@ -830,7 +849,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sh->sq->pd_idx;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -847,11 +866,11 @@ static void ops_complete_check(void *stripe_head_ref)
 static void ops_run_check(struct stripe_head *sh)
 {
 	/* kernel stack size limits the total number of disks */
-	int disks = sh->disks;
+	int disks = sh->sq->disks;
 	struct page *xor_srcs[disks];
 	struct dma_async_tx_descriptor *tx;
 
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count = 0, pd_idx = sh->sq->pd_idx, i;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -878,7 +897,7 @@ static void ops_run_check(struct stripe_head *sh)
 
 static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 {
-	int overlap_clear = 0, i, disks = sh->disks;
+	int overlap_clear = 0, i, disks = sh->sq->disks;
 	struct dma_async_tx_descriptor *tx = NULL;
 
 	if (test_bit(STRIPE_OP_BIOFILL, &pending)) {
@@ -906,35 +925,51 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 	if (test_bit(STRIPE_OP_IO, &pending))
 		ops_run_io(sh);
 
-	if (overlap_clear)
+	if (overlap_clear) {
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
-				wake_up(&sh->raid_conf->wait_for_overlap);
+				wake_up(&sh->sq->raid_conf->wait_for_overlap);
 		}
+	}
 }
 
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
-	sh = kmem_cache_alloc(conf->slab_cache, GFP_KERNEL);
+	struct stripe_queue *sq;
+
+	sh = kmem_cache_alloc(conf->sh_slab_cache, GFP_KERNEL);
 	if (!sh)
 		return 0;
+
+	sq = kmem_cache_alloc(conf->sq_slab_cache, GFP_KERNEL);
+	if (!sq) {
+		kmem_cache_free(conf->sh_slab_cache, sh);
+		return 0;
+	}
+
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
-	sh->raid_conf = conf;
-	spin_lock_init(&sh->lock);
+	memset(sq, 0, sizeof(*sq) +
+		(conf->raid_disks-1) * sizeof(struct r5_queue_dev));
+	sh->sq = sq;
+	sq->raid_conf = conf;
+	spin_lock_init(&sq->lock);
 
 	if (grow_buffers(sh, conf->raid_disks)) {
 		shrink_buffers(sh, conf->raid_disks);
-		kmem_cache_free(conf->slab_cache, sh);
+		kmem_cache_free(conf->sh_slab_cache, sh);
+		kmem_cache_free(conf->sq_slab_cache, sq);
 		return 0;
 	}
-	sh->disks = conf->raid_disks;
+	sq->disks = conf->raid_disks;
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
 	INIT_LIST_HEAD(&sh->lru);
-	release_stripe(sh);
+	spin_lock_irq(&conf->device_lock);
+	__release_stripe(conf, sh);
+	spin_unlock_irq(&conf->device_lock);
 	return 1;
 }
 
@@ -943,16 +978,28 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name[0], "raid5-%s", mdname(conf->mddev));
-	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
+	sprintf(conf->sh_cache_name[0], "raid5-%s", mdname(conf->mddev));
+	sprintf(conf->sh_cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
+	sprintf(conf->sq_cache_name[0], "raid5q-%s", mdname(conf->mddev));
+	sprintf(conf->sq_cache_name[1], "raid5q-%s-alt", mdname(conf->mddev));
+
 	conf->active_name = 0;
-	sc = kmem_cache_create(conf->cache_name[conf->active_name],
+	sc = kmem_cache_create(conf->sh_cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
 			       0, 0, NULL);
 	if (!sc)
 		return 1;
-	conf->slab_cache = sc;
+	conf->sh_slab_cache = sc;
 	conf->pool_size = devs;
+
+	sc = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+		sizeof(struct stripe_queue) +
+		(devs-1)*sizeof(struct r5_queue_dev), 0, 0, NULL);
+
+	if (!sc)
+		return 1;
+	conf->sq_slab_cache = sc;
+
 	while (num--)
 		if (!grow_one_stripe(conf))
 			return 1;
@@ -989,7 +1036,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	LIST_HEAD(newstripes);
 	struct disk_info *ndisks;
 	int err = 0;
-	struct kmem_cache *sc;
+	struct kmem_cache *sc, *sc_q;
 	int i;
 
 	if (newsize <= conf->pool_size)
@@ -998,21 +1045,40 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	md_allow_write(conf->mddev);
 
 	/* Step 1 */
-	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
+	sc = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
 			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
 			       0, 0, NULL);
 	if (!sc)
 		return -ENOMEM;
 
+	sc_q = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
+		    sizeof(struct stripe_queue) +
+		    (newsize-1)*sizeof(struct r5_queue_dev), 0, 0, NULL);
+	if (!sc_q) {
+		kmem_cache_destroy(sc);
+		return -ENOMEM;
+	}
+
 	for (i = conf->max_nr_stripes; i; i--) {
+		struct stripe_queue *nsq;
+
 		nsh = kmem_cache_alloc(sc, GFP_KERNEL);
 		if (!nsh)
 			break;
 
+		nsq = kmem_cache_alloc(sc_q, GFP_KERNEL);
+		if (!nsq) {
+			kmem_cache_free(sc, nsh);
+			break;
+		}
+
 		memset(nsh, 0, sizeof(*nsh) + (newsize-1)*sizeof(struct r5dev));
+		memset(nsq, 0, sizeof(*nsq) +
+			(newsize-1)*sizeof(struct r5_queue_dev));
 
-		nsh->raid_conf = conf;
-		spin_lock_init(&nsh->lock);
+		nsq->raid_conf = conf;
+		nsh->sq = nsq;
+		spin_lock_init(&nsq->lock);
 
 		list_add(&nsh->lru, &newstripes);
 	}
@@ -1021,8 +1087,10 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 		while (!list_empty(&newstripes)) {
 			nsh = list_entry(newstripes.next, struct stripe_head, lru);
 			list_del(&nsh->lru);
+			kmem_cache_free(sc_q, nsh->sq);
 			kmem_cache_free(sc, nsh);
 		}
+		kmem_cache_destroy(sc_q);
 		kmem_cache_destroy(sc);
 		return -ENOMEM;
 	}
@@ -1044,9 +1112,11 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 			nsh->dev[i].page = osh->dev[i].page;
 		for( ; i<newsize; i++)
 			nsh->dev[i].page = NULL;
-		kmem_cache_free(conf->slab_cache, osh);
+		kmem_cache_free(conf->sq_slab_cache, osh->sq);
+		kmem_cache_free(conf->sh_slab_cache, osh);
 	}
-	kmem_cache_destroy(conf->slab_cache);
+	kmem_cache_destroy(conf->sh_slab_cache);
+	kmem_cache_destroy(conf->sq_slab_cache);
 
 	/* Step 3.
 	 * At this point, we are holding all the stripes so the array
@@ -1077,7 +1147,8 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
 
-	conf->slab_cache = sc;
+	conf->sh_slab_cache = sc;
+	conf->sq_slab_cache = sc_q;
 	conf->active_name = 1-conf->active_name;
 	conf->pool_size = newsize;
 	return err;
@@ -1095,7 +1166,9 @@ static int drop_one_stripe(raid5_conf_t *conf)
 		return 0;
 	BUG_ON(atomic_read(&sh->count));
 	shrink_buffers(sh, conf->pool_size);
-	kmem_cache_free(conf->slab_cache, sh);
+	if (sh->sq)
+		kmem_cache_free(conf->sq_slab_cache, sh->sq);
+	kmem_cache_free(conf->sh_slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
 	return 1;
 }
@@ -1105,17 +1178,21 @@ static void shrink_stripes(raid5_conf_t *conf)
 	while (drop_one_stripe(conf))
 		;
 
-	if (conf->slab_cache)
-		kmem_cache_destroy(conf->slab_cache);
-	conf->slab_cache = NULL;
+	if (conf->sh_slab_cache)
+		kmem_cache_destroy(conf->sh_slab_cache);
+	conf->sh_slab_cache = NULL;
+
+	if (conf->sq_slab_cache)
+		kmem_cache_destroy(conf->sq_slab_cache);
+	conf->sq_slab_cache = NULL;
 }
 
 static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 				   int error)
 {
  	struct stripe_head *sh = bi->bi_private;
-	raid5_conf_t *conf = sh->raid_conf;
-	int disks = sh->disks, i;
+	raid5_conf_t *conf = sh->sq->raid_conf;
+	int disks = sh->sq->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
@@ -1192,8 +1269,9 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 				    int error)
 {
  	struct stripe_head *sh = bi->bi_private;
-	raid5_conf_t *conf = sh->raid_conf;
-	int disks = sh->disks, i;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
+	int disks = sq->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
 	if (bi->bi_size)
@@ -1222,12 +1300,10 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 	return 0;
 }
 
-
-static sector_t compute_blocknr(struct stripe_head *sh, int i);
-	
 static void raid5_build_block (struct stripe_head *sh, int i)
 {
 	struct r5dev *dev = &sh->dev[i];
+	struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
 	bio_init(&dev->req);
 	dev->req.bi_io_vec = &dev->vec;
@@ -1241,7 +1317,8 @@ static void raid5_build_block (struct stripe_head *sh, int i)
 	dev->req.bi_private = sh;
 
 	dev->flags = 0;
-	dev->sector = compute_blocknr(sh, i);
+	dev_q->sector = compute_blocknr(sh->sq->raid_conf, sh->sq->disks,
+			sh->sector, sh->sq->pd_idx, i);
 }
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
@@ -1376,12 +1453,12 @@ static sector_t raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
 }
 
 
-static sector_t compute_blocknr(struct stripe_head *sh, int i)
+static sector_t
+compute_blocknr(raid5_conf_t *conf, int raid_disks, sector_t sector,
+	int pd_idx, int i)
 {
-	raid5_conf_t *conf = sh->raid_conf;
-	int raid_disks = sh->disks;
 	int data_disks = raid_disks - conf->max_degraded;
-	sector_t new_sector = sh->sector, check;
+	sector_t new_sector = sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
 	int chunk_offset;
@@ -1393,7 +1470,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	stripe = new_sector;
 	BUG_ON(new_sector != stripe);
 
-	if (i == sh->pd_idx)
+	if (i == pd_idx)
 		return 0;
 	switch(conf->level) {
 	case 4: break;
@@ -1401,14 +1478,14 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			if (i > sh->pd_idx)
+			if (i > pd_idx)
 				i--;
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			if (i < sh->pd_idx)
+			if (i < pd_idx)
 				i += raid_disks;
-			i -= (sh->pd_idx + 1);
+			i -= (pd_idx + 1);
 			break;
 		default:
 			printk(KERN_ERR "raid5: unsupported algorithm %d\n",
@@ -1416,25 +1493,25 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 		}
 		break;
 	case 6:
-		if (i == raid6_next_disk(sh->pd_idx, raid_disks))
+		if (i == raid6_next_disk(pd_idx, raid_disks))
 			return 0; /* It is the Q disk */
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-		  	if (sh->pd_idx == raid_disks-1)
-				i--; 	/* Q D D D P */
-			else if (i > sh->pd_idx)
+			if (pd_idx == raid_disks-1)
+				i--;	/* Q D D D P */
+			else if (i > pd_idx)
 				i -= 2; /* D D P Q D */
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			if (sh->pd_idx == raid_disks-1)
+			if (pd_idx == raid_disks-1)
 				i--; /* Q D D D P */
 			else {
 				/* D D P Q D */
-				if (i < sh->pd_idx)
+				if (i < pd_idx)
 					i += raid_disks;
-				i -= (sh->pd_idx + 2);
+				i -= (pd_idx + 2);
 			}
 			break;
 		default:
@@ -1448,7 +1525,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
-	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
+	if (check != sector || dummy1 != dd_idx || dummy2 != pd_idx) {
 		printk(KERN_ERR "compute_blocknr: map not correct\n");
 		return 0;
 	}
@@ -1515,8 +1592,9 @@ static void copy_data(int frombio, struct bio *bio,
 
 static void compute_parity6(struct stripe_head *sh, int method)
 {
-	raid6_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
+	struct stripe_queue *sq = sh->sq;
+	raid6_conf_t *conf = sq->raid_conf;
+	int i, pd_idx = sq->pd_idx, qd_idx, d0_idx, disks = sq->disks, count;
 	struct bio *chosen;
 	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
 	void *ptrs[disks];
@@ -1532,15 +1610,15 @@ static void compute_parity6(struct stripe_head *sh, int method)
 		BUG();		/* READ_MODIFY_WRITE N/A for RAID-6 */
 	case RECONSTRUCT_WRITE:
 		for (i= disks; i-- ;)
-			if ( i != pd_idx && i != qd_idx && sh->dev[i].towrite ) {
-				chosen = sh->dev[i].towrite;
-				sh->dev[i].towrite = NULL;
+			if (i != pd_idx && i != qd_idx && sq->dev[i].towrite) {
+				chosen = sq->dev[i].towrite;
+				sq->dev[i].towrite = NULL;
 
 				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
 
-				BUG_ON(sh->dev[i].written);
-				sh->dev[i].written = chosen;
+				BUG_ON(sq->dev[i].written);
+				sq->dev[i].written = chosen;
 			}
 		break;
 	case CHECK_PARITY:
@@ -1548,9 +1626,9 @@ static void compute_parity6(struct stripe_head *sh, int method)
 	}
 
 	for (i = disks; i--;)
-		if (sh->dev[i].written) {
-			sector_t sector = sh->dev[i].sector;
-			struct bio *wbi = sh->dev[i].written;
+		if (sq->dev[i].written) {
+			sector_t sector = sq->dev[i].sector;
+			struct bio *wbi = sq->dev[i].written;
 			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
 				copy_data(1, wbi, sh->dev[i].page, sector);
 				wbi = r5_next_bio(wbi, sector);
@@ -1597,9 +1675,10 @@ static void compute_parity6(struct stripe_head *sh, int method)
 /* Compute one missing block */
 static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
-	int i, count, disks = sh->disks;
+	struct stripe_queue *sq = sh->sq;
+	int i, count, disks = sq->disks;
 	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sq->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 
 	pr_debug("compute_block_1, stripe %llu, idx %d\n",
@@ -1635,8 +1714,8 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 /* Compute two missing blocks */
 static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 {
-	int i, count, disks = sh->disks;
-	int pd_idx = sh->pd_idx;
+	int i, count, disks = sh->sq->disks;
+	int pd_idx = sh->sq->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 	int d0_idx = raid6_next_disk(qd_idx, disks);
 	int faila, failb;
@@ -1698,8 +1777,9 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 static int
 handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 {
-	int i, pd_idx = sh->pd_idx, disks = sh->disks;
 	int locked = 0;
+	struct stripe_queue *sq = sh->sq;
+	int i, pd_idx = sq->pd_idx, disks = sq->disks;
 
 	if (rcw) {
 		/* if we are not expanding this is a proper write request, and
@@ -1716,8 +1796,9 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
 
-			if (dev->towrite) {
+			if (dev_q->towrite) {
 				set_bit(R5_LOCKED, &dev->flags);
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
@@ -1736,6 +1817,8 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+
 			if (i == pd_idx)
 				continue;
 
@@ -1744,7 +1827,7 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 			 * written so we distinguish these blocks by the
 			 * R5_Wantprexor bit
 			 */
-			if (dev->towrite &&
+			if (dev_q->towrite &&
 			    (test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags))) {
 				set_bit(R5_Wantprexor, &dev->flags);
@@ -1777,7 +1860,8 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
 	struct bio **bip;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int firstwrite=0;
 
 	pr_debug("adding bh b#%llu to stripe s#%llu\n",
@@ -1785,14 +1869,14 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		(unsigned long long)sh->sector);
 
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	spin_lock_irq(&conf->device_lock);
 	if (forwrite) {
-		bip = &sh->dev[dd_idx].towrite;
-		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
+		bip = &sq->dev[dd_idx].towrite;
+		if (*bip == NULL && sq->dev[dd_idx].written == NULL)
 			firstwrite = 1;
 	} else
-		bip = &sh->dev[dd_idx].toread;
+		bip = &sq->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
@@ -1807,7 +1891,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	*bip = bi;
 	bi->bi_phys_segments ++;
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
@@ -1822,15 +1906,15 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 
 	if (forwrite) {
 		/* check if page is covered */
-		sector_t sector = sh->dev[dd_idx].sector;
-		for (bi=sh->dev[dd_idx].towrite;
-		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
+		sector_t sector = sq->dev[dd_idx].sector;
+		for (bi = sq->dev[dd_idx].towrite;
+		     sector < sq->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_sector <= sector;
-		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
+		     bi = r5_next_bio(bi, sq->dev[dd_idx].sector)) {
 			if (bi->bi_sector + (bi->bi_size>>9) >= sector)
 				sector = bi->bi_sector + (bi->bi_size>>9);
 		}
-		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
+		if (sector >= sq->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
 	return 1;
@@ -1838,7 +1922,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
  overlap:
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 	return 0;
 }
 
@@ -1870,6 +1954,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 				struct bio **return_bi)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
+
 	for (i = disks; i--; ) {
 		struct bio *bi;
 		int bitmap_end = 0;
@@ -1885,8 +1971,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 		}
 		spin_lock_irq(&conf->device_lock);
 		/* fail all writes first */
-		bi = sh->dev[i].towrite;
-		sh->dev[i].towrite = NULL;
+		bi = sq->dev[i].towrite;
+		sq->dev[i].towrite = NULL;
 		if (bi) {
 			s->to_write--;
 			bitmap_end = 1;
@@ -1896,8 +1982,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 			wake_up(&conf->wait_for_overlap);
 
 		while (bi && bi->bi_sector <
-			sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
+			sq->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *nextbi = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (--bi->bi_phys_segments == 0) {
 				md_write_end(conf->mddev);
@@ -1907,12 +1993,12 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 			bi = nextbi;
 		}
 		/* and fail all 'written' */
-		bi = sh->dev[i].written;
-		sh->dev[i].written = NULL;
+		bi = sq->dev[i].written;
+		sq->dev[i].written = NULL;
 		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_sector <
-		       sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
+		       sq->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *bi2 = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (--bi->bi_phys_segments == 0) {
 				md_write_end(conf->mddev);
@@ -1928,15 +2014,15 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 		if (!test_bit(R5_Wantfill, &sh->dev[i].flags) &&
 		    (!test_bit(R5_Insync, &sh->dev[i].flags) ||
 		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
-			bi = sh->dev[i].toread;
-			sh->dev[i].toread = NULL;
+			bi = sq->dev[i].toread;
+			sq->dev[i].toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
 			if (bi) s->to_read--;
 			while (bi && bi->bi_sector <
-			       sh->dev[i].sector + STRIPE_SECTORS) {
+			       sq->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *nextbi =
-					r5_next_bio(bi, sh->dev[i].sector);
+					r5_next_bio(bi, sq->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
 				if (--bi->bi_phys_segments == 0) {
 					bi->bi_next = *return_bi;
@@ -1959,22 +2045,25 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
 			struct stripe_head_state *s, int disk_idx, int disks)
 {
+	struct stripe_queue *sq = sh->sq;
 	struct r5dev *dev = &sh->dev[disk_idx];
+	struct r5_queue_dev *dev_q = &sq->dev[disk_idx];
 	struct r5dev *failed_dev = &sh->dev[s->failed_num];
+	struct r5_queue_dev *failed_dev_q = &sq->dev[s->failed_num];
 
 	/* don't schedule compute operations or reads on the parity block while
 	 * a check is in flight
 	 */
-	if ((disk_idx == sh->pd_idx) &&
+	if ((disk_idx == sq->pd_idx) &&
 	     test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
 		return ~0;
 
 	/* is the data in this block needed, and can we get it? */
 	if (!test_bit(R5_LOCKED, &dev->flags) &&
-	    !test_bit(R5_UPTODATE, &dev->flags) && (dev->toread ||
-	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	    !test_bit(R5_UPTODATE, &dev->flags) && (dev_q->toread ||
+	    (dev_q->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
 	     s->syncing || s->expanding || (s->failed &&
-	     (failed_dev->toread || (failed_dev->towrite &&
+	     (failed_dev_q->toread || (failed_dev_q->towrite &&
 	     !test_bit(R5_OVERWRITE, &failed_dev->flags)
 	     ))))) {
 		/* 1/ We would like to get this block, possibly by computing it,
@@ -2057,18 +2146,22 @@ static void handle_issuing_new_read_requests6(struct stripe_head *sh,
 			int disks)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
+
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
 		if (!test_bit(R5_LOCKED, &dev->flags) &&
 		    !test_bit(R5_UPTODATE, &dev->flags) &&
-		    (dev->toread || (dev->towrite &&
+		    (dev_q->toread || (dev_q->towrite &&
 		     !test_bit(R5_OVERWRITE, &dev->flags)) ||
 		     s->syncing || s->expanding ||
 		     (s->failed >= 1 &&
-		      (sh->dev[r6s->failed_num[0]].toread ||
+		      (sq->dev[r6s->failed_num[0]].toread ||
 		       s->to_write)) ||
 		     (s->failed >= 2 &&
-		      (sh->dev[r6s->failed_num[1]].toread ||
+		      (sq->dev[r6s->failed_num[1]].toread ||
 		       s->to_write)))) {
 			/* we would like to get this block, possibly
 			 * by computing it, but we might not be able to
@@ -2118,11 +2211,12 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 	struct stripe_head *sh, int disks, struct bio **return_bi)
 {
 	int i;
-	struct r5dev *dev;
+	struct stripe_queue *sq = sh->sq;
 
 	for (i = disks; i--; )
-		if (sh->dev[i].written) {
-			dev = &sh->dev[i];
+		if (sq->dev[i].written) {
+			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) &&
 				test_bit(R5_UPTODATE, &dev->flags)) {
 				/* We can return any write requests */
@@ -2130,11 +2224,11 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 				int bitmap_end = 0;
 				pr_debug("Return write for disc %d\n", i);
 				spin_lock_irq(&conf->device_lock);
-				wbi = dev->written;
-				dev->written = NULL;
+				wbi = dev_q->written;
+				dev_q->written = NULL;
 				while (wbi && wbi->bi_sector <
-					dev->sector + STRIPE_SECTORS) {
-					wbi2 = r5_next_bio(wbi, dev->sector);
+					dev_q->sector + STRIPE_SECTORS) {
+					wbi2 = r5_next_bio(wbi, dev_q->sector);
 					if (--wbi->bi_phys_segments == 0) {
 						md_write_end(conf->mddev);
 						wbi->bi_next = *return_bi;
@@ -2142,7 +2236,7 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 					}
 					wbi = wbi2;
 				}
-				if (dev->towrite == NULL)
+				if (dev_q->towrite == NULL)
 					bitmap_end = 1;
 				spin_unlock_irq(&conf->device_lock);
 				if (bitmap_end)
@@ -2159,10 +2253,14 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s, int disks)
 {
 	int rmw = 0, rcw = 0, i;
+	struct stripe_queue *sq = sh->sq;
+
 	for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
 		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx) &&
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
+		if ((dev_q->towrite || i == sq->pd_idx) &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		      test_bit(R5_Wantcompute, &dev->flags))) {
@@ -2172,7 +2270,7 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 				rmw += 2*disks;  /* cannot read it */
 		}
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sq->pd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		    test_bit(R5_Wantcompute, &dev->flags))) {
@@ -2188,7 +2286,9 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 		/* prefer read-modify-write, but need to get some data */
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx) &&
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+
+			if ((dev_q->towrite || i == sq->pd_idx) &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
@@ -2213,8 +2313,9 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 		/* want reconstruct write, but need to get some data */
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+
 			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
-			    i != sh->pd_idx &&
+			    i != sq->pd_idx &&
 			    !test_bit(R5_LOCKED, &dev->flags) &&
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
@@ -2256,7 +2357,8 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s,
 		struct r6_state *r6s, int disks)
 {
-	int rcw = 0, must_compute = 0, pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int rcw = 0, must_compute = 0, pd_idx = sq->pd_idx, i;
 	int qd_idx = r6s->qd_idx;
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
@@ -2352,6 +2454,7 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks)
 {
+	struct stripe_queue *sq = sh->sq;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	/* Take one of the following actions:
 	 * 1/ start a check parity operation if (uptodate == disks)
@@ -2363,7 +2466,7 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
 		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			BUG_ON(s->uptodate != disks);
-			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+			clear_bit(R5_UPTODATE, &sh->dev[sq->pd_idx].flags);
 			sh->ops.count++;
 			s->uptodate--;
 		} else if (
@@ -2389,8 +2492,8 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 					set_bit(STRIPE_OP_MOD_REPAIR_PD,
 						&sh->ops.pending);
 					set_bit(R5_Wantcompute,
-						&sh->dev[sh->pd_idx].flags);
-					sh->ops.target = sh->pd_idx;
+						&sh->dev[sq->pd_idx].flags);
+					sh->ops.target = sq->pd_idx;
 					sh->ops.count++;
 					s->uptodate++;
 				}
@@ -2415,9 +2518,10 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
 		!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
 		struct r5dev *dev;
+
 		/* either failed parity check, or recovery is happening */
 		if (s->failed == 0)
-			s->failed_num = sh->pd_idx;
+			s->failed_num = sq->pd_idx;
 		dev = &sh->dev[s->failed_num];
 		BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		BUG_ON(s->uptodate != disks);
@@ -2440,8 +2544,9 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 				int disks)
 {
 	int update_p = 0, update_q = 0;
+	struct stripe_queue *sq = sh->sq;
 	struct r5dev *dev;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sq->pd_idx;
 	int qd_idx = r6s->qd_idx;
 
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -2531,18 +2636,21 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 				struct r6_state *r6s)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
 
 	/* We have read all the blocks in this stripe and now we need to
 	 * copy some of them into a target stripe for expand.
 	 */
 	struct dma_async_tx_descriptor *tx = NULL;
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
-	for (i = 0; i < sh->disks; i++)
-		if (i != sh->pd_idx && (!r6s || i != r6s->qd_idx)) {
+	for (i = 0; i < sq->disks; i++)
+		if (i != sq->pd_idx && (!r6s || i != r6s->qd_idx)) {
 			int dd_idx, pd_idx, j;
 			struct stripe_head *sh2;
+			struct stripe_queue *sq2;
 
-			sector_t bn = compute_blocknr(sh, i);
+			sector_t bn = compute_blocknr(conf, sq->disks,
+						sh->sector, sq->pd_idx, i);
 			sector_t s = raid5_compute_sector(bn, conf->raid_disks,
 						conf->raid_disks -
 						conf->max_degraded, &dd_idx,
@@ -2567,12 +2675,13 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 				sh->dev[i].page, 0, 0, STRIPE_SIZE,
 				ASYNC_TX_DEP_ACK, tx, NULL, NULL);
 
+			sq2 = sh2->sq;
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
-				if (j != sh2->pd_idx &&
-				    (!r6s || j != raid6_next_disk(sh2->pd_idx,
-								 sh2->disks)) &&
+				if (j != sq2->pd_idx &&
+				    (!r6s || j != raid6_next_disk(sq2->pd_idx,
+								 sq2->disks)) &&
 				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
 					break;
 			if (j == conf->raid_disks) {
@@ -2608,8 +2717,9 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 
 static void handle_stripe5(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
-	int disks = sh->disks, i;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sh->sq->raid_conf;
+	int disks = sq->disks, i;
 	struct bio *return_bi = NULL;
 	struct stripe_head_state s;
 	struct r5dev *dev;
@@ -2618,10 +2728,10 @@ static void handle_stripe5(struct stripe_head *sh)
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
 		"ops=%lx:%lx:%lx\n", (unsigned long long)sh->sector, sh->state,
-		atomic_read(&sh->count), sh->pd_idx,
+		atomic_read(&sh->count), sq->pd_idx,
 		sh->ops.pending, sh->ops.ack, sh->ops.complete);
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -2634,18 +2744,19 @@ static void handle_stripe5(struct stripe_head *sh)
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
-			"written %p\n",	i, dev->flags, dev->toread, dev->read,
-			dev->towrite, dev->written);
+			"written %p\n",	i, dev->flags, dev_q->toread,
+			dev_q->read, dev_q->towrite, dev_q->written);
 
 		/* maybe we can request a biofill operation
 		 *
 		 * new wantfill requests are only permitted while
 		 * STRIPE_OP_BIOFILL is clear
 		 */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev_q->toread &&
 			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
 			set_bit(R5_Wantfill, &dev->flags);
 
@@ -2656,14 +2767,14 @@ static void handle_stripe5(struct stripe_head *sh)
 
 		if (test_bit(R5_Wantfill, &dev->flags))
 			s.to_fill++;
-		else if (dev->toread)
+		else if (dev_q->toread)
 			s.to_read++;
-		if (dev->towrite) {
+		if (dev_q->towrite) {
 			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
 				s.non_overwrite++;
 		}
-		if (dev->written)
+		if (dev_q->written)
 			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
@@ -2702,12 +2813,12 @@ static void handle_stripe5(struct stripe_head *sh)
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
-	dev = &sh->dev[sh->pd_idx];
+	dev = &sh->dev[sq->pd_idx];
 	if ( s.written &&
 	     ((test_bit(R5_Insync, &dev->flags) &&
 	       !test_bit(R5_LOCKED, &dev->flags) &&
 	       test_bit(R5_UPTODATE, &dev->flags)) ||
-	       (s.failed == 1 && s.failed_num == sh->pd_idx)))
+		(s.failed == 1 && s.failed_num == sq->pd_idx)))
 		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -2752,18 +2863,20 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* All the 'written' buffers and the parity block are ready to
 		 * be written back to disk
 		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sq->pd_idx].flags));
 		for (i = disks; i--; ) {
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+
 			dev = &sh->dev[i];
 			if (test_bit(R5_LOCKED, &dev->flags) &&
-				(i == sh->pd_idx || dev->written)) {
+				(i == sq->pd_idx || dev_q->written)) {
 				pr_debug("Writing block %d\n", i);
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (!test_and_set_bit(
 				    STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
 				if (!test_bit(R5_Insync, &dev->flags) ||
-				    (i == sh->pd_idx && s.failed == 0))
+				    (i == sq->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
@@ -2850,8 +2963,8 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		/* Need to write out all blocks after computing parity */
-		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+		sq->disks = conf->raid_disks;
+		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
 		s.locked += handle_write_operations5(sh, 1, 1);
 	} else if (s.expanded &&
@@ -2868,7 +2981,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (sh->ops.count)
 		pending = get_stripe_work(sh);
 
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	if (pending)
 		raid5_run_ops(sh, pending);
@@ -2879,10 +2992,11 @@ static void handle_stripe5(struct stripe_head *sh)
 
 static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 {
-	raid6_conf_t *conf = sh->raid_conf;
-	int disks = sh->disks;
+	struct stripe_queue *sq = sh->sq;
+	raid6_conf_t *conf = sq->raid_conf;
+	int disks = sq->disks;
 	struct bio *return_bi = NULL;
-	int i, pd_idx = sh->pd_idx;
+	int i, pd_idx = sq->pd_idx;
 	struct stripe_head_state s;
 	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
@@ -2894,7 +3008,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
 	memset(&s, 0, sizeof(s));
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -2906,24 +3020,28 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev->flags, dev->toread, dev->towrite, dev->written);
+			i, dev->flags, dev_q->toread, dev_q->towrite,
+			dev_q->written);
 		/* maybe we can reply to a read */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev_q->toread) {
 			struct bio *rbi, *rbi2;
 			pr_debug("Return read for disc %d\n", i);
 			spin_lock_irq(&conf->device_lock);
-			rbi = dev->toread;
-			dev->toread = NULL;
+			rbi = dev_q->toread;
+			dev_q->toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-				copy_data(0, rbi, dev->page, dev->sector);
-				rbi2 = r5_next_bio(rbi, dev->sector);
+			while (rbi && rbi->bi_sector <
+			       dev_q->sector + STRIPE_SECTORS) {
+				copy_data(0, rbi, dev->page, dev_q->sector);
+				rbi2 = r5_next_bio(rbi, dev_q->sector);
 				spin_lock_irq(&conf->device_lock);
 				if (--rbi->bi_phys_segments == 0) {
 					rbi->bi_next = return_bi;
@@ -2939,14 +3057,14 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
 
-		if (dev->toread)
+		if (dev_q->toread)
 			s.to_read++;
-		if (dev->towrite) {
+		if (dev_q->towrite) {
 			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
 				s.non_overwrite++;
 		}
-		if (dev->written)
+		if (dev_q->written)
 			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
@@ -3047,8 +3165,8 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
-		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+		sq->disks = conf->raid_disks;
+		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 					     conf->raid_disks);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
@@ -3067,7 +3185,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	if (s.expanding && s.locked == 0)
 		handle_stripe_expansion(conf, sh, &r6s);
 
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	return_io(return_bi);
 
@@ -3133,7 +3251,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
 {
-	if (sh->raid_conf->level == 6)
+	if (sh->sq->raid_conf->level == 6)
 		handle_stripe6(sh, tmp_page);
 	else
 		handle_stripe5(sh);
@@ -3677,14 +3795,17 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		/* If any of this stripe is beyond the end of the old
 		 * array, then we need to zero those blocks
 		 */
-		for (j=sh->disks; j--;) {
+		for (j = sh->sq->disks; j--;) {
 			sector_t s;
-			if (j == sh->pd_idx)
+			int pd_idx = sh->sq->pd_idx;
+
+			if (j == pd_idx)
 				continue;
 			if (conf->level == 6 &&
-			    j == raid6_next_disk(sh->pd_idx, sh->disks))
+			    j == raid6_next_disk(pd_idx, sh->sq->disks))
 				continue;
-			s = compute_blocknr(sh, j);
+			s = compute_blocknr(conf, sh->sq->disks, sh->sector,
+					    pd_idx, j);
 			if (s < (mddev->array_size<<1)) {
 				skipped = 1;
 				continue;
@@ -3736,6 +3857,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int pd_idx;
 	int raid_disks = conf->raid_disks;
 	sector_t max_sector = mddev->size << 1;
@@ -3792,6 +3914,8 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 		 */
 		schedule_timeout_uninterruptible(1);
 	}
+	sq = sh->sq;
+
 	/* Need to check if array will still be degraded after recovery/resync
 	 * We don't need to check the 'failed' flag as when that gets set,
 	 * recovery aborts.
@@ -3802,10 +3926,10 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	handle_stripe(sh, NULL);
 	release_stripe(sh);
@@ -3826,6 +3950,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int dd_idx, pd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
@@ -3859,6 +3984,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			return handled;
 		}
 
+		sq = sh->sq;
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
@@ -4325,16 +4451,16 @@ static int stop(mddev_t *mddev)
 static void print_sh (struct seq_file *seq, struct stripe_head *sh)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
 
 	seq_printf(seq, "sh %llu, pd_idx %d, state %ld.\n",
-		   (unsigned long long)sh->sector, sh->pd_idx, sh->state);
+		   (unsigned long long)sh->sector, sq->pd_idx, sh->state);
 	seq_printf(seq, "sh %llu,  count %d.\n",
 		   (unsigned long long)sh->sector, atomic_read(&sh->count));
 	seq_printf(seq, "sh %llu, ", (unsigned long long)sh->sector);
-	for (i = 0; i < sh->disks; i++) {
+	for (i = 0; i < sq->disks; i++)
 		seq_printf(seq, "(cache%d: %p %ld) ",
 			   i, sh->dev[i].page, sh->dev[i].flags);
-	}
 	seq_printf(seq, "\n");
 }
 
@@ -4347,7 +4473,7 @@ static void printall (struct seq_file *seq, raid5_conf_t *conf)
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < NR_HASH; i++) {
 		hlist_for_each_entry(sh, hn, &conf->stripe_hashtbl[i], hash) {
-			if (sh->raid_conf != conf)
+			if (sh->sq->raid_conf != conf)
 				continue;
 			print_sh(seq, sh);
 		}
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 93678f5..857e2bf 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -158,17 +158,14 @@
  *    the compute block completes.
  */
 
+struct stripe_queue;
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;			/* inactive_list or handle_list */
-	struct raid5_private_data	*raid_conf;
 	sector_t		sector;			/* sector of this row */
-	int			pd_idx;			/* parity disk index */
 	unsigned long		state;			/* state flags */
 	atomic_t		count;			/* nr of active thread/requests */
-	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
-	int			disks;			/* disks in stripe */
 	/* stripe_operations
 	 * @pending - pending ops flags (set for request->issue->complete)
 	 * @ack - submitted ops flags (set for issue->complete)
@@ -184,13 +181,12 @@ struct stripe_head {
 		int		   count;
 		u32		   zero_sum_result;
 	} ops;
+	struct stripe_queue *sq;
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
 		struct page	*page;
-		struct bio	*toread, *read, *towrite, *written;
-		sector_t	sector;			/* sector of this page */
-		unsigned long	flags;
+		unsigned long flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
@@ -209,6 +205,18 @@ struct r6_state {
 	int p_failed, q_failed, qd_idx, failed_num[2];
 };
 
+struct stripe_queue {
+	sector_t sector;
+	spinlock_t lock; /* protect bio lists and stripe_head state */
+	struct raid5_private_data *raid_conf;
+	int pd_idx; /* parity disk index */
+	int disks; /* disks in stripe */
+	struct r5_queue_dev {
+		sector_t sector; /* hw starting sector for this block */
+		struct bio *toread, *read, *towrite, *written;
+	} dev[1];
+};
+
 /* Flags */
 #define	R5_UPTODATE	0	/* page contains current data */
 #define	R5_LOCKED	1	/* IO has been submitted on "req" */
@@ -328,8 +336,10 @@ struct raid5_private_data {
 	 * two caches.
 	 */
 	int			active_name;
-	char			cache_name[2][20];
-	struct kmem_cache		*slab_cache; /* for allocating stripes */
+	char			sh_cache_name[2][20];
+	char			sq_cache_name[2][20];
+	struct kmem_cache	*sh_slab_cache;
+	struct kmem_cache	*sq_slab_cache;
 
 	int			seq_flush, seq_write;
 	int			quiesce;
