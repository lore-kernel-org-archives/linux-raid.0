From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10] raid5-cache: use FUA writes for the log
Date: Mon,  7 Sep 2015 07:20:43 +0200
Message-ID: <1441603250-5119-4-git-send-email-hch@lst.de>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441603250-5119-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

If we submit writes with the FUA bit for the log they are guaranteed to
be on stable storage once the endio callback is called.  This allows
to simplify the IO unit state machine, and decrease latencies a lot
when the device supports FUA.  If the device doesnt' support FUA the
block layer has an efficient state machine to emulate it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 133 +++++++++++++----------------------------------
 drivers/md/raid5.c       |   9 +---
 drivers/md/raid5.h       |   1 -
 3 files changed, 37 insertions(+), 106 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 803bcc6..1e54249 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -61,13 +61,8 @@ struct r5l_log {
 	struct list_head running_ios; /* io_units which are still running,
 				       * and have not yet been completely
 				       * written to the log */
-	struct list_head io_end_ios; /* io_units which have been completely
-				      * written to the log but not yet written
-				      * to the RAID */
-	struct list_head flushing_ios; /* io_units which are waiting for log
-					* cache flush */
-	struct list_head flushed_ios; /* io_units which settle down in log disk */
-	struct bio flush_bio;
+	struct list_head finished_ios; /* io_units already written to the
+					* log disk */
 
 	struct kmem_cache *io_kc;
 
@@ -169,21 +164,6 @@ static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
 	kmem_cache_free(log->io_kc, io);
 }
 
-static void r5l_move_io_unit_list(struct list_head *from, struct list_head *to,
-       enum r5l_io_unit_state state)
-{
-       struct r5l_io_unit *io;
-
-       while (!list_empty(from)) {
-               io = list_first_entry(from, struct r5l_io_unit, log_sibling);
-               /* don't change list order */
-               if (io->state >= state)
-                       list_move_tail(&io->log_sibling, to);
-               else
-                       break;
-       }
-}
-
 static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	enum r5l_io_unit_state state)
 {
@@ -192,6 +172,33 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+static void r5l_io_run_stripes(struct r5l_io_unit *io)
+{
+	struct stripe_head *sh, *next;
+
+	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
+		list_del_init(&sh->log_list);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+}
+
+static void r5l_log_run_stripes(struct r5l_log *log)
+{
+	struct r5l_io_unit *io, *next;
+
+	assert_spin_locked(&log->io_list_lock);
+
+	list_for_each_entry_safe(io, next, &log->running_ios, log_sibling) {
+		/* don't change list order */
+		if (io->state < IO_UNIT_IO_END)
+			break;
+
+		list_move_tail(&io->log_sibling, &log->finished_ios);
+		r5l_io_run_stripes(io);
+	}
+}
+
 /* XXX: totally ignores I/O errors */
 static void r5l_log_endio(struct bio *bio)
 {
@@ -206,11 +213,8 @@ static void r5l_log_endio(struct bio *bio)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
-	r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
-			IO_UNIT_IO_END);
+	r5l_log_run_stripes(log);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
-
-	md_wakeup_thread(log->rdev->mddev->thread);
 }
 
 static void r5l_submit_current_io(struct r5l_log *log)
@@ -237,7 +241,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	while ((bio = bio_list_pop(&io->bios))) {
 		/* all IO must start from rdev->data_offset */
 		bio->bi_iter.bi_sector += log->rdev->data_offset;
-		submit_bio(WRITE, bio);
+		submit_bio(WRITE | REQ_FUA, bio);
 	}
 }
 
@@ -516,14 +520,14 @@ static sector_t r5l_reclaimable_space(struct r5l_log *log)
 				 log->next_checkpoint);
 }
 
-static bool r5l_complete_flushed_ios(struct r5l_log *log)
+static bool r5l_complete_finished_ios(struct r5l_log *log)
 {
 	struct r5l_io_unit *io, *next;
 	bool found = false;
 
 	assert_spin_locked(&log->io_list_lock);
 
-	list_for_each_entry_safe(io, next, &log->flushed_ios, log_sibling) {
+	list_for_each_entry_safe(io, next, &log->finished_ios, log_sibling) {
 		/* don't change list order */
 		if (io->state < IO_UNIT_STRIPE_END)
 			break;
@@ -549,7 +553,7 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
 
-	if (!r5l_complete_flushed_ios(log)) {
+	if (!r5l_complete_finished_ios(log)) {
 		spin_unlock_irqrestore(&log->io_list_lock, flags);
 		return;
 	}
@@ -572,66 +576,6 @@ void r5l_stripe_write_finished(struct stripe_head *sh)
 		__r5l_stripe_write_finished(io);
 }
 
-static void r5l_log_flush_endio(struct bio *bio)
-{
-	struct r5l_log *log = container_of(bio, struct r5l_log,
-		flush_bio);
-	unsigned long flags;
-	struct r5l_io_unit *io;
-	struct stripe_head *sh;
-
-	spin_lock_irqsave(&log->io_list_lock, flags);
-	list_for_each_entry(io, &log->flushing_ios, log_sibling) {
-		while (!list_empty(&io->stripe_list)) {
-			sh = list_first_entry(&io->stripe_list,
-				struct stripe_head, log_list);
-			list_del_init(&sh->log_list);
-			set_bit(STRIPE_HANDLE, &sh->state);
-			raid5_release_stripe(sh);
-		}
-	}
-	list_splice_tail_init(&log->flushing_ios, &log->flushed_ios);
-	spin_unlock_irqrestore(&log->io_list_lock, flags);
-}
-
-/*
- * Starting dispatch IO to raid.
- * io_unit(meta) consists of a log. There is one situation we want to avoid. A
- * broken meta in the middle of a log causes recovery can't find meta at the
- * head of log. If operations require meta at the head persistent in log, we
- * must make sure meta before it persistent in log too. A case is:
- *
- * stripe data/parity is in log, we start write stripe to raid disks. stripe
- * data/parity must be persistent in log before we do the write to raid disks.
- *
- * The solution is we restrictly maintain io_unit list order. In this case, we
- * only write stripes of an io_unit to raid disks till the io_unit is the first
- * one whose data/parity is in log.
- * */
-void r5l_flush_stripe_to_raid(struct r5l_log *log)
-{
-	bool do_flush;
-	if (!log)
-		return;
-
-	spin_lock_irq(&log->io_list_lock);
-	/* flush bio is running */
-	if (!list_empty(&log->flushing_ios)) {
-		spin_unlock_irq(&log->io_list_lock);
-		return;
-	}
-	list_splice_tail_init(&log->io_end_ios, &log->flushing_ios);
-	do_flush = !list_empty(&log->flushing_ios);
-	spin_unlock_irq(&log->io_list_lock);
-
-	if (!do_flush)
-		return;
-	bio_reset(&log->flush_bio);
-	log->flush_bio.bi_bdev = log->rdev->bdev;
-	log->flush_bio.bi_end_io = r5l_log_flush_endio;
-	submit_bio(WRITE_FLUSH, &log->flush_bio);
-}
-
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
 static void r5l_write_super_and_discard_space(struct r5l_log *log,
 	sector_t end)
@@ -678,9 +622,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 		reclaimable = r5l_reclaimable_space(log);
 		if (reclaimable >= reclaim_target ||
 		    (list_empty(&log->running_ios) &&
-		     list_empty(&log->io_end_ios) &&
-		     list_empty(&log->flushing_ios) &&
-		     list_empty(&log->flushed_ios)))
+		     list_empty(&log->finished_ios)))
 			break;
 
 		md_wakeup_thread(log->rdev->mddev->thread);
@@ -1070,10 +1012,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	spin_lock_init(&log->io_list_lock);
 	INIT_LIST_HEAD(&log->running_ios);
-	INIT_LIST_HEAD(&log->io_end_ios);
-	INIT_LIST_HEAD(&log->flushing_ios);
-	INIT_LIST_HEAD(&log->flushed_ios);
-	bio_init(&log->flush_bio);
+	INIT_LIST_HEAD(&log->finished_ios);
 
 	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
 	if (!log->io_kc)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d86a39e..99e2d13 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5732,12 +5732,8 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
 			if (!list_empty(temp_inactive_list + i))
 				break;
-		if (i == NR_STRIPE_HASH_LOCKS) {
-			spin_unlock_irq(&conf->device_lock);
-			r5l_flush_stripe_to_raid(conf->log);
-			spin_lock_irq(&conf->device_lock);
+		if (i == NR_STRIPE_HASH_LOCKS)
 			return batch_size;
-		}
 		release_inactive = true;
 	}
 	spin_unlock_irq(&conf->device_lock);
@@ -5745,7 +5741,6 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 	release_inactive_stripe_list(conf, temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
 
-	r5l_flush_stripe_to_raid(conf->log);
 	if (release_inactive) {
 		spin_lock_irq(&conf->device_lock);
 		return 0;
@@ -5875,8 +5870,6 @@ static void raid5d(struct md_thread *thread)
 		mutex_unlock(&conf->cache_size_mutex);
 	}
 
-	r5l_flush_stripe_to_raid(conf->log);
-
 	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index b85ee02..720f0b3 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -624,7 +624,6 @@ extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
 extern void r5l_exit_log(struct r5l_log *log);
 extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
 extern void r5l_write_stripe_run(struct r5l_log *log);
-extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 #endif
-- 
1.9.1

