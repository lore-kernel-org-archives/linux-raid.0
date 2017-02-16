From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 14/17] md: raid10: avoid direct access to bvec table in sync_request_write()
Date: Thu, 16 Feb 2017 19:45:44 +0800
Message-ID: <1487245547-24384-15-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

The cost is 256bytes(8*16*2) stack space, and just use the bio
helper to retrieve pages from bio.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid10.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5c698f3d3083..69fe2a3cef89 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2036,6 +2036,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	int i, first;
 	struct bio *tbio, *fbio;
 	int vcnt;
+	struct bio_vec *bvl;
+	struct page *fbio_pages[RESYNC_PAGES], *tbio_pages[RESYNC_PAGES];
 
 	atomic_set(&r10_bio->remaining, 1);
 
@@ -2052,6 +2054,10 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
 	fbio->bi_iter.bi_idx = 0;
 
+	/* the bio has been filled up in raid10_sync_request */
+	bio_for_each_segment_all(bvl, fbio, i)
+		fbio_pages[i] = bvl->bv_page;
+
 	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
 	/* now find blocks with errors */
 	for (i=0 ; i < conf->copies ; i++) {
@@ -2072,12 +2078,17 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			 * All vec entries are PAGE_SIZE;
 			 */
 			int sectors = r10_bio->sectors;
+
+			/* the bio has been filled up in raid10_sync_request */
+			bio_for_each_segment_all(bvl, tbio, j)
+				tbio_pages[j] = bvl->bv_page;
+
 			for (j = 0; j < vcnt; j++) {
 				int len = PAGE_SIZE;
 				if (sectors < (len / 512))
 					len = sectors * 512;
-				if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
-					   page_address(tbio->bi_io_vec[j].bv_page),
+				if (memcmp(page_address(fbio_pages[j]),
+					   page_address(tbio_pages[j]),
 					   len))
 					break;
 				sectors -= len/512;
-- 
2.7.4
