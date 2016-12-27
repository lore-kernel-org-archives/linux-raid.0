From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 38/54] md/raid1.c: convert to bio_for_each_segment_all_sp()
Date: Wed, 28 Dec 2016 00:04:47 +0800
Message-ID: <1482854706-14128-7-git-send-email-tom.leiming@gmail.com>
References: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1482854706-14128-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a1f3fbed9100..4818f40e7ce9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -988,12 +988,13 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
 {
 	int i;
 	struct bio_vec *bvec;
+	struct bvec_iter_all bia;
 	struct bio_vec *bvecs = kzalloc(bio->bi_vcnt * sizeof(struct bio_vec),
 					GFP_NOIO);
 	if (unlikely(!bvecs))
 		return;
 
-	bio_for_each_segment_all(bvec, bio, i) {
+	bio_for_each_segment_all_sp(bvec, bio, i, bia) {
 		bvecs[i] = *bvec;
 		bvecs[i].bv_page = alloc_page(GFP_NOIO);
 		if (unlikely(!bvecs[i].bv_page))
-- 
2.7.4

