From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 15/27] bcache: super: use bio_set_vec_table()
Date: Thu, 14 Apr 2016 20:02:33 +0800
Message-ID: <1460635375-28282-16-git-send-email-tom.leiming@gmail.com>
References: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/super.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f5dbb4e..3fa1ecf 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1151,8 +1151,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev->bd_holder = dc;
 
 	bio_init(&dc->sb_bio);
-	dc->sb_bio.bi_max_vecs	= 1;
-	dc->sb_bio.bi_io_vec	= dc->sb_bio.bi_inline_vecs;
+	bio_set_vec_table(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
 	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
@@ -1812,8 +1811,8 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 	kobject_init(&ca->kobj, &bch_cache_ktype);
 
 	bio_init(&ca->journal.bio);
-	ca->journal.bio.bi_max_vecs = 8;
-	ca->journal.bio.bi_io_vec = ca->journal.bio.bi_inline_vecs;
+	bio_set_vec_table(&ca->journal.bio,
+			  ca->journal.bio.bi_inline_vecs, 8);
 
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
 
@@ -1850,8 +1849,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev->bd_holder = ca;
 
 	bio_init(&ca->sb_bio);
-	ca->sb_bio.bi_max_vecs	= 1;
-	ca->sb_bio.bi_io_vec	= ca->sb_bio.bi_inline_vecs;
+	bio_set_vec_table(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
 	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
-- 
1.9.1
