From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 12/17] md: raid1: avoid direct access to bvec table in process_checks()
Date: Thu, 16 Feb 2017 19:45:42 +0800
Message-ID: <1487245547-24384-13-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Given process_checks is only called in resync path, it should be
ok to allocate three stack variable(total 320byteds) to store
pages from bios.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4400fbe7ce8c..54ec32be3277 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2010,6 +2010,9 @@ static void process_checks(struct r1bio *r1_bio)
 	int primary;
 	int i;
 	int vcnt;
+	struct bio_vec *bi;
+	int page_len[RESYNC_PAGES];
+	struct page *pbio_pages[RESYNC_PAGES], *sbio_pages[RESYNC_PAGES];
 
 	/* Fix variable parts of all bios */
 	vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
@@ -2017,7 +2020,6 @@ static void process_checks(struct r1bio *r1_bio)
 		int j;
 		int size;
 		int error;
-		struct bio_vec *bi;
 		struct bio *b = r1_bio->bios[i];
 		if (b->bi_end_io != end_sync_read)
 			continue;
@@ -2051,6 +2053,11 @@ static void process_checks(struct r1bio *r1_bio)
 			break;
 		}
 	r1_bio->read_disk = primary;
+
+	/* .bi_vcnt has been set for all read bios */
+	bio_for_each_segment_all(bi, r1_bio->bios[primary], i)
+		pbio_pages[i] = bi->bv_page;
+
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		int j;
 		struct bio *pbio = r1_bio->bios[primary];
@@ -2062,14 +2069,19 @@ static void process_checks(struct r1bio *r1_bio)
 		/* Now we can 'fixup' the error value */
 		sbio->bi_error = 0;
 
+		bio_for_each_segment_all(bi, sbio, j) {
+			sbio_pages[j] = bi->bv_page;
+			page_len[j] = bi->bv_len;
+		}
+
 		if (!error) {
 			for (j = vcnt; j-- ; ) {
 				struct page *p, *s;
-				p = pbio->bi_io_vec[j].bv_page;
-				s = sbio->bi_io_vec[j].bv_page;
+				p = pbio_pages[j];
+				s = sbio_pages[j];
 				if (memcmp(page_address(p),
 					   page_address(s),
-					   sbio->bi_io_vec[j].bv_len))
+					   page_len[j]))
 					break;
 			}
 		} else
-- 
2.7.4
