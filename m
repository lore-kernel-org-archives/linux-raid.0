From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 07/54] bcache: comment on direct access to bvec table
Date: Tue, 27 Dec 2016 23:55:56 +0800
Message-ID: <1482854250-13481-8-git-send-email-tom.leiming@gmail.com>
References: <1482854250-13481-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1482854250-13481-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Guoqing Jiang <gqjiang@suse.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Mike Christie <mchristi@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Eric Wheeler <git@linux.ewheeler.net>, Yijing Wang <wangyijing@huawei.com>, Al Viro <viro@ZenIV.linux.org.uk>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Looks all are safe after multipage bvec is supported.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/bcache/btree.c | 1 +
 drivers/md/bcache/super.c | 6 ++++++
 drivers/md/bcache/util.c  | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index a43eedd5804d..fc35cfb4d0f1 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -428,6 +428,7 @@ static void do_btree_node_write(struct btree *b)
 
 		continue_at(cl, btree_node_write_done, NULL);
 	} else {
+		/* No harm for multipage bvec since the new is just allocated */
 		b->bio->bi_vcnt = 0;
 		bch_bio_map(b->bio, i);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3a19cbc8b230..607b022259dc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -208,6 +208,7 @@ static void write_bdev_super_endio(struct bio *bio)
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
+	/* single page bio, safe for multipage bvec */
 	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page);
 	unsigned i;
 
@@ -1156,6 +1157,8 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev->bd_holder = dc;
 
 	bio_init(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
+
+	/* single page bio, safe for multipage bvec */
 	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
@@ -1799,6 +1802,7 @@ void bch_cache_release(struct kobject *kobj)
 	for (i = 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
 
+	/* single page bio, safe for multipage bvec */
 	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
 		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
 
@@ -1854,6 +1858,8 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev->bd_holder = ca;
 
 	bio_init(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
+
+	/* single page bio, safe for multipage bvec */
 	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index dde6172f3f10..5cc0b49a65fb 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -222,6 +222,13 @@ uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 		: 0;
 }
 
+/*
+ * Generally it isn't good to access .bi_io_vec and .bi_vcnt
+ * directly, the preferred way is bio_add_page, but in
+ * this case, bch_bio_map() supposes that the bvec table
+ * is empty, so it is safe to access .bi_vcnt & .bi_io_vec
+ * in this way even after multipage bvec is supported.
+ */
 void bch_bio_map(struct bio *bio, void *base)
 {
 	size_t size = bio->bi_iter.bi_size;
-- 
2.7.4
