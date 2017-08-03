From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v5] md/r5cache: fix io_unit handling in r5l_log_endio()
Date: Thu, 3 Aug 2017 10:03:17 -0700
Message-ID: <20170803170317.2767860-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, shli@kernel.org
Cc: Song Liu <songliubraving@fb.com>, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

In r5l_log_endio(), once log->io_list_lock is released, the io unit
may be accessed (or even freed) by other threads. Current code
doesn't handle the io_unit properly, which leads to potential race
conditions.

This patch solves this race condition by:

1. Add a pending_stripe count flush_payload. Multiple flush_payloads
   are counted as only one pending_stripe. Flag has_flush_payload is
   added to show whether the io unit has flush_payload;
2. In r5l_log_endio(), check flags has_null_flush and
   has_flush_payload with log->io_list_lock held. After the lock
   is released, this IO unit is only accessed when we know the
   pending_stripe counter cannot be zeroed by other threads.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index ce98414..2dcbafa 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -236,9 +236,10 @@ struct r5l_io_unit {
 	bool need_split_bio;
 	struct bio *split_bio;
 
-	unsigned int has_flush:1;      /* include flush request */
-	unsigned int has_fua:1;        /* include fua request */
-	unsigned int has_null_flush:1; /* include empty flush request */
+	unsigned int has_flush:1;		/* include flush request */
+	unsigned int has_fua:1;			/* include fua request */
+	unsigned int has_null_flush:1;		/* include null flush request */
+	unsigned int has_flush_payload:1;	/* include flush payload  */
 	/*
 	 * io isn't sent yet, flush/fua request can only be submitted till it's
 	 * the first IO in running_ios list
@@ -571,6 +572,8 @@ static void r5l_log_endio(struct bio *bio)
 	struct r5l_io_unit *io_deferred;
 	struct r5l_log *log = io->log;
 	unsigned long flags;
+	bool has_null_flush;
+	bool has_flush_payload;
 
 	if (bio->bi_status)
 		md_error(log->rdev->mddev, log->rdev);
@@ -580,6 +583,16 @@ static void r5l_log_endio(struct bio *bio)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
+
+	/*
+	 * if the io doesn't not have null_flush or flush payload,
+	 * it is not safe to access it after releasing io_list_lock.
+	 * Therefore, it is necessary to check the condition with
+	 * the lock held.
+	 */
+	has_null_flush = io->has_null_flush;
+	has_flush_payload = io->has_flush_payload;
+
 	if (log->need_cache_flush && !list_empty(&io->stripe_list))
 		r5l_move_to_end_ios(log);
 	else
@@ -600,19 +613,23 @@ static void r5l_log_endio(struct bio *bio)
 	if (log->need_cache_flush)
 		md_wakeup_thread(log->rdev->mddev->thread);
 
-	if (io->has_null_flush) {
+	/* finish flush only io_unit and PAYLOAD_FLUSH only io_unit */
+	if (has_null_flush) {
 		struct bio *bi;
 
 		WARN_ON(bio_list_empty(&io->flush_barriers));
 		while ((bi = bio_list_pop(&io->flush_barriers)) != NULL) {
 			bio_endio(bi);
-			atomic_dec(&io->pending_stripe);
+			if (atomic_dec_and_test(&io->pending_stripe)) {
+				__r5l_stripe_write_finished(io);
+				return;
+			}
 		}
 	}
-
-	/* finish flush only io_unit and PAYLOAD_FLUSH only io_unit */
-	if (atomic_read(&io->pending_stripe) == 0)
-		__r5l_stripe_write_finished(io);
+	/* decrease pending_stripe for flush payload */
+	if (has_flush_payload)
+		if (atomic_dec_and_test(&io->pending_stripe))
+			__r5l_stripe_write_finished(io);
 }
 
 static void r5l_do_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
@@ -881,6 +898,11 @@ static void r5l_append_flush_payload(struct r5l_log *log, sector_t sect)
 	payload->size = cpu_to_le32(sizeof(__le64));
 	payload->flush_stripes[0] = cpu_to_le64(sect);
 	io->meta_offset += meta_size;
+	/* multiple flush payloads count as one pending_stripe */
+	if (!io->has_flush_payload) {
+		io->has_flush_payload = 1;
+		atomic_inc(&io->pending_stripe);
+	}
 	mutex_unlock(&log->io_mutex);
 }
 
-- 
2.9.3

