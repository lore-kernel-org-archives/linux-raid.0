From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 16/17] md: raid10: avoid direct access to bvec table in reshape_request
Date: Thu, 16 Feb 2017 19:45:46 +0800
Message-ID: <1487245547-24384-17-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

The cost is 128bytes(8*16) stack space in kernel thread context, and
just use the bio helper to retrieve pages from bio.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid10.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c7d2f73565d9..5016ce8163c3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4383,6 +4383,8 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	struct bio *blist;
 	struct bio *bio, *read_bio;
 	int sectors_done = 0;
+	struct bio_vec *bvl;
+	struct page *pages[RESYNC_PAGES];
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
@@ -4546,9 +4548,12 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 
 	/* Now add as many pages as possible to all of these bios. */
 
+	bio_for_each_segment_all(bvl, r10_bio->devs[0].bio, s)
+		pages[s] = bvl->bv_page;
+
 	nr_sectors = 0;
 	for (s = 0 ; s < max_sectors; s += PAGE_SIZE >> 9) {
-		struct page *page = r10_bio->devs[0].bio->bi_io_vec[s/(PAGE_SIZE>>9)].bv_page;
+		struct page *page = pages[s / (PAGE_SIZE >> 9)];
 		int len = (max_sectors - s) << 9;
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
-- 
2.7.4
