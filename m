From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 03/10] Revert "block: introduce bio_copy_data_partial"
Date: Wed, 05 Apr 2017 14:05:50 +1000
Message-ID: <149136515062.25893.13013004998471117345.stgit@noble>
References: <149136485390.25893.1797855041954158826.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149136485390.25893.1797855041954158826.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This reverts commit 6f8802852f7e58a12177a86179803b9efaad98e2.
bio_copy_data_partial() is no longer needed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 block/bio.c         |   60 +++++++++++----------------------------------------
 include/linux/bio.h |    2 --
 2 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 036435995c55..12c2837c4277 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -990,8 +990,19 @@ int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(bio_alloc_pages);
 
-static void __bio_copy_data(struct bio *dst, struct bio *src,
-			    int offset, int size)
+/**
+ * bio_copy_data - copy contents of data buffers from one chain of bios to
+ * another
+ * @src: source bio list
+ * @dst: destination bio list
+ *
+ * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
+ * @src and @dst as linked lists of bios.
+ *
+ * Stops when it reaches the end of either @src or @dst - that is, copies
+ * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
+ */
+void bio_copy_data(struct bio *dst, struct bio *src)
 {
 	struct bvec_iter src_iter, dst_iter;
 	struct bio_vec src_bv, dst_bv;
@@ -1001,12 +1012,6 @@ static void __bio_copy_data(struct bio *dst, struct bio *src,
 	src_iter = src->bi_iter;
 	dst_iter = dst->bi_iter;
 
-	/* for supporting partial copy */
-	if (offset || size != src->bi_iter.bi_size) {
-		bio_advance_iter(src, &src_iter, offset);
-		src_iter.bi_size = size;
-	}
-
 	while (1) {
 		if (!src_iter.bi_size) {
 			src = src->bi_next;
@@ -1043,47 +1048,8 @@ static void __bio_copy_data(struct bio *dst, struct bio *src,
 		bio_advance_iter(dst, &dst_iter, bytes);
 	}
 }
-
-/**
- * bio_copy_data - copy contents of data buffers from one chain of bios to
- * another
- * @src: source bio list
- * @dst: destination bio list
- *
- * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
- * @src and @dst as linked lists of bios.
- *
- * Stops when it reaches the end of either @src or @dst - that is, copies
- * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
- */
-void bio_copy_data(struct bio *dst, struct bio *src)
-{
-	__bio_copy_data(dst, src, 0, src->bi_iter.bi_size);
-}
 EXPORT_SYMBOL(bio_copy_data);
 
-/**
- * bio_copy_data_partial - copy partial contents of data buffers from one
- * chain of bios to another
- * @dst: destination bio list
- * @src: source bio list
- * @offset: starting copy from the offset
- * @size: how many bytes to copy
- *
- * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
- * @src and @dst as linked lists of bios.
- *
- * Stops when it reaches the end of either @src or @dst - that is, copies
- * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
- */
-void bio_copy_data_partial(struct bio *dst, struct bio *src,
-			   int offset, int size)
-{
-	__bio_copy_data(dst, src, offset, size);
-
-}
-EXPORT_SYMBOL(bio_copy_data_partial);
-
 struct bio_map_data {
 	int is_our_pages;
 	struct iov_iter iter;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index fafef6343d1b..7cf8a6c70a3f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -461,8 +461,6 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 #endif
 
 extern void bio_copy_data(struct bio *dst, struct bio *src);
-extern void bio_copy_data_partial(struct bio *dst, struct bio *src,
-				  int offset, int size);
 extern int bio_alloc_pages(struct bio *bio, gfp_t gfp);
 extern void bio_free_pages(struct bio *bio);
 


