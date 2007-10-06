From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH -mm 2/4] raid5: split allocation of stripe_heads and
	stripe_queues
Date: Sat, 06 Oct 2007 10:06:49 -0700
Message-ID: <20071006170649.23741.93602.stgit@dwillia2-linux.ch.intel.com>
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

Provide separate routines for allocating stripe_head and stripe_queue
objects and introduce 'io_weight' bitmaps to struct stripe_queue.

The io_weight bitmaps add an efficient way to determine what is pending in
a stripe_queue using 'hweight' in comparison to a 'for' loop.

Tested-by: Mr. James W. Laferriere <babydr@baby-dragons.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |  316 ++++++++++++++++++++++++++++++++------------
 include/linux/raid/raid5.h |   11 +-
 2 files changed, 239 insertions(+), 88 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a13de7d..7bc206c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -65,6 +65,7 @@
 #define	IO_THRESHOLD		1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
+#define STRIPE_QUEUE_SIZE 1 /* multiple of nr_stripes */
 
 #define stripe_hash(conf, sect)	(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
 
@@ -78,6 +79,8 @@
  * of the current stripe+device
  */
 #define r5_next_bio(bio, sect) ( ( (bio)->bi_sector + ((bio)->bi_size>>9) < sect + STRIPE_SECTORS) ? (bio)->bi_next : NULL)
+#define r5_io_weight_size(devs) (sizeof(unsigned long) * \
+				  (ALIGN(devs, BITS_PER_LONG) / BITS_PER_LONG))
 /*
  * The following can be used to debug the driver
  */
@@ -120,6 +123,21 @@ static void return_io(struct bio *return_bi)
 	}
 }
 
+#if BITS_PER_LONG == 32
+#define hweight hweight32
+#else
+#define hweight hweight64
+#endif
+static unsigned long io_weight(unsigned long *bitmap, int disks)
+{
+	unsigned long weight = hweight(*bitmap);
+
+	for (bitmap++; disks > BITS_PER_LONG; disks -= BITS_PER_LONG, bitmap++)
+		weight += hweight(*bitmap);
+
+	return weight;
+}
+
 static void print_raid5_conf (raid5_conf_t *conf);
 
 static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
@@ -236,36 +254,37 @@ static int grow_buffers(struct stripe_head *sh, int num)
 
 static void raid5_build_block (struct stripe_head *sh, int i);
 
-static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
+static void init_queue(struct stripe_queue *sq, sector_t sector,
+		int disks, int pd_idx);
+
+static void
+init_stripe(struct stripe_head *sh, struct stripe_queue *sq,
+	     sector_t sector, int pd_idx, int disks)
 {
-	raid5_conf_t *conf = sh->sq->raid_conf;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i;
 
+	pr_debug("init_stripe called, stripe %llu\n",
+		(unsigned long long)sector);
+
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
 	BUG_ON(sh->ops.pending || sh->ops.ack || sh->ops.complete);
+	init_queue(sh->sq, sector, disks, pd_idx);
 
 	CHECK_DEVLOCK();
-	pr_debug("init_stripe called, stripe %llu\n",
-		(unsigned long long)sh->sector);
 
 	remove_hash(sh);
 
 	sh->sector = sector;
-	sh->sq->pd_idx = pd_idx;
 	sh->state = 0;
 
-	sh->sq->disks = disks;
-
 	for (i = disks; i--;) {
 		struct r5dev *dev = &sh->dev[i];
-		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
-		if (dev_q->toread || dev_q->read || dev_q->towrite ||
-		    dev_q->written || test_bit(R5_LOCKED, &dev->flags)) {
-			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
-			       (unsigned long long)sh->sector, i, dev_q->toread,
-			       dev_q->read, dev_q->towrite, dev_q->written,
+		if (test_bit(R5_LOCKED, &dev->flags)) {
+			printk(KERN_ERR "sector=%llx i=%d %d\n",
+			       (unsigned long long)sector, i,
 			       test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
@@ -283,7 +302,7 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, in
 	CHECK_DEVLOCK();
 	pr_debug("__find_stripe, sector %llu\n", (unsigned long long)sector);
 	hlist_for_each_entry(sh, hn, stripe_hash(conf, sector), hash)
-		if (sh->sector == sector && sh->sq->disks == disks)
+		if (sh->sector == sector && disks == disks)
 			return sh;
 	pr_debug("__stripe %llu not in cache\n", (unsigned long long)sector);
 	return NULL;
@@ -326,7 +345,7 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 					);
 				conf->inactive_blocked = 0;
 			} else
-				init_stripe(sh, sector, pd_idx, disks);
+				init_stripe(sh, sh->sq, sector, pd_idx, disks);
 		} else {
 			if (atomic_read(&sh->count)) {
 			  BUG_ON(!list_empty(&sh->lru));
@@ -348,6 +367,39 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 	return sh;
 }
 
+static void init_queue(struct stripe_queue *sq, sector_t sector,
+		int disks, int pd_idx)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+	int i;
+
+	pr_debug("%s: %llu -> %llu [%p]\n",
+		__FUNCTION__, (unsigned long long) sq->sector,
+		(unsigned long long) sector, sq);
+
+	BUG_ON(io_weight(sq->to_read, disks));
+	BUG_ON(io_weight(sq->to_write, disks));
+	BUG_ON(io_weight(sq->overwrite, disks));
+
+	sq->sector = sector;
+	sq->pd_idx = pd_idx;
+	sq->disks = disks;
+
+	for (i = disks; i--;) {
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
+		if (dev_q->toread || dev_q->read || dev_q->towrite ||
+		    dev_q->written) {
+			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p\n",
+			       (unsigned long long)sq->sector, i, dev_q->toread,
+			       dev_q->read, dev_q->towrite, dev_q->written);
+			BUG();
+		}
+		dev_q->sector = compute_blocknr(conf, disks, sector, pd_idx, i);
+	}
+}
+
+
 /* test_and_ack_op() ensures that we only dequeue an operation once */
 #define test_and_ack_op(op, pend) \
 do {							\
@@ -570,21 +622,23 @@ static void ops_complete_biofill(void *stripe_head_ref)
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	raid5_conf_t *conf = sh->sq->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
-	for (i = sh->sq->disks; i--;) {
+	for (i = sq->disks; i--;) {
 		struct r5dev *dev = &sh->dev[i];
-		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
 			spin_lock_irq(&conf->device_lock);
 			dev_q->read = rbi = dev_q->toread;
 			dev_q->toread = NULL;
+			clear_bit(i, sq->to_read);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
 				dev_q->sector + STRIPE_SECTORS) {
@@ -669,9 +723,9 @@ static struct dma_async_tx_descriptor *
 ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	/* kernel stack size limits the total number of disks */
-	int disks = sh->sq->disks;
-	struct page *xor_srcs[disks];
 	struct stripe_queue *sq = sh->sq;
+	int disks = sq->disks;
+	struct page *xor_srcs[disks];
 	int count = 0, pd_idx = sq->pd_idx, i;
 
 	/* existing parity data subtracted */
@@ -698,9 +752,10 @@ ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
-	int disks = sh->sq->disks;
 	struct stripe_queue *sq = sh->sq;
-	int pd_idx = sq->pd_idx, i;
+	int disks = sq->disks;
+	int pd_idx = sq->pd_idx;
+	int i;
 
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
@@ -733,6 +788,7 @@ ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 			spin_lock(&sq->lock);
 			chosen = dev_q->towrite;
 			dev_q->towrite = NULL;
+			clear_bit(i, sq->to_write);
 			BUG_ON(dev_q->written);
 			wbi = dev_q->written = chosen;
 			spin_unlock(&sq->lock);
@@ -793,7 +849,9 @@ ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 	int disks = sq->disks;
 	struct page *xor_srcs[disks];
 
-	int count = 0, pd_idx = sh->sq->pd_idx, i;
+	int count = 0;
+	int pd_idx = sq->pd_idx;
+	int i;
 	struct page *xor_dest;
 	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 	unsigned long flags;
@@ -866,11 +924,14 @@ static void ops_complete_check(void *stripe_head_ref)
 static void ops_run_check(struct stripe_head *sh)
 {
 	/* kernel stack size limits the total number of disks */
-	int disks = sh->sq->disks;
+	struct stripe_queue *sq = sh->sq;
+	int disks = sq->disks;
 	struct page *xor_srcs[disks];
 	struct dma_async_tx_descriptor *tx;
 
-	int count = 0, pd_idx = sh->sq->pd_idx, i;
+	int count = 0;
+	int pd_idx = sq->pd_idx;
+	int i;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -897,7 +958,10 @@ static void ops_run_check(struct stripe_head *sh)
 
 static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 {
-	int overlap_clear = 0, i, disks = sh->sq->disks;
+	struct stripe_queue *sq = sh->sq;
+	int overlap_clear = 0;
+	int disks = sq->disks;
+	int i;
 	struct dma_async_tx_descriptor *tx = NULL;
 
 	if (test_bit(STRIPE_OP_BIOFILL, &pending)) {
@@ -926,43 +990,29 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 		ops_run_io(sh);
 
 	if (overlap_clear) {
-		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-			if (test_and_clear_bit(R5_Overlap, &dev->flags))
-				wake_up(&sh->sq->raid_conf->wait_for_overlap);
-		}
+		for (i = disks; i--;)
+			if (test_and_clear_bit(i, sq->overlap))
+				wake_up(&sq->raid_conf->wait_for_overlap);
 	}
 }
 
+static struct stripe_queue *grow_one_queue(raid5_conf_t *conf);
+
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
-	struct stripe_queue *sq;
-
 	sh = kmem_cache_alloc(conf->sh_slab_cache, GFP_KERNEL);
 	if (!sh)
 		return 0;
-
-	sq = kmem_cache_alloc(conf->sq_slab_cache, GFP_KERNEL);
-	if (!sq) {
-		kmem_cache_free(conf->sh_slab_cache, sh);
-		return 0;
-	}
-
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
-	memset(sq, 0, sizeof(*sq) +
-		(conf->raid_disks-1) * sizeof(struct r5_queue_dev));
-	sh->sq = sq;
-	sq->raid_conf = conf;
-	spin_lock_init(&sq->lock);
+	sh->sq = grow_one_queue(conf);
 
 	if (grow_buffers(sh, conf->raid_disks)) {
 		shrink_buffers(sh, conf->raid_disks);
 		kmem_cache_free(conf->sh_slab_cache, sh);
-		kmem_cache_free(conf->sq_slab_cache, sq);
 		return 0;
 	}
-	sq->disks = conf->raid_disks;
+
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
@@ -973,6 +1023,37 @@ static int grow_one_stripe(raid5_conf_t *conf)
 	return 1;
 }
 
+static struct stripe_queue *grow_one_queue(raid5_conf_t *conf)
+{
+	struct stripe_queue *sq;
+	int disks = conf->raid_disks;
+	void *weight_map;
+	sq = kmem_cache_alloc(conf->sq_slab_cache, GFP_KERNEL);
+	if (!sq)
+		return 0;
+	memset(sq, 0, (sizeof(*sq)+(disks-1) * sizeof(struct r5_queue_dev)) +
+		r5_io_weight_size(disks) + r5_io_weight_size(disks) +
+		r5_io_weight_size(disks) + r5_io_weight_size(disks));
+
+	/* set the queue weight bitmaps to the free space at the end of sq */
+	weight_map = ((void *) sq) + offsetof(typeof(*sq), dev) +
+			sizeof(struct r5_queue_dev) * disks;
+	sq->to_read = weight_map;
+	weight_map += r5_io_weight_size(disks);
+	sq->to_write = weight_map;
+	weight_map += r5_io_weight_size(disks);
+	sq->overwrite = weight_map;
+	weight_map += r5_io_weight_size(disks);
+	sq->overlap = weight_map;
+
+	spin_lock_init(&sq->lock);
+	sq->sector = MaxSector;
+	sq->raid_conf = conf;
+	sq->disks = disks;
+
+	return sq;
+}
+
 static int grow_stripes(raid5_conf_t *conf, int num)
 {
 	struct kmem_cache *sc;
@@ -993,9 +1074,12 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	conf->pool_size = devs;
 
 	sc = kmem_cache_create(conf->sq_cache_name[conf->active_name],
-		sizeof(struct stripe_queue) +
-		(devs-1)*sizeof(struct r5_queue_dev), 0, 0, NULL);
-
+			       (sizeof(struct stripe_queue)+(devs-1) *
+				sizeof(struct r5_queue_dev)) +
+				r5_io_weight_size(devs) +
+				r5_io_weight_size(devs) +
+				r5_io_weight_size(devs) +
+				r5_io_weight_size(devs), 0, 0, NULL);
 	if (!sc)
 		return 1;
 	conf->sq_slab_cache = sc;
@@ -1003,6 +1087,7 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	while (num--)
 		if (!grow_one_stripe(conf))
 			return 1;
+
 	return 0;
 }
 
@@ -1033,11 +1118,13 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	 * so we use GFP_NOIO allocations.
 	 */
 	struct stripe_head *osh, *nsh;
+	struct stripe_queue *nsq;
 	LIST_HEAD(newstripes);
+	LIST_HEAD(newqueues);
 	struct disk_info *ndisks;
 	int err = 0;
 	struct kmem_cache *sc, *sc_q;
-	int i;
+	int i, j;
 
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
@@ -1051,45 +1138,88 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	if (!sc)
 		return -ENOMEM;
 
-	sc_q = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
-		    sizeof(struct stripe_queue) +
-		    (newsize-1)*sizeof(struct r5_queue_dev), 0, 0, NULL);
+	sc_q = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+			       (sizeof(struct stripe_queue)+(newsize-1) *
+				sizeof(struct r5_queue_dev)) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize),
+				0, 0, NULL);
+
 	if (!sc_q) {
 		kmem_cache_destroy(sc);
 		return -ENOMEM;
 	}
 
 	for (i = conf->max_nr_stripes; i; i--) {
-		struct stripe_queue *nsq;
+		struct stripe_queue *nsq_per_sh[STRIPE_QUEUE_SIZE];
 
 		nsh = kmem_cache_alloc(sc, GFP_KERNEL);
 		if (!nsh)
 			break;
 
-		nsq = kmem_cache_alloc(sc_q, GFP_KERNEL);
-		if (!nsq) {
+		/* allocate STRIPE_QUEUE_SIZE queues per stripe */
+		for (j = 0; j < ARRAY_SIZE(nsq_per_sh); j++)
+			nsq_per_sh[j] = kmem_cache_alloc(sc_q, GFP_KERNEL);
+
+		for (j = 0; j < ARRAY_SIZE(nsq_per_sh); j++)
+			if (!nsq_per_sh[j])
+				break;
+
+		if (j <= ARRAY_SIZE(nsq_per_sh)) {
 			kmem_cache_free(sc, nsh);
+			do
+				if (nsq_per_sh[j])
+					kmem_cache_free(sc_q, nsq_per_sh[j]);
+			while (--j >= 0);
 			break;
 		}
 
 		memset(nsh, 0, sizeof(*nsh) + (newsize-1)*sizeof(struct r5dev));
-		memset(nsq, 0, sizeof(*nsq) +
-			(newsize-1)*sizeof(struct r5_queue_dev));
-
-		nsq->raid_conf = conf;
-		nsh->sq = nsq;
-		spin_lock_init(&nsq->lock);
-
 		list_add(&nsh->lru, &newstripes);
+
+		for (j = 0; j < ARRAY_SIZE(nsq_per_sh); j++) {
+			void *weight_map;
+			nsq = nsq_per_sh[j];
+			memset(nsq, 0, (sizeof(*nsq)+(newsize-1) *
+				sizeof(struct r5_queue_dev)) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize));
+			/* set the queue weight bitmaps to the free space at
+			 * the end of nsq
+			 */
+			weight_map = ((void *) nsq) +
+					offsetof(typeof(*nsq), dev) +
+					sizeof(struct r5_queue_dev) * newsize;
+			nsq->to_read = weight_map;
+			weight_map += r5_io_weight_size(newsize);
+			nsq->to_write = weight_map;
+			weight_map += r5_io_weight_size(newsize);
+			nsq->overwrite = weight_map;
+			weight_map += r5_io_weight_size(newsize);
+			nsq->overlap = weight_map;
+			nsq->raid_conf = conf;
+			spin_lock_init(&nsq->lock);
+			list_add(&nsq->list_node, &newqueues);
+		}
 	}
 	if (i) {
 		/* didn't get enough, give up */
 		while (!list_empty(&newstripes)) {
 			nsh = list_entry(newstripes.next, struct stripe_head, lru);
 			list_del(&nsh->lru);
-			kmem_cache_free(sc_q, nsh->sq);
 			kmem_cache_free(sc, nsh);
 		}
+		while (!list_empty(&newqueues)) {
+			nsq = list_entry(newqueues.next,
+					 struct stripe_queue,
+					 list_node);
+			list_del(&nsh->lru);
+			kmem_cache_free(sc_q, nsq);
+		}
 		kmem_cache_destroy(sc_q);
 		kmem_cache_destroy(sc);
 		return -ENOMEM;
@@ -1133,8 +1263,11 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 		err = -ENOMEM;
 
 	/* Step 4, return new stripes to service */
-	while(!list_empty(&newstripes)) {
+	while (!list_empty(&newstripes)) {
+		nsq = list_entry(newqueues.next, struct stripe_queue,
+					list_node);
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
+		list_del_init(&nsq->list_node);
 		list_del_init(&nsh->lru);
 		for (i=conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
@@ -1143,6 +1276,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 				if (!p)
 					err = -ENOMEM;
 			}
+		nsh->sq = nsq;
 		release_stripe(nsh);
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
@@ -1191,9 +1325,11 @@ static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 				   int error)
 {
  	struct stripe_head *sh = bi->bi_private;
-	raid5_conf_t *conf = sh->sq->raid_conf;
-	int disks = sh->sq->disks, i;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
+	int disks = sq->disks;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	int i;
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
 
@@ -1271,8 +1407,9 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
  	struct stripe_head *sh = bi->bi_private;
 	struct stripe_queue *sq = sh->sq;
 	raid5_conf_t *conf = sq->raid_conf;
-	int disks = sq->disks, i;
+	int disks = sq->disks;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	int i;
 
 	if (bi->bi_size)
 		return 1;
@@ -1303,7 +1440,6 @@ static int raid5_end_write_request (struct bio *bi, unsigned int bytes_done,
 static void raid5_build_block (struct stripe_head *sh, int i)
 {
 	struct r5dev *dev = &sh->dev[i];
-	struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
 	bio_init(&dev->req);
 	dev->req.bi_io_vec = &dev->vec;
@@ -1315,10 +1451,6 @@ static void raid5_build_block (struct stripe_head *sh, int i)
 
 	dev->req.bi_sector = sh->sector;
 	dev->req.bi_private = sh;
-
-	dev->flags = 0;
-	dev_q->sector = compute_blocknr(sh->sq->raid_conf, sh->sq->disks,
-			sh->sector, sh->sq->pd_idx, i);
 }
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
@@ -1613,8 +1745,9 @@ static void compute_parity6(struct stripe_head *sh, int method)
 			if (i != pd_idx && i != qd_idx && sq->dev[i].towrite) {
 				chosen = sq->dev[i].towrite;
 				sq->dev[i].towrite = NULL;
+				clear_bit(i, sq->to_write);
 
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				if (test_and_clear_bit(i, sq->overlap))
 					wake_up(&conf->wait_for_overlap);
 
 				BUG_ON(sq->dev[i].written);
@@ -1714,8 +1847,9 @@ static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 /* Compute two missing blocks */
 static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 {
-	int i, count, disks = sh->sq->disks;
-	int pd_idx = sh->sq->pd_idx;
+	struct stripe_queue *sq = sh->sq;
+	int i, count, disks = sq->disks;
+	int pd_idx = sq->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 	int d0_idx = raid6_next_disk(qd_idx, disks);
 	int faila, failb;
@@ -1917,10 +2051,11 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		if (sector >= sq->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
+
 	return 1;
 
  overlap:
-	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
+	set_bit(dd_idx, sq->overlap);
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sq->lock);
 	return 0;
@@ -1973,12 +2108,13 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 		/* fail all writes first */
 		bi = sq->dev[i].towrite;
 		sq->dev[i].towrite = NULL;
+		clear_bit(i, sq->to_write);
 		if (bi) {
 			s->to_write--;
 			bitmap_end = 1;
 		}
 
-		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+		if (test_and_clear_bit(i, sq->overlap))
 			wake_up(&conf->wait_for_overlap);
 
 		while (bi && bi->bi_sector <
@@ -2016,7 +2152,8 @@ handle_requests_to_failed_array(raid5_conf_t *conf, struct stripe_head *sh,
 		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
 			bi = sq->dev[i].toread;
 			sq->dev[i].toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+			clear_bit(i, sq->to_read);
+			if (test_and_clear_bit(i, sq->overlap))
 				wake_up(&conf->wait_for_overlap);
 			if (bi) s->to_read--;
 			while (bi && bi->bi_sector <
@@ -2718,7 +2855,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 static void handle_stripe5(struct stripe_head *sh)
 {
 	struct stripe_queue *sq = sh->sq;
-	raid5_conf_t *conf = sh->sq->raid_conf;
+	raid5_conf_t *conf = sq->raid_conf;
 	int disks = sq->disks, i;
 	struct bio *return_bi = NULL;
 	struct stripe_head_state s;
@@ -2746,6 +2883,8 @@ static void handle_stripe5(struct stripe_head *sh)
 		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
+		if (test_and_clear_bit(i, sq->overwrite))
+			set_bit(R5_OVERWRITE, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
 			"written %p\n",	i, dev->flags, dev_q->toread,
@@ -3024,6 +3163,8 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
+		if (test_and_clear_bit(i, sq->overwrite))
+			set_bit(R5_OVERWRITE, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev_q->toread, dev_q->towrite,
@@ -3035,7 +3176,8 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev_q->toread;
 			dev_q->toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &dev->flags))
+			clear_bit(i, sq->to_read);
+			if (test_and_clear_bit(i, sq->overlap))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
@@ -3735,6 +3877,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 */
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int pd_idx;
 	sector_t first_sector, last_sector;
 	int raid_disks = conf->previous_raid_disks;
@@ -3790,21 +3933,22 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		pd_idx = stripe_to_pdidx(sector_nr+i, conf, conf->raid_disks);
 		sh = get_active_stripe(conf, sector_nr+i,
 				       conf->raid_disks, pd_idx, 0);
+		sq = sh->sq;
 		set_bit(STRIPE_EXPANDING, &sh->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
 		 * array, then we need to zero those blocks
 		 */
-		for (j = sh->sq->disks; j--;) {
+		for (j = sq->disks; j--;) {
 			sector_t s;
 			int pd_idx = sh->sq->pd_idx;
 
 			if (j == pd_idx)
 				continue;
 			if (conf->level == 6 &&
-			    j == raid6_next_disk(pd_idx, sh->sq->disks))
+			    j == raid6_next_disk(pd_idx, sq->disks))
 				continue;
-			s = compute_blocknr(conf, sh->sq->disks, sh->sector,
+			s = compute_blocknr(conf, sq->disks, sh->sector,
 					    pd_idx, j);
 			if (s < (mddev->array_size<<1)) {
 				skipped = 1;
@@ -3950,7 +4094,6 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
 	struct stripe_head *sh;
-	struct stripe_queue *sq;
 	int dd_idx, pd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
@@ -3984,7 +4127,6 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			return handled;
 		}
 
-		sq = sh->sq;
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 857e2bf..fbe622c 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -207,8 +207,18 @@ struct r6_state {
 
 struct stripe_queue {
 	sector_t sector;
+	/* stripe queues are allocated with extra space to hold the following
+	 * four bitmaps.  One bit for each block in the stripe_head.  These
+	 * bitmaps enable use of hweight to count the number of blocks
+	 * undergoing read, write, overwrite.
+	 */
+	unsigned long *to_read;
+	unsigned long *to_write;
+	unsigned long *overwrite;
+	unsigned long *overlap; /* There is a pending overlapping request */
 	spinlock_t lock; /* protect bio lists and stripe_head state */
 	struct raid5_private_data *raid_conf;
+	struct list_head list_node;
 	int pd_idx; /* parity disk index */
 	int disks; /* disks in stripe */
 	struct r5_queue_dev {
@@ -225,7 +235,6 @@ struct stripe_queue {
 #define	R5_Insync	3	/* rdev && rdev->in_sync at start */
 #define	R5_Wantread	4	/* want to schedule a read */
 #define	R5_Wantwrite	5
-#define	R5_Overlap	7	/* There is a pending overlapping request on this block */
 #define	R5_ReadError	8	/* seen a read error here recently */
 #define	R5_ReWrite	9	/* have tried to over-write the readerror */
 
