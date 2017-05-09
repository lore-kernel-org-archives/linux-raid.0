From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 1/2] md:r5cache: in r5l_do_submit_io(), submit io->split_bio first.
Date: Mon, 8 May 2017 17:39:24 -0700
Message-ID: <20170509003925.3480693-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In r5l_do_submit_io(), it is necessary to check io->split_bio before
submit io->current_bio. This is because, endio of current_bio may
free the whole IO unit, and thus change io->split_bio.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 26ba092..dc1dba6 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -622,20 +622,29 @@ static void r5l_do_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
+	/*
+	 * In case of journal device failures, submit_bio will get error
+	 * and calls endio, then active stripes will continue write
+	 * process. Therefore, it is not necessary to check Faulty bit
+	 * of journal device here.
+	 *
+	 * However, calling r5l_log_endio for current_bio may free the
+	 * io_unit. Therefore, it is necessary to check io->split_bio
+	 * before submitting io->current_bio.
+	 */
+	if (io->split_bio) {
+		if (io->has_flush)
+			io->split_bio->bi_opf |= REQ_PREFLUSH;
+		if (io->has_fua)
+			io->split_bio->bi_opf |= REQ_FUA;
+		submit_bio(io->split_bio);
+	}
+
 	if (io->has_flush)
 		io->current_bio->bi_opf |= REQ_PREFLUSH;
 	if (io->has_fua)
 		io->current_bio->bi_opf |= REQ_FUA;
 	submit_bio(io->current_bio);
-
-	if (!io->split_bio)
-		return;
-
-	if (io->has_flush)
-		io->split_bio->bi_opf |= REQ_PREFLUSH;
-	if (io->has_fua)
-		io->split_bio->bi_opf |= REQ_FUA;
-	submit_bio(io->split_bio);
 }
 
 /* deferred io_unit will be dispatched here */
-- 
2.9.3

