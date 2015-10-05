From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/11] raid5-cache: take rdev->data_offset into account early on
Date: Mon,  5 Oct 2015 09:31:12 +0200
Message-ID: <1444030276-30850-8-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Set up bi_sector properly when we allocate an bio instead of updating it
at submission time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 4d4dc4d..f3958e5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -271,11 +271,8 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
-	while ((bio = bio_list_pop(&io->bios))) {
-		/* all IO must start from rdev->data_offset */
-		bio->bi_iter.bi_sector += log->rdev->data_offset;
+	while ((bio = bio_list_pop(&io->bios)))
 		submit_bio(WRITE, bio);
-	}
 }
 
 static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
@@ -284,7 +281,7 @@ static struct bio *r5l_bio_alloc(struct r5l_log *log, struct r5l_io_unit *io)
 
 	bio->bi_rw = WRITE;
 	bio->bi_bdev = log->rdev->bdev;
-	bio->bi_iter.bi_sector = log->log_start;
+	bio->bi_iter.bi_sector = log->rdev->data_offset + log->log_start;
 	bio->bi_end_io = r5l_log_endio;
 	bio->bi_private = io;
 
-- 
1.9.1

