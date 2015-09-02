From: Shaohua Li <shli@fb.com>
Subject: [PATCH 5/8] raid5-cache: move functionality out of __r5l_set_io_unit_state
Date: Wed, 2 Sep 2015 13:49:48 -0700
Message-ID: <9c6012891d07d00594ec726cbf1c14c08deaf24d.1441221530.git.shli@fb.com>
References: <cover.1441221530.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1441221530.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

From: Christoph Hellwig <hch@lst.de>

Just keep __r5l_set_io_unit_state as a small set the state wrapper, and
remove r5l_set_io_unit_state entirely after moving the real
functionality to the two callers that need it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 81 +++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2f5e2b8..5a216ab 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -214,59 +214,31 @@ static void r5l_compress_stripe_end_list(struct r5l_log *log)
 	list_add_tail(&last->log_sibling, &log->stripe_end_ios);
 }
 
-static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	enum r5l_io_unit_state state)
 {
-	struct r5l_log *log = io->log;
-
 	if (WARN_ON(io->state >= state))
 		return;
 	io->state = state;
-	if (state == IO_UNIT_IO_END)
-		r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
-			IO_UNIT_IO_END);
-	if (state == IO_UNIT_STRIPE_END) {
-		struct r5l_io_unit *last;
-		sector_t reclaimable_space;
-
-		r5l_move_io_unit_list(&log->flushed_ios, &log->stripe_end_ios,
-			IO_UNIT_STRIPE_END);
-
-		last = list_last_entry(&log->stripe_end_ios,
-				struct r5l_io_unit, log_sibling);
-		reclaimable_space = r5l_ring_distance(log, log->last_checkpoint,
-					last->log_end);
-		if (reclaimable_space >= log->max_free_space)
-			r5l_wake_reclaim(log, 0);
-
-		r5l_compress_stripe_end_list(log);
-		wake_up(&log->iounit_wait);
-	}
 }
 
-static void r5l_set_io_unit_state(struct r5l_io_unit *io,
-	enum r5l_io_unit_state state)
-{
-	struct r5l_log *log = io->log;
-	unsigned long flags;
-
-	spin_lock_irqsave(&log->io_list_lock, flags);
-	__r5l_set_io_unit_state(io, state);
-	spin_unlock_irqrestore(&log->io_list_lock, flags);
-}
-
-static void r5l_log_endio(struct bio *bio, int error)
+static inline void r5l_log_endio(struct bio *bio, int error)
 {
 	struct r5l_io_unit *io = bio->bi_private;
 	struct r5l_log *log = io->log;
+	unsigned long flags;
 
 	bio_put(bio);
 
 	if (!atomic_dec_and_test(&io->pending_io))
 		return;
 
-	r5l_set_io_unit_state(io, IO_UNIT_IO_END);
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
+	r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
+			IO_UNIT_IO_END);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+
 	md_wakeup_thread(log->rdev->mddev->thread);
 }
 
@@ -275,6 +247,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	struct r5l_io_unit *io = log->current_io;
 	struct r5l_meta_block *block;
 	struct bio *bio;
+	unsigned long flags;
 	u32 crc;
 
 	if (!io)
@@ -286,7 +259,9 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	block->checksum = cpu_to_le32(crc);
 
 	log->current_io = NULL;
-	r5l_set_io_unit_state(io, IO_UNIT_IO_START);
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
 	while ((bio = bio_list_pop(&io->bios))) {
 		/* all IO must start from rdev->data_offset */
@@ -451,6 +426,7 @@ static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 	sh->log_io = io;
 }
 
+static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 /*
  * running in raid5d, where reclaim could wait for raid5d too (when it flushes
  * data from log to raid disks), so we shouldn't wait for reclaim here
@@ -542,18 +518,39 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 	spin_unlock(&log->no_space_stripes_lock);
 }
 
+static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
+{
+	struct r5l_log *log = io->log;
+	struct r5l_io_unit *last;
+	sector_t reclaimable_space;
+	unsigned long flags;
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
+	r5l_move_io_unit_list(&log->flushed_ios, &log->stripe_end_ios,
+		IO_UNIT_STRIPE_END);
+
+	last = list_last_entry(&log->stripe_end_ios,
+			struct r5l_io_unit, log_sibling);
+	reclaimable_space = r5l_ring_distance(log, log->last_checkpoint,
+				last->log_end);
+	if (reclaimable_space >= log->max_free_space)
+		r5l_wake_reclaim(log, 0);
+
+	r5l_compress_stripe_end_list(log);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+	wake_up(&log->iounit_wait);
+}
+
 void r5l_stripe_write_finished(struct stripe_head *sh)
 {
 	struct r5l_io_unit *io;
 
-	/* Don't support stripe batch */
 	io = sh->log_io;
-	if (!io)
-		return;
 	sh->log_io = NULL;
 
-	if (atomic_dec_and_test(&io->pending_stripe))
-		r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
+	if (io && atomic_dec_and_test(&io->pending_stripe))
+		__r5l_stripe_write_finished(io);
 }
 
 static void r5l_log_flush_endio(struct bio *bio, int error)
-- 
1.8.1

