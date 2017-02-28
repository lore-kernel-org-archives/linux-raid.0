From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v2 08/13] md: raid1: use bio helper in process_checks()
Date: Tue, 28 Feb 2017 23:41:38 +0800
Message-ID: <1488296503-4987-9-git-send-email-tom.leiming@gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Avoid to direct access to bvec table.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d0cb5c026506..316bd6dd6cc1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2108,6 +2108,7 @@ static void process_checks(struct r1bio *r1_bio)
 		int j;
 		int size;
 		int error;
+		struct bio_vec *bi;
 		struct bio *b = r1_bio->bios[i];
 		struct resync_pages *rp = get_resync_pages(b);
 		if (b->bi_end_io != end_sync_read)
@@ -2126,9 +2127,7 @@ static void process_checks(struct r1bio *r1_bio)
 		b->bi_private = rp;
 
 		size = b->bi_iter.bi_size;
-		for (j = 0; j < vcnt ; j++) {
-			struct bio_vec *bi;
-			bi = &b->bi_io_vec[j];
+		bio_for_each_segment_all(bi, b, j) {
 			bi->bv_offset = 0;
 			if (size > PAGE_SIZE)
 				bi->bv_len = PAGE_SIZE;
@@ -2152,17 +2151,22 @@ static void process_checks(struct r1bio *r1_bio)
 		int error = sbio->bi_error;
 		struct page **ppages = get_resync_pages(pbio)->pages;
 		struct page **spages = get_resync_pages(sbio)->pages;
+		struct bio_vec *bi;
+		int page_len[RESYNC_PAGES];
 
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
 		/* Now we can 'fixup' the error value */
 		sbio->bi_error = 0;
 
+		bio_for_each_segment_all(bi, sbio, j)
+			page_len[j] = bi->bv_len;
+
 		if (!error) {
 			for (j = vcnt; j-- ; ) {
 				if (memcmp(page_address(ppages[j]),
 					   page_address(spages[j]),
-					   sbio->bi_io_vec[j].bv_len))
+					   page_len[j]))
 					break;
 			}
 		} else
-- 
2.7.4

