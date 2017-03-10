From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3] md/r5cache: generate R5LOG_PAYLOAD_FLUSH
Date: Thu, 9 Mar 2017 21:23:39 -0800
Message-ID: <20170310052339.2705936-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
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
 drivers/md/raid5-cache.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index e69f922..e3c20c7 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -591,7 +591,7 @@ static void r5l_log_endio(struct bio *bio)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
-	if (log->need_cache_flush)
+	if (log->need_cache_flush && !list_empty(&io->stripe_list))
 		r5l_move_to_end_ios(log);
 	else
 		r5l_log_run_stripes(log);
@@ -619,9 +619,11 @@ static void r5l_log_endio(struct bio *bio)
 			bio_endio(bi);
 			atomic_dec(&io->pending_stripe);
 		}
-		if (atomic_read(&io->pending_stripe) == 0)
-			__r5l_stripe_write_finished(io);
 	}
+
+	/* finish flush only io_unit and PAYLOAD_FLUSH only io_unit */
+	if (atomic_read(&io->pending_stripe) == 0)
+		__r5l_stripe_write_finished(io);
 }
 
 static void r5l_do_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
@@ -843,6 +845,41 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
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
@@ -2784,6 +2821,8 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 		atomic_dec(&conf->r5c_flushing_full_stripes);
 		atomic_dec(&conf->r5c_cached_full_stripes);
 	}
+
+	r5l_append_flush_payload(log, sh->sector);
 }
 
 int
-- 
2.9.3

