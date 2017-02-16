From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 11/17] md: raid1: use bio helper in process_checks()
Date: Thu, 16 Feb 2017 19:45:41 +0800
Message-ID: <1487245547-24384-12-git-send-email-tom.leiming@gmail.com>
References: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487245547-24384-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Avoid to direct access to bvec table.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 02ee8542295d..4400fbe7ce8c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2017,6 +2017,7 @@ static void process_checks(struct r1bio *r1_bio)
 		int j;
 		int size;
 		int error;
+		struct bio_vec *bi;
 		struct bio *b = r1_bio->bios[i];
 		if (b->bi_end_io != end_sync_read)
 			continue;
@@ -2033,9 +2034,7 @@ static void process_checks(struct r1bio *r1_bio)
 		b->bi_private = r1_bio;
 
 		size = b->bi_iter.bi_size;
-		for (j = 0; j < vcnt ; j++) {
-			struct bio_vec *bi;
-			bi = &b->bi_io_vec[j];
+		bio_for_each_segment_all(bi, b, j) {
 			bi->bv_offset = 0;
 			if (size > PAGE_SIZE)
 				bi->bv_len = PAGE_SIZE;
-- 
2.7.4
