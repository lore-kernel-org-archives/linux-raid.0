From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] raid5-cache: remove r5l_move_io_unit_list
Date: Wed,  2 Sep 2015 16:14:47 +0200
Message-ID: <1441203288-22515-3-git-send-email-hch@lst.de>
References: <1441203288-22515-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441203288-22515-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com, neilb@suse.de
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, Kernel-team@fb.com
List-Id: linux-raid.ids

We only move I/O unit structures from one list to another under the
io_list_lock, so there is no need to scan the whole list for other
elements of the same state - we only change the state for one of them
at a time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9f984f8..8684100 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -168,21 +168,6 @@ static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
 	kmem_cache_free(log->io_kc, io);
 }
 
-static void r5l_move_io_unit_list(struct list_head *from, struct list_head *to,
-       enum r5l_io_unit_state state)
-{
-       struct r5l_io_unit *io;
-
-       while (!list_empty(from)) {
-               io = list_first_entry(from, struct r5l_io_unit, log_sibling);
-               /* don't change list order */
-               if (io->state >= state)
-                       list_move_tail(&io->log_sibling, to);
-               else
-                       break;
-       }
-}
-
 /*
  * We don't want too many io_units reside in stripe_end_ios list, which will
  * waste a lot of memory. So we try to remove some. But we must keep at least 2
@@ -235,8 +220,7 @@ static void r5l_log_endio(struct bio *bio, int error)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
-	r5l_move_io_unit_list(&log->running_ios, &log->io_end_ios,
-			IO_UNIT_IO_END);
+	list_move_tail(&io->log_sibling, &log->io_end_ios);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
 	wake_up(&io->wait_state);
@@ -528,8 +512,7 @@ static void __r5l_stripe_write_finished(struct r5l_io_unit *io)
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	__r5l_set_io_unit_state(io, IO_UNIT_STRIPE_END);
-	r5l_move_io_unit_list(&log->io_end_ios, &log->stripe_end_ios,
-		IO_UNIT_STRIPE_END);
+	list_move_tail(&io->log_sibling, &log->stripe_end_ios);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 	wake_up(&io->wait_state);
 
-- 
1.9.1

