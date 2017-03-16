From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 13/14] md: raid10: retrieve page from preallocated resync page array
Date: Fri, 17 Mar 2017 00:12:34 +0800
Message-ID: <20170316161235.27110-14-tom.leiming@gmail.com>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316161235.27110-1-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Now one page array is allocated for each resync bio, and we can
retrieve page from this table directly.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid10.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d2cb68971486..8db3b0869be4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2075,6 +2075,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	int i, first;
 	struct bio *tbio, *fbio;
 	int vcnt;
+	struct page **tpages, **fpages;
 
 	atomic_set(&r10_bio->remaining, 1);
 
@@ -2090,6 +2091,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	fbio = r10_bio->devs[i].bio;
 	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
 	fbio->bi_iter.bi_idx = 0;
+	fpages = get_resync_pages(fbio)->pages;
 
 	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
 	/* now find blocks with errors */
@@ -2104,6 +2106,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			continue;
 		if (i == first)
 			continue;
+
+		tpages = get_resync_pages(tbio)->pages;
 		d = r10_bio->devs[i].devnum;
 		rdev = conf->mirrors[d].rdev;
 		if (!r10_bio->devs[i].bio->bi_error) {
@@ -2116,8 +2120,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 				int len = PAGE_SIZE;
 				if (sectors < (len / 512))
 					len = sectors * 512;
-				if (memcmp(page_address(fbio->bi_io_vec[j].bv_page),
-					   page_address(tbio->bi_io_vec[j].bv_page),
+				if (memcmp(page_address(fpages[j]),
+					   page_address(tpages[j]),
 					   len))
 					break;
 				sectors -= len/512;
@@ -2215,6 +2219,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 	int idx = 0;
 	int dr = r10_bio->devs[0].devnum;
 	int dw = r10_bio->devs[1].devnum;
+	struct page **pages = get_resync_pages(bio)->pages;
 
 	while (sectors) {
 		int s = sectors;
@@ -2230,7 +2235,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 		ok = sync_page_io(rdev,
 				  addr,
 				  s << 9,
-				  bio->bi_io_vec[idx].bv_page,
+				  pages[idx],
 				  REQ_OP_READ, 0, false);
 		if (ok) {
 			rdev = conf->mirrors[dw].rdev;
@@ -2238,7 +2243,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 			ok = sync_page_io(rdev,
 					  addr,
 					  s << 9,
-					  bio->bi_io_vec[idx].bv_page,
+					  pages[idx],
 					  REQ_OP_WRITE, 0, false);
 			if (!ok) {
 				set_bit(WriteErrorSeen, &rdev->flags);
-- 
2.9.3

