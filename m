From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/11] raid5-cache: simplify state machine when caches flushes are not needed
Date: Mon,  5 Oct 2015 09:31:09 +0200
Message-ID: <1444030276-30850-5-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For devices without a volatile write cache we don't need to send a FLUSH
command to ensure writes are stable on disk, and thus can avoid the whole
step of batching up bios for processing by the MD thread.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b04e908..0d18ed7 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -83,6 +83,8 @@ struct r5l_log {
 
 	struct list_head no_space_stripes; /* pending stripes, log has no space */
 	spinlock_t no_space_stripes_lock;
+
+	bool need_cache_flush;
 };
 
 /*
@@ -205,6 +207,22 @@ static void r5l_io_run_stripes(struct r5l_io_unit *io)
 	}
 }
 
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
 static void r5l_log_endio(struct bio *bio)
 {
 	struct r5l_io_unit *io = bio->bi_private;
@@ -221,11 +239,15 @@ static void r5l_log_endio(struct bio *bio)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
-	r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
-			IO_UNIT_IO_END);
+	if (log->need_cache_flush)
+		r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
+				      IO_UNIT_IO_END);
+	else
+		r5l_log_run_stripes(log);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
-	md_wakeup_thread(log->rdev->mddev->thread);
+	if (log->need_cache_flush)
+		md_wakeup_thread(log->rdev->mddev->thread);
 }
 
 static void r5l_submit_current_io(struct r5l_log *log)
@@ -626,7 +648,8 @@ static void r5l_log_flush_endio(struct bio *bio)
 void r5l_flush_stripe_to_raid(struct r5l_log *log)
 {
 	bool do_flush;
-	if (!log)
+
+	if (!log || !log->need_cache_flush)
 		return;
 
 	spin_lock_irq(&log->io_list_lock);
@@ -1115,6 +1138,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		return -ENOMEM;
 	log->rdev = rdev;
 
+	log->need_cache_flush = (rdev->bdev->bd_disk->queue->flush_flags != 0);
+
 	log->uuid_checksum = crc32_le(~0, (void *)rdev->mddev->uuid,
 				      sizeof(rdev->mddev->uuid));
 
-- 
1.9.1

