From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] raid5-cache: new helper: r5_reserve_log_entry
Date: Mon,  7 Sep 2015 07:20:48 +0200
Message-ID: <1441603250-5119-9-git-send-email-hch@lst.de>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441603250-5119-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Factor out code to reserve log space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2ccc1b0..ae8caa8 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -240,6 +240,23 @@ static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
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
@@ -268,11 +285,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
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
@@ -325,13 +338,8 @@ alloc_bio:
 		io->current_bio = NULL;
 		goto alloc_bio;
 	}
-	log->log_start = r5l_ring_add(log, log->log_start,
-			BLOCK_SECTORS);
-	/* current bio hit disk end */
-	if (log->log_start == 0)
-		io->current_bio = NULL;
 
-	io->log_end = log->log_start;
+	r5_reserve_log_entry(log, io);
 }
 
 static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
-- 
1.9.1

