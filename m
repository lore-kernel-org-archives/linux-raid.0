From: Dan Williams <dan.j.williams@intel.com>
Subject: [md-accel PATCH 07/19] md: raid5_run_ops - run stripe operations
	outside sh->lock
Date: Tue, 26 Jun 2007 18:51:10 -0700
Message-ID: <20070627015110.18962.54419.stgit@dwillia2-linux.ch.intel.com>
References: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070627014823.18962.96398.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, akpm@linux-foundation.org, davem@davemloft.net, christopher.leech@intel.com, shannon.nelson@intel.com, herbert@gondor.apana.org.au, jeff@garzik.org
List-Id: linux-raid.ids

When the raid acceleration work was proposed, Neil laid out the following
attack plan:

1/ move the xor and copy operations outside spin_lock(&sh->lock)
2/ find/implement an asynchronous offload api

The raid5_run_ops routine uses the asynchronous offload api (async_tx) and
the stripe_operations member of a stripe_head to carry out xor+copy
operations asynchronously, outside the lock.

To perform operations outside the lock a new set of state flags is needed
to track new requests, in-flight requests, and completed requests.  In this
new model handle_stripe is tasked with scanning the stripe_head for work,
updating the stripe_operations structure, and finally dropping the lock and
calling raid5_run_ops for processing.  The following flags outline the
requests that handle_stripe can make of raid5_run_ops:

STRIPE_OP_BIOFILL
 - copy data into request buffers to satisfy a read request
STRIPE_OP_COMPUTE_BLK
 - generate a missing block in the cache from the other blocks
STRIPE_OP_PREXOR
 - subtract existing data as part of the read-modify-write process
STRIPE_OP_BIODRAIN
 - copy data out of request buffers to satisfy a write request
STRIPE_OP_POSTXOR
 - recalculate parity for new data that has entered the cache
STRIPE_OP_CHECK
 - verify that the parity is correct
STRIPE_OP_IO
 - submit i/o to the member disks (note this was already performed outside
   the stripe lock, but it made sense to add it as an operation type

The flow is:
1/ handle_stripe sets STRIPE_OP_* in sh->ops.pending
2/ raid5_run_ops reads sh->ops.pending, sets sh->ops.ack, and submits the
   operation to the async_tx api
3/ async_tx triggers the completion callback routine to set
   sh->ops.complete and release the stripe
4/ handle_stripe runs again to finish the operation and optionally submit
   new operations that were previously blocked

Note this patch just defines raid5_run_ops, subsequent commits (one per
major operation type) modify handle_stripe to take advantage of this
routine.

Changelog:
* removed ops_complete_biodrain in favor of ops_complete_postxor and
  ops_complete_write.
* removed the raid5_run_ops workqueue
* call bi_end_io for reads in ops_complete_biofill, saves a call to
  handle_stripe
* explicitly handle the 2-disk raid5 case (xor becomes memcpy), Neil Brown
* fix race between async engines and bi_end_io call for reads, Neil Brown
* remove unnecessary spin_lock from ops_complete_biofill
* remove test_and_set/test_and_clear BUG_ONs, Neil Brown
* remove explicit interrupt handling for channel switching, this feature
  was absorbed (i.e. it is now implicit) by the async_tx api

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-By: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c         |  546 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/raid/raid5.h |   81 ++++++-
 2 files changed, 624 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d21fa7a..34fcda0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -52,6 +52,7 @@
 #include "raid6.h"
 
 #include <linux/raid/bitmap.h>
+#include <linux/async_tx.h>
 
 /*
  * Stripe cache
@@ -324,6 +325,551 @@ static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector
 	return sh;
 }
 
+static int
+raid5_end_read_request(struct bio *bi, unsigned int bytes_done, int error);
+static int
+raid5_end_write_request (struct bio *bi, unsigned int bytes_done, int error);
+
+static void ops_run_io(struct stripe_head *sh)
+{
+	raid5_conf_t *conf = sh->raid_conf;
+	int i, disks = sh->disks;
+
+	might_sleep();
+
+	for (i = disks; i--; ) {
+		int rw;
+		struct bio *bi;
+		mdk_rdev_t *rdev;
+		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
+			rw = WRITE;
+		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
+			rw = READ;
+		else
+			continue;
+
+		bi = &sh->dev[i].req;
+
+		bi->bi_rw = rw;
+		if (rw == WRITE)
+			bi->bi_end_io = raid5_end_write_request;
+		else
+			bi->bi_end_io = raid5_end_read_request;
+
+		rcu_read_lock();
+		rdev = rcu_dereference(conf->disks[i].rdev);
+		if (rdev && test_bit(Faulty, &rdev->flags))
+			rdev = NULL;
+		if (rdev)
+			atomic_inc(&rdev->nr_pending);
+		rcu_read_unlock();
+
+		if (rdev) {
+			if (test_bit(STRIPE_SYNCING, &sh->state) ||
+				test_bit(STRIPE_EXPAND_SOURCE, &sh->state) ||
+				test_bit(STRIPE_EXPAND_READY, &sh->state))
+				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
+
+			bi->bi_bdev = rdev->bdev;
+			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
+				__FUNCTION__, (unsigned long long)sh->sector,
+				bi->bi_rw, i);
+			atomic_inc(&sh->count);
+			bi->bi_sector = sh->sector + rdev->data_offset;
+			bi->bi_flags = 1 << BIO_UPTODATE;
+			bi->bi_vcnt = 1;
+			bi->bi_max_vecs = 1;
+			bi->bi_idx = 0;
+			bi->bi_io_vec = &sh->dev[i].vec;
+			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
+			bi->bi_io_vec[0].bv_offset = 0;
+			bi->bi_size = STRIPE_SIZE;
+			bi->bi_next = NULL;
+			if (rw == WRITE &&
+			    test_bit(R5_ReWrite, &sh->dev[i].flags))
+				atomic_add(STRIPE_SECTORS,
+					&rdev->corrected_errors);
+			generic_make_request(bi);
+		} else {
+			if (rw == WRITE)
+				set_bit(STRIPE_DEGRADED, &sh->state);
+			pr_debug("skip op %ld on disc %d for sector %llu\n",
+				bi->bi_rw, i, (unsigned long long)sh->sector);
+			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			set_bit(STRIPE_HANDLE, &sh->state);
+		}
+	}
+}
+
+static struct dma_async_tx_descriptor *
+async_copy_data(int frombio, struct bio *bio, struct page *page,
+	sector_t sector, struct dma_async_tx_descriptor *tx)
+{
+	struct bio_vec *bvl;
+	struct page *bio_page;
+	int i;
+	int page_offset;
+
+	if (bio->bi_sector >= sector)
+		page_offset = (signed)(bio->bi_sector - sector) * 512;
+	else
+		page_offset = (signed)(sector - bio->bi_sector) * -512;
+	bio_for_each_segment(bvl, bio, i) {
+		int len = bio_iovec_idx(bio, i)->bv_len;
+		int clen;
+		int b_offset = 0;
+
+		if (page_offset < 0) {
+			b_offset = -page_offset;
+			page_offset += b_offset;
+			len -= b_offset;
+		}
+
+		if (len > 0 && page_offset + len > STRIPE_SIZE)
+			clen = STRIPE_SIZE - page_offset;
+		else
+			clen = len;
+
+		if (clen > 0) {
+			b_offset += bio_iovec_idx(bio, i)->bv_offset;
+			bio_page = bio_iovec_idx(bio, i)->bv_page;
+			if (frombio)
+				tx = async_memcpy(page, bio_page, page_offset,
+					b_offset, clen,
+					ASYNC_TX_DEP_ACK | ASYNC_TX_KMAP_SRC,
+					tx, NULL, NULL);
+			else
+				tx = async_memcpy(bio_page, page, b_offset,
+					page_offset, clen,
+					ASYNC_TX_DEP_ACK | ASYNC_TX_KMAP_DST,
+					tx, NULL, NULL);
+		}
+		if (clen < len) /* hit end of page */
+			break;
+		page_offset +=  len;
+	}
+
+	return tx;
+}
+
+static void ops_complete_biofill(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+	struct bio *return_bi = NULL, *bi;
+	raid5_conf_t *conf = sh->raid_conf;
+	int i, more_to_read = 0;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	/* clear completed biofills */
+	for (i = sh->disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+		/* check if this stripe has new incoming reads */
+		if (dev->toread)
+			more_to_read++;
+
+		/* acknowledge completion of a biofill operation */
+		/* and check if we need to reply to a read request
+		*/
+		if (test_bit(R5_Wantfill, &dev->flags) && !dev->toread) {
+			struct bio *rbi, *rbi2;
+			clear_bit(R5_Wantfill, &dev->flags);
+
+			/* The access to dev->read is outside of the
+			 * spin_lock_irq(&conf->device_lock), but is protected
+			 * by the STRIPE_OP_BIOFILL pending bit
+			 */
+			BUG_ON(!dev->read);
+			rbi = dev->read;
+			dev->read = NULL;
+			while (rbi && rbi->bi_sector <
+				dev->sector + STRIPE_SECTORS) {
+				rbi2 = r5_next_bio(rbi, dev->sector);
+				spin_lock_irq(&conf->device_lock);
+				if (--rbi->bi_phys_segments == 0) {
+					rbi->bi_next = return_bi;
+					return_bi = rbi;
+				}
+				spin_unlock_irq(&conf->device_lock);
+				rbi = rbi2;
+			}
+		}
+	}
+	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
+	clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
+
+	bi = return_bi;
+	while (bi) {
+		int bytes = bi->bi_size;
+
+		return_bi = bi->bi_next;
+		bi->bi_next = NULL;
+		bi->bi_size = 0;
+		bi->bi_end_io(bi, bytes,
+			test_bit(BIO_UPTODATE, &bi->bi_flags) ? 0 : -EIO);
+		bi = return_bi;
+	}
+
+	if (more_to_read)
+		set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+}
+
+static void ops_run_biofill(struct stripe_head *sh)
+{
+	struct dma_async_tx_descriptor *tx = NULL;
+	raid5_conf_t *conf = sh->raid_conf;
+	int i;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	for (i = sh->disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+		if (test_bit(R5_Wantfill, &dev->flags)) {
+			struct bio *rbi;
+			spin_lock_irq(&conf->device_lock);
+			dev->read = rbi = dev->toread;
+			dev->toread = NULL;
+			spin_unlock_irq(&conf->device_lock);
+			while (rbi && rbi->bi_sector <
+				dev->sector + STRIPE_SECTORS) {
+				tx = async_copy_data(0, rbi, dev->page,
+					dev->sector, tx);
+				rbi = r5_next_bio(rbi, dev->sector);
+			}
+		}
+	}
+
+	atomic_inc(&sh->count);
+	async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
+		ops_complete_biofill, sh);
+}
+
+static void ops_complete_compute5(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+	int target = sh->ops.target;
+	struct r5dev *tgt = &sh->dev[target];
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	set_bit(R5_UPTODATE, &tgt->flags);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+	clear_bit(R5_Wantcompute, &tgt->flags);
+	set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.complete);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_compute5(struct stripe_head *sh, unsigned long pending)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->disks;
+	struct page *xor_srcs[disks];
+	int target = sh->ops.target;
+	struct r5dev *tgt = &sh->dev[target];
+	struct page *xor_dest = tgt->page;
+	int count = 0;
+	struct dma_async_tx_descriptor *tx;
+	int i;
+
+	pr_debug("%s: stripe %llu block: %d\n",
+		__FUNCTION__, (unsigned long long)sh->sector, target);
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+
+	for (i = disks; i--; )
+		if (i != target)
+			xor_srcs[count++] = sh->dev[i].page;
+
+	atomic_inc(&sh->count);
+
+	if (unlikely(count == 1))
+		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
+			0, NULL, ops_complete_compute5, sh);
+	else
+		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
+			ASYNC_TX_XOR_ZERO_DST, NULL,
+			ops_complete_compute5, sh);
+
+	/* ack now if postxor is not set to be run */
+	if (tx && !test_bit(STRIPE_OP_POSTXOR, &pending))
+		async_tx_ack(tx);
+
+	return tx;
+}
+
+static void ops_complete_prexor(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	set_bit(STRIPE_OP_PREXOR, &sh->ops.complete);
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_prexor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->disks;
+	struct page *xor_srcs[disks];
+	int count = 0, pd_idx = sh->pd_idx, i;
+
+	/* existing parity data subtracted */
+	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	for (i = disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+		/* Only process blocks that are known to be uptodate */
+		if (dev->towrite && test_bit(R5_Wantprexor, &dev->flags))
+			xor_srcs[count++] = dev->page;
+	}
+
+	tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
+		ASYNC_TX_DEP_ACK | ASYNC_TX_XOR_DROP_DST, tx,
+		ops_complete_prexor, sh);
+
+	return tx;
+}
+
+static struct dma_async_tx_descriptor *
+ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+{
+	int disks = sh->disks;
+	int pd_idx = sh->pd_idx, i;
+
+	/* check if prexor is active which means only process blocks
+	 * that are part of a read-modify-write (Wantprexor)
+	 */
+	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	for (i = disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+		struct bio *chosen;
+		int towrite;
+
+		towrite = 0;
+		if (prexor) { /* rmw */
+			if (dev->towrite &&
+			    test_bit(R5_Wantprexor, &dev->flags))
+				towrite = 1;
+		} else { /* rcw */
+			if (i != pd_idx && dev->towrite &&
+				test_bit(R5_LOCKED, &dev->flags))
+				towrite = 1;
+		}
+
+		if (towrite) {
+			struct bio *wbi;
+
+			spin_lock(&sh->lock);
+			chosen = dev->towrite;
+			dev->towrite = NULL;
+			BUG_ON(dev->written);
+			wbi = dev->written = chosen;
+			spin_unlock(&sh->lock);
+
+			while (wbi && wbi->bi_sector <
+				dev->sector + STRIPE_SECTORS) {
+				tx = async_copy_data(1, wbi, dev->page,
+					dev->sector, tx);
+				wbi = r5_next_bio(wbi, dev->sector);
+			}
+		}
+	}
+
+	return tx;
+}
+
+static void ops_complete_postxor(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+}
+
+static void ops_complete_write(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+	int disks = sh->disks, i, pd_idx = sh->pd_idx;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	for (i = disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+		if (dev->written || i == pd_idx)
+			set_bit(R5_UPTODATE, &dev->flags);
+	}
+
+	set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
+	set_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
+
+	set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+}
+
+static void
+ops_run_postxor(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->disks;
+	struct page *xor_srcs[disks];
+
+	int count = 0, pd_idx = sh->pd_idx, i;
+	struct page *xor_dest;
+	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
+	unsigned long flags;
+	dma_async_tx_callback callback;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	/* check if prexor is active which means only process blocks
+	 * that are part of a read-modify-write (written)
+	 */
+	if (prexor) {
+		xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
+			if (dev->written)
+				xor_srcs[count++] = dev->page;
+		}
+	} else {
+		xor_dest = sh->dev[pd_idx].page;
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
+			if (i != pd_idx)
+				xor_srcs[count++] = dev->page;
+		}
+	}
+
+	/* check whether this postxor is part of a write */
+	callback = test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending) ?
+		ops_complete_write : ops_complete_postxor;
+
+	/* 1/ if we prexor'd then the dest is reused as a source
+	 * 2/ if we did not prexor then we are redoing the parity
+	 * set ASYNC_TX_XOR_DROP_DST and ASYNC_TX_XOR_ZERO_DST
+	 * for the synchronous xor case
+	 */
+	flags = ASYNC_TX_DEP_ACK | ASYNC_TX_ACK |
+		(prexor ? ASYNC_TX_XOR_DROP_DST : ASYNC_TX_XOR_ZERO_DST);
+
+	atomic_inc(&sh->count);
+
+	if (unlikely(count == 1)) {
+		flags &= ~(ASYNC_TX_XOR_DROP_DST | ASYNC_TX_XOR_ZERO_DST);
+		tx = async_memcpy(xor_dest, xor_srcs[0], 0, 0, STRIPE_SIZE,
+			flags, tx, callback, sh);
+	} else
+		tx = async_xor(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
+			flags, tx, callback, sh);
+}
+
+static void ops_complete_check(void *stripe_head_ref)
+{
+	struct stripe_head *sh = stripe_head_ref;
+	int pd_idx = sh->pd_idx;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
+		sh->ops.zero_sum_result == 0)
+		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+
+	set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
+	set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+}
+
+static void ops_run_check(struct stripe_head *sh)
+{
+	/* kernel stack size limits the total number of disks */
+	int disks = sh->disks;
+	struct page *xor_srcs[disks];
+	struct dma_async_tx_descriptor *tx;
+
+	int count = 0, pd_idx = sh->pd_idx, i;
+	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
+
+	pr_debug("%s: stripe %llu\n", __FUNCTION__,
+		(unsigned long long)sh->sector);
+
+	for (i = disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
+		if (i != pd_idx)
+			xor_srcs[count++] = dev->page;
+	}
+
+	tx = async_xor_zero_sum(xor_dest, xor_srcs, 0, count, STRIPE_SIZE,
+		&sh->ops.zero_sum_result, 0, NULL, NULL, NULL);
+
+	if (tx)
+		set_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending);
+	else
+		clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending);
+
+	atomic_inc(&sh->count);
+	tx = async_trigger_callback(ASYNC_TX_DEP_ACK | ASYNC_TX_ACK, tx,
+		ops_complete_check, sh);
+}
+
+static void raid5_run_ops(struct stripe_head *sh, unsigned long pending)
+{
+	int overlap_clear = 0, i, disks = sh->disks;
+	struct dma_async_tx_descriptor *tx = NULL;
+
+	if (test_bit(STRIPE_OP_BIOFILL, &pending)) {
+		ops_run_biofill(sh);
+		overlap_clear++;
+	}
+
+	if (test_bit(STRIPE_OP_COMPUTE_BLK, &pending))
+		tx = ops_run_compute5(sh, pending);
+
+	if (test_bit(STRIPE_OP_PREXOR, &pending))
+		tx = ops_run_prexor(sh, tx);
+
+	if (test_bit(STRIPE_OP_BIODRAIN, &pending)) {
+		tx = ops_run_biodrain(sh, tx);
+		overlap_clear++;
+	}
+
+	if (test_bit(STRIPE_OP_POSTXOR, &pending))
+		ops_run_postxor(sh, tx);
+
+	if (test_bit(STRIPE_OP_CHECK, &pending))
+		ops_run_check(sh);
+
+	if (test_bit(STRIPE_OP_IO, &pending))
+		ops_run_io(sh);
+
+	if (overlap_clear)
+		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
+			if (test_and_clear_bit(R5_Overlap, &dev->flags))
+				wake_up(&sh->raid_conf->wait_for_overlap);
+		}
+}
+
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
diff --git a/include/linux/raid/raid5.h b/include/linux/raid/raid5.h
index 208aa68..f623a44 100644
--- a/include/linux/raid/raid5.h
+++ b/include/linux/raid/raid5.h
@@ -116,13 +116,46 @@
  *  attach a request to an active stripe (add_stripe_bh())
  *     lockdev attach-buffer unlockdev
  *  handle a stripe (handle_stripe())
- *     lockstripe clrSTRIPE_HANDLE ... (lockdev check-buffers unlockdev) .. change-state .. record io needed unlockstripe schedule io
+ *     lockstripe clrSTRIPE_HANDLE ...
+ *		(lockdev check-buffers unlockdev) ..
+ *		change-state ..
+ *		record io/ops needed unlockstripe schedule io/ops
  *  release an active stripe (release_stripe())
  *     lockdev if (!--cnt) { if  STRIPE_HANDLE, add to handle_list else add to inactive-list } unlockdev
  *
  * The refcount counts each thread that have activated the stripe,
  * plus raid5d if it is handling it, plus one for each active request
- * on a cached buffer.
+ * on a cached buffer, and plus one if the stripe is undergoing stripe
+ * operations.
+ *
+ * Stripe operations are performed outside the stripe lock,
+ * the stripe operations are:
+ * -copying data between the stripe cache and user application buffers
+ * -computing blocks to save a disk access, or to recover a missing block
+ * -updating the parity on a write operation (reconstruct write and
+ *  read-modify-write)
+ * -checking parity correctness
+ * -running i/o to disk
+ * These operations are carried out by raid5_run_ops which uses the async_tx
+ * api to (optionally) offload operations to dedicated hardware engines.
+ * When requesting an operation handle_stripe sets the pending bit for the
+ * operation and increments the count.  raid5_run_ops is then run whenever
+ * the count is non-zero.
+ * There are some critical dependencies between the operations that prevent some
+ * from being requested while another is in flight.
+ * 1/ Parity check operations destroy the in cache version of the parity block,
+ *    so we prevent parity dependent operations like writes and compute_blocks
+ *    from starting while a check is in progress.  Some dma engines can perform
+ *    the check without damaging the parity block, in these cases the parity
+ *    block is re-marked up to date (assuming the check was successful) and is
+ *    not re-read from disk.
+ * 2/ When a write operation is requested we immediately lock the affected
+ *    blocks, and mark them as not up to date.  This causes new read requests
+ *    to be held off, as well as parity checks and compute block operations.
+ * 3/ Once a compute block operation has been requested handle_stripe treats
+ *    that block as if it is up to date.  raid5_run_ops guaruntees that any
+ *    operation that is dependent on the compute block result is initiated after
+ *    the compute block completes.
  */
 
 struct stripe_head {
@@ -136,11 +169,26 @@ struct stripe_head {
 	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
+	/* stripe_operations
+	 * @pending - pending ops flags (set for request->issue->complete)
+	 * @ack - submitted ops flags (set for issue->complete)
+	 * @complete - completed ops flags (set for complete)
+	 * @target - STRIPE_OP_COMPUTE_BLK target
+	 * @count - raid5_runs_ops is set to run when this is non-zero
+	 */
+	struct stripe_operations {
+		unsigned long	   pending;
+		unsigned long	   ack;
+		unsigned long	   complete;
+		int		   target;
+		int		   count;
+		u32		   zero_sum_result;
+	} ops;
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
 		struct page	*page;
-		struct bio	*toread, *towrite, *written;
+		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
@@ -174,6 +222,15 @@ struct r6_state {
 #define	R5_ReWrite	9	/* have tried to over-write the readerror */
 
 #define	R5_Expanded	10	/* This block now has post-expand data */
+#define	R5_Wantcompute	11 /* compute_block in progress treat as
+				    * uptodate
+				    */
+#define	R5_Wantfill	12 /* dev->toread contains a bio that needs
+				    * filling
+				    */
+#define	R5_Wantprexor	13 /* distinguish blocks ready for rmw from
+				    * other "towrites"
+				    */
 /*
  * Write method
  */
@@ -196,6 +253,24 @@ struct r6_state {
 #define	STRIPE_EXPAND_SOURCE	10
 #define	STRIPE_EXPAND_READY	11
 /*
+ * Operations flags (in issue order)
+ */
+#define STRIPE_OP_BIOFILL	0
+#define STRIPE_OP_COMPUTE_BLK	1
+#define STRIPE_OP_PREXOR	2
+#define STRIPE_OP_BIODRAIN	3
+#define STRIPE_OP_POSTXOR	4
+#define STRIPE_OP_CHECK	5
+#define STRIPE_OP_IO		6
+
+/* modifiers to the base operations
+ * STRIPE_OP_MOD_REPAIR_PD - compute the parity block and write it back
+ * STRIPE_OP_MOD_DMA_CHECK - parity is not corrupted by the check
+ */
+#define STRIPE_OP_MOD_REPAIR_PD 7
+#define STRIPE_OP_MOD_DMA_CHECK 8
+
+/*
  * Plugging:
  *
  * To improve write throughput, we need to delay the handling of some
