From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/8] raid5-cache: switching to state machine for log disk cache flush
Date: Wed, 2 Sep 2015 13:49:46 -0700
Message-ID: <a64e03897b037fc918e9cd98138e9aed06244f47.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Before we write stripe data to raid disks, we must guarantee stripe data
is settled down in log disk. To do this, we flush log disk cache and
wait the flush finish. That wait introduces sleep time in raid5d thread
and impact performance. This patch moves the log disk cache flush
process to the stripe handling state machine, which can remove the wait
in raid5d.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 116 ++++++++++++++++++++++++++---------------------
 drivers/md/raid5.c       |   7 ++-
 2 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index c85d72a..86b836c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -61,6 +61,10 @@ struct r5l_log {
 	struct list_head io_end_ios; /* io_units which have been completely
 				      * written to the log but not yet written
 				      * to the RAID */
+	struct list_head flushing_ios; /* io_units which are waiting for log
+					* cache flush */
+	struct list_head flushed_ios; /* io_units which settle down in log disk */
+	struct bio flush_bio;
 	struct list_head stripe_end_ios; /* io_units which have been
 					  * completely written to the RAID *
 					  * but have not yet been considered *
@@ -113,8 +117,7 @@ enum r5l_io_unit_state {
 	IO_UNIT_IO_START = 1, /* io_unit bio start writting to log,
 			       * don't accepting new bio */
 	IO_UNIT_IO_END = 2, /* io_unit bio finish writting to log */
-	IO_UNIT_STRIPE_START = 3, /* stripes of io_unit are flushing to raid */
-	IO_UNIT_STRIPE_END = 4, /* stripes data finished writting to raid */
+	IO_UNIT_STRIPE_END = 3, /* stripes data finished writting to raid */
 };
 
 static sector_t r5l_ring_add(struct r5l_log *log, sector_t start, sector_t inc)
@@ -228,7 +231,7 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 		struct r5l_io_unit *last;
 		sector_t reclaimable_space;
 
-		r5l_move_io_unit_list(&log->io_end_ios, &log->stripe_end_ios,
+		r5l_move_io_unit_list(&log->flushed_ios, &log->stripe_end_ios,
 			IO_UNIT_STRIPE_END);
 
 		last = list_last_entry(&log->stripe_end_ios,
@@ -554,6 +557,28 @@ void r5l_stripe_write_finished(struct stripe_head *sh)
 		r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
 }
 
+static void r5l_log_flush_endio(struct bio *bio, int error)
+{
+	struct r5l_log *log = container_of(bio, struct r5l_log,
+		flush_bio);
+	unsigned long flags;
+	struct r5l_io_unit *io;
+	struct stripe_head *sh;
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	list_for_each_entry(io, &log->flushing_ios, log_sibling) {
+		while (!list_empty(&io->stripe_list)) {
+			sh = list_first_entry(&io->stripe_list,
+				struct stripe_head, log_list);
+			list_del_init(&sh->log_list);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			raid5_release_stripe(sh);
+		}
+	}
+	list_splice_tail_init(&log->flushing_ios, &log->flushed_ios);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+}
+
 /*
  * Starting dispatch IO to raid.
  * io_unit(meta) consists of a log. There is one situation we want to avoid. A
@@ -570,44 +595,31 @@ void r5l_stripe_write_finished(struct stripe_head *sh)
  * */
 void r5l_flush_stripe_to_raid(struct r5l_log *log)
 {
-	struct r5l_io_unit *io;
-	struct stripe_head *sh;
-	bool run_stripe;
-
+	bool do_flush;
 	if (!log)
 		return;
-	spin_lock_irq(&log->io_list_lock);
-	run_stripe = !list_empty(&log->io_end_ios);
-	spin_unlock_irq(&log->io_list_lock);
-
-	if (!run_stripe)
-		return;
-
-	blkdev_issue_flush(log->rdev->bdev, GFP_NOIO, NULL);
 
 	spin_lock_irq(&log->io_list_lock);
-	list_for_each_entry(io, &log->io_end_ios, log_sibling) {
-		if (io->state >= IO_UNIT_STRIPE_START)
-			continue;
-		__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_START);
-
-		while (!list_empty(&io->stripe_list)) {
-			sh = list_first_entry(&io->stripe_list,
-				struct stripe_head, log_list);
-			list_del_init(&sh->log_list);
-			set_bit(STRIPE_HANDLE, &sh->state);
-			raid5_release_stripe(sh);
-		}
+	/* flush bio is running */
+	if (!list_empty(&log->flushing_ios)) {
+		spin_unlock_irq(&log->io_list_lock);
+		return;
 	}
+	list_splice_tail_init(&log->io_end_ios, &log->flushing_ios);
+	do_flush = !list_empty(&log->flushing_ios);
 	spin_unlock_irq(&log->io_list_lock);
+
+	if (!do_flush)
+		return;
+	bio_reset(&log->flush_bio);
+	log->flush_bio.bi_bdev = log->rdev->bdev;
+	log->flush_bio.bi_end_io = r5l_log_flush_endio;
+	submit_bio(WRITE_FLUSH, &log->flush_bio);
 }
 
 static void r5l_kick_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
 {
-	/* the log thread will write the io unit */
-	wait_event(io->wait_state, io->state >= IO_UNIT_IO_END);
-	if (io->state < IO_UNIT_STRIPE_START)
-		r5l_flush_stripe_to_raid(log);
+	md_wakeup_thread(log->rdev->mddev->thread);
 	wait_event(io->wait_state, io->state >= IO_UNIT_STRIPE_END);
 }
 
@@ -626,6 +638,8 @@ static void r5l_do_reclaim(struct r5l_log *log)
 	 * shouldn't reuse space of an unreclaimable io_unit
 	 * */
 	while (1) {
+		struct list_head *target_list = NULL;
+
 		while (!list_empty(&log->stripe_end_ios)) {
 			io = list_first_entry(&log->stripe_end_ios,
 				struct r5l_io_unit, log_sibling);
@@ -637,29 +651,26 @@ static void r5l_do_reclaim(struct r5l_log *log)
 		if (free >= reclaim_target ||
 		    (list_empty(&log->running_ios) &&
 		     list_empty(&log->io_end_ios) &&
-		     list_empty(&log->stripe_end_ios)))
+		     list_empty(&log->flushing_ios) &&
+		     list_empty(&log->flushed_ios)))
 			break;
 
 		/* Below waiting mostly happens when we shutdown the raid */
-		if (!list_empty(&log->io_end_ios)) {
-			io = list_first_entry(&log->io_end_ios,
-				struct r5l_io_unit, log_sibling);
-			spin_unlock_irq(&log->io_list_lock);
-			/* nobody else can delete the io, we are safe */
-			r5l_kick_io_unit(log, io);
-			spin_lock_irq(&log->io_list_lock);
-			continue;
-		}
-
-		if (!list_empty(&log->running_ios)) {
-			io = list_first_entry(&log->running_ios,
-				struct r5l_io_unit, log_sibling);
-			spin_unlock_irq(&log->io_list_lock);
-			/* nobody else can delete the io, we are safe */
-			r5l_kick_io_unit(log, io);
-			spin_lock_irq(&log->io_list_lock);
-			continue;
-		}
+		if (!list_empty(&log->flushed_ios))
+			target_list = &log->flushed_ios;
+		else if (!list_empty(&log->flushing_ios))
+			target_list = &log->flushing_ios;
+		else if (!list_empty(&log->io_end_ios))
+			target_list = &log->io_end_ios;
+		else if (!list_empty(&log->running_ios))
+			target_list = &log->running_ios;
+
+		io = list_first_entry(target_list,
+			struct r5l_io_unit, log_sibling);
+		spin_unlock_irq(&log->io_list_lock);
+		/* nobody else can delete the io, we are safe */
+		r5l_kick_io_unit(log, io);
+		spin_lock_irq(&log->io_list_lock);
 	}
 	spin_unlock_irq(&log->io_list_lock);
 
@@ -1048,6 +1059,9 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->running_ios);
 	INIT_LIST_HEAD(&log->io_end_ios);
 	INIT_LIST_HEAD(&log->stripe_end_ios);
+	INIT_LIST_HEAD(&log->flushing_ios);
+	INIT_LIST_HEAD(&log->flushed_ios);
+	bio_init(&log->flush_bio);
 
 	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
 	if (!log->io_kc)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cd24d58..b247997 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5758,8 +5758,12 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 		for (i = 0; i < NR_STRIPE_HASH_LOCKS; i++)
 			if (!list_empty(temp_inactive_list + i))
 				break;
-		if (i == NR_STRIPE_HASH_LOCKS)
+		if (i == NR_STRIPE_HASH_LOCKS) {
+			spin_unlock_irq(&conf->device_lock);
+			r5l_flush_stripe_to_raid(conf->log);
+			spin_lock_irq(&conf->device_lock);
 			return batch_size;
+		}
 		release_inactive = true;
 	}
 	spin_unlock_irq(&conf->device_lock);
@@ -5767,6 +5771,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 	release_inactive_stripe_list(conf, temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
 
+	r5l_flush_stripe_to_raid(conf->log);
 	if (release_inactive) {
 		spin_lock_irq(&conf->device_lock);
 		return 0;
-- 
1.8.1

