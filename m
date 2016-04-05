From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 16/27] bcache: super: use bio_get_base_vec
Date: Tue,  5 Apr 2016 20:07:31 +0800
Message-ID: <1459858062-21075-2-git-send-email-tom.leiming@gmail.com>
References: <1459858062-21075-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459858062-21075-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/super.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3f649c9..56ad797 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -208,7 +208,12 @@ static void write_bdev_super_endio(struct bio *bio)
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
-	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page);
+	/*
+	 * For accessing page pointed to by the 1st bvec, it
+	 * works too after multipage bvecs.
+	 */
+	struct bio_vec *bvec = bio_get_base_vec(bio);
+	struct cache_sb *out = page_address(bvec->bv_page);
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
@@ -1145,6 +1150,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
 	struct cache_set *c;
+	struct bio_vec *bvec;
 
 	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
 	dc->bdev = bdev;
@@ -1152,7 +1158,8 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 
 	bio_init(&dc->sb_bio);
 	bio_set_vec_table(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
-	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	bvec = bio_get_base_vec(&dc->sb_bio);
+	bvec->bv_page = sb_page;
 	get_page(sb_page);
 
 	if (cached_dev_init(dc, sb->block_size << 9))
@@ -1776,6 +1783,7 @@ void bch_cache_release(struct kobject *kobj)
 {
 	struct cache *ca = container_of(kobj, struct cache, kobj);
 	unsigned i;
+	struct bio_vec *bvec = bio_get_base_vec(&ca->sb_bio);
 
 	if (ca->set) {
 		BUG_ON(ca->set->cache[ca->sb.nr_this_dev] != ca);
@@ -1793,7 +1801,7 @@ void bch_cache_release(struct kobject *kobj)
 		free_fifo(&ca->free[i]);
 
 	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
-		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
+		put_page(bvec->bv_page);
 
 	if (!IS_ERR_OR_NULL(ca->bdev))
 		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
@@ -1843,6 +1851,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	char name[BDEVNAME_SIZE];
 	const char *err = NULL;
 	int ret = 0;
+	struct bio_vec *bvec;
 
 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
 	ca->bdev = bdev;
@@ -1850,7 +1859,8 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 
 	bio_init(&ca->sb_bio);
 	bio_set_vec_table(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
-	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	bvec = bio_get_base_vec(&ca->sb_bio);
+	bvec->bv_page = sb_page;
 	get_page(sb_page);
 
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
-- 
1.9.1
