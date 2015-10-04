From: Shaohua Li <shli@fb.com>
Subject: [PATCH 6/6] raid5-cache: IO error handling
Date: Sun, 4 Oct 2015 09:20:16 -0700
Message-ID: <a0512a009016cb5a02429f48176839dd642f6d3c.1443973492.git.shli@fb.com>
References: <cover.1443973492.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1443973492.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

There are 3 places the raid5-cache dispatches IO. The discard IO error
doesn't matter, so we ignore it. The superblock write IO error can be
handled in MD core. The remaining are log write and flush. When the IO
error happens, we mark log disk faulty and fail all write IO. Read IO is
still allowed to run. Userspace will get a notification too and
corresponding daemon can choose setting raid array readonly for example.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c | 15 ++++++++++++++-
 drivers/md/raid5.c       |  4 +++-
 drivers/md/raid5.h       |  2 ++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 6c52168..e917e53 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -223,13 +223,15 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
-/* XXX: totally ignores I/O errors */
 static void r5l_log_endio(struct bio *bio)
 {
 	struct r5l_io_unit *io = bio->bi_private;
 	struct r5l_log *log = io->log;
 	unsigned long flags;
 
+	if (bio->bi_error)
+		md_error(log->rdev->mddev, log->rdev);
+
 	bio_put(bio);
 
 	if (!atomic_dec_and_test(&io->pending_io))
@@ -594,6 +596,9 @@ static void r5l_log_flush_endio(struct bio *bio)
 	struct r5l_io_unit *io;
 	struct stripe_head *sh;
 
+	if (bio->bi_error)
+		md_error(log->rdev->mddev, log->rdev);
+
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	list_for_each_entry(io, &log->flushing_ios, log_sibling) {
 		while (!list_empty(&io->stripe_list)) {
@@ -675,6 +680,7 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
 		md_update_sb(mddev, 1);
 	}
 
+	/* discard IO error really doesn't matter, ignore it */
 	if (log->last_checkpoint < end) {
 		blkdev_issue_discard(bdev,
 				log->last_checkpoint + log->rdev->data_offset,
@@ -802,6 +808,13 @@ void r5l_quiesce(struct r5l_log *log, int state)
 	}
 }
 
+bool r5l_log_disk_error(struct r5l_log *log)
+{
+	if (!log)
+		return false;
+	return !test_bit(In_sync, &log->rdev->flags);
+}
+
 struct r5l_recovery_ctx {
 	struct page *meta_page;		/* current meta */
 	sector_t meta_total_blocks;	/* total size of current meta and data */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c164501..53bb7f6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3147,6 +3147,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		 * the data has not reached the cache yet.
 		 */
 		if (!test_bit(R5_Wantfill, &sh->dev[i].flags) &&
+		    s->failed > conf->max_degraded &&
 		    (!test_bit(R5_Insync, &sh->dev[i].flags) ||
 		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
 			spin_lock_irq(&sh->stripe_lock);
@@ -4015,6 +4016,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 	s->expanded = test_bit(STRIPE_EXPAND_READY, &sh->state) && !sh->batch_head;
 	s->failed_num[0] = -1;
 	s->failed_num[1] = -1;
+	s->log_failed = r5l_log_disk_error(conf->log);
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
@@ -4358,7 +4360,7 @@ static void handle_stripe(struct stripe_head *sh)
 	/* check if the array has lost more than max_degraded devices and,
 	 * if so, some requests might need to be failed.
 	 */
-	if (s.failed > conf->max_degraded) {
+	if (s.failed > conf->max_degraded || s.log_failed) {
 		sh->check_state = 0;
 		sh->reconstruct_state = 0;
 		break_stripe_batch_list(sh, 0);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 1ab534c..d114389 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -272,6 +272,7 @@ struct stripe_head_state {
 	struct bio_list return_bi;
 	struct md_rdev *blocked_rdev;
 	int handle_bad_blocks;
+	int log_failed;
 };
 
 /* Flags for struct r5dev.flags */
@@ -631,4 +632,5 @@ extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
 extern void r5l_stripe_write_finished(struct stripe_head *sh);
 extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
+extern bool r5l_log_disk_error(struct r5l_log *log);
 #endif
-- 
2.4.6

