From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] md/r5cache: generate R5LOG_PAYLOAD_FLUSH
Date: Tue, 7 Mar 2017 17:44:22 -0800
Message-ID: <20170308014422.4019149-2-songliubraving@fb.com>
References: <20170308014422.4019149-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308014422.4019149-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In r5c_finish_stripe_write_out(), R5LOG_PAYLOAD_FLUSH is append to
log->current_io.

Appending R5LOG_PAYLOAD_FLUSH in quiesce needs extra writes to
journal. To simplify the logic, we just skip R5LOG_PAYLOAD_FLUSH in
quiesce.

Even R5LOG_PAYLOAD_FLUSH supports multiple stripes per payload.
However, current implementation is one stripe per R5LOG_PAYLOAD_FLUSH,
which is simpler.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index e69f922..fd0bfea 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -590,7 +590,21 @@ static void r5l_log_endio(struct bio *bio)
 	mempool_free(io->meta_page, log->meta_pool);
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
-	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
+
+	if (list_empty(&io->stripe_list))
+		/*
+		 * this io_unit only has R5LOG_PAYLOAD_FLUSH, set
+		 * to IO_UNIT_STRIPE_END
+		 */
+		__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
+	else
+		/*
+		 * io_unit with R5LOG_PAYLOAD_FLUSH and also DATA/PARITY
+		 * set to IO_UNIT_IO_END and wait for all stripes get
+		 * handled.
+		 */
+		__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
+
 	if (log->need_cache_flush)
 		r5l_move_to_end_ios(log);
 	else
@@ -843,6 +857,41 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
 	r5_reserve_log_entry(log, io);
 }
 
+static void r5l_append_flush_payload(struct r5l_log *log, sector_t sect)
+{
+	struct mddev *mddev = log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+	struct r5l_io_unit *io;
+	struct r5l_payload_flush *payload;
+	int meta_size;
+
+	/*
+	 * payload_flush requires extra writes to the journal.
+	 * To avoid handling the extra IO in quiesce, just skip
+	 * flush_payload
+	 */
+	if (conf->quiesce)
+		return;
+
+	mutex_lock(&log->io_mutex);
+	meta_size = sizeof(struct r5l_payload_flush) + sizeof(__le64);
+
+	if (r5l_get_meta(log, meta_size)) {
+		mutex_unlock(&log->io_mutex);
+		return;
+	}
+
+	/* current implementation is one stripe per flush payload */
+	io = log->current_io;
+	payload = page_address(io->meta_page) + io->meta_offset;
+	payload->header.type = cpu_to_le16(R5LOG_PAYLOAD_FLUSH);
+	payload->header.flags = cpu_to_le16(0);
+	payload->size = cpu_to_le32(sizeof(__le64));
+	payload->flush_stripes[0] = cpu_to_le64(sect);
+	io->meta_offset += meta_size;
+	mutex_unlock(&log->io_mutex);
+}
+
 static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
 			   int data_pages, int parity_pages)
 {
@@ -1466,6 +1515,13 @@ static void r5l_do_reclaim(struct r5l_log *log)
 		     list_empty(&log->finished_ios)))
 			break;
 
+		/*
+		 * In some cases, io_unit with only R5LOG_PAYLOAD_FLUSH
+		 * will stay in finished_ios list. It is necessary to
+		 * complete them before quiesce.
+		 */
+		r5l_complete_finished_ios(log);
+
 		md_wakeup_thread(log->rdev->mddev->thread);
 		wait_event_lock_irq(log->iounit_wait,
 				    r5l_reclaimable_space(log) > reclaimable,
@@ -2784,6 +2840,8 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 		atomic_dec(&conf->r5c_flushing_full_stripes);
 		atomic_dec(&conf->r5c_cached_full_stripes);
 	}
+
+	r5l_append_flush_payload(log, sh->sector);
 }
 
 int
-- 
2.9.3

