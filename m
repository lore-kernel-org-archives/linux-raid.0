From: Shaohua Li <shli@fb.com>
Subject: [patch v2 07/11] raid5: log reclaim support
Date: Thu, 13 Aug 2015 14:32:00 -0700
Message-ID: <bd8502929267d2aaaf6215fc508438f19f7b3c7f.1439500639.git.shli@fb.com>
References: <cover.1439500639.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1439500639.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

This is the reclaim support for raid5 log. A stripe write will have
following steps:

1. reconstruct the stripe, read data/calculate parity. ops_run_io
prepares to write data/parity to raid disks
2. hijack ops_run_io. stripe data/parity is appending to log disk
3. flush log disk cache
4. ops_run_io run again and do normal operation. stripe data/parity is
written in raid array disks. raid core can return io to upper layer.
5. flush cache of all raid array disks
6. update super block
7. log disk space used by the stripe can be reused

In practice, several stripes consist of an io_unit and we will batch
several io_unit in different steps, but the whole process doesn't
change.

It's possible io return just after data/parity hit log disk, but then
read IO will need read from log disk. For simplicity, IO return happens
at step 4, where read IO can directly read from raid disks.

Currently reclaim run if there is specific reclaimable space (1/4 disk
size or 10G) or we are out of space. Reclaim is just to free log disk
spaces, it doesn't impact data consistency. The size based force reclaim
is to make sure log isn't too big, so recovery doesn't scan log too
much.

Recovery make sure raid disks and log disk have the same data of a
stripe. If crash happens before 4, recovery might/might not recovery
stripe's data/parity depending on if data/parity and its checksum
matches. In either case, this doesn't change the syntax of an IO write.
After step 3, stripe is guaranteed recoverable, because stripe's
data/parity is persistent in log disk. In some cases, log disk content
and raid disks content of a stripe are the same, but recovery will still
copy log disk content to raid disks, this doesn't impact data
consistency. space reuse happens after superblock update and cache
flush.

There is one situation we want to avoid. A broken meta in the middle of
a log causes recovery can't find meta at the head of log. If operations
require meta at the head persistent in log, we must make sure meta
before it persistent in log too. The case is stripe data/parity is in
log and we start write stripe to raid disks (before step 4). stripe
data/parity must be persistent in log before we do the write to raid
disks. The solution is we restrictly maintain io_unit list order. In
this case, we only write stripes of an io_unit to raid disks till the
io_unit is the first one whose data/parity is in log.

The io_unit list order is important for other cases too. For example,
some io_unit are reclaimable and others not. They can be mixed in the
list, we shouldn't reuse space of an unreclaimable io_unit.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 257 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c       |   6 ++
 drivers/md/raid5.h       |   2 +
 3 files changed, 264 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 50328ee..d02a402 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -30,12 +30,20 @@
  * */
 #define BLOCK_SECTORS (8)
 
+/*
+ * reclaim runs every 1/4 disk size or 10G reclaimable space. This can prevent
+ * recovery scans a very long log
+ * */
+#define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
+#define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
+
 struct r5l_log {
 	struct md_rdev *rdev;
 
 	u32 uuid_checksum;
 
 	sector_t device_size; /* log device size, round to BLOCK_SECTORS */
+	sector_t max_free_space; /* reclaim run if free space is at this size */
 
 	sector_t last_checkpoint; /* log tail. where recovery scan starts from */
 	u64 last_cp_seq; /* log tail sequence */
@@ -53,9 +61,20 @@ struct r5l_log {
 	struct list_head io_end_ios; /* io_units which have been completely
 				      * written to the log but not yet written
 				      * to the RAID */
+	struct list_head stripe_end_ios; /* io_units which have been
+					  * completely written to the RAID *
+					  * but have not yet been considered *
+					  * for updating super */
 
 	struct kmem_cache *io_kc;
 
+	struct md_thread *reclaim_thread;
+	sector_t reclaim_target; /* number of space that need to be reclaimed.
+				  * if it's 0, reclaim spaces used by io_units
+				  * which are in IO_UNIT_STRIPE_END state (eg,
+				  * reclaim dones't wait for specific io_unit
+				  * switching to IO_UNIT_STRIPE_END state) */
+
 	struct list_head no_space_stripes; /* pending stripes, log has no space */
 	spinlock_t no_space_stripes_lock;
 };
@@ -164,6 +183,35 @@ static void r5l_move_io_unit_list(struct list_head *from, struct list_head *to,
        }
 }
 
+/*
+ * We don't want too many io_units reside in stripe_end_ios list, which will
+ * waste a lot of memory. So we try to remove some. But we must keep at least 2
+ * io_units. The superblock must point to a valid meta, if it's the last meta,
+ * recovery can scan less
+ * */
+static void r5l_compress_stripe_end_list(struct r5l_log *log)
+{
+	struct r5l_io_unit *first, *last, *io;
+
+	first = list_first_entry(&log->stripe_end_ios,
+		struct r5l_io_unit, log_sibling);
+	last = list_last_entry(&log->stripe_end_ios,
+		struct r5l_io_unit, log_sibling);
+	if (first == last)
+		return;
+	list_del(&first->log_sibling);
+	list_del(&last->log_sibling);
+	while (!list_empty(&log->stripe_end_ios)) {
+		io = list_first_entry(&log->stripe_end_ios,
+			struct r5l_io_unit, log_sibling);
+		list_del(&io->log_sibling);
+		first->log_end = io->log_end;
+		r5l_free_io_unit(log, io);
+	}
+	list_add_tail(&first->log_sibling, &log->stripe_end_ios);
+	list_add_tail(&last->log_sibling, &log->stripe_end_ios);
+}
+
 static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	enum r5l_io_unit_state state)
@@ -176,6 +224,22 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	if (state == IO_UNIT_IO_END)
 		r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
 			IO_UNIT_IO_END);
+	if (state == IO_UNIT_STRIPE_END) {
+		struct r5l_io_unit *last;
+		sector_t reclaimable_space;
+
+		r5l_move_io_unit_list(&log->io_end_ios, &log->stripe_end_ios,
+			IO_UNIT_STRIPE_END);
+
+		last = list_last_entry(&log->stripe_end_ios,
+				struct r5l_io_unit, log_sibling);
+		reclaimable_space = r5l_ring_distance(log, log->last_checkpoint,
+					last->log_end);
+		if (reclaimable_space >= log->max_free_space)
+			r5l_wake_reclaim(log, 0);
+
+		r5l_compress_stripe_end_list(log);
+	}
 	wake_up(&io->wait_state);
 }
 
@@ -476,9 +540,175 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 	spin_unlock(&log->no_space_stripes_lock);
 }
 
+void r5l_stripe_write_finished(struct stripe_head *sh)
+{
+	struct r5l_io_unit *io;
+
+	/* Don't support stripe batch */
+	io = sh->log_io;
+	if (!io)
+		return;
+	sh->log_io = NULL;
+
+	if (atomic_dec_and_test(&io->pending_stripe))
+		r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
+}
+
+/*
+ * Starting dispatch IO to raid.
+ * io_unit(meta) consists of a log. There is one situation we want to avoid. A
+ * broken meta in the middle of a log causes recovery can't find meta at the
+ * head of log. If operations require meta at the head persistent in log, we
+ * must make sure meta before it persistent in log too. A case is:
+ *
+ * stripe data/parity is in log, we start write stripe to raid disks. stripe
+ * data/parity must be persistent in log before we do the write to raid disks.
+ *
+ * The solution is we restrictly maintain io_unit list order. In this case, we
+ * only write stripes of an io_unit to raid disks till the io_unit is the first
+ * one whose data/parity is in log.
+ * */
+void r5l_flush_stripe_to_raid(struct r5l_log *log)
+{
+	struct r5l_io_unit *io;
+	struct stripe_head *sh;
+	bool run_stripe;
+
+	if (!log)
+		return;
+	spin_lock_irq(&log->io_list_lock);
+	run_stripe = !list_empty(&log->io_end_ios);
+	spin_unlock_irq(&log->io_list_lock);
+
+	if (!run_stripe)
+		return;
+
+	blkdev_issue_flush(log->rdev->bdev, GFP_NOIO, NULL);
+
+	spin_lock_irq(&log->io_list_lock);
+	list_for_each_entry(io, &log->io_end_ios, log_sibling) {
+		if (io->state >= IO_UNIT_STRIPE_START)
+			continue;
+		__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_START);
+
+		while (!list_empty(&io->stripe_list)) {
+			sh = list_first_entry(&io->stripe_list,
+				struct stripe_head, log_list);
+			list_del_init(&sh->log_list);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			raid5_release_stripe(sh);
+		}
+	}
+	spin_unlock_irq(&log->io_list_lock);
+}
+
+static void r5l_kick_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
+{
+	/* the log thread will write the io unit */
+	wait_event(io->wait_state, io->state >= IO_UNIT_IO_END);
+	if (io->state < IO_UNIT_STRIPE_START)
+		r5l_flush_stripe_to_raid(log);
+	wait_event(io->wait_state, io->state >= IO_UNIT_STRIPE_END);
+}
+
+static void r5l_write_super(struct r5l_log *log, sector_t cp);
+static void r5l_do_reclaim(struct r5l_log *log)
+{
+	struct r5l_io_unit *io, *last;
+	LIST_HEAD(list);
+	sector_t free = 0;
+	sector_t reclaim_target = xchg(&log->reclaim_target, 0);
+
+	spin_lock_irq(&log->io_list_lock);
+	/*
+	 * move proper io_unit to reclaim list. We should not change the order.
+	 * reclaimable/unreclaimable io_unit can be mixed in the list, we
+	 * shouldn't reuse space of an unreclaimable io_unit
+	 * */
+	while (1) {
+		while (!list_empty(&log->stripe_end_ios)) {
+			io = list_first_entry(&log->stripe_end_ios,
+				struct r5l_io_unit, log_sibling);
+			list_move_tail(&io->log_sibling, &list);
+			free += r5l_ring_distance(log, io->log_start,
+						io->log_end);
+		}
+
+		if (free >= reclaim_target ||
+		    (list_empty(&log->running_ios) &&
+		     list_empty(&log->io_end_ios) &&
+		     list_empty(&log->stripe_end_ios)))
+			break;
+
+		/* Below waiting mostly happens when we shutdown the raid */
+		if (!list_empty(&log->io_end_ios)) {
+			io = list_first_entry(&log->io_end_ios,
+				struct r5l_io_unit, log_sibling);
+			spin_unlock_irq(&log->io_list_lock);
+			/* nobody else can delete the io, we are safe */
+			r5l_kick_io_unit(log, io);
+			spin_lock_irq(&log->io_list_lock);
+			continue;
+		}
+
+		if (!list_empty(&log->running_ios)) {
+			io = list_first_entry(&log->running_ios,
+				struct r5l_io_unit, log_sibling);
+			spin_unlock_irq(&log->io_list_lock);
+			/* nobody else can delete the io, we are safe */
+			r5l_kick_io_unit(log, io);
+			spin_lock_irq(&log->io_list_lock);
+			continue;
+		}
+	}
+	spin_unlock_irq(&log->io_list_lock);
+
+	if (list_empty(&list))
+		return;
+
+	/* super always point to last valid meta */
+	last = list_last_entry(&list, struct r5l_io_unit, log_sibling);
+	/*
+	 * write_super will flush cache of each raid disk. We must write super
+	 * here, because the log area might be reused soon and we don't want to
+	 * confuse recovery
+	 * */
+	r5l_write_super(log, last->log_start);
+
+	mutex_lock(&log->io_mutex);
+	log->last_checkpoint = last->log_start;
+	log->last_cp_seq = last->seq;
+	mutex_unlock(&log->io_mutex);
+	r5l_run_no_space_stripes(log);
+
+	while (!list_empty(&list)) {
+		io = list_first_entry(&list, struct r5l_io_unit, log_sibling);
+		list_del(&io->log_sibling);
+		r5l_free_io_unit(log, io);
+	}
+}
+
+static void r5l_reclaim_thread(struct md_thread *thread)
+{
+	struct mddev *mddev = thread->mddev;
+	struct r5conf *conf = mddev->private;
+	struct r5l_log *log = conf->log;
+
+	if (!log)
+		return;
+	r5l_do_reclaim(log);
+}
+
 static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
 {
-	/* will implement later */
+	sector_t target;
+
+	do {
+		target = log->reclaim_target;
+		if (space < target)
+			return;
+	} while (cmpxchg(&log->reclaim_target, target, space) != target);
+	md_wakeup_thread(log->reclaim_thread);
 }
 
 static int r5l_recovery_log(struct r5l_log *log)
@@ -549,6 +779,9 @@ static int r5l_load_log(struct r5l_log *log)
 		log->last_cp_seq = le64_to_cpu(mb->seq);
 
 	log->device_size = round_down(rdev->sectors, BLOCK_SECTORS);
+	log->max_free_space = log->device_size >> RECLAIM_MAX_FREE_SPACE_SHIFT;
+	if (log->max_free_space > RECLAIM_MAX_FREE_SPACE)
+		log->max_free_space = RECLAIM_MAX_FREE_SPACE;
 	log->last_checkpoint = cp;
 
 	__free_page(page);
@@ -577,11 +810,18 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 	spin_lock_init(&log->io_list_lock);
 	INIT_LIST_HEAD(&log->running_ios);
+	INIT_LIST_HEAD(&log->io_end_ios);
+	INIT_LIST_HEAD(&log->stripe_end_ios);
 
 	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
 	if (!log->io_kc)
 		goto io_kc;
 
+	log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
+		log->rdev->mddev, "reclaim");
+	if (!log->reclaim_thread)
+		goto reclaim_thread;
+
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
@@ -591,6 +831,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	conf->log = log;
 	return 0;
 error:
+	md_unregister_thread(&log->reclaim_thread);
+reclaim_thread:
 	kmem_cache_destroy(log->io_kc);
 io_kc:
 	kfree(log);
@@ -599,6 +841,19 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 
 void r5l_exit_log(struct r5l_log *log)
 {
+	/*
+	 * at this point all stripes are finished, so io_unit is at least in
+	 * STRIPE_END state
+	 * */
+	r5l_wake_reclaim(log, -1L);
+	md_unregister_thread(&log->reclaim_thread);
+	r5l_do_reclaim(log);
+	/*
+	 * force a super update, r5l_do_reclaim might updated the super.
+	 * mddev->thread is already stopped
+	 * */
+	md_update_sb(log->rdev->mddev, 1);
+
 	kmem_cache_destroy(log->io_kc);
 	kfree(log);
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fb8a811..40799ed 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3106,6 +3106,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		if (bi)
 			bitmap_end = 1;
 
+		r5l_stripe_write_finished(sh);
+
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
 
@@ -3504,6 +3506,8 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 			WARN_ON(dev->page != dev->orig_page);
 		}
 
+	r5l_stripe_write_finished(sh);
+
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
 		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
@@ -5879,6 +5883,8 @@ static void raid5d(struct md_thread *thread)
 		mutex_unlock(&conf->cache_size_mutex);
 	}
 
+	r5l_flush_stripe_to_raid(conf->log);
+
 	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index ff666eb..d098ca9 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -624,4 +624,6 @@ extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
 extern void r5l_exit_log(struct r5l_log *log);
 extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
 extern void r5l_write_stripe_run(struct r5l_log *log);
+extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
+extern void r5l_stripe_write_finished(struct stripe_head *sh);
 #endif
-- 
1.8.1

