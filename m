From: Coly Li <colyli@suse.de>
Subject: [v2 PATCH 2/2] RAID1: avoid unnecessary spin locks in I/O barrier code
Date: Tue, 27 Dec 2016 23:47:38 +0800
Message-ID: <1482853658-82535-2-git-send-email-colyli@suse.de>
References: <1482853658-82535-1-git-send-email-colyli@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1482853658-82535-1-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Shaohua Li <shli@fb.com>, Hannes Reinecke <hare@suse.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

When I run a parallel reading performan testing on a md raid1 device with
two NVMe SSDs, I observe very bad throughput in supprise: by fio with 64KB
block size, 40 seq read I/O jobs, 128 iodepth, overall throughput is
only 2.7GB/s, this is around 50% of the idea performance number.

The perf reports locking contention happens at allow_barrier() and
wait_barrier() code,
 - 41.41%  fio [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
   - _raw_spin_lock_irqsave
         + 89.92% allow_barrier
         + 9.34% __wake_up
 - 37.30%  fio [kernel.kallsyms]     [k] _raw_spin_lock_irq
   - _raw_spin_lock_irq
         - 100.00% wait_barrier

The reason is, in these I/O barrier related functions,
 - raise_barrier()
 - lower_barrier()
 - wait_barrier()
 - allow_barrier()
They always hold conf->resync_lock firstly, even there are only regular
reading I/Os and no resync I/O at all. This is a huge performance penalty.

The solution is a lockless-like algorithm in I/O barrier code, and only
holding conf->resync_lock when it is really necessary.

The original idea is from Hannes Reinecke, and Neil Brown provides
comments to improve it. Now I write the patch based on new simpler raid1
I/O barrier code.

In the new simpler raid1 I/O barrier implementation, there are two
wait barrier functions,
 - wait_barrier()
   Which in turns calls _wait_barrier(), is used for regular write I/O.
   If there is resync I/O happening on the same barrier bucket index, or
   the whole array is frozen, task will wait until no barrier on same
   bucket index, or the whold array is unfreezed.
 - wait_read_barrier()
   Since regular read I/O won't interfere with resync I/O (read_balance()
   will make sure only uptodate data will be read out), so it is
   unnecessary to wait for barrier in regular read I/Os, they only have to
   wait only when the whole array is frozen.
The operations on conf->nr_pending[idx], conf->nr_waiting[idx], conf->
barrier[idx] are very carefully designed in raise_barrier(),
lower_barrier(), _wait_barrier() and wait_read_barrier(), in order to
avoid unnecessary spin locks in these functions. Once conf->
nr_pengding[idx] is increased, a resync I/O with same barrier bucket index
has to wait in raise_barrier(). Then in _wait_barrier() or
wait_read_barrier() if no barrier raised in same barrier bucket index or
array is not frozen, the regular I/O doesn't need to hold conf->
resync_lock, it can just increase conf->nr_pending[idx], and return to its
caller. For heavy parallel reading I/Os, the lockless I/O barrier code
almostly gets rid of all spin lock cost.

This patch significantly improves raid1 reading peroformance. From my
testing, a raid1 device built by two NVMe SSD, runs fio with 64KB
blocksize, 40 seq read I/O jobs, 128 iodepth, overall throughput
increases from 2.7GB/s to 4.6GB/s (+70%).

Open question:
Shaohua points out the memory barrier should be added to some atomic
operations. Now I am reading the document to learn how to add the memory
barriers correctly. Anyway, if anyone has suggestion, please don't
hesitate to let me know.

Changelog
V1:
- Original RFC patch for comments.
V2:
- Remove a spin_lock/unlock pair in raid1d().
- Add more code comments to explain why there is no racy when checking two
  atomic_t variables at same time.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Shaohua Li <shli@fb.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/raid1.c | 134 +++++++++++++++++++++++++++++++----------------------
 drivers/md/raid1.h |  12 ++---
 2 files changed, 85 insertions(+), 61 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5813656..b1fb4c1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -222,7 +222,7 @@ static void reschedule_retry(struct r1bio *r1_bio)
 	idx = hash_long(r1_bio->sector, BARRIER_BUCKETS_NR_BITS);
 	spin_lock_irqsave(&conf->device_lock, flags);
 	list_add(&r1_bio->retry_list, &conf->retry_list);
-	conf->nr_queued[idx]++;
+	atomic_inc(&conf->nr_queued[idx]);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	wake_up(&conf->wait_barrier);
@@ -831,13 +831,13 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
 	spin_lock_irq(&conf->resync_lock);
 
 	/* Wait until no block IO is waiting */
-	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting[idx],
+	wait_event_lock_irq(conf->wait_barrier,
+			    !atomic_read(&conf->nr_waiting[idx]),
 			    conf->resync_lock);
 
 	/* block any new IO from starting */
-	conf->barrier[idx]++;
-	conf->total_barriers++;
-
+	atomic_inc(&conf->barrier[idx]);
+	atomic_inc(&conf->total_barriers);
 	/* For these conditions we must wait:
 	 * A: while the array is in frozen state
 	 * B: while conf->nr_pending[idx] is not 0, meaning regular I/O
@@ -846,44 +846,69 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
 	 *    the max count which allowed on the whole raid1 device.
 	 */
 	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen &&
-			     !conf->nr_pending[idx] &&
-			     conf->total_barriers < RESYNC_DEPTH,
+			    !atomic_read(&conf->array_frozen) &&
+			     !atomic_read(&conf->nr_pending[idx]) &&
+			     atomic_read(&conf->total_barriers) < RESYNC_DEPTH,
 			    conf->resync_lock);
 
-	conf->nr_pending[idx]++;
+	atomic_inc(&conf->nr_pending[idx]);
 	spin_unlock_irq(&conf->resync_lock);
 }
 
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
 {
-	unsigned long flags;
 	int idx = hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
 
-	BUG_ON((conf->barrier[idx] <= 0) || conf->total_barriers <= 0);
-
-	spin_lock_irqsave(&conf->resync_lock, flags);
-	conf->barrier[idx]--;
-	conf->total_barriers--;
-	conf->nr_pending[idx]--;
-	spin_unlock_irqrestore(&conf->resync_lock, flags);
+	BUG_ON(atomic_read(&conf->barrier[idx]) <= 0);
+	BUG_ON(atomic_read(&conf->total_barriers) <= 0);
+	atomic_dec(&conf->barrier[idx]);
+	atomic_dec(&conf->total_barriers);
+	atomic_dec(&conf->nr_pending[idx]);
 	wake_up(&conf->wait_barrier);
 }
 
 static void _wait_barrier(struct r1conf *conf, int idx)
 {
-	spin_lock_irq(&conf->resync_lock);
-	if (conf->array_frozen || conf->barrier[idx]) {
-		conf->nr_waiting[idx]++;
-		/* Wait for the barrier to drop. */
-		wait_event_lock_irq(
-			conf->wait_barrier,
-			!conf->array_frozen && !conf->barrier[idx],
-			conf->resync_lock);
-		conf->nr_waiting[idx]--;
-	}
+	/* We need to increase conf->nr_pending[idx] very early here,
+	 * then raise_barrier() can be blocked when it waits for
+	 * conf->nr_pending[idx] to be 0. Then we can avoid holding
+	 * conf->resync_lock when there is no barrier raised in same
+	 * barrier unit bucket. Also if the array is frozen, I/O
+	 * should be blocked until array is unfrozen.
+	 */
+	atomic_inc(&conf->nr_pending[idx]);
+
+	/* Don't worry about checking two atomic_t variables at same time
+	 * here. conf->array_frozen MUST be checked firstly, The logic is,
+	 * if the array is frozen, no matter there is any barrier or not,
+	 * all I/O should be blocked. If there is no barrier in current
+	 * barrier bucket, we still need to check whether the array is frozen,
+	 * otherwise I/O will happen on frozen array, that's buggy.
+	 * If during we check conf->barrier[idx], the array is frozen (a.k.a
+	 * conf->array_frozen is set), and chonf->barrier[idx] is 0, it is
+	 * safe to return and make the I/O continue. Because the array is
+	 * frozen, all I/O returned here will eventually complete or be
+	 * queued, see code comment in frozen_array().
+	 */
+	if (!atomic_read(&conf->array_frozen) &&
+	    !atomic_read(&conf->barrier[idx]))
+		return;
 
-	conf->nr_pending[idx]++;
+	/* After holding conf->resync_lock, conf->nr_pending[idx]
+	 * should be decreased before waiting for barrier to drop.
+	 * Otherwise, we may encounter a race condition because
+	 * raise_barrer() might be waiting for conf->nr_pending[idx]
+	 * to be 0 at same time.
+	 */
+	atomic_inc(&conf->nr_waiting[idx]);
+	atomic_dec(&conf->nr_pending[idx]);
+	/* Wait for the barrier in same barrier unit bucket to drop. */
+	wait_event_lock_irq(conf->wait_barrier,
+			    !atomic_read(&conf->array_frozen) &&
+			     !atomic_read(&conf->barrier[idx]),
+			    conf->resync_lock);
+	atomic_inc(&conf->nr_pending[idx]);
+	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -891,18 +916,23 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 {
 	long idx = hash_long(sector_nr, BARRIER_BUCKETS_NR_BITS);
 
-	spin_lock_irq(&conf->resync_lock);
-	if (conf->array_frozen) {
-		conf->nr_waiting[idx]++;
-		/* Wait for array to unfreeze */
-		wait_event_lock_irq(
-			conf->wait_barrier,
-			!conf->array_frozen,
-			conf->resync_lock);
-		conf->nr_waiting[idx]--;
-	}
+	/* Very similar to _wait_barrier(). The difference is, for read
+	 * I/O we don't need wait for sync I/O, but if the whole array
+	 * is frozen, the read I/O still has to wait until the array is
+	 * unfrozen.
+	 */
+	atomic_inc(&conf->nr_pending[idx]);
+	if (!atomic_read(&conf->array_frozen))
+		return;
 
-	conf->nr_pending[idx]++;
+	atomic_inc(&conf->nr_waiting[idx]);
+	atomic_dec(&conf->nr_pending[idx]);
+	/* Wait for array to be unfrozen */
+	wait_event_lock_irq(conf->wait_barrier,
+			    !atomic_read(&conf->array_frozen),
+			    conf->resync_lock);
+	atomic_inc(&conf->nr_pending[idx]);
+	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -923,11 +953,7 @@ static void wait_all_barriers(struct r1conf *conf)
 
 static void _allow_barrier(struct r1conf *conf, int idx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&conf->resync_lock, flags);
-	conf->nr_pending[idx]--;
-	spin_unlock_irqrestore(&conf->resync_lock, flags);
+	atomic_dec(&conf->nr_pending[idx]);
 	wake_up(&conf->wait_barrier);
 }
 
@@ -952,7 +978,7 @@ static int get_all_pendings(struct r1conf *conf)
 	int idx, ret;
 
 	for (ret = 0, idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
-		ret += conf->nr_pending[idx];
+		ret += atomic_read(&conf->nr_pending[idx]);
 	return ret;
 }
 
@@ -962,7 +988,7 @@ static int get_all_queued(struct r1conf *conf)
 	int idx, ret;
 
 	for (ret = 0, idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
-		ret += conf->nr_queued[idx];
+		ret += atomic_read(&conf->nr_queued[idx]);
 	return ret;
 }
 
@@ -992,7 +1018,7 @@ static void freeze_array(struct r1conf *conf, int extra)
 	 * normal I/O context, extra is 1, in rested situations extra is 0.
 	 */
 	spin_lock_irq(&conf->resync_lock);
-	conf->array_frozen = 1;
+	atomic_set(&conf->array_frozen, 1);
 	raid1_log(conf->mddev, "wait freeze");
 	wait_event_lock_irq_cmd(
 		conf->wait_barrier,
@@ -1005,7 +1031,7 @@ static void unfreeze_array(struct r1conf *conf)
 {
 	/* reverse the effect of the freeze */
 	spin_lock_irq(&conf->resync_lock);
-	conf->array_frozen = 0;
+	atomic_set(&conf->array_frozen, 0);
 	wake_up(&conf->wait_barrier);
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -2407,7 +2433,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 		spin_lock_irq(&conf->device_lock);
 		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
 		idx = hash_long(r1_bio->sector, BARRIER_BUCKETS_NR_BITS);
-		conf->nr_queued[idx]++;
+		atomic_inc(&conf->nr_queued[idx]);
 		spin_unlock_irq(&conf->device_lock);
 		md_wakeup_thread(conf->mddev->thread);
 	} else {
@@ -2546,9 +2572,7 @@ static void raid1d(struct md_thread *thread)
 			list_del(&r1_bio->retry_list);
 			idx = hash_long(r1_bio->sector,
 					BARRIER_BUCKETS_NR_BITS);
-			spin_lock_irqsave(&conf->device_lock, flags);
-			conf->nr_queued[idx]--;
-			spin_unlock_irqrestore(&conf->device_lock, flags);
+			atomic_dec(&conf->nr_queued[idx]);
 			if (mddev->degraded)
 				set_bit(R1BIO_Degraded, &r1_bio->state);
 			if (test_bit(R1BIO_WriteError, &r1_bio->state))
@@ -2570,7 +2594,7 @@ static void raid1d(struct md_thread *thread)
 		r1_bio = list_entry(head->prev, struct r1bio, retry_list);
 		list_del(head->prev);
 		idx = hash_long(r1_bio->sector, BARRIER_BUCKETS_NR_BITS);
-		conf->nr_queued[idx]--;
+		atomic_dec(&conf->nr_queued[idx]);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 
 		mddev = r1_bio->mddev;
@@ -2687,7 +2711,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	 * If there is non-resync activity waiting for a turn, then let it
 	 * though before starting on this new sync request.
 	 */
-	if (conf->nr_waiting[idx])
+	if (atomic_read(&conf->nr_waiting[idx]))
 		schedule_timeout_uninterruptible(1);
 
 	/* we are incrementing sector_nr below. To be safe, we check against
@@ -3316,7 +3340,7 @@ static void *raid1_takeover(struct mddev *mddev)
 		conf = setup_conf(mddev);
 		if (!IS_ERR(conf)) {
 			/* Array must appear to be quiesced */
-			conf->array_frozen = 1;
+			atomic_set(&conf->array_frozen, 1);
 			clear_bit(MD_HAS_JOURNAL, &mddev->flags);
 			clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
 		}
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 817115d..bbe65f7 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -68,12 +68,12 @@ struct r1conf {
 	 */
 	wait_queue_head_t	wait_barrier;
 	spinlock_t		resync_lock;
-	int			nr_pending[BARRIER_BUCKETS_NR];
-	int			nr_waiting[BARRIER_BUCKETS_NR];
-	int			nr_queued[BARRIER_BUCKETS_NR];
-	int			barrier[BARRIER_BUCKETS_NR];
-	int			total_barriers;
-	int			array_frozen;
+	atomic_t		nr_pending[BARRIER_BUCKETS_NR];
+	atomic_t		nr_waiting[BARRIER_BUCKETS_NR];
+	atomic_t		nr_queued[BARRIER_BUCKETS_NR];
+	atomic_t		barrier[BARRIER_BUCKETS_NR];
+	atomic_t		total_barriers;
+	atomic_t		array_frozen;
 
 	/* Set to 1 if a full sync is needed, (fresh device added).
 	 * Cleared when a sync completes.
-- 
2.6.6

