From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/2] md/r5cache: fix io_unit handling in r5l_log_endio()
Date: Thu, 27 Jul 2017 16:35:56 -0700
Message-ID: <20170727233556.3802574-2-songliubraving@fb.com>
References: <20170727233556.3802574-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170727233556.3802574-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

In r5l_log_endio(), the io_unit should only be modified with lock
io_list_lock held.

Also, r5l_log_endio() should not call __r5l_stripe_write_finished()
directly. It should be just set io_state to IO_UNIT_STRIPE_END and
__r5l_stripe_write_finished() will be called later.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/md/raid5-cache.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 315cabf..d4e08a2 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -580,6 +580,20 @@ static void r5l_log_endio(struct bio *bio)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
+
+	if (io->has_null_flush) {
+		struct bio *bi;
+
+		WARN_ON(bio_list_empty(&io->flush_barriers));
+		while ((bi = bio_list_pop(&io->flush_barriers)) != NULL) {
+			bio_endio(bi);
+			atomic_dec(&io->pending_stripe);
+		}
+	}
+	/* finish flush only io_unit and PAYLOAD_FLUSH only io_unit */
+	if (atomic_read(&io->pending_stripe) == 0)
+		__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
+
 	if (log->need_cache_flush && !list_empty(&io->stripe_list))
 		r5l_move_to_end_ios(log);
 	else
@@ -599,20 +613,6 @@ static void r5l_log_endio(struct bio *bio)
 
 	if (log->need_cache_flush)
 		md_wakeup_thread(log->rdev->mddev->thread);
-
-	if (io->has_null_flush) {
-		struct bio *bi;
-
-		WARN_ON(bio_list_empty(&io->flush_barriers));
-		while ((bi = bio_list_pop(&io->flush_barriers)) != NULL) {
-			bio_endio(bi);
-			atomic_dec(&io->pending_stripe);
-		}
-	}
-
-	/* finish flush only io_unit and PAYLOAD_FLUSH only io_unit */
-	if (atomic_read(&io->pending_stripe) == 0)
-		__r5l_stripe_write_finished(io);
 }
 
 static void r5l_do_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
-- 
2.9.3

