From: Dan Williams <dan.j.williams@intel.com>
Subject: [-mm PATCH 1/2] raid5: add the stripe_queue object for tracking raid
	io requests (take2)
Date: Fri, 13 Jul 2007 15:35:47 -0700
Message-ID: <20070713223547.25202.34756.stgit@dwillia2-linux.ch.intel.com>
References: <20070713223257.25202.74399.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070713223257.25202.74399.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, akpm@linux-foundation.org
Cc: raziebe@gmail.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The raid5 stripe cache object, struct stripe_head, serves two purposes:
	1/ frontend: queuing incoming requests
	2/ backend: transitioning requests through the cache state machine
	   to the backing devices
The problem with this model is that queuing decisions are directly tied to
cache availability.  There is no facility to determine that a request or
group of requests 'deserves' usage of the cache and disks at any given time.

This patch separates the object members needed for queuing from the object
members used for caching.  The stripe_queue object takes over the incoming
bio lists as well as the buffer state flags.

The following fields are moved from struct stripe_head to struct
stripe_queue:
	raid5_private_data *raid_conf
	int pd_idx
	spinlock_t lock
	int bm_seq

The following fields are moved from struct r5dev to struct r5_queue_dev:
	sector_t sector
	struct bio *toread, *towrite

This patch lays the groundwork, but does not implement, the facility to
have more queue objects in the system than available stripes, currently this
remains a 1:1 relationship.  In other words, this patch just moves fields
around and does not implement new logic.

--- Performance Data ---

Unit information
================
File size = megabytes
Blk Size  = bytes
Num Thr   = number of threads
Avg Rate  = relative throughput
CPU%      = relative percentage of CPU used during the test
CPU Eff   = Rate divided by CPU% - relative throughput per cpu load

Configuration
=============
Platform: 1200Mhz iop348 with 4-disk sata_vsc array
mdadm --create /dev/md0 /dev/sd[abcd] -n 4 -l 5
mkfs.ext2 /dev/md0
mount /dev/md0 /mnt/raid
tiobench --size 2048 --numruns 5 --block 4096 --block 131072 --dir /mnt/raid

Sequential Reads
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
-----------     ------  -----   ---     ------  ------  -----
2.6.22-iop1     2048    4096    1       -1%     2%      -3%
2.6.22-iop1     2048    4096    2       -37%    -34%    -5%
2.6.22-iop1     2048    4096    4       -22%    -19%    -3%
2.6.22-iop1     2048    4096    8       -3%     -3%     -1%
2.6.22-iop1     2048    13107   1       1%      -1%     2%
2.6.22-iop1     2048    13107   2       -11%    -11%    -1%
2.6.22-iop1     2048    13107   4       25%     20%     4%
2.6.22-iop1     2048    13107   8       8%      6%      2%

Sequential Writes
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
-----------     ------  -----   ---     ------  ------  -----
2.6.22-iop1     2048    4096    1       26%     29%     -2%
2.6.22-iop1     2048    4096    2       40%     43%     -2%
2.6.22-iop1     2048    4096    4       24%     7%      16%
2.6.22-iop1     2048    4096    8       6%      -11%    19%
2.6.22-iop1     2048    13107   1       66%     65%     0%
2.6.22-iop1     2048    13107   2       41%     33%     6%
2.6.22-iop1     2048    13107   4       23%     -8%     34%
2.6.22-iop1     2048    13107   8       13%     -24%    49%

The read numbers in this take have approved from a %14 average decline to a
%5 average decline.  However it is still a mystery as to why any
significant variance is showing up because most reads should completely
bypass the stripe_cache.

New for take3 is blktrace data for a component disk while running the
following:
	for i in `seq 1 5`; do dd if=/dev/zero of=/dev/md0 bs=1024k count=1024; done

Pre-patch:
CPU0 (sda):
 Reads Queued:        7965,    31860KiB  Writes Queued:      437458, 1749MiB
 Read Dispatches:      881,    31860KiB  Write Dispatches:    26405, 1749MiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:      881,    31860KiB  Writes Completed:    26415, 1749MiB
 Read Merges:         6955,    27820KiB  Write Merges:       411007, 1644MiB
 Read depth:             2               Write depth:             2
 IO unplugs:           176               Timer unplugs:         176

Post-patch:
CPU0 (sda):
 Reads Queued:       36255,   145020KiB  Writes Queued:      437727, 1750MiB
 Read Dispatches:     1960,   145020KiB  Write Dispatches:     6672, 1750MiB
 Reads Requeued:         0               Writes Requeued:         0
 Reads Completed:     1960,   145020KiB  Writes Completed:     6682, 1750MiB
 Read Merges:        34235,   136940KiB  Write Merges:       430409, 1721MiB
 Read depth:             2               Write depth:             2
 IO unplugs:           423               Timer unplugs:         423

It looks like the performance win is coming from improved merging and not
from reduced reads as previously assumed.  Note that with blktrace enabled
the throughput comes in at ~98MB/s compared to ~120MB/s without.  Pre-patch
throughput hovers at ~85MB/s for this dd command.

Changes in take2:
* leave the flags with the buffers, prevents a data corruption issue
  whereby stale buffer state flags are attached to newly initialized buffers

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |  475 ++++++++++++++++++++++++++++----------------
 include/linux/raid/raid5.h |   29 ++-
 2 files changed, 317 insertions(+), 187 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0b66afe..b653c2b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -31,7 +31,7 @@
  * conf->bm_flush is the number of the last batch that was closed to
  *    new additions.
  * When we discover that we will need to write to any block in a stripe
- * (in add_stripe_bio) we update the in-memory bitmap and record in sh->bm_seq
+ * (in add_stripe_bio) we update the in-memory bitmap and record in sq->bm_seq
  * the number of the batch it will be in. This is bm_flush+1.
  * When we are ready to do a write, if that batch hasn't been written yet,
  *   we plug the array and queue the stripe for later.
@@ -132,7 +132,7 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 				list_add_tail(&sh->lru, &conf->delayed_list);
 				blk_plug_device(conf->mddev->queue);
 			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
-				   sh->bm_seq - conf->seq_write > 0) {
+				   sh->sq->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 				blk_plug_device(conf->mddev->queue);
 			} else {
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
 
 	sh->disks = disks;
 
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
-		if (dev->toread || dev->read || dev->towrite || dev->written ||
-		    test_bit(R5_LOCKED, &dev->flags)) {
+		if (dev_q->toread || dev->read || dev_q->towrite ||
+			dev->written || test_bit(R5_LOCKED, &dev->flags)) {
 			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
-			       (unsigned long long)sh->sector, i, dev->toread,
-			       dev->read, dev->towrite, dev->written,
+			       (unsigned long long)sh->sector, i, dev_q->toread,
+			       dev->read, dev_q->towrite, dev->written,
 			       test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
@@ -288,6 +289,9 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, in
 	return NULL;
 }
 
+static sector_t compute_blocknr(raid5_conf_t *conf, int raid_disks,
+	sector_t sector, int pd_idx, int i);
+
 static void unplug_slaves(mddev_t *mddev);
 static void raid5_unplug_device(request_queue_t *q);
 
@@ -389,12 +393,13 @@ raid5_end_write_request (struct bio *bi, unsigned int bytes_done, int error);
 
 static void ops_run_io(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i, disks = sh->disks;
 
 	might_sleep();
 
-	for (i = disks; i--; ) {
+	for (i = disks; i--;) {
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
@@ -513,7 +518,8 @@ static void ops_complete_biofill(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
 	struct bio *return_bi = NULL;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i, more_to_read = 0;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -522,14 +528,16 @@ static void ops_complete_biofill(void *stripe_head_ref)
 	/* clear completed biofills */
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
 		/* check if this stripe has new incoming reads */
-		if (dev->toread)
+		if (dev_q->toread)
 			more_to_read++;
 
 		/* acknowledge completion of a biofill operation */
 		/* and check if we need to reply to a read request
 		*/
-		if (test_bit(R5_Wantfill, &dev->flags) && !dev->toread) {
+		if (test_bit(R5_Wantfill, &dev->flags) && !dev_q->toread) {
 			struct bio *rbi, *rbi2;
 			clear_bit(R5_Wantfill, &dev->flags);
 
@@ -541,8 +549,8 @@ static void ops_complete_biofill(void *stripe_head_ref)
 			rbi = dev->read;
 			dev->read = NULL;
 			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
-				rbi2 = r5_next_bio(rbi, dev->sector);
+				dev_q->sector + STRIPE_SECTORS) {
+				rbi2 = r5_next_bio(rbi, dev_q->sector);
 				spin_lock_irq(&conf->device_lock);
 				if (--rbi->bi_phys_segments == 0) {
 					rbi->bi_next = return_bi;
@@ -566,7 +574,7 @@ static void ops_complete_biofill(void *stripe_head_ref)
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -574,17 +582,18 @@ static void ops_run_biofill(struct stripe_head *sh)
 
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
 			spin_lock_irq(&conf->device_lock);
-			dev->read = rbi = dev->toread;
-			dev->toread = NULL;
+			dev->read = rbi = dev_q->toread;
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
@@ -665,7 +674,8 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
-	int count = 0, pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int count = 0, pd_idx = sq->pd_idx, i;
 
 	/* existing parity data subtracted */
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
@@ -675,8 +685,9 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (dev->towrite && test_bit(R5_Wantprexor, &dev->flags))
+		if (dev_q->towrite && test_bit(R5_Wantprexor, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -691,7 +702,8 @@ static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	int pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int pd_idx = sq->pd_idx, i;
 
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
@@ -703,16 +715,17 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 
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
@@ -720,18 +733,18 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 		if (towrite) {
 			struct bio *wbi;
 
-			spin_lock(&sh->lock);
-			chosen = dev->towrite;
-			dev->towrite = NULL;
+			spin_lock(&sq->lock);
+			chosen = dev_q->towrite;
+			dev_q->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
-			spin_unlock(&sh->lock);
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
@@ -754,7 +767,8 @@ static void ops_complete_postxor(void *stripe_head_ref)
 static void ops_complete_write(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int disks = sh->disks, i, pd_idx = sh->pd_idx;
+	struct stripe_queue *sq = sh->sq;
+	int disks = sh->disks, i, pd_idx = sq->pd_idx;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -779,7 +793,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
 
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count = 0, pd_idx = sh->sq->pd_idx, i;
 	struct page *xor_dest;
 	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 	unsigned long flags;
@@ -833,7 +847,7 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sh->sq->pd_idx;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -854,7 +868,7 @@ static void ops_run_check(struct stripe_head *sh)
 	struct page *xor_srcs[disks];
 	struct dma_async_tx_descriptor *tx;
 
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count = 0, pd_idx = sh->sq->pd_idx, i;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -909,27 +923,41 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
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
 	sh->disks = conf->raid_disks;
@@ -937,7 +965,9 @@ static int grow_one_stripe(raid5_conf_t *conf)
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
 	INIT_LIST_HEAD(&sh->lru);
-	release_stripe(sh);
+	spin_lock_irq(&conf->device_lock);
+	__release_stripe(conf, sh);
+	spin_unlock_irq(&conf->device_lock);
 	return 1;
 }
 
@@ -946,16 +976,29 @@ static int grow_stripes(raid5_conf_t *conf, int num)
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
 			       0, 0, NULL, NULL);
+
 	if (!sc)
 		return 1;
-	conf->slab_cache = sc;
+	conf->sh_slab_cache = sc;
 	conf->pool_size = devs;
+
+	sc = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+		sizeof(struct stripe_queue) +
+		(devs-1)*sizeof(struct r5_queue_dev), 0, 0, NULL, NULL);
+
+	if (!sc)
+		return 1;
+	conf->sq_slab_cache = sc;
+
 	while (num--)
 		if (!grow_one_stripe(conf))
 			return 1;
@@ -992,7 +1035,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	LIST_HEAD(newstripes);
 	struct disk_info *ndisks;
 	int err = 0;
-	struct kmem_cache *sc;
+	struct kmem_cache *sc, *sc_q;
 	int i;
 
 	if (newsize <= conf->pool_size)
@@ -1001,21 +1044,40 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	md_allow_write(conf->mddev);
 
 	/* Step 1 */
-	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
+	sc = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
 			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
 			       0, 0, NULL, NULL);
 	if (!sc)
 		return -ENOMEM;
 
+	sc_q = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
+		    sizeof(struct stripe_queue) +
+		    (newsize-1)*sizeof(struct r5_queue_dev), 0, 0, NULL, NULL);
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
@@ -1024,8 +1086,10 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
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
@@ -1047,9 +1111,11 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
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
@@ -1080,7 +1146,8 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
 
-	conf->slab_cache = sc;
+	conf->sh_slab_cache = sc;
+	conf->sq_slab_cache = sc_q;
 	conf->active_name = 1-conf->active_name;
 	conf->pool_size = newsize;
 	return err;
@@ -1098,7 +1165,9 @@ static int drop_one_stripe(raid5_conf_t *conf)
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
@@ -1108,16 +1177,20 @@ static void shrink_stripes(raid5_conf_t *conf)
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
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	char b[BDEVNAME_SIZE];
@@ -1195,7 +1268,8 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 				    int error)
 {
  	struct stripe_head *sh = bi->bi_private;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
@@ -1225,12 +1299,10 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
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
@@ -1244,7 +1316,8 @@ static void raid5_build_block (struct stripe_head *sh, int i)
 	dev->req.bi_private = sh;
 
 	dev->flags = 0;
-	dev->sector = compute_blocknr(sh, i);
+	dev_q->sector = compute_blocknr(sh->sq->raid_conf, sh->disks,
+			sh->sector, sh->sq->pd_idx, i);
 }
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
@@ -1379,12 +1452,12 @@ static sector_t raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
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
@@ -1396,7 +1469,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	stripe = new_sector;
 	BUG_ON(new_sector != stripe);
 
-	if (i == sh->pd_idx)
+	if (i == pd_idx)
 		return 0;
 	switch(conf->level) {
 	case 4: break;
@@ -1404,14 +1477,14 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
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
@@ -1419,25 +1492,25 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
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
@@ -1451,7 +1524,7 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i)
 	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
-	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
+	if (check != sector || dummy1 != dd_idx || dummy2 != pd_idx) {
 		printk(KERN_ERR "compute_blocknr: map not correct\n");
 		return 0;
 	}
@@ -1518,8 +1591,9 @@ static void copy_data(int frombio, struct bio *bio,
 
 static void compute_parity6(struct stripe_head *sh, int method)
 {
-	raid6_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
+	struct stripe_queue *sq = sh->sq;
+	raid6_conf_t *conf = sq->raid_conf;
+	int i, pd_idx = sq->pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
 	struct bio *chosen;
 	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
 	void *ptrs[disks];
@@ -1535,9 +1609,9 @@ static void compute_parity6(struct stripe_head *sh, int method)
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
@@ -1550,9 +1624,9 @@ static void compute_parity6(struct stripe_head *sh, int method)
 		BUG();		/* Not implemented yet */
 	}
 
-	for (i = disks; i--;)
+	for (i = disks; i--; )
 		if (sh->dev[i].written) {
-			sector_t sector = sh->dev[i].sector;
+			sector_t sector = sq->dev[i].sector;
 			struct bio *wbi = sh->dev[i].written;
 			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
 				copy_data(1, wbi, sh->dev[i].page, sector);
@@ -1600,9 +1674,10 @@ static void compute_parity6(struct stripe_head *sh, int method)
 /* Compute one missing block */
 static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
+	struct stripe_queue *sq = sh->sq;
 	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sq->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 
 	pr_debug("compute_block_1, stripe %llu, idx %d\n",
@@ -1639,7 +1714,7 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 {
 	int i, count, disks = sh->disks;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sh->sq->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 	int d0_idx = raid6_next_disk(qd_idx, disks);
 	int faila, failb;
@@ -1701,8 +1776,9 @@ static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 static int
 handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 {
-	int i, pd_idx = sh->pd_idx, disks = sh->disks;
 	int locked = 0;
+	struct stripe_queue *sq = sh->sq;
+	int i, pd_idx = sq->pd_idx, disks = sh->disks;
 
 	if (rcw) {
 		/* if we are not expanding this is a proper write request, and
@@ -1719,8 +1795,9 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
 
-			if (dev->towrite) {
+			if (dev_q->towrite) {
 				set_bit(R5_LOCKED, &dev->flags);
 				if (!expand)
 					clear_bit(R5_UPTODATE, &dev->flags);
@@ -1739,6 +1816,8 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+
 			if (i == pd_idx)
 				continue;
 
@@ -1747,7 +1826,7 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 			 * written so we distinguish these blocks by the
 			 * R5_Wantprexor bit
 			 */
-			if (dev->towrite &&
+			if (dev_q->towrite &&
 			    (test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags))) {
 				set_bit(R5_Wantprexor, &dev->flags);
@@ -1780,7 +1859,8 @@ handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
 	struct bio **bip;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int firstwrite=0;
 
 	pr_debug("adding bh b#%llu to stripe s#%llu\n",
@@ -1788,14 +1868,14 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		(unsigned long long)sh->sector);
 
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	spin_lock_irq(&conf->device_lock);
 	if (forwrite) {
-		bip = &sh->dev[dd_idx].towrite;
+		bip = &sq->dev[dd_idx].towrite;
 		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
 			firstwrite = 1;
 	} else
-		bip = &sh->dev[dd_idx].toread;
+		bip = &sq->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
@@ -1810,7 +1890,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	*bip = bi;
 	bi->bi_phys_segments ++;
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
@@ -1819,21 +1899,21 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	if (conf->mddev->bitmap && firstwrite) {
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
 				  STRIPE_SECTORS, 0);
-		sh->bm_seq = conf->seq_flush+1;
+		sq->bm_seq = conf->seq_flush+1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 
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
@@ -1841,7 +1921,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
  overlap:
 	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 	return 0;
 }
 
@@ -1873,6 +1953,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 				struct bio **return_bi)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
+
 	for (i = disks; i--; ) {
 		struct bio *bi;
 		int bitmap_end = 0;
@@ -1888,8 +1970,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
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
@@ -1899,8 +1981,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 			wake_up(&conf->wait_for_overlap);
 
 		while (bi && bi->bi_sector <
-			sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
+			sq->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *nextbi = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (--bi->bi_phys_segments == 0) {
 				md_write_end(conf->mddev);
@@ -1914,8 +1996,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 		sh->dev[i].written = NULL;
 		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_sector <
-		       sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
+		       sq->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *bi2 = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (--bi->bi_phys_segments == 0) {
 				md_write_end(conf->mddev);
@@ -1931,15 +2013,15 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
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
@@ -1962,22 +2044,25 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
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
@@ -2060,18 +2145,22 @@ static void handle_issuing_new_read_requests6(struct stripe_head *sh,
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
@@ -2121,11 +2210,12 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 	struct stripe_head *sh, int disks, struct bio **return_bi)
 {
 	int i;
-	struct r5dev *dev;
+	struct stripe_queue *sq = sh->sq;
 
 	for (i = disks; i--; )
 		if (sh->dev[i].written) {
-			dev = &sh->dev[i];
+			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) &&
 				test_bit(R5_UPTODATE, &dev->flags)) {
 				/* We can return any write requests */
@@ -2136,8 +2226,8 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_sector <
-					dev->sector + STRIPE_SECTORS) {
-					wbi2 = r5_next_bio(wbi, dev->sector);
+					dev_q->sector + STRIPE_SECTORS) {
+					wbi2 = r5_next_bio(wbi, dev_q->sector);
 					if (--wbi->bi_phys_segments == 0) {
 						md_write_end(conf->mddev);
 						wbi->bi_next = *return_bi;
@@ -2145,7 +2235,7 @@ static void handle_completed_write_requests(raid5_conf_t *conf,
 					}
 					wbi = wbi2;
 				}
-				if (dev->towrite == NULL)
+				if (dev_q->towrite == NULL)
 					bitmap_end = 1;
 				spin_unlock_irq(&conf->device_lock);
 				if (bitmap_end)
@@ -2162,10 +2252,14 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
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
@@ -2175,7 +2269,7 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 				rmw += 2*disks;  /* cannot read it */
 		}
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
+		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sq->pd_idx &&
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		    test_bit(R5_Wantcompute, &dev->flags))) {
@@ -2191,7 +2285,9 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
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
@@ -2216,8 +2312,9 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
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
@@ -2259,7 +2356,8 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 		struct stripe_head *sh,	struct stripe_head_state *s,
 		struct r6_state *r6s, int disks)
 {
-	int rcw = 0, must_compute = 0, pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int rcw = 0, must_compute = 0, pd_idx = sq->pd_idx, i;
 	int qd_idx = r6s->qd_idx;
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
@@ -2355,6 +2453,7 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks)
 {
+	struct stripe_queue *sq = sh->sq;
 	set_bit(STRIPE_HANDLE, &sh->state);
 	/* Take one of the following actions:
 	 * 1/ start a check parity operation if (uptodate == disks)
@@ -2366,7 +2465,7 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
 		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			BUG_ON(s->uptodate != disks);
-			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+			clear_bit(R5_UPTODATE, &sh->dev[sq->pd_idx].flags);
 			sh->ops.count++;
 			s->uptodate--;
 		} else if (
@@ -2392,8 +2491,8 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
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
@@ -2418,9 +2517,10 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
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
@@ -2443,8 +2543,9 @@ static void handle_parity_checks6(raid5_conf_t *conf, struct stripe_head *sh,
 				int disks)
 {
 	int update_p = 0, update_q = 0;
+	struct stripe_queue *sq = sh->sq;
 	struct r5dev *dev;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sq->pd_idx;
 	int qd_idx = r6s->qd_idx;
 
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -2534,6 +2635,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 				struct r6_state *r6s)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
 
 	/* We have read all the blocks in this stripe and now we need to
 	 * copy some of them into a target stripe for expand.
@@ -2541,11 +2643,12 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 	struct dma_async_tx_descriptor *tx = NULL;
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
-		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
+		if (i != sq->pd_idx && (r6s && i != r6s->qd_idx)) {
 			int dd_idx, pd_idx, j;
 			struct stripe_head *sh2;
 
-			sector_t bn = compute_blocknr(sh, i);
+			sector_t bn = compute_blocknr(conf, sh->disks,
+						sh->sector, sq->pd_idx, i);
 			sector_t s = raid5_compute_sector(bn, conf->raid_disks,
 						conf->raid_disks -
 						conf->max_degraded, &dd_idx,
@@ -2573,7 +2676,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
-				if (j != sh2->pd_idx &&
+				if (j != sh2->sq->pd_idx &&
 				    (r6s && j != r6s->qd_idx) &&
 				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
 					break;
@@ -2610,7 +2713,8 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 
 static void handle_stripe5(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int disks = sh->disks, i;
 	struct bio *return_bi = NULL;
 	struct stripe_head_state s;
@@ -2620,10 +2724,10 @@ static void handle_stripe5(struct stripe_head *sh)
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
 
@@ -2636,18 +2740,19 @@ static void handle_stripe5(struct stripe_head *sh)
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
-			"written %p\n",	i, dev->flags, dev->toread, dev->read,
-			dev->towrite, dev->written);
+			"written %p\n",	i, dev->flags, dev_q->toread,
+			dev->read, dev_q->towrite, dev->written);
 
 		/* maybe we can request a biofill operation
 		 *
 		 * new wantfill requests are only permitted while
 		 * STRIPE_OP_BIOFILL is clear
 		 */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev_q->toread &&
 			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
 			set_bit(R5_Wantfill, &dev->flags);
 
@@ -2658,9 +2763,9 @@ static void handle_stripe5(struct stripe_head *sh)
 
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
@@ -2704,12 +2809,12 @@ static void handle_stripe5(struct stripe_head *sh)
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
@@ -2754,18 +2859,18 @@ static void handle_stripe5(struct stripe_head *sh)
 		/* All the 'written' buffers and the parity block are ready to
 		 * be written back to disk
 		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sq->pd_idx].flags));
 		for (i = disks; i--; ) {
 			dev = &sh->dev[i];
 			if (test_bit(R5_LOCKED, &dev->flags) &&
-				(i == sh->pd_idx || dev->written)) {
+				(i == sq->pd_idx || dev->written)) {
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
@@ -2853,7 +2958,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
 		s.locked += handle_write_operations5(sh, 0, 1);
 	} else if (s.expanded &&
@@ -2870,7 +2975,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (sh->ops.count)
 		pending = get_stripe_work(sh);
 
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	if (pending)
 		raid5_run_ops(sh, pending);
@@ -2881,10 +2986,11 @@ static void handle_stripe5(struct stripe_head *sh)
 
 static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 {
-	raid6_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid6_conf_t *conf = sq->raid_conf;
 	int disks = sh->disks;
 	struct bio *return_bi = NULL;
-	int i, pd_idx = sh->pd_idx;
+	int i, pd_idx = sq->pd_idx;
 	struct stripe_head_state s;
 	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
@@ -2896,7 +3002,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
 	memset(&s, 0, sizeof(s));
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -2908,24 +3014,28 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
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
+			dev->written);
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
@@ -2941,9 +3051,9 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
 
-		if (dev->toread)
+		if (dev_q->toread)
 			s.to_read++;
-		if (dev->towrite) {
+		if (dev_q->towrite) {
 			s.to_write++;
 			if (!test_bit(R5_OVERWRITE, &dev->flags))
 				s.non_overwrite++;
@@ -3050,7 +3160,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 					     conf->raid_disks);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
@@ -3069,7 +3179,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 	if (s.expanding && s.locked == 0)
 		handle_stripe_expansion(conf, sh, &r6s);
 
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	return_io(return_bi);
 
@@ -3135,7 +3245,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
 {
-	if (sh->raid_conf->level == 6)
+	if (sh->sq->raid_conf->level == 6)
 		handle_stripe6(sh, tmp_page);
 	else
 		handle_stripe5(sh);
@@ -3681,12 +3791,15 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		 */
 		for (j=sh->disks; j--;) {
 			sector_t s;
-			if (j == sh->pd_idx)
+			int pd_idx = sh->sq->pd_idx;
+
+			if (j == pd_idx)
 				continue;
 			if (conf->level == 6 &&
-			    j == raid6_next_disk(sh->pd_idx, sh->disks))
+			    j == raid6_next_disk(pd_idx, sh->disks))
 				continue;
-			s = compute_blocknr(sh, j);
+			s = compute_blocknr(conf, sh->disks, sh->sector,
+					    pd_idx, j);
 			if (s < (mddev->array_size<<1)) {
 				skipped = 1;
 				continue;
@@ -3738,6 +3851,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int pd_idx;
 	int raid_disks = conf->raid_disks;
 	sector_t max_sector = mddev->size << 1;
@@ -3794,6 +3908,8 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 		 */
 		schedule_timeout_uninterruptible(1);
 	}
+	sq = sh->sq;
+
 	/* Need to check if array will still be degraded after recovery/resync
 	 * We don't need to check the 'failed' flag as when that gets set,
 	 * recovery aborts.
@@ -3804,10 +3920,10 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	handle_stripe(sh, NULL);
 	release_stripe(sh);
@@ -3828,6 +3944,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int dd_idx, pd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
@@ -3861,6 +3978,7 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			return handled;
 		}
 
+		sq = sh->sq;
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
@@ -4327,9 +4445,10 @@ static int stop(mddev_t *mddev)
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
@@ -4349,7 +4468,7 @@ static void printall (struct seq_file *seq, raid5_conf_t *conf)
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < NR_HASH; i++) {
 		hlist_for_each_entry(sh, hn, &conf->stripe_hashtbl[i], hash) {
-			if (sh->raid_conf != conf)
+			if (sh->sq->raid_conf != conf)
 				continue;
 			print_sh(seq, sh);
 		}
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 93678f5..dff2732 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -158,16 +158,13 @@
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
-	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
 	/* stripe_operations
 	 * @pending - pending ops flags (set for request->issue->complete)
@@ -184,13 +181,13 @@ struct stripe_head {
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
+		struct bio	*read, *written;
+		unsigned long flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
@@ -209,6 +206,18 @@ struct r6_state {
 	int p_failed, q_failed, qd_idx, failed_num[2];
 };
 
+struct stripe_queue {
+	sector_t sector;
+	int pd_idx; /* parity disk index */
+	int bm_seq; /* sequence number for bitmap flushes */
+	spinlock_t lock;
+	struct raid5_private_data *raid_conf;
+	struct r5_queue_dev {
+		sector_t sector; /* hw starting sector for this block */
+		struct bio *toread, *towrite;
+	} dev[1];
+};
+
 /* Flags */
 #define	R5_UPTODATE	0	/* page contains current data */
 #define	R5_LOCKED	1	/* IO has been submitted on "req" */
@@ -328,8 +337,10 @@ struct raid5_private_data {
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
