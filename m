From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 8/8] md/r5cache: handle SYNC and FUA
Date: Mon, 10 Oct 2016 17:24:46 -0700
Message-ID: <20161011002446.2002428-9-songliubraving@fb.com>
References: <20161011002446.2002428-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161011002446.2002428-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

With raid5 cache, we committing data from journal device. When
there is flush request, we need to flush journal device's cache.
This was not needed in raid5 journal, because we will flush the
journal before committing data to raid disks.

This is similar to FUA, except that we also need flush journal for
FUA. Otherwise, corruptions in earlier meta data will stop recovery
from reaching FUA data.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 162 +++++++++++++++++++++++++++++++++++++++++------
 drivers/md/raid5.c       |   8 +++
 drivers/md/raid5.h       |   1 +
 3 files changed, 153 insertions(+), 18 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b9fade3..f78ee8c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -19,6 +19,7 @@
 #include <linux/raid/md_p.h>
 #include <linux/crc32c.h>
 #include <linux/random.h>
+#include <trace/events/block.h>
 #include "md.h"
 #include "raid5.h"
 #include "bitmap.h"
@@ -158,6 +159,9 @@ struct r5l_log {
 						 */
 	spinlock_t stripe_in_cache_lock;
 	atomic_t stripe_in_cache_count;
+
+	/* to submit async io_units, to fulfill ordering of flush */
+	struct work_struct deferred_io_work;
 };
 
 /*
@@ -184,6 +188,18 @@ struct r5l_io_unit {
 
 	int state;
 	bool need_split_bio;
+	struct bio *split_bio;
+
+	unsigned int has_flush:1;      /* include flush request */
+	unsigned int has_fua:1;        /* include fua request */
+	unsigned int has_null_flush:1; /* include empty flush request */
+	/*
+	 * io isn't sent yet, flush/fua request can only be submitted till it's
+	 * the first IO in running_ios list
+	 */
+	unsigned int io_deferred:1;
+
+	struct bio_list flush_barriers;   /* size == 0 flush bios */
 };
 
 /* r5l_io_unit state */
@@ -481,9 +497,11 @@ static void r5l_move_to_end_ios(struct r5l_log *log)
 	}
 }
 
+static void __r5l_stripe_write_finished(struct r5l_io_unit *io);
 static void r5l_log_endio(struct bio *bio)
 {
 	struct r5l_io_unit *io = bio->bi_private;
+	struct r5l_io_unit *io_deferred;
 	struct r5l_log *log = io->log;
 	unsigned long flags;
 
@@ -499,18 +517,89 @@ static void r5l_log_endio(struct bio *bio)
 		r5l_move_to_end_ios(log);
 	else
 		r5l_log_run_stripes(log);
+	if (!list_empty(&log->running_ios)) {
+		/*
+		 * FLUSH/FUA io_unit is deferred because of ordering, now we
+		 * can dispatch it
+		 */
+		io_deferred = list_first_entry(&log->running_ios,
+					       struct r5l_io_unit, log_sibling);
+		if (io_deferred->io_deferred)
+			schedule_work(&log->deferred_io_work);
+	}
+
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
 	if (log->need_cache_flush)
 		md_wakeup_thread(log->rdev->mddev->thread);
+
+	if (io->has_null_flush) {
+		struct bio *bi;
+
+		WARN_ON(bio_list_empty(&io->flush_barriers));
+		while ((bi = bio_list_pop(&io->flush_barriers)) != NULL) {
+			bio_endio(bi);
+			atomic_dec(&io->pending_stripe);
+		}
+		if (atomic_read(&io->pending_stripe) == 0)
+			__r5l_stripe_write_finished(io);
+	}
+}
+
+static void r5l_do_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+
+	if (io->has_flush)
+		bio_set_op_attrs(io->current_bio, REQ_OP_WRITE, WRITE_FLUSH);
+	if (io->has_fua)
+		bio_set_op_attrs(io->current_bio, REQ_OP_WRITE, WRITE_FUA);
+	submit_bio(io->current_bio);
+
+	if (!io->split_bio)
+		return;
+
+	if (io->has_flush)
+		bio_set_op_attrs(io->split_bio, REQ_OP_WRITE, WRITE_FLUSH);
+	if (io->has_fua)
+		bio_set_op_attrs(io->split_bio, REQ_OP_WRITE, WRITE_FUA);
+	submit_bio(io->split_bio);
+}
+
+/* deferred io_unit will be dispatched here */
+static void r5l_submit_io_async(struct work_struct *work)
+{
+	struct r5l_log *log = container_of(work, struct r5l_log,
+					   deferred_io_work);
+	struct r5l_io_unit *io = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	if (!list_empty(&log->running_ios)) {
+		io = list_first_entry(&log->running_ios, struct r5l_io_unit,
+				      log_sibling);
+		if (!io->io_deferred)
+			io = NULL;
+		else
+			io->io_deferred = 0;
+	}
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+	if (io)
+		r5l_do_submit_io(log, io);
 }
 
 static void r5l_submit_current_io(struct r5l_log *log)
 {
 	struct r5l_io_unit *io = log->current_io;
+	struct bio *bio;
 	struct r5l_meta_block *block;
 	unsigned long flags;
 	u32 crc;
+	bool do_submit = true;
 
 	if (!io)
 		return;
@@ -519,13 +608,20 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	block->meta_size = cpu_to_le32(io->meta_offset);
 	crc = crc32c_le(log->uuid_checksum, block, PAGE_SIZE);
 	block->checksum = cpu_to_le32(crc);
+	bio = io->current_bio;
 
 	log->current_io = NULL;
 	spin_lock_irqsave(&log->io_list_lock, flags);
-	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
+	if (io->has_flush || io->has_fua) {
+		if (io != list_first_entry(&log->running_ios,
+					   struct r5l_io_unit, log_sibling)) {
+			io->io_deferred = 1;
+			do_submit = false;
+		}
+	}
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
-
-	submit_bio(io->current_bio);
+	if (do_submit)
+		r5l_do_submit_io(log, io);
 }
 
 static struct bio *r5l_bio_alloc(struct r5l_log *log)
@@ -570,6 +666,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	io->log = log;
 	INIT_LIST_HEAD(&io->log_sibling);
 	INIT_LIST_HEAD(&io->stripe_list);
+	bio_list_init(&io->flush_barriers);
 	io->state = IO_UNIT_RUNNING;
 
 	io->meta_page = mempool_alloc(log->meta_pool, GFP_NOIO);
@@ -640,12 +737,11 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
 	struct r5l_io_unit *io = log->current_io;
 
 	if (io->need_split_bio) {
-		struct bio *prev = io->current_bio;
-
+		BUG_ON(io->split_bio);
+		io->split_bio = io->current_bio;
 		io->current_bio = r5l_bio_alloc(log);
-		bio_chain(io->current_bio, prev);
-
-		submit_bio(prev);
+		bio_chain(io->current_bio, io->split_bio);
+		io->need_split_bio = false;
 	}
 
 	if (!bio_add_page(io->current_bio, page, PAGE_SIZE, 0))
@@ -675,12 +771,23 @@ static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 
 	io = log->current_io;
 
+	if (test_and_clear_bit(STRIPE_R5C_PREFLUSH, &sh->state))
+		io->has_flush = 1;
+
 	for (i = 0; i < sh->disks; i++) {
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
 		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
 			continue;
 		if (i == sh->pd_idx || i == sh->qd_idx)
 			continue;
+		if (test_bit(R5_WantFUA, &sh->dev[i].flags)) {
+			io->has_fua = 1;
+			/*
+			 * we need to flush journal to make sure recovery can
+			 * reach the data with fua flag
+			 */
+			io->has_flush = 1;
+		}
 		r5l_append_payload_meta(log, R5LOG_PAYLOAD_DATA,
 					raid5_compute_blocknr(sh, i, 0),
 					sh->dev[i].log_checksum, 0, false);
@@ -845,17 +952,34 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 {
 	if (!log)
 		return -ENODEV;
-	/*
-	 * we flush log disk cache first, then write stripe data to raid disks.
-	 * So if bio is finished, the log disk cache is flushed already. The
-	 * recovery guarantees we can recovery the bio from log disk, so we
-	 * don't need to flush again
-	 */
-	if (bio->bi_iter.bi_size == 0) {
-		bio_endio(bio);
-		return 0;
+
+	if (log->r5c_state == R5C_STATE_WRITE_THROUGH) {
+		/*
+		 * in write through (journal only)
+		 * we flush log disk cache first, then write stripe data to
+		 * raid disks. So if bio is finished, the log disk cache is
+		 * flushed already. The recovery guarantees we can recovery
+		 * the bio from log disk, so we don't need to flush again
+		 */
+		if (bio->bi_iter.bi_size == 0) {
+			bio_endio(bio);
+			return 0;
+		}
+		bio->bi_opf &= ~REQ_PREFLUSH;
+	} else {
+		/* write back (with cache) */
+		if (bio->bi_iter.bi_size == 0) {
+			mutex_lock(&log->io_mutex);
+			r5l_get_meta(log, 0);
+			bio_list_add(&log->current_io->flush_barriers, bio);
+			log->current_io->has_flush = 1;
+			log->current_io->has_null_flush = 1;
+			atomic_inc(&log->current_io->pending_stripe);
+			r5l_submit_current_io(log);
+			mutex_unlock(&log->io_mutex);
+			return 0;
+		}
 	}
-	bio->bi_opf &= ~REQ_PREFLUSH;
 	return -EAGAIN;
 }
 
@@ -2314,6 +2438,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->no_space_stripes);
 	spin_lock_init(&log->no_space_stripes_lock);
 
+	INIT_WORK(&log->deferred_io_work, r5l_submit_io_async);
+
 	log->r5c_state = R5C_STATE_WRITE_THROUGH;
 	INIT_LIST_HEAD(&log->stripe_in_cache_list);
 	spin_lock_init(&log->stripe_in_cache_lock);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ffabde9..cb81703 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5224,6 +5224,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 	int remaining;
 	DEFINE_WAIT(w);
 	bool do_prepare;
+	bool do_flush = false;
 
 	if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
 		int ret = r5l_handle_flush_request(conf->log, bi);
@@ -5235,6 +5236,7 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 			return;
 		}
 		/* ret == -EAGAIN, fallback */
+		do_flush = true;
 	}
 
 	md_write_start(mddev, bi);
@@ -5374,6 +5376,12 @@ static void raid5_make_request(struct mddev *mddev, struct bio * bi)
 				do_prepare = true;
 				goto retry;
 			}
+			if (do_flush) {
+				set_bit(STRIPE_R5C_PREFLUSH, &sh->state);
+				/* we only need flush for one stripe */
+				do_flush = false;
+			}
+
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if ((!sh->batch_head || sh == sh->batch_head) &&
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 6898a76..317f204 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -360,6 +360,7 @@ enum {
 	STRIPE_R5C_FULL_STRIPE,	/* in r5c cache (to-be/being handled or
 				 * in conf->r5c_full_stripe_list)
 				 */
+	STRIPE_R5C_PREFLUSH,	/* need to flush journal device */
 };
 
 #define STRIPE_EXPAND_SYNC_FLAGS \
-- 
2.9.3

