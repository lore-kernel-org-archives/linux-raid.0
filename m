From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 15/17] md: raid10: avoid direct access to bvec table in fix_recovery_read_error
Date: Thu, 16 Feb 2017 19:45:45 +0800
Message-ID: <1487245547-24384-16-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

The cost is 128bytes(8*16) stack space in kernel thread context, and just
use the bio helper to retrieve pages from bio.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid10.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 69fe2a3cef89..c7d2f73565d9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2184,6 +2184,11 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 	int idx = 0;
 	int dr = r10_bio->devs[0].devnum;
 	int dw = r10_bio->devs[1].devnum;
+	struct bio_vec *bvl;
+	struct page *pages[RESYNC_PAGES];
+
+	bio_for_each_segment_all(bvl, bio, idx)
+		pages[idx] = bvl->bv_page;
 
 	while (sectors) {
 		int s = sectors;
@@ -2199,7 +2204,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 		ok = sync_page_io(rdev,
 				  addr,
 				  s << 9,
-				  bio->bi_io_vec[idx].bv_page,
+				  pages[idx],
 				  REQ_OP_READ, 0, false);
 		if (ok) {
 			rdev = conf->mirrors[dw].rdev;
@@ -2207,7 +2212,7 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 			ok = sync_page_io(rdev,
 					  addr,
 					  s << 9,
-					  bio->bi_io_vec[idx].bv_page,
+					  pages[idx],
 					  REQ_OP_WRITE, 0, false);
 			if (!ok) {
 				set_bit(WriteErrorSeen, &rdev->flags);
-- 
2.7.4
