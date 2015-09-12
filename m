From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/12] raid5-cache: use FUA writes for the log
Date: Sat, 12 Sep 2015 08:17:11 +0200
Message-ID: <1442038638-6947-6-git-send-email-hch@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442038638-6947-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

If we submit writes with the FUA bit for the log they are guaranteed to
be on stable storage once the endio callback is called.  This allows
to simplify the IO unit state machine, and decrease latencies a lot
when the device supports FUA.  Use this to improve performance on devices
that support FUA, or keep the old code if the device doesn't support it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index c288c43..d813c89 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -81,6 +81,8 @@ struct r5l_log {
 
 	struct list_head no_space_stripes; /* pending stripes, log has no space */
 	spinlock_t no_space_stripes_lock;
+
+	bool use_fua;
 };
 
 /*
@@ -203,6 +205,22 @@ static void r5l_io_run_stripes(struct r5l_io_unit *io)
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
 /* XXX: totally ignores I/O errors */
 static void r5l_log_endio(struct bio *bio)
 {
@@ -217,11 +235,15 @@ static void r5l_log_endio(struct bio *bio)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
-	r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
-			IO_UNIT_IO_END);
+	if (log->use_fua)
+		r5l_log_run_stripes(log);
+	else
+		r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
+				      IO_UNIT_IO_END);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
-	md_wakeup_thread(log->rdev->mddev->thread);
+	if (!log->use_fua)
+		md_wakeup_thread(log->rdev->mddev->thread);
 }
 
 static void r5l_submit_current_io(struct r5l_log *log)
@@ -248,7 +270,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	while ((bio = bio_list_pop(&io->bios))) {
 		/* all IO must start from rdev->data_offset */
 		bio->bi_iter.bi_sector += log->rdev->data_offset;
-		submit_bio(WRITE, bio);
+		submit_bio(WRITE | (log->use_fua ? REQ_FUA : 0), bio);
 	}
 }
 
@@ -614,7 +636,8 @@ static void r5l_log_flush_endio(struct bio *bio)
 void r5l_flush_stripe_to_raid(struct r5l_log *log)
 {
 	bool do_flush;
-	if (!log)
+
+	if (!log || log->use_fua)
 		return;
 
 	spin_lock_irq(&log->io_list_lock);
@@ -1066,6 +1089,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		return -ENOMEM;
 	log->rdev = rdev;
 
+	log->use_fua = (rdev->bdev->bd_disk->queue->flush_flags & REQ_FUA);
+
 	log->uuid_checksum = crc32_le(~0, (void *)rdev->mddev->uuid,
 			sizeof(rdev->mddev->uuid));
 
-- 
1.9.1

