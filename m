From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/11] raid5-cache: new helper: r5_reserve_log_entry
Date: Mon,  5 Oct 2015 09:31:14 +0200
Message-ID: <1444030276-30850-10-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Factor out code to reserve log space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index b716c41..87fa3b5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -273,6 +273,23 @@ static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
 	return bio;
 }
 
+static void r5_reserve_log_entry(struct r5l_log *log, struct r5l_io_unit *io)
+{
+	log->log_start = r5l_ring_add(log, log->log_start, BLOCK_SECTORS);
+
+	/*
+	 * If we filled up the log device start from the beginning again,
+	 * which will require a new bio.
+	 *
+	 * Note: for this to work properly the log size needs to me a multiple
+	 * of BLOCK_SECTORS.
+	 */
+	if (log->log_start == 0)
+		io->current_bio = NULL;
+
+	io->log_end = log->log_start;
+}
+
 static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 {
 	struct r5l_io_unit *io;
@@ -301,11 +318,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
 
 	log->seq++;
-	log->log_start = r5l_ring_add(log, log->log_start, BLOCK_SECTORS);
-	io->log_end = log->log_start;
-	/* current bio hit disk end */
-	if (log->log_start == 0)
-		io->current_bio = NULL;
+	r5_reserve_log_entry(log, io);
 
 	spin_lock_irq(&log->io_list_lock);
 	list_add_tail(&io->log_sibling, &log->running_ios);
@@ -359,13 +372,8 @@ alloc_bio:
 		io->current_bio = NULL;
 		goto alloc_bio;
 	}
-	log->log_start = r5l_ring_add(log, log->log_start,
-				      BLOCK_SECTORS);
-	/* current bio hit disk end */
-	if (log->log_start == 0)
-		io->current_bio = NULL;
 
-	io->log_end = log->log_start;
+	r5_reserve_log_entry(log, io);
 }
 
 static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
-- 
1.9.1

