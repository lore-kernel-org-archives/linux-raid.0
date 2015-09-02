From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] raid5-cache: fix __r5l_stripe_write_finished
Date: Wed,  2 Sep 2015 16:14:48 +0200
Message-ID: <1441203288-22515-4-git-send-email-hch@lst.de>
References: <1441203288-22515-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441203288-22515-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, neilb@suse.de
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, Kernel-team@fb.com
List-Id: linux-raid.ids

The stripe end processing has two flaws:

 - it walks the stripe_end_ios list for finding the last I/O unit
   and collapsing unneded ones without taking the proper lock
 - it may remove the currently completed io unit, which will cause
   a use after free when calling wake_up on io->wait_state

Fix this by ensuring we hold io_list_lock over the whole function,
and rewrite the I/O unit colapsing algorithm to be smarted about
handling the stripe_end_ios list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 8684100..054bad4 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -174,27 +174,23 @@ static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
  * io_units. The superblock must point to a valid meta, if it's the last meta,
  * recovery can scan less
  * */
-static void r5l_compress_stripe_end_list(struct r5l_log *log)
+static void r5l_compress_stripe_end_list(struct r5l_log *log,
+		struct r5l_io_unit *last)
 {
-	struct r5l_io_unit *first, *last, *io;
+	struct r5l_io_unit *first, *cur;
+
+	assert_spin_locked(&log->io_list_lock);
 
 	first = list_first_entry(&log->stripe_end_ios,
 		struct r5l_io_unit, log_sibling);
-	last = list_last_entry(&log->stripe_end_ios,
-		struct r5l_io_unit, log_sibling);
 	if (first == last)
 		return;
-	list_del(&first->log_sibling);
-	list_del(&last->log_sibling);
-	while (!list_empty(&log->stripe_end_ios)) {
-		io = list_first_entry(&log->stripe_end_ios,
-			struct r5l_io_unit, log_sibling);
-		list_del(&io->log_sibling);
-		first->log_end = io->log_end;
-		r5l_free_io_unit(log, io);
+
+	while ((cur = list_next_entry(first, log_sibling)) != last) {
+		list_del(&cur->log_sibling);
+		first->log_end = cur->log_end;
+		r5l_free_io_unit(log, cur);
 	}
-	list_add_tail(&first->log_sibling, &log->stripe_end_ios);
-	list_add_tail(&last->log_sibling, &log->stripe_end_ios);
 }
 
 static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
@@ -506,24 +502,21 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 {
 	struct r5l_log *log = io->log;
-	struct r5l_io_unit *last;
 	sector_t reclaimable_space;
 	unsigned long flags;
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
 	list_move_tail(&io->log_sibling, &log->stripe_end_ios);
-	spin_unlock_irqrestore(&log->io_list_lock, flags);
 	wake_up(&io->wait_state);
 
-	last = list_last_entry(&log->stripe_end_ios,
-			struct r5l_io_unit, log_sibling);
 	reclaimable_space = r5l_ring_distance(log, log->last_checkpoint,
-				last->log_end);
+				io->log_end);
 	if (reclaimable_space >= log->max_free_space)
 		r5l_wake_reclaim(log, 0);
 
-	r5l_compress_stripe_end_list(log);
+	r5l_compress_stripe_end_list(log, io);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
 }
 
 void r5l_stripe_write_finished(struct stripe_head *sh)
-- 
1.9.1

