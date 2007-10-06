From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH -mm 4/4] raid5: use stripe_queues to prioritize the "most
	deserving" requests (rev7)
Date: Sat, 06 Oct 2007 10:06:59 -0700
Message-ID: <20071006170659.23741.15728.stgit@dwillia2-linux.ch.intel.com>
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

Overview:
Taking advantage of the stripe_queue/stripe_head separation, this patch
implements a queue in front of the stripe cache.  A stripe_queue pool
accepts incoming requests.  As requests are attached, the weight of the
queue object is updated.  A workqueue (raid456_cache_arbiter) is introduced
to control the flow of requests to the stripe cache.  Pressure (weight of
the queue object) can push requests to be processed by the the cache
(raid5d).  raid5d also pulls requests when its 'handle' list is empty.

The cache arbiter prioritizes reads and full stripe-writes, as there is no
performance to be gained by delaying them.  Sub-stripe-width writes are
handled as before by a 'preread-active' mechanism.  The difference now is
that full-stripe-writes can pass delayed-writes waiting for the cache.
Previously there was no opportunity to make this decision, sub-width-writes
would occupy a stripe cache entry from the time they entered the delayed
list until they finished processing.

Flow:
1/ make_request calls get_active_queue, add_queue_bio, and handle_queue
2/ handle_queue tries, opportunistically, to allocate a stripe_head.  If
   the allocation succeeds the stripe_head is immediately processed otherwise
   the stripe_queue will be placed on a list to be handled by the cache
   arbiter.  The queue routing option is one of io_hi (for
   full-stripe-writes), io_lo (for reads and preread active stripes), delayed
   (for preread inactive stripes), and finally inactive if no i/o is pending.
3/ raid456_cache_arbiter runs and attaches stripe_queues to stripe_heads in
   priority order, io-hi then io-lo.  If the raid device is not plugged and
   there is nothing else to do it will transition delayed queues to the io-lo
   list.  Since there are more stripe_queues in the system than stripe_heads
   we will end up sleeping in get_active_stripe.  While sleeping requests can
   still enter the queue and hopefully promote sub-width-writes to
   full-stripe-writes.

Details:
* the number of stripe_queue objects in the pool is set at 2x the maximum
  number of stripes in the stripe_cache (STRIPE_QUEUE_SIZE).
* stripe_queues are tracked in a red-black-tree
* a stripe_queue is considered active while it has pending i/o
* get_active_stripe increments the count on the stripe_queue such that the
  stripe_queue will not be inactivated until after the stripe_head is
  inactivated

Changes in rev2:
* separate write and overwrite in the io_weight fields, i.e. an overwrite
  no longer implies a write
* rename queue_weight -> io_weight
* fix r5_io_weight_size
* implement support for sysfs changes to stripe_cache_size
* delete and re-add stripe queues from their management lists rather than
  moving them.  This guarantees that when the count is non-zero that the
  queue is not on a list (identical to stripe_head handling)
* __wait_for_inactive_queue was incorrectly using conf->inactive_blocked
  which is exclusively for the stripe_cache.  Added
  conf->inactive_queue_blocked and set the routine to wait until the number
  of active queues drops below 7/8's of the total before unblocking
  processing.  7/8's arises from the following: get_active_stripe waits for
  3/4's of the stripe cache i.e. 1/4 inactive. conf->max_nr_stripes / 4 ==
  conf->max_nr_stripes * STRIPE_QUEUE_SIZE / 8 iff STRIPE_QUEUE_SIZE == 2
* change raid5_congested to report whether the queue is congested and not
  the cache.

Changes in rev3:
* rename raid5qd => raid456_cache_arbiter
* make raid456_cache_arbiter the only thread that can block on a call to
  get_active_stripe, this ensures proper ordering of attachments
* added wait_for_cache_attach for routines outside the i/o path (like
  resync, and reshape) to request servicing from raid456_cache_arbiter
* change cache attachment priorities to io_hi (full-stripe-writes) and
  io_lo (reads and sub-width-stripe-writes)
* changed handle_queue to try to attempt a non-blocking cache attachment,
  this recovers some of the lost read throughput from rev2
* move flags back to r5dev to stay in sync with the buffers
* use sq->overwrite to set R5_OVERWRITE, fixes a data corruption issue with
  stale overwrite flags when attempting to use sq->overwrite in
  handle_stripe

Changes in rev4
* disconnect sq->sh and sh->sh->sq at the end of __release_queue
* remove the implicit get_active_stripe from get_active_queue to ensure
  that writes that need to be delayed go through raid456_cache_arbiter.
  This fixes the performance regression caused by increasing the stripe
  cache size.
* kill __get_active_stripe, not needed

Changes in rev5
* fix retry_aligned_read... check for null returns from get_active_queue
* workqueue leak fix, dmonakhov@openvz.org

Changes in rev6
* place reads/writes to the sq->to_write bitmap under sq->lock to synch up
  with updates to sh->dev[i].towrite
* Fix 'wait_for_stripe'/'wait_for_queue' confusion when performing
  atomic_dec_and_test(&conf->active_aligned_reads)
* Fix, retry_aligned_read needs to call release_stripe on its stripe_head
  after handle_queue, otherwise we deadlock on drive removal.  To make this
  more obvious handle_queue no longer implicitly releases the stripe_queue.
* kill wait_for_attach
* Fix up stripe_queue documentation

Changes in rev7
* split out the 'add_queue_bio' and object allocation changes into separate
  patches
* fix release_stripe/release_queue ordering
* refactor handle_queue and release_queue to remove STRIPE_QUEUE_HANDLE and
  sq->sh back references
* kill init_sh and allocate init_sq on the stack

Tested-by: Mr. James W. Laferriere <babydr@baby-dragons.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/md/raid5.c         |  843 +++++++++++++++++++++++++++++++++-----------
 include/linux/raid/raid5.h |   45 ++
 2 files changed, 666 insertions(+), 222 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d566fc9..eb7fd10 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -67,7 +67,7 @@
 #define	IO_THRESHOLD		1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
-#define STRIPE_QUEUE_SIZE 1 /* multiple of nr_stripes */
+#define STRIPE_QUEUE_SIZE 2 /* multiple of nr_stripes */
 
 #define stripe_hash(conf, sect)	(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
 
@@ -142,16 +142,66 @@ static unsigned long io_weight(unsigned long *bitmap, int disks)
 
 static void print_raid5_conf (raid5_conf_t *conf);
 
+/* __release_queue - route the stripe_queue based on pending i/o's.  The
+ * queue object is allowed to bounce around between 4 lists up until
+ * it is attached to a stripe_head.  The lists in order of priority are:
+ * 1/ overwrite: all data blocks are set to be overwritten, no prereads
+ * 2/ unaligned_read: read requests that get past chunk_aligned_read
+ * 3/ subwidth_write: write requests that require prereading
+ * 4/ delayed_q: write requests pending activation
+ */
+static void __release_queue(raid5_conf_t *conf, struct stripe_queue *sq)
+{
+	if (atomic_dec_and_test(&sq->count)) {
+		int disks = sq->disks;
+		int data_disks = disks - conf->max_degraded;
+		int to_write = io_weight(sq->to_write, disks);
+
+		BUG_ON(!list_empty(&sq->list_node));
+		BUG_ON(atomic_read(&conf->active_queues) == 0);
+
+		if (to_write &&
+		    io_weight(sq->overwrite, disks) == data_disks) {
+			list_add_tail(&sq->list_node, &conf->io_hi_q_list);
+			queue_work(conf->workqueue, &conf->stripe_queue_work);
+		} else if (io_weight(sq->to_read, disks)) {
+			list_add_tail(&sq->list_node, &conf->io_lo_q_list);
+			queue_work(conf->workqueue, &conf->stripe_queue_work);
+		} else if (to_write &&
+			   test_bit(STRIPE_QUEUE_PREREAD_ACTIVE, &sq->state)) {
+			list_add_tail(&sq->list_node, &conf->io_lo_q_list);
+			queue_work(conf->workqueue, &conf->stripe_queue_work);
+		} else if (to_write) {
+			list_add_tail(&sq->list_node, &conf->delayed_q_list);
+			blk_plug_device(conf->mddev->queue);
+		} else {
+			atomic_dec(&conf->active_queues);
+			if (test_and_clear_bit(STRIPE_QUEUE_PREREAD_ACTIVE,
+					       &sq->state)) {
+				atomic_dec(&conf->preread_active_queues);
+				if (atomic_read(&conf->preread_active_queues) <
+				    IO_THRESHOLD)
+					queue_work(conf->workqueue,
+						   &conf->stripe_queue_work);
+			}
+			if (!test_bit(STRIPE_QUEUE_EXPANDING, &sq->state)) {
+				list_add_tail(&sq->list_node,
+					      &conf->inactive_q_list);
+				wake_up(&conf->wait_for_queue);
+			}
+		}
+	}
+}
+
 static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 {
+	struct stripe_queue *sq = sh->sq;
+
 	if (atomic_dec_and_test(&sh->count)) {
 		BUG_ON(!list_empty(&sh->lru));
 		BUG_ON(atomic_read(&conf->active_stripes)==0);
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state)) {
-				list_add_tail(&sh->lru, &conf->delayed_list);
-				blk_plug_device(conf->mddev->queue);
-			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+			if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 				   sh->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 				blk_plug_device(conf->mddev->queue);
@@ -162,21 +212,29 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			BUG_ON(sh->ops.pending);
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
 			atomic_dec(&conf->active_stripes);
-			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			if (!test_bit(STRIPE_QUEUE_EXPANDING, &sq->state)) {
 				list_add_tail(&sh->lru, &conf->inactive_list);
 				wake_up(&conf->wait_for_stripe);
 				if (conf->retry_read_aligned)
 					md_wakeup_thread(conf->mddev->thread);
 			}
+			__release_queue(conf, sq);
+			sh->sq = NULL;
 		}
 	}
 }
+
+static void release_queue(struct stripe_queue *sq)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&conf->device_lock, flags);
+	__release_queue(conf, sq);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+}
+
 static void release_stripe(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->sq->raid_conf;
@@ -221,10 +279,28 @@ static struct stripe_head *get_free_stripe(raid5_conf_t *conf)
 	list_del_init(first);
 	remove_hash(sh);
 	atomic_inc(&conf->active_stripes);
+	BUG_ON(sh->sq != NULL);
 out:
 	return sh;
 }
 
+static struct stripe_queue *get_free_queue(raid5_conf_t *conf)
+{
+	struct stripe_queue *sq = NULL;
+	struct list_head *first;
+
+	CHECK_DEVLOCK();
+	if (list_empty(&conf->inactive_q_list))
+		goto out;
+	first = conf->inactive_q_list.next;
+	sq = list_entry(first, struct stripe_queue, list_node);
+	list_del_init(first);
+	rb_erase(&sq->rb_node, &conf->stripe_queue_tree);
+	atomic_inc(&conf->active_queues);
+out:
+	return sq;
+}
+
 static void shrink_buffers(struct stripe_head *sh, int num)
 {
 	struct page *p;
@@ -256,14 +332,11 @@ static int grow_buffers(struct stripe_head *sh, int num)
 
 static void raid5_build_block (struct stripe_head *sh, int i);
 
-static void init_queue(struct stripe_queue *sq, sector_t sector,
-		int disks, int pd_idx);
-
 static void
-init_stripe(struct stripe_head *sh, struct stripe_queue *sq,
-	     sector_t sector, int pd_idx, int disks)
+init_stripe(struct stripe_head *sh, struct stripe_queue *sq, int disks)
 {
 	raid5_conf_t *conf = sq->raid_conf;
+	sector_t sector = sq->sector;
 	int i;
 
 	pr_debug("init_stripe called, stripe %llu\n",
@@ -272,7 +345,6 @@ init_stripe(struct stripe_head *sh, struct stripe_queue *sq,
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
 	BUG_ON(sh->ops.pending || sh->ops.ack || sh->ops.complete);
-	init_queue(sh->sq, sector, disks, pd_idx);
 
 	CHECK_DEVLOCK();
 
@@ -310,68 +382,151 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector, in
 	return NULL;
 }
 
+static struct stripe_queue *__find_queue(raid5_conf_t *conf, sector_t sector)
+{
+	struct rb_node *n = conf->stripe_queue_tree.rb_node;
+	struct stripe_queue *sq;
+
+	pr_debug("%s, sector %llu\n", __FUNCTION__, (unsigned long long)sector);
+	while (n) {
+		sq = rb_entry(n, struct stripe_queue, rb_node);
+
+		if (sector < sq->sector)
+			n = n->rb_left;
+		else if (sector > sq->sector)
+			n = n->rb_right;
+		else
+			return sq;
+	}
+	pr_debug("__queue %llu not in tree\n", (unsigned long long)sector);
+	return NULL;
+}
+
+static struct stripe_queue *
+__insert_active_sq(raid5_conf_t *conf, sector_t sector, struct rb_node *node)
+{
+	struct rb_node **p = &conf->stripe_queue_tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct stripe_queue *sq;
+
+	while (*p) {
+		parent = *p;
+		sq = rb_entry(parent, struct stripe_queue, rb_node);
+
+		if (sector < sq->sector)
+			p = &(*p)->rb_left;
+		else if (sector > sq->sector)
+			p = &(*p)->rb_right;
+		else
+			return sq;
+	}
+
+	rb_link_node(node, parent, p);
+
+	return NULL;
+}
+
+static struct stripe_queue *
+insert_active_sq(raid5_conf_t *conf, sector_t sector, struct rb_node *node)
+{
+	struct stripe_queue *sq = __insert_active_sq(conf, sector, node);
+
+	if (sq)
+		goto out;
+	rb_insert_color(node, &conf->stripe_queue_tree);
+ out:
+	return sq;
+}
+
 static sector_t compute_blocknr(raid5_conf_t *conf, int raid_disks,
 	sector_t sector, int pd_idx, int i);
 
+static void
+pickup_cached_stripe(struct stripe_head *sh, struct stripe_queue *sq)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+
+	if (atomic_read(&sh->count))
+		BUG_ON(!list_empty(&sh->lru));
+	else {
+		if (!test_bit(STRIPE_HANDLE, &sh->state)) {
+			atomic_inc(&conf->active_stripes);
+			BUG_ON(sh->sq != NULL);
+		}
+		if (list_empty(&sh->lru) &&
+		    !test_bit(STRIPE_QUEUE_EXPANDING, &sq->state))
+			BUG();
+		list_del_init(&sh->lru);
+	}
+}
+
 static void unplug_slaves(mddev_t *mddev);
 static void raid5_unplug_device(struct request_queue *q);
 
-static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector, int disks,
-					     int pd_idx, int noblock)
+static void
+__wait_for_inactive_stripe(raid5_conf_t *conf, struct stripe_queue *sq)
 {
-	struct stripe_head *sh;
+	conf->inactive_blocked = 1;
+	wait_event_lock_irq(conf->wait_for_stripe,
+			    (!list_empty(&conf->inactive_list) &&
+			     (atomic_read(&conf->active_stripes)
+			      < (conf->max_nr_stripes * 3/4) ||
+			      !conf->inactive_blocked)),
+			    conf->device_lock,
+			    raid5_unplug_device(conf->mddev->queue));
+	conf->inactive_blocked = 0;
+}
 
-	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
+static struct stripe_head *
+get_active_stripe(struct stripe_queue *sq, int disks, int noblock)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+	sector_t sector = sq->sector;
+	struct stripe_head *sh;
 
 	spin_lock_irq(&conf->device_lock);
 
+	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sq->sector);
+
 	do {
-		wait_event_lock_irq(conf->wait_for_stripe,
-				    conf->quiesce == 0,
-				    conf->device_lock, /* nothing */);
+		/* try to get a cached stripe */
 		sh = __find_stripe(conf, sector, disks);
+
+		/* try to activate a new stripe */
 		if (!sh) {
 			if (!conf->inactive_blocked)
 				sh = get_free_stripe(conf);
 			if (noblock && sh == NULL)
 				break;
-			if (!sh) {
-				conf->inactive_blocked = 1;
-				wait_event_lock_irq(conf->wait_for_stripe,
-						    !list_empty(&conf->inactive_list) &&
-						    (atomic_read(&conf->active_stripes)
-						     < (conf->max_nr_stripes *3/4)
-						     || !conf->inactive_blocked),
-						    conf->device_lock,
-						    raid5_unplug_device(conf->mddev->queue)
-					);
-				conf->inactive_blocked = 0;
-			} else
-				init_stripe(sh, sh->sq, sector, pd_idx, disks);
-		} else {
-			if (atomic_read(&sh->count)) {
-			  BUG_ON(!list_empty(&sh->lru));
-			} else {
-				if (!test_bit(STRIPE_HANDLE, &sh->state))
-					atomic_inc(&conf->active_stripes);
-				if (list_empty(&sh->lru) &&
-				    !test_bit(STRIPE_EXPANDING, &sh->state))
-					BUG();
-				list_del_init(&sh->lru);
-			}
-		}
+			if (!sh)
+				__wait_for_inactive_stripe(conf, sq);
+			else
+				init_stripe(sh, sq, disks);
+		} else
+			pickup_cached_stripe(sh, sq);
 	} while (sh == NULL);
 
+	BUG_ON(sq->sector != sector);
+
 	if (sh) {
 		atomic_inc(&sh->count);
-		if (test_and_clear_bit(STRIPE_QUEUE_FIRSTWRITE,
-					&sh->sq->state)) {
+		if (test_and_clear_bit(STRIPE_QUEUE_FIRSTWRITE, &sq->state)) {
 			sh->bm_seq = conf->seq_flush+1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
+
+		if (sh->sq)
+			BUG_ON(sh->sq != sq);
+		else {
+			sh->sq = sq;
+			atomic_inc(&sq->count);
+		}
+
+		BUG_ON(!list_empty(&sq->list_node));
 	}
 
 	spin_unlock_irq(&conf->device_lock);
+
 	return sh;
 }
 
@@ -385,6 +540,7 @@ static void init_queue(struct stripe_queue *sq, sector_t sector,
 		__FUNCTION__, (unsigned long long) sq->sector,
 		(unsigned long long) sector, sq);
 
+	BUG_ON(atomic_read(&sq->count) != 0);
 	BUG_ON(io_weight(sq->to_read, disks));
 	BUG_ON(io_weight(sq->to_write, disks));
 	BUG_ON(io_weight(sq->overwrite, disks));
@@ -392,6 +548,7 @@ static void init_queue(struct stripe_queue *sq, sector_t sector,
 	sq->sector = sector;
 	sq->pd_idx = pd_idx;
 	sq->disks = disks;
+	sq->state = 0;
 
 	for (i = disks; i--;) {
 		struct r5_queue_dev *dev_q = &sq->dev[i];
@@ -405,6 +562,74 @@ static void init_queue(struct stripe_queue *sq, sector_t sector,
 		}
 		dev_q->sector = compute_blocknr(conf, disks, sector, pd_idx, i);
 	}
+
+	sq = insert_active_sq(conf, sector, &sq->rb_node);
+	if (unlikely(sq)) {
+		printk(KERN_ERR "%s: sq: %p sector: %llu bounced off the "
+			"stripe_queue rb_tree\n", __FUNCTION__, sq,
+			(unsigned long long) sq->sector);
+		BUG();
+	}
+}
+
+static void __wait_for_inactive_queue(raid5_conf_t *conf)
+{
+	conf->inactive_queue_blocked = 1;
+	wait_event_lock_irq(conf->wait_for_queue,
+			    !list_empty(&conf->inactive_q_list) &&
+			    (atomic_read(&conf->active_queues)
+			     < conf->max_nr_stripes *
+			     STRIPE_QUEUE_SIZE * 7/8 ||
+			    !conf->inactive_queue_blocked),
+			    conf->device_lock,
+			    /* nothing */);
+	conf->inactive_queue_blocked = 0;
+}
+
+
+static struct stripe_queue *
+get_active_queue(raid5_conf_t *conf, sector_t sector, int disks, int pd_idx,
+		  int noblock)
+{
+	struct stripe_queue *sq;
+
+	pr_debug("%s, sector %llu\n", __FUNCTION__,
+		(unsigned long long)sector);
+
+	spin_lock_irq(&conf->device_lock);
+
+	do {
+		wait_event_lock_irq(conf->wait_for_queue,
+				    conf->quiesce == 0,
+				    conf->device_lock,
+				    /* nothing */);
+		sq = __find_queue(conf, sector);
+		if (!sq) {
+			if (!conf->inactive_queue_blocked)
+				sq = get_free_queue(conf);
+			if (noblock && sq == NULL)
+				break;
+			if (!sq)
+				__wait_for_inactive_queue(conf);
+			else
+				init_queue(sq, sector, disks, pd_idx);
+		} else {
+			if (atomic_read(&sq->count))
+				BUG_ON(!list_empty(&sq->list_node));
+			else if (io_weight(sq->to_write, disks) == 0 &&
+				 io_weight(sq->to_read, disks) == 0)
+				atomic_inc(&conf->active_queues);
+
+			list_del_init(&sq->list_node);
+		}
+	} while (sq == NULL);
+
+	if (sq)
+		atomic_inc(&sq->count);
+
+	spin_unlock_irq(&conf->device_lock);
+
+	return sq;
 }
 
 
@@ -1004,16 +1229,15 @@ static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
 	}
 }
 
-static struct stripe_queue *grow_one_queue(raid5_conf_t *conf);
-
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
+	struct stripe_queue init_sq = { .raid_conf = conf };
+
 	sh = kmem_cache_alloc(conf->sh_slab_cache, GFP_KERNEL);
 	if (!sh)
 		return 0;
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
-	sh->sq = grow_one_queue(conf);
 
 	if (grow_buffers(sh, conf->raid_disks)) {
 		shrink_buffers(sh, conf->raid_disks);
@@ -1025,13 +1249,14 @@ static int grow_one_stripe(raid5_conf_t *conf)
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
 	INIT_LIST_HEAD(&sh->lru);
-	spin_lock_irq(&conf->device_lock);
-	__release_stripe(conf, sh);
-	spin_unlock_irq(&conf->device_lock);
+	atomic_set(&init_sq.count, 2); /* bypass release_queue() */
+	sh->sq = &init_sq;
+	release_stripe(sh);
+
 	return 1;
 }
 
-static struct stripe_queue *grow_one_queue(raid5_conf_t *conf)
+static int grow_one_queue(raid5_conf_t *conf)
 {
 	struct stripe_queue *sq;
 	int disks = conf->raid_disks;
@@ -1059,13 +1284,20 @@ static struct stripe_queue *grow_one_queue(raid5_conf_t *conf)
 	sq->raid_conf = conf;
 	sq->disks = disks;
 
-	return sq;
+	/* we just created an active queue so... */
+	atomic_set(&sq->count, 1);
+	atomic_inc(&conf->active_queues);
+	INIT_LIST_HEAD(&sq->list_node);
+	RB_CLEAR_NODE(&sq->rb_node);
+	release_queue(sq);
+
+	return 1;
 }
 
 static int grow_stripes(raid5_conf_t *conf, int num)
 {
 	struct kmem_cache *sc;
-	int devs = conf->raid_disks;
+	int devs = conf->raid_disks, num_q = num * STRIPE_QUEUE_SIZE;
 
 	sprintf(conf->sh_cache_name[0], "raid5-%s", mdname(conf->mddev));
 	sprintf(conf->sh_cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
@@ -1080,6 +1312,9 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 		return 1;
 	conf->sh_slab_cache = sc;
 	conf->pool_size = devs;
+	while (num--)
+		if (!grow_one_stripe(conf))
+			return 1;
 
 	sc = kmem_cache_create(conf->sq_cache_name[conf->active_name],
 			       (sizeof(struct stripe_queue)+(devs-1) *
@@ -1090,10 +1325,10 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 				r5_io_weight_size(devs), 0, 0, NULL);
 	if (!sc)
 		return 1;
-	conf->sq_slab_cache = sc;
 
-	while (num--)
-		if (!grow_one_stripe(conf))
+	conf->sq_slab_cache = sc;
+	while (num_q--)
+		if (!grow_one_queue(conf))
 			return 1;
 
 	return 0;
@@ -1126,7 +1361,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	 * so we use GFP_NOIO allocations.
 	 */
 	struct stripe_head *osh, *nsh;
-	struct stripe_queue *nsq;
+	struct stripe_queue *osq, *nsq;
 	LIST_HEAD(newstripes);
 	LIST_HEAD(newqueues);
 	struct disk_info *ndisks;
@@ -1209,7 +1444,9 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 			nsq->overwrite = weight_map;
 			weight_map += r5_io_weight_size(newsize);
 			nsq->overlap = weight_map;
+
 			nsq->raid_conf = conf;
+			RB_CLEAR_NODE(&nsq->rb_node);
 			spin_lock_init(&nsq->lock);
 			list_add(&nsq->list_node, &newqueues);
 		}
@@ -1236,6 +1473,19 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	 * OK, we have enough stripes, start collecting inactive
 	 * stripes and copying them over
 	 */
+	list_for_each_entry(nsq, &newqueues, list_node) {
+		spin_lock_irq(&conf->device_lock);
+		wait_event_lock_irq(conf->wait_for_queue,
+				    !list_empty(&conf->inactive_q_list),
+				    conf->device_lock,
+				    unplug_slaves(conf->mddev));
+		osq = get_free_queue(conf);
+		spin_unlock_irq(&conf->device_lock);
+		atomic_set(&nsq->count, 1);
+		kmem_cache_free(conf->sq_slab_cache, osq);
+	}
+	kmem_cache_destroy(conf->sq_slab_cache);
+
 	list_for_each_entry(nsh, &newstripes, lru) {
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
@@ -1250,11 +1500,9 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 			nsh->dev[i].page = osh->dev[i].page;
 		for( ; i<newsize; i++)
 			nsh->dev[i].page = NULL;
-		kmem_cache_free(conf->sq_slab_cache, osh->sq);
 		kmem_cache_free(conf->sh_slab_cache, osh);
 	}
 	kmem_cache_destroy(conf->sh_slab_cache);
-	kmem_cache_destroy(conf->sq_slab_cache);
 
 	/* Step 3.
 	 * At this point, we are holding all the stripes so the array
@@ -1272,10 +1520,8 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 
 	/* Step 4, return new stripes to service */
 	while (!list_empty(&newstripes)) {
-		nsq = list_entry(newqueues.next, struct stripe_queue,
-					list_node);
+		struct stripe_queue init_sq = { .raid_conf = conf };
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
-		list_del_init(&nsq->list_node);
 		list_del_init(&nsh->lru);
 		for (i=conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
@@ -1284,9 +1530,19 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 				if (!p)
 					err = -ENOMEM;
 			}
-		nsh->sq = nsq;
+		atomic_set(&init_sq.count, 2); /* bypass release_queue() */
+		nsh->sq = &init_sq;
 		release_stripe(nsh);
 	}
+
+	/* Step 4a, return new queues to service */
+	while (!list_empty(&newqueues)) {
+		nsq = list_entry(newqueues.next, struct stripe_queue,
+				 list_node);
+		list_del_init(&nsq->list_node);
+		release_queue(nsq);
+	}
+
 	/* critical section pass, GFP_NOIO no longer needed */
 
 	conf->sh_slab_cache = sc;
@@ -1308,18 +1564,33 @@ static int drop_one_stripe(raid5_conf_t *conf)
 		return 0;
 	BUG_ON(atomic_read(&sh->count));
 	shrink_buffers(sh, conf->pool_size);
-	if (sh->sq)
-		kmem_cache_free(conf->sq_slab_cache, sh->sq);
 	kmem_cache_free(conf->sh_slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
 	return 1;
 }
 
+static int drop_one_queue(raid5_conf_t *conf)
+{
+	struct stripe_queue *sq;
+
+	spin_lock_irq(&conf->device_lock);
+	sq = get_free_queue(conf);
+	spin_unlock_irq(&conf->device_lock);
+	if (!sq)
+		return 0;
+	kmem_cache_free(conf->sq_slab_cache, sq);
+	atomic_dec(&conf->active_queues);
+	return 1;
+}
+
 static void shrink_stripes(raid5_conf_t *conf)
 {
 	while (drop_one_stripe(conf))
 		;
 
+	while (drop_one_queue(conf))
+		;
+
 	if (conf->sh_slab_cache)
 		kmem_cache_destroy(conf->sh_slab_cache);
 	conf->sh_slab_cache = NULL;
@@ -2055,6 +2326,7 @@ static int add_queue_bio(struct stripe_queue *sq, struct bio *bi, int dd_idx,
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sq->dev[dd_idx].sector;
+
 		for (bi = sq->dev[dd_idx].towrite;
 		     sector < sq->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_sector <= sector;
@@ -2444,20 +2716,13 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old block "
-						"%d for r-m-w\n", i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					if (!test_and_set_bit(
-						STRIPE_OP_IO, &sh->ops.pending))
-						sh->ops.count++;
-					s->locked++;
-				} else {
-					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
+				pr_debug("Read_old block %d for r-m-w\n", i);
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				if (!test_and_set_bit(STRIPE_OP_IO,
+				    &sh->ops.pending))
+					sh->ops.count++;
+				s->locked++;
 			}
 		}
 	if (rcw <= rmw && rcw > 0)
@@ -2471,20 +2736,14 @@ static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old block "
-						"%d for Reconstruct\n", i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					if (!test_and_set_bit(
-						STRIPE_OP_IO, &sh->ops.pending))
-						sh->ops.count++;
-					s->locked++;
-				} else {
-					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
+				pr_debug("Read_old block "
+					 "%d for Reconstruct\n", i);
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				if (!test_and_set_bit(STRIPE_OP_IO,
+				    &sh->ops.pending))
+					sh->ops.count++;
+				s->locked++;
 			}
 		}
 	/* now if nothing is locked, and if we have enough data,
@@ -2540,21 +2799,12 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 			    && !test_bit(R5_LOCKED, &dev->flags) &&
 			    !test_bit(R5_UPTODATE, &dev->flags) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old stripe %llu "
-						"block %d for Reconstruct\n",
-					     (unsigned long long)sh->sector, i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					s->locked++;
-				} else {
-					pr_debug("Request delayed stripe %llu "
-						"block %d for Reconstruct\n",
-					     (unsigned long long)sh->sector, i);
-					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
+				pr_debug("Read_old stripe %llu "
+					"block %d for Reconstruct\n",
+				     (unsigned long long)sh->sector, i);
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				s->locked++;
 			}
 		}
 	/* now if nothing is locked, and if we have enough data, we can start a
@@ -2592,13 +2842,6 @@ static void handle_issuing_new_write_requests6(raid5_conf_t *conf,
 			}
 		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
 		set_bit(STRIPE_INSYNC, &sh->state);
-
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-			    IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
 	}
 }
 
@@ -2799,25 +3042,32 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 			int dd_idx, pd_idx, j;
 			struct stripe_head *sh2;
 			struct stripe_queue *sq2;
+			int disks = conf->raid_disks;
 
 			sector_t bn = compute_blocknr(conf, sq->disks,
 						sh->sector, sq->pd_idx, i);
 			sector_t s = raid5_compute_sector(bn, conf->raid_disks,
-						conf->raid_disks -
+						disks -
 						conf->max_degraded, &dd_idx,
 						&pd_idx, conf);
-			sh2 = get_active_stripe(conf, s, conf->raid_disks,
-						pd_idx, 1);
-			if (sh2 == NULL)
+			sq2 = get_active_queue(conf, s, disks, pd_idx, 1);
+			if (sq2)
+				sh2 = get_active_stripe(sq, disks, 1);
+			if (!(sq2 && sh2)) {
 				/* so far only the early blocks of this stripe
 				 * have been requested.  When later blocks
 				 * get requested, we will try again
 				 */
+				if (sq2)
+					release_queue(sq2);
 				continue;
-			if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-			   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
+			}
+
+			if (!test_bit(STRIPE_QUEUE_EXPANDING, &sq2->state) ||
+			    test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
 				/* must have already done this block */
 				release_stripe(sh2);
+				release_queue(sq2);
 				continue;
 			}
 
@@ -2826,7 +3076,6 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 				sh->dev[i].page, 0, 0, STRIPE_SIZE,
 				ASYNC_TX_DEP_ACK, tx, NULL, NULL);
 
-			sq2 = sh2->sq;
 			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
 			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
@@ -2840,6 +3089,7 @@ static void handle_stripe_expansion(raid5_conf_t *conf, struct stripe_head *sh,
 				set_bit(STRIPE_HANDLE, &sh2->state);
 			}
 			release_stripe(sh2);
+			release_queue(sq2);
 
 		}
 	/* done submitting copies, wait for them to complete */
@@ -2884,7 +3134,6 @@ static void handle_stripe5(struct stripe_head *sh)
 
 	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
-	clear_bit(STRIPE_DELAYED, &sh->state);
 
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
@@ -3033,12 +3282,6 @@ static void handle_stripe5(struct stripe_head *sh)
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-				IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
 	}
 
 	/* Now to consider new write requests and what else, if anything
@@ -3100,7 +3343,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	if (test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete) &&
 		!test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending)) {
 
-		clear_bit(STRIPE_EXPANDING, &sh->state);
+		clear_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
 
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
@@ -3113,7 +3356,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		}
 	}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+	if (s.expanded && test_bit(STRIPE_QUEUE_EXPANDING, &sq->state) &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		/* Need to write out all blocks after computing parity */
 		sq->disks = conf->raid_disks;
@@ -3163,7 +3406,6 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 
 	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
-	clear_bit(STRIPE_DELAYED, &sh->state);
 
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
@@ -3319,7 +3561,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			}
 		}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	if (s.expanded && test_bit(STRIPE_QUEUE_EXPANDING, &sq->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sq->disks = conf->raid_disks;
 		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
@@ -3330,7 +3572,7 @@ static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
-		clear_bit(STRIPE_EXPANDING, &sh->state);
+		clear_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
 	} else if (s.expanded) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
@@ -3413,20 +3655,41 @@ static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
 		handle_stripe5(sh);
 }
 
-
+static void handle_queue(struct stripe_queue *sq, int disks, int data_disks)
+{
+	int to_write = io_weight(sq->to_write, disks);
+
+	pr_debug("%s: sector %llu "
+		 "state: %#lx r: %lu w: %lu o: %lu\n", __FUNCTION__,
+		 (unsigned long long) sq->sector, sq->state,
+		 io_weight(sq->to_read, disks),
+		 io_weight(sq->to_write, disks),
+		 io_weight(sq->overwrite, disks));
+
+	/* continue to process i/o while the stripe is cached */
+	if (to_write == data_disks || io_weight(sq->to_read, disks) ||
+	    (to_write && test_bit(STRIPE_QUEUE_PREREAD_ACTIVE, &sq->state))) {
+		struct stripe_head *sh = get_active_stripe(sq, disks, 1);
+		if (sh) {
+			handle_stripe(sh, NULL);
+			release_stripe(sh);
+		}
+	}
+}
 
 static void raid5_activate_delayed(raid5_conf_t *conf)
 {
-	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
-		while (!list_empty(&conf->delayed_list)) {
-			struct list_head *l = conf->delayed_list.next;
-			struct stripe_head *sh;
-			sh = list_entry(l, struct stripe_head, lru);
-			list_del_init(l);
-			clear_bit(STRIPE_DELAYED, &sh->state);
-			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-				atomic_inc(&conf->preread_active_stripes);
-			list_add_tail(&sh->lru, &conf->handle_list);
+	if (atomic_read(&conf->preread_active_queues) < IO_THRESHOLD) {
+		struct stripe_queue *sq, *_sq;
+		pr_debug("%s\n", __FUNCTION__);
+		list_for_each_entry_safe(sq, _sq, &conf->delayed_q_list,
+					 list_node) {
+			list_del_init(&sq->list_node);
+			atomic_inc(&sq->count);
+			if (!test_and_set_bit(STRIPE_QUEUE_PREREAD_ACTIVE,
+						&sq->state))
+				atomic_inc(&conf->preread_active_queues);
+			__release_queue(conf, sq);
 		}
 	}
 }
@@ -3481,6 +3744,7 @@ static void raid5_unplug_device(struct request_queue *q)
 		conf->seq_flush++;
 		raid5_activate_delayed(conf);
 	}
+
 	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -3524,13 +3788,13 @@ static int raid5_congested(void *data, int bits)
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
 	/* No difference between reads and writes.  Just check
-	 * how busy the stripe_cache is
+	 * how busy the stripe_queue is
 	 */
-	if (conf->inactive_blocked)
+	if (conf->inactive_queue_blocked)
 		return 1;
 	if (conf->quiesce)
 		return 1;
-	if (list_empty_careful(&conf->inactive_list))
+	if (list_empty_careful(&conf->inactive_q_list))
 		return 1;
 
 	return 0;
@@ -3636,7 +3900,7 @@ static int raid5_align_endio(struct bio *bi, unsigned int bytes, int error)
 	if (!error && uptodate) {
 		bio_endio(raid_bi, bytes, 0);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
-			wake_up(&conf->wait_for_stripe);
+			wake_up(&conf->wait_for_queue);
 		return 0;
 	}
 
@@ -3722,7 +3986,7 @@ static int chunk_aligned_read(struct request_queue *q, struct bio * raid_bio)
 		}
 
 		spin_lock_irq(&conf->device_lock);
-		wait_event_lock_irq(conf->wait_for_stripe,
+		wait_event_lock_irq(conf->wait_for_queue,
 				    conf->quiesce == 0,
 				    conf->device_lock, /* nothing */);
 		atomic_inc(&conf->active_aligned_reads);
@@ -3745,7 +4009,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	unsigned int dd_idx, pd_idx;
 	sector_t new_sector;
 	sector_t logical_sector, last_sector;
-	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	const int rw = bio_data_dir(bi);
 	int remaining;
 
@@ -3807,16 +4071,18 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, disks, pd_idx, (bi->bi_rw&RWA_MASK));
-		if (sh) {
+		sq = get_active_queue(conf, new_sector, disks, pd_idx,
+					(bi->bi_rw & RWA_MASK));
+		if (sq) {
 			if (unlikely(conf->expand_progress != MaxSector)) {
 				/* expansion might have moved on while waiting for a
-				 * stripe, so we must do the range check again.
+				 * queue, so we must do the range check again.
 				 * Expansion could still move past after this
 				 * test, but as we are holding a reference to
-				 * 'sh', we know that if that happens,
-				 *  STRIPE_EXPANDING will get set and the expansion
-				 * won't proceed until we finish with the stripe.
+				 * 'sq', we know that if that happens,
+				 * STRIPE_QUEUE_EXPANDING will get set and the
+				 * expansion won't proceed until we finish
+				 * with the queue.
 				 */
 				int must_retry = 0;
 				spin_lock_irq(&conf->device_lock);
@@ -3826,7 +4092,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 					must_retry = 1;
 				spin_unlock_irq(&conf->device_lock);
 				if (must_retry) {
-					release_stripe(sh);
+					release_queue(sq);
 					goto retry;
 				}
 			}
@@ -3835,28 +4101,28 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			 */
 			if (logical_sector >= mddev->suspend_lo &&
 			    logical_sector < mddev->suspend_hi) {
-				release_stripe(sh);
+				release_queue(sq);
 				schedule();
 				goto retry;
 			}
 
-			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_queue_bio(sh->sq, bi, dd_idx,
+			if (test_bit(STRIPE_QUEUE_EXPANDING, &sq->state) ||
+			    !add_queue_bio(sq, bi, dd_idx,
 					   bi->bi_rw & RW_MASK)) {
 				/* Stripe is busy expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
 				 */
 				raid5_unplug_device(mddev->queue);
-				release_stripe(sh);
+				release_queue(sq);
 				schedule();
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			handle_stripe(sh, NULL);
-			release_stripe(sh);
+			handle_queue(sq, disks, data_disks);
+			release_queue(sq);
 		} else {
-			/* cannot get stripe for read-ahead, just give-up */
+			/* cannot get queue for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			finish_wait(&conf->wait_for_overlap, &w);
 			break;
@@ -3879,6 +4145,34 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	return 0;
 }
 
+static struct stripe_head *
+wait_for_inactive_cache(raid5_conf_t *conf, sector_t sector,
+			int disks, int pd_idx)
+{
+	struct stripe_head *sh;
+
+	do {
+		struct stripe_queue *sq;
+		wait_queue_t wait;
+		init_waitqueue_entry(&wait, current);
+		add_wait_queue(&conf->wait_for_stripe, &wait);
+		for (;;) {
+			sq = get_active_queue(conf, sector, disks, pd_idx, 0);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			sh = get_active_stripe(sq, disks, 1);
+			if (sh)
+				break;
+			release_queue(sq);
+			schedule();
+		}
+		current->state = TASK_RUNNING;
+		remove_wait_queue(&conf->wait_for_stripe, &wait);
+	} while (0);
+
+	return sh;
+}
+
+
 static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped)
 {
 	/* reshaping is quite different to recovery/resync so it is
@@ -3946,17 +4240,18 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		int j;
 		int skipped = 0;
 		pd_idx = stripe_to_pdidx(sector_nr+i, conf, conf->raid_disks);
-		sh = get_active_stripe(conf, sector_nr+i,
-				       conf->raid_disks, pd_idx, 0);
+		sh = wait_for_inactive_cache(conf, sector_nr+i,
+					     conf->raid_disks, pd_idx);
 		sq = sh->sq;
-		set_bit(STRIPE_EXPANDING, &sh->state);
+
+		set_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
 		 * array, then we need to zero those blocks
 		 */
 		for (j = sq->disks; j--;) {
 			sector_t s;
-			int pd_idx = sh->sq->pd_idx;
+			int pd_idx = sq->pd_idx;
 
 			if (j == pd_idx)
 				continue;
@@ -3978,6 +4273,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
 		release_stripe(sh);
+		release_queue(sq);
 	}
 	spin_lock_irq(&conf->device_lock);
 	conf->expand_progress = (sector_nr + i) * new_data_disks;
@@ -4001,11 +4297,14 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	while (first_sector <= last_sector) {
 		pd_idx = stripe_to_pdidx(first_sector, conf,
 					 conf->previous_raid_disks);
-		sh = get_active_stripe(conf, first_sector,
-				       conf->previous_raid_disks, pd_idx, 0);
+		sh = wait_for_inactive_cache(conf, first_sector,
+					     conf->previous_raid_disks,
+					     pd_idx);
+		sq = sh->sq;
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
+		release_queue(sq);
 		first_sector += STRIPE_SECTORS;
 	}
 	return conf->chunk_size>>9;
@@ -4065,14 +4364,8 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 	}
 
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
-	sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 1);
-	if (sh == NULL) {
-		sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 0);
-		/* make sure we don't swamp the stripe cache if someone else
-		 * is trying to get access
-		 */
-		schedule_timeout_uninterruptible(1);
-	}
+
+	sh = wait_for_inactive_cache(conf, sector_nr, raid_disks, pd_idx);
 	sq = sh->sq;
 
 	/* Need to check if array will still be degraded after recovery/resync
@@ -4092,6 +4385,7 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 
 	handle_stripe(sh, NULL);
 	release_stripe(sh);
+	release_queue(sq);
 
 	return STRIPE_SECTORS;
 }
@@ -4108,17 +4402,19 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	 * We *know* that this entire raid_bio is in one chunk, so
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
-	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int dd_idx, pd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
 	int remaining;
 	int handled = 0;
+	int disks = conf->raid_disks;
+	int data_disks = disks - conf->max_degraded;
 
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(	logical_sector,
-					conf->raid_disks,
-					conf->raid_disks - conf->max_degraded,
+					disks,
+					data_disks,
 					&dd_idx,
 					&pd_idx,
 					conf);
@@ -4128,30 +4424,36 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 	     logical_sector += STRIPE_SECTORS,
 		     sector += STRIPE_SECTORS,
 		     scnt++) {
+		struct stripe_head *sh;
 
 		if (scnt < raid_bio->bi_hw_segments)
 			/* already done this stripe */
 			continue;
 
-		sh = get_active_stripe(conf, sector, conf->raid_disks, pd_idx, 1);
-
-		if (!sh) {
-			/* failed to get a stripe - must wait */
+		sq = get_active_queue(conf, sector, disks, pd_idx, 1);
+		if (sq)
+			sh = get_active_stripe(sq, disks, 1);
+		if (!(sq && sh)) {
+			/* failed to get a queue/stripe - must wait */
 			raid_bio->bi_hw_segments = scnt;
 			conf->retry_read_aligned = raid_bio;
+			if (sq)
+				release_queue(sq);
 			return handled;
 		}
 
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
-		if (!add_queue_bio(sh->sq, raid_bio, dd_idx, 0)) {
+		if (!add_queue_bio(sq, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
+			release_queue(sq);
 			raid_bio->bi_hw_segments = scnt;
 			conf->retry_read_aligned = raid_bio;
 			return handled;
 		}
 
-		handle_stripe(sh, NULL);
+		handle_queue(sq, disks, data_disks);
 		release_stripe(sh);
+		release_queue(sq);
 		handled++;
 	}
 	spin_lock_irq(&conf->device_lock);
@@ -4166,11 +4468,63 @@ static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
 			        ? 0 : -EIO);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
-		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_queue);
 	return handled;
 }
 
+static void raid456_cache_arbiter(struct work_struct *work)
+{
+	raid5_conf_t *conf = container_of(work, raid5_conf_t,
+					  stripe_queue_work);
+	struct list_head *sq_entry;
+	int attach = 0;
+
+	/* attach queues to stripes in priority order */
+	pr_debug("+++ %s active\n", __FUNCTION__);
+	spin_lock_irq(&conf->device_lock);
+	do {
+		sq_entry = NULL;
+		if (!list_empty(&conf->io_hi_q_list))
+			sq_entry = conf->io_hi_q_list.next;
+		else if (!list_empty(&conf->io_lo_q_list))
+			sq_entry = conf->io_lo_q_list.next;
+
+		/* "these aren't the droids you're looking for..."
+		 * do not handle the delayed list while there are better
+		 * things to do
+		 */
+		if (!sq_entry &&
+		    atomic_read(&conf->preread_active_queues) <
+		    IO_THRESHOLD && !blk_queue_plugged(conf->mddev->queue) &&
+		    !list_empty(&conf->delayed_q_list)) {
+			raid5_activate_delayed(conf);
+			sq_entry = conf->io_lo_q_list.next;
+		}
+
+		if (sq_entry) {
+			struct stripe_queue *sq;
+			struct stripe_head *sh;
+			sq = list_entry(sq_entry, struct stripe_queue,
+					list_node);
+
+			list_del_init(sq_entry);
+			atomic_inc(&sq->count);
+			BUG_ON(atomic_read(&sq->count) != 1);
 
+			spin_unlock_irq(&conf->device_lock);
+			sh = get_active_stripe(sq, conf->raid_disks, 0);
+			spin_lock_irq(&conf->device_lock);
+
+			set_bit(STRIPE_HANDLE, &sh->state);
+			__release_stripe(conf, sh);
+			__release_queue(conf, sq);
+			attach++;
+		}
+	} while (sq_entry);
+	spin_unlock_irq(&conf->device_lock);
+	pr_debug("%d stripe(s) attached\n", attach);
+	pr_debug("--- %s inactive\n", __FUNCTION__);
+}
 
 /*
  * This is our raid5 kernel thread.
@@ -4204,12 +4558,6 @@ static void raid5d (mddev_t *mddev)
 			activate_bit_delay(conf);
 		}
 
-		if (list_empty(&conf->handle_list) &&
-		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !blk_queue_plugged(mddev->queue) &&
-		    !list_empty(&conf->delayed_list))
-			raid5_activate_delayed(conf);
-
 		while ((bio = remove_bio_from_retry(conf))) {
 			int ok;
 			spin_unlock_irq(&conf->device_lock);
@@ -4221,6 +4569,7 @@ static void raid5d (mddev_t *mddev)
 		}
 
 		if (list_empty(&conf->handle_list)) {
+			queue_work(conf->workqueue, &conf->stripe_queue_work);
 			async_tx_issue_pending_all();
 			break;
 		}
@@ -4263,7 +4612,8 @@ raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	char *end;
-	int new;
+	int new, queue, i;
+
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
@@ -4279,9 +4629,21 @@ raid5_store_stripe_cache_size(mddev_t *mddev, const char *page, size_t len)
 			conf->max_nr_stripes--;
 		else
 			break;
+
+		for (i = 0, queue = 0; i < STRIPE_QUEUE_SIZE; i++)
+			queue += drop_one_queue(conf);
+
+		if (queue < STRIPE_QUEUE_SIZE)
+			break;
 	}
 	md_allow_write(mddev);
 	while (new > conf->max_nr_stripes) {
+		for (i = 0, queue = 0; i < STRIPE_QUEUE_SIZE; i++)
+			queue += grow_one_queue(conf);
+
+		if (queue < STRIPE_QUEUE_SIZE)
+			break;
+
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;
 		else break;
@@ -4307,9 +4669,23 @@ stripe_cache_active_show(mddev_t *mddev, char *page)
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static ssize_t
+stripe_queue_active_show(mddev_t *mddev, char *page)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	if (conf)
+		return sprintf(page, "%d\n", atomic_read(&conf->active_queues));
+	else
+		return 0;
+}
+
+static struct md_sysfs_entry
+raid5_stripequeue_active = __ATTR_RO(stripe_queue_active);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
+	&raid5_stripequeue_active.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -4410,16 +4786,29 @@ static int run(mddev_t *mddev)
 		if (!conf->spare_page)
 			goto abort;
 	}
+
+	sprintf(conf->workqueue_name, "%s_cache_arb",
+		mddev->gendisk->disk_name);
+	conf->workqueue = create_singlethread_workqueue(conf->workqueue_name);
+	if (!conf->workqueue)
+		goto abort;
+
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
+	init_waitqueue_head(&conf->wait_for_queue);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
-	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
+	INIT_LIST_HEAD(&conf->io_hi_q_list);
+	INIT_LIST_HEAD(&conf->io_lo_q_list);
+	INIT_LIST_HEAD(&conf->delayed_q_list);
+	INIT_LIST_HEAD(&conf->inactive_q_list);
 	atomic_set(&conf->active_stripes, 0);
-	atomic_set(&conf->preread_active_stripes, 0);
+	atomic_set(&conf->active_queues, 0);
+	atomic_set(&conf->preread_active_queues, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
+	INIT_WORK(&conf->stripe_queue_work, raid456_cache_arbiter);
 
 	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
@@ -4519,6 +4908,8 @@ static int run(mddev_t *mddev)
 		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
 			memory, mdname(mddev));
 
+	conf->stripe_queue_tree = RB_ROOT;
+
 	if (mddev->degraded == 0)
 		printk("raid5: raid level %d set %s active with %d out of %d"
 			" devices, algorithm %d\n", conf->level, mdname(mddev), 
@@ -4575,6 +4966,8 @@ static int run(mddev_t *mddev)
 abort:
 	if (conf) {
 		print_raid5_conf(conf);
+		if (conf->workqueue)
+			destroy_workqueue(conf->workqueue);
 		safe_put_page(conf->spare_page);
 		kfree(conf->disks);
 		kfree(conf->stripe_hashtbl);
@@ -4599,6 +4992,7 @@ static int stop(mddev_t *mddev)
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
 	kfree(conf->disks);
+	destroy_workqueue(conf->workqueue);
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;
@@ -4608,29 +5002,50 @@ static int stop(mddev_t *mddev)
 static void print_sh (struct seq_file *seq, struct stripe_head *sh)
 {
 	int i;
-	struct stripe_queue *sq = sh->sq;
 
-	seq_printf(seq, "sh %llu, pd_idx %d, state %ld.\n",
-		   (unsigned long long)sh->sector, sq->pd_idx, sh->state);
+	seq_printf(seq, "sh %llu, state %ld.\n",
+		   (unsigned long long)sh->sector, sh->state);
 	seq_printf(seq, "sh %llu,  count %d.\n",
 		   (unsigned long long)sh->sector, atomic_read(&sh->count));
 	seq_printf(seq, "sh %llu, ", (unsigned long long)sh->sector);
-	for (i = 0; i < sq->disks; i++)
+	for (i = 0; i < sh->sq->disks; i++) {
 		seq_printf(seq, "(cache%d: %p %ld) ",
 			   i, sh->dev[i].page, sh->dev[i].flags);
 	seq_printf(seq, "\n");
 }
 
-static void printall (struct seq_file *seq, raid5_conf_t *conf)
+static void print_sq(struct seq_file *seq, struct stripe_queue *sq)
 {
+	int disks = sq->disks;
+
+	seq_printf(seq, "sq %llu, pd_idx %d, state %ld.\n",
+		   (unsigned long long)sq->sector, sq->pd_idx, sq->state);
+	seq_printf(seq, "sq %llu,  count %d to_write: %lu to_read: %lu "
+		   "overwrite: %lu\n", (unsigned long long)sq->sector,
+		   atomic_read(&sq->count), io_weight(sq->to_write, disks),
+		   io_weight(sq->to_read, disks),
+		   io_weight(sq->overwrite, disks));
+	seq_printf(seq, "sq %llu, ", (unsigned long long)sq->sector);
+}
+
+static void printall(struct seq_file *seq, raid5_conf_t *conf)
+{
+	struct stripe_queue *sq;
 	struct stripe_head *sh;
+	struct rb_node *rbn;
 	struct hlist_node *hn;
 	int i;
 
 	spin_lock_irq(&conf->device_lock);
+	rbn = rb_first(&conf->stripe_queue_tree);
+	while (rbn) {
+		sq = rb_entry(rbn, struct stripe_queue, rb_node);
+		print_sq(seq, sq);
+		rbn = rb_next(rbn);
+	}
 	for (i = 0; i < NR_HASH; i++) {
 		hlist_for_each_entry(sh, hn, &conf->stripe_hashtbl[i], hash) {
-			if (sh->sq->raid_conf != conf)
+			if (!sh->sq)
 				continue;
 			print_sh(seq, sh);
 		}
@@ -4952,8 +5367,8 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 	case 1: /* stop all writes */
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 1;
-		wait_event_lock_irq(conf->wait_for_stripe,
-				    atomic_read(&conf->active_stripes) == 0 &&
+		wait_event_lock_irq(conf->wait_for_queue,
+				    atomic_read(&conf->active_queues) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
 				    conf->device_lock, /* nothing */);
 		spin_unlock_irq(&conf->device_lock);
@@ -4962,7 +5377,7 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 	case 0: /* re-enable writes */
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 0;
-		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_queue);
 		wake_up(&conf->wait_for_overlap);
 		spin_unlock_irq(&conf->device_lock);
 		break;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 3d4938c..7ff0c9c 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -3,6 +3,7 @@
 
 #include <linux/raid/md.h>
 #include <linux/raid/xor.h>
+#include <linux/rbtree.h>
 
 /*
  *
@@ -181,7 +182,7 @@ struct stripe_head {
 		int		   count;
 		u32		   zero_sum_result;
 	} ops;
-	struct stripe_queue *sq;
+	struct stripe_queue *sq; /* list of pending bios for this stripe */
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
@@ -191,7 +192,7 @@ struct stripe_head {
 };
 
 /* stripe_head_state - collects and tracks the dynamic state of a stripe_head
- *     for handle_stripe.  It is only valid under spin_lock(sh->lock);
+ *     for handle_stripe.  It is only valid under spin_lock(sq->lock);
  */
 struct stripe_head_state {
 	int syncing, expanding, expanded;
@@ -205,7 +206,16 @@ struct r6_state {
 	int p_failed, q_failed, qd_idx, failed_num[2];
 };
 
+/* stripe_queue
+ * @sector - rb_tree key
+ * @lock
+ * @sh - our stripe_head in the cache
+ * @list_node - once this queue object satisfies some constraint (like full
+ *  stripe write) it is placed on a list for processing by the cache
+ * @overwrite_count - how many blocks are set to be overwritten
+ */
 struct stripe_queue {
+	struct rb_node rb_node;
 	sector_t sector;
 	/* stripe queues are allocated with extra space to hold the following
 	 * four bitmaps.  One bit for each block in the stripe_head.  These
@@ -222,6 +232,7 @@ struct stripe_queue {
 	struct list_head list_node;
 	int pd_idx; /* parity disk index */
 	int disks; /* disks in stripe */
+	atomic_t count;
 	struct r5_queue_dev {
 		sector_t sector; /* hw starting sector for this block */
 		struct bio *toread, *read, *towrite, *written;
@@ -263,11 +274,8 @@ struct stripe_queue {
 #define STRIPE_HANDLE		2
 #define	STRIPE_SYNCING		3
 #define	STRIPE_INSYNC		4
-#define	STRIPE_PREREAD_ACTIVE	5
-#define	STRIPE_DELAYED		6
 #define	STRIPE_DEGRADED		7
 #define	STRIPE_BIT_DELAY	8
-#define	STRIPE_EXPANDING	9
 #define	STRIPE_EXPAND_SOURCE	10
 #define	STRIPE_EXPAND_READY	11
 /*
@@ -292,6 +300,8 @@ struct stripe_queue {
  * Stripe-queue state
  */
 #define STRIPE_QUEUE_FIRSTWRITE 0
+#define STRIPE_QUEUE_EXPANDING 1
+#define STRIPE_QUEUE_PREREAD_ACTIVE 2
 
 /*
  * Plugging:
@@ -324,6 +334,7 @@ struct disk_info {
 
 struct raid5_private_data {
 	struct hlist_head	*stripe_hashtbl;
+	struct rb_root		stripe_queue_tree;
 	mddev_t			*mddev;
 	struct disk_info	*spare;
 	int			chunk_size, level, algorithm;
@@ -339,12 +350,22 @@ struct raid5_private_data {
 	int			previous_raid_disks;
 
 	struct list_head	handle_list; /* stripes needing handling */
-	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
+	struct list_head	delayed_q_list; /* queues that have plugged
+						 * requests
+						 */
+	struct list_head	io_hi_q_list; /* reads and full stripe writes */
+	struct list_head	io_lo_q_list; /* sub-stripe-width writes */
+	struct workqueue_struct *workqueue; /* attaches sq's to sh's */
+	struct work_struct	stripe_queue_work;
+	char 			workqueue_name[20];
+
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
-	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;
+	atomic_t		preread_active_queues; /* queues with scheduled
+							* io
+							*/
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
 	/* unfortunately we need two cache names as we temporarily have
@@ -367,12 +388,20 @@ struct raid5_private_data {
 	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
 
 	/*
+	 * Free queue pool
+	 */
+	atomic_t		active_queues;
+	struct list_head	inactive_q_list;
+	wait_queue_head_t	wait_for_queue;
+	wait_queue_head_t	wait_for_overlap;
+	int			inactive_queue_blocked;
+
+	/*
 	 * Free stripes pool
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
 	wait_queue_head_t	wait_for_stripe;
-	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
 							 * waiting for 25% to be free
 							 */
