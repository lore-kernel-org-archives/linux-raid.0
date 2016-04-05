From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 11/27] bcache: io.c: use bio_set_vec_table
Date: Tue,  5 Apr 2016 19:56:56 +0800
Message-ID: <1459857443-20611-12-git-send-email-tom.leiming@gmail.com>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 86a0bb8..1c48462 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -26,8 +26,7 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
 
 	bio_init(bio);
 	bio->bi_flags		|= BIO_POOL_NONE << BIO_POOL_OFFSET;
-	bio->bi_max_vecs	 = bucket_pages(c);
-	bio->bi_io_vec		 = bio->bi_inline_vecs;
+	bio_set_vec_table(bio, bio->bi_inline_vecs, bucket_pages(c));
 
 	return bio;
 }
-- 
1.9.1
