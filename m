From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 21/60] bcache: comment on direct access to bvec table
Date: Sat, 29 Oct 2016 16:08:20 +0800
Message-ID: <1477728600-12938-22-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Jiri Kosina <jkosina@suse.cz>, Zheng Liu <gnehzuil.liu@gmail.com>, Eric Wheeler <git@linux.ewheeler.net>, Yijing Wang <wangyijing@huawei.com>, Coly Li <colyli@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>, "open list:BCACHE BLOCK LAYER CACHE" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID Multiple Disks
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
index 81d3db40cd7b..b419bc91ba32 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -428,6 +428,7 @@ static void do_btree_node_write(struct btree *b)
 
 		continue_at(cl, btree_node_write_done, NULL);
 	} else {
+		/* No harm for multipage bvec since the new is just allocated */
 		b->bio->bi_vcnt = 0;
 		bch_bio_map(b->bio, i);
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d8a6d807b498..52876fcf2b36 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -207,6 +207,7 @@ static void write_bdev_super_endio(struct bio *bio)
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
+	/* single page bio, safe for multipage bvec */
 	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page);
 	unsigned i;
 
@@ -1153,6 +1154,8 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev->bd_holder = dc;
 
 	bio_init_with_vec_table(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
+
+	/* single page bio, safe for multipage bvec */
 	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
@@ -1794,6 +1797,7 @@ void bch_cache_release(struct kobject *kobj)
 	for (i = 0; i < RESERVE_NR; i++)
 		free_fifo(&ca->free[i]);
 
+	/* single page bio, safe for multipage bvec */
 	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
 		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
 
@@ -1850,6 +1854,8 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev->bd_holder = ca;
 
 	bio_init_with_vec_table(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
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

