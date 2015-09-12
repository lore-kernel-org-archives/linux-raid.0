From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/12] raid5-cache: take rdev->data_offset into account early on
Date: Sat, 12 Sep 2015 08:17:14 +0200
Message-ID: <1442038638-6947-9-git-send-email-hch@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1442038638-6947-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Set up bi_sector properly when we allocate an bio instead of updating it
at submission time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index fb1ac4c..df24e9c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -267,11 +267,8 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
-	while ((bio = bio_list_pop(&io->bios))) {
-		/* all IO must start from rdev->data_offset */
-		bio->bi_iter.bi_sector += log->rdev->data_offset;
+	while ((bio = bio_list_pop(&io->bios)))
 		submit_bio(WRITE | (log->use_fua ? REQ_FUA : 0), bio);
-	}
 }
 
 static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
@@ -280,7 +277,7 @@ static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
 
 	bio->bi_rw = WRITE;
 	bio->bi_bdev = log->rdev->bdev;
-	bio->bi_iter.bi_sector = log->log_start;
+	bio->bi_iter.bi_sector = log->rdev->data_offset + log->log_start;
 	bio->bi_end_io = r5l_log_endio;
 	bio->bi_private = io;
 
-- 
1.9.1

