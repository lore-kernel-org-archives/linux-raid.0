From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 10/17] md: raid1: remove direct access to bvec table in fix_sync_read_error
Date: Thu, 16 Feb 2017 19:45:40 +0800
Message-ID: <1487245547-24384-11-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

This patch uses a stack variable to hold the pages in bio, so
that we can remove direct access to bvec table in fix_sync_read_error().

This 16*8 stack variable is just fine for kernel thread context.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1dd6b2760fba..02ee8542295d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1874,6 +1874,16 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	int sectors = r1_bio->sectors;
 	int idx = 0;
 	struct md_rdev *rdev;
+	struct bio_vec *bvl;
+	int i;
+	struct page *pages[RESYNC_PAGES];
+
+	/*
+	 * bio for read_disk is filled up, so we can use
+	 * bio_for_each_segment_all() to retrieve all pages.
+	 */
+	bio_for_each_segment_all(bvl, bio, i)
+		pages[i] = bvl->bv_page;
 
 	rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	if (test_bit(FailFast, &rdev->flags)) {
@@ -1903,7 +1913,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				 */
 				rdev = conf->mirrors[d].rdev;
 				if (sync_page_io(rdev, sect, s<<9,
-						 bio->bi_io_vec[idx].bv_page,
+						 pages[idx],
 						 REQ_OP_READ, 0, false)) {
 					success = 1;
 					break;
@@ -1958,7 +1968,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				continue;
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
-					    bio->bi_io_vec[idx].bv_page,
+					    pages[idx],
 					    WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
@@ -1973,7 +1983,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 				continue;
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
-					    bio->bi_io_vec[idx].bv_page,
+					    pages[idx],
 					    READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
-- 
2.7.4
