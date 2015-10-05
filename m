From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/11] raid5-cache: factor out a helper to run all stripes for an I/O unit
Date: Mon,  5 Oct 2015 09:31:08 +0200
Message-ID: <1444030276-30850-4-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9f5a48e..b04e908 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -194,6 +194,17 @@ static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
 	io->state = state;
 }
 
+static void r5l_io_run_stripes(struct r5l_io_unit *io)
+{
+	struct stripe_head *sh, *next;
+
+	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
+		list_del_init(&sh->log_list);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+}
+
 static void r5l_log_endio(struct bio *bio)
 {
 	struct r5l_io_unit *io = bio->bi_private;
@@ -587,21 +598,13 @@ static void r5l_log_flush_endio(struct bio *bio)
 		flush_bio);
 	unsigned long flags;
 	struct r5l_io_unit *io;
-	struct stripe_head *sh;
 
 	if (bio->bi_error)
 		md_error(log->rdev->mddev, log->rdev);
 
 	spin_lock_irqsave(&log->io_list_lock, flags);
-	list_for_each_entry(io, &log->flushing_ios, log_sibling) {
-		while (!list_empty(&io->stripe_list)) {
-			sh = list_first_entry(&io->stripe_list,
-				struct stripe_head, log_list);
-			list_del_init(&sh->log_list);
-			set_bit(STRIPE_HANDLE, &sh->state);
-			raid5_release_stripe(sh);
-		}
-	}
+	list_for_each_entry(io, &log->flushing_ios, log_sibling)
+		r5l_io_run_stripes(io);
 	list_splice_tail_init(&log->flushing_ios, &log->finished_ios);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 }
-- 
1.9.1

