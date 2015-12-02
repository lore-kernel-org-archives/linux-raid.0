From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] raid5-cache: simplify r5l_move_io_unit_list
Date: Wed,  2 Dec 2015 17:06:38 +0100
Message-ID: <1449072399-15360-2-git-send-email-hch@lst.de>
References: <1449072399-15360-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449072399-15360-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's only used for one kind of move, so make that explicit.  Also clean
up the code a bit by using list_for_each_safe.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b887e04..3699c47 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -156,21 +156,6 @@ static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
 	kmem_cache_free(log->io_kc, io);
 }
 
-static void r5l_move_io_unit_list(struct list_head *from, struct list_head *to,
-				  enum r5l_io_unit_state state)
-{
-	struct r5l_io_unit *io;
-
-	while (!list_empty(from)) {
-		io = list_first_entry(from, struct r5l_io_unit, log_sibling);
-		/* don't change list order */
-		if (io->state >= state)
-			list_move_tail(&io->log_sibling, to);
-		else
-			break;
-	}
-}
-
 static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 				    enum r5l_io_unit_state state)
 {
@@ -206,6 +191,20 @@ static void r5l_log_run_stripes(struct r5l_log *log)
 	}
 }
 
+static void r5l_move_to_end_ios(struct r5l_log *log)
+{
+	struct r5l_io_unit *io, *next;
+
+	assert_spin_locked(&log->io_list_lock);
+
+	list_for_each_entry_safe(io, next, &log->running_ios, log_sibling) {
+		/* don't change list order */
+		if (io->state < IO_UNIT_IO_END)
+			break;
+		list_move_tail(&io->log_sibling, &log->io_end_ios);
+	}
+}
+
 static void r5l_log_endio(struct bio *bio)
 {
 	struct r5l_io_unit *io = bio->bi_private;
@@ -220,8 +219,7 @@ static void r5l_log_endio(struct bio *bio)
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
 	if (log->need_cache_flush)
-		r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
-				      IO_UNIT_IO_END);
+		r5l_move_to_end_ios(log);
 	else
 		r5l_log_run_stripes(log);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
-- 
1.9.1

