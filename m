From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/11] raid5-cache: rename flushed_ios to finished_ios
Date: Mon,  5 Oct 2015 09:31:07 +0200
Message-ID: <1444030276-30850-3-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After this series we won't nessecarily have flushed the cache for these
I/Os, so give the list a more neutral name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 5b5f346..9f5a48e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -66,7 +66,7 @@ struct r5l_log {
 					 * to the RAID */
 	struct list_head flushing_ios;	/* io_units which are waiting for log
 					 * cache flush */
-	struct list_head flushed_ios;	/* io_units which settle down in log disk */
+	struct list_head finished_ios;	/* io_units which settle down in log disk */
 	struct bio flush_bio;
 
 	struct kmem_cache *io_kc;
@@ -525,14 +525,14 @@ static sector_t r5l_reclaimable_space(struct r5l_log *log)
 				 log->next_checkpoint);
 }
 
-static bool r5l_complete_flushed_ios(struct r5l_log *log)
+static bool r5l_complete_finished_ios(struct r5l_log *log)
 {
 	struct r5l_io_unit *io, *next;
 	bool found = false;
 
 	assert_spin_locked(&log->io_list_lock);
 
-	list_for_each_entry_safe(io, next, &log->flushed_ios, log_sibling) {
+	list_for_each_entry_safe(io, next, &log->finished_ios, log_sibling) {
 		/* don't change list order */
 		if (io->state < IO_UNIT_STRIPE_END)
 			break;
@@ -558,7 +558,7 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
 
-	if (!r5l_complete_flushed_ios(log)) {
+	if (!r5l_complete_finished_ios(log)) {
 		spin_unlock_irqrestore(&log->io_list_lock, flags);
 		return;
 	}
@@ -602,7 +602,7 @@ static void r5l_log_flush_endio(struct bio *bio)
 			raid5_release_stripe(sh);
 		}
 	}
-	list_splice_tail_init(&log->flushing_ios, &log->flushed_ios);
+	list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 }
 
@@ -701,7 +701,7 @@ static void r5l_do_reclaim(struct r5l_log *log)
 		    (list_empty(&log->running_ios) &&
 		     list_empty(&log->io_end_ios) &&
 		     list_empty(&log->flushing_ios) &&
-		     list_empty(&log->flushed_ios)))
+		     list_empty(&log->finished_ios)))
 			break;
 
 		md_wakeup_thread(log->rdev->mddev->thread);
@@ -1121,7 +1121,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->running_ios);
 	INIT_LIST_HEAD(&log->io_end_ios);
 	INIT_LIST_HEAD(&log->flushing_ios);
-	INIT_LIST_HEAD(&log->flushed_ios);
+	INIT_LIST_HEAD(&log->finished_ios);
 	bio_init(&log->flush_bio);
 
 	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
-- 
1.9.1

