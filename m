From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/11] raid5-cache: free I/O units earlier
Date: Mon,  5 Oct 2015 09:31:06 +0200
Message-ID: <1444030276-30850-2-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is no good reason to keep the I/O unit structures around after the
stripe has been written back to the RAID array.  The only information
we need is the log sequence number, and the checkpoint offset of the
highest successfull writeback.  Store those in the log structure, and
free the IO units from __r5l_stripe_write_finished.

Besides simplifying the code this also avoid having to keep the allocation
for the I/O unit around for a potentially long time as superblock updates
that checkpoint the log do not happen very often.

This also fixes the previously incorrect calculation of 'free' in
r5l_do_reclaim as a side effect: previous if took the last unit which
isn't checkpointed into account.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 144 ++++++++++++++++++-----------------------------
 1 file changed, 55 insertions(+), 89 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index e917e53..5b5f346 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -51,6 +51,9 @@ struct r5l_log {
 	sector_t log_start;		/* log head. where new data appends */
 	u64 seq;			/* log head sequence */
 
+	sector_t next_checkpoint;
+	u64 next_cp_seq;
+
 	struct mutex io_mutex;
 	struct r5l_io_unit *current_io;	/* current io_unit accepting new data */
 
@@ -65,9 +68,6 @@ struct r5l_log {
 					 * cache flush */
 	struct list_head flushed_ios;	/* io_units which settle down in log disk */
 	struct bio flush_bio;
-	struct list_head stripe_end_ios;/* io_units which have been completely
-					 * written to the RAID but have not yet
-					 * been considered for updating super */
 
 	struct kmem_cache *io_kc;
 
@@ -186,35 +186,6 @@ static void r5l_move_io_unit_list(struct list_head *from, struct list_head *to,
 	}
 }
 
-/*
- * We don't want too many io_units reside in stripe_end_ios list, which will
- * waste a lot of memory. So we try to remove some. But we must keep at least 2
- * io_units. The superblock must point to a valid meta, if it's the last meta,
- * recovery can scan less
- */
-static void r5l_compress_stripe_end_list(struct r5l_log *log)
-{
-	struct r5l_io_unit *first, *last, *io;
-
-	first = list_first_entry(&log->stripe_end_ios,
-				 struct r5l_io_unit, log_sibling);
-	last = list_last_entry(&log->stripe_end_ios,
-			       struct r5l_io_unit, log_sibling);
-	if (first == last)
-		return;
-	list_del(&first->log_sibling);
-	list_del(&last->log_sibling);
-	while (!list_empty(&log->stripe_end_ios)) {
-		io = list_first_entry(&log->stripe_end_ios,
-				      struct r5l_io_unit, log_sibling);
-		list_del(&io->log_sibling);
-		first->log_end = io->log_end;
-		r5l_free_io_unit(log, io);
-	}
-	list_add_tail(&first->log_sibling, &log->stripe_end_ios);
-	list_add_tail(&last->log_sibling, &log->stripe_end_ios);
-}
-
 static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 				    enum r5l_io_unit_state state)
 {
@@ -548,31 +519,53 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 	spin_unlock(&log->no_space_stripes_lock);
 }
 
+static sector_t r5l_reclaimable_space(struct r5l_log *log)
+{
+	return r5l_ring_distance(log, log->last_checkpoint,
+				 log->next_checkpoint);
+}
+
+static bool r5l_complete_flushed_ios(struct r5l_log *log)
+{
+	struct r5l_io_unit *io, *next;
+	bool found = false;
+
+	assert_spin_locked(&log->io_list_lock);
+
+	list_for_each_entry_safe(io, next, &log->flushed_ios, log_sibling) {
+		/* don't change list order */
+		if (io->state < IO_UNIT_STRIPE_END)
+			break;
+
+		log->next_checkpoint = io->log_start;
+		log->next_cp_seq = io->seq;
+
+		list_del(&io->log_sibling);
+		r5l_free_io_unit(log, io);
+
+		found = true;
+	}
+	
+
+	return found;
+}
+
 static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 {
 	struct r5l_log *log = io->log;
-	struct r5l_io_unit *last;
-	sector_t reclaimable_space;
 	unsigned long flags;
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
-	/* might move 0 entry */
-	r5l_move_io_unit_list(&log->flushed_ios, &log->stripe_end_ios,
-			      IO_UNIT_STRIPE_END);
-	if (list_empty(&log->stripe_end_ios)) {
+
+	if (!r5l_complete_flushed_ios(log)) {
 		spin_unlock_irqrestore(&log->io_list_lock, flags);
 		return;
 	}
 
-	last = list_last_entry(&log->stripe_end_ios,
-			       struct r5l_io_unit, log_sibling);
-	reclaimable_space = r5l_ring_distance(log, log->last_checkpoint,
-					      last->log_end);
-	if (reclaimable_space >= log->max_free_space)
+	if (r5l_reclaimable_space(log) > log->max_free_space)
 		r5l_wake_reclaim(log, 0);
 
-	r5l_compress_stripe_end_list(log);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 	wake_up(&log->iounit_wait);
 }
@@ -651,13 +644,6 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
 	submit_bio(WRITE_FLUSH, &log->flush_bio);
 }
 
-static void r5l_kick_io_unit(struct r5l_log *log)
-{
-	md_wakeup_thread(log->rdev->mddev->thread);
-	wait_event_lock_irq(log->iounit_wait, !list_empty(&log->stripe_end_ios),
-			    log->io_list_lock);
-}
-
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
 static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	sector_t end)
@@ -698,10 +684,10 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 
 static void r5l_do_reclaim(struct r5l_log *log)
 {
-	struct r5l_io_unit *io, *last;
-	LIST_HEAD(list);
-	sector_t free = 0;
 	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
+	sector_t reclaimable;
+	sector_t next_checkpoint;
+	u64 next_cp_seq;
 
 	spin_lock_irq(&log->io_list_lock);
 	/*
@@ -710,60 +696,41 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	 * shouldn't reuse space of an unreclaimable io_unit
 	 */
 	while (1) {
-		struct list_head *target_list = NULL;
-
-		while (!list_empty(&log->stripe_end_ios)) {
-			io = list_first_entry(&log->stripe_end_ios,
-					      struct r5l_io_unit, log_sibling);
-			list_move_tail(&io->log_sibling, &list);
-			free += r5l_ring_distance(log, io->log_start,
-						  io->log_end);
-		}
-
-		if (free >= reclaim_target ||
+		reclaimable = r5l_reclaimable_space(log);
+		if (reclaimable >= reclaim_target ||
 		    (list_empty(&log->running_ios) &&
 		     list_empty(&log->io_end_ios) &&
 		     list_empty(&log->flushing_ios) &&
 		     list_empty(&log->flushed_ios)))
 			break;
 
-		/* Below waiting mostly happens when we shutdown the raid */
-		if (!list_empty(&log->flushed_ios))
-			target_list = &log->flushed_ios;
-		else if (!list_empty(&log->flushing_ios))
-			target_list = &log->flushing_ios;
-		else if (!list_empty(&log->io_end_ios))
-			target_list = &log->io_end_ios;
-		else if (!list_empty(&log->running_ios))
-			target_list = &log->running_ios;
-
-		r5l_kick_io_unit(log);
+		md_wakeup_thread(log->rdev->mddev->thread);
+		wait_event_lock_irq(log->iounit_wait,
+				    r5l_reclaimable_space(log) > reclaimable,
+				    log->io_list_lock);
 	}
+
+	next_checkpoint = log->next_checkpoint;
+	next_cp_seq = log->next_cp_seq;
 	spin_unlock_irq(&log->io_list_lock);
 
-	if (list_empty(&list))
+	BUG_ON(reclaimable < 0);
+	if (reclaimable == 0)
 		return;
 
-	/* super always point to last valid meta */
-	last = list_last_entry(&list, struct r5l_io_unit, log_sibling);
 	/*
 	 * write_super will flush cache of each raid disk. We must write super
 	 * here, because the log area might be reused soon and we don't want to
 	 * confuse recovery
 	 */
-	r5l_write_super_and_discard_space(log, last->log_start);
+	r5l_write_super_and_discard_space(log, next_checkpoint);
 
 	mutex_lock(&log->io_mutex);
-	log->last_checkpoint = last->log_start;
-	log->last_cp_seq = last->seq;
+	log->last_checkpoint = next_checkpoint;
+	log->last_cp_seq = next_cp_seq;
 	mutex_unlock(&log->io_mutex);
-	r5l_run_no_space_stripes(log);
 
-	while (!list_empty(&list)) {
-		io = list_first_entry(&list, struct r5l_io_unit, log_sibling);
-		list_del(&io->log_sibling);
-		r5l_free_io_unit(log, io);
-	}
+	r5l_run_no_space_stripes(log);
 }
 
 static void r5l_reclaim_thread(struct md_thread *thread)
@@ -1153,7 +1120,6 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->io_list_lock);
 	INIT_LIST_HEAD(&log->running_ios);
 	INIT_LIST_HEAD(&log->io_end_ios);
-	INIT_LIST_HEAD(&log->stripe_end_ios);
 	INIT_LIST_HEAD(&log->flushing_ios);
 	INIT_LIST_HEAD(&log->flushed_ios);
 	bio_init(&log->flush_bio);
-- 
1.9.1

