From: Ming Lin <mlin@kernel.org>
Subject: [PATCH] md/raid10: make sync_request_write() call bio_copy_data()
Date: Fri, 24 Apr 2015 15:52:10 -0700
Message-ID: <1429915930-22449-1-git-send-email-mlin@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Ming Lin <mlin@kernel.org>
List-Id: linux-raid.ids

From: Kent Overstreet <kent.overstreet@gmail.com>

Refactor sync_request_write() of md/raid10 to use bio_copy_data()
instead of open coding bio_vec iterations.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
Signed-off-by: Ming Lin <mlin@kernel.org>
---
 drivers/md/raid10.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a7196c4..02e33f1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2097,18 +2097,11 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_iter.bi_size = r10_bio->sectors << 9;
 		tbio->bi_rw = WRITE;
-		tbio->bi_private = r10_bio;
 		tbio->bi_iter.bi_sector = r10_bio->devs[i].addr;
-
-		for (j=0; j < vcnt ; j++) {
-			tbio->bi_io_vec[j].bv_offset = 0;
-			tbio->bi_io_vec[j].bv_len = PAGE_SIZE;
-
-			memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-			       page_address(fbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
-		}
 		tbio->bi_end_io = end_sync_write;
+		tbio->bi_private = r10_bio;
+
+		bio_copy_data(tbio, fbio);
 
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
@@ -2124,17 +2117,14 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * that are active
 	 */
 	for (i = 0; i < conf->copies; i++) {
-		int j, d;
+		int d;
 
 		tbio = r10_bio->devs[i].repl_bio;
 		if (!tbio || !tbio->bi_end_io)
 			continue;
 		if (r10_bio->devs[i].bio->bi_end_io != end_sync_write
 		    && r10_bio->devs[i].bio != fbio)
-			for (j = 0; j < vcnt; j++)
-				memcpy(page_address(tbio->bi_io_vec[j].bv_page),
-				       page_address(fbio->bi_io_vec[j].bv_page),
-				       PAGE_SIZE);
+			bio_copy_data(tbio, fbio);
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
-- 
1.9.1

