From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 1/5] block: introduce bio_clone_bioset_partial()
Date: Fri, 10 Feb 2017 18:56:13 +0800
Message-ID: <1486724177-14817-2-git-send-email-tom.leiming@gmail.com>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

md still need bio clone(not the fast version) for behind write,
and it is more efficient to use bio_clone_bioset_partial().

The idea is simple and just copy the bvecs range specified from
parameters.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/bio.c         | 61 +++++++++++++++++++++++++++++++++++++++++------------
 include/linux/bio.h | 11 ++++++++--
 2 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 4b564d0c3e29..5eec5e08417f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -625,21 +625,20 @@ struct bio *bio_clone_fast(struct bio *bio, gfp_t gfp_mask, struct bio_set *bs)
 }
 EXPORT_SYMBOL(bio_clone_fast);
 
-/**
- * 	bio_clone_bioset - clone a bio
- * 	@bio_src: bio to clone
- *	@gfp_mask: allocation priority
- *	@bs: bio_set to allocate from
- *
- *	Clone bio. Caller will own the returned bio, but not the actual data it
- *	points to. Reference count of returned bio will be one.
- */
-struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
-			     struct bio_set *bs)
+static struct bio *__bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
+				      struct bio_set *bs, int offset,
+				      int size)
 {
 	struct bvec_iter iter;
 	struct bio_vec bv;
 	struct bio *bio;
+	struct bvec_iter iter_src = bio_src->bi_iter;
+
+	/* for supporting partial clone */
+	if (offset || size != bio_src->bi_iter.bi_size) {
+		bio_advance_iter(bio_src, &iter_src, offset);
+		iter_src.bi_size = size;
+	}
 
 	/*
 	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
@@ -663,7 +662,8 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 	 *    __bio_clone_fast() anyways.
 	 */
 
-	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
+	bio = bio_alloc_bioset(gfp_mask, __bio_segments(bio_src,
+			       &iter_src), bs);
 	if (!bio)
 		return NULL;
 	bio->bi_bdev		= bio_src->bi_bdev;
@@ -680,7 +680,7 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
 		break;
 	default:
-		bio_for_each_segment(bv, bio_src, iter)
+		__bio_for_each_segment(bv, bio_src, iter, iter_src)
 			bio->bi_io_vec[bio->bi_vcnt++] = bv;
 		break;
 	}
@@ -699,9 +699,44 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 
 	return bio;
 }
+
+/**
+ * 	bio_clone_bioset - clone a bio
+ * 	@bio_src: bio to clone
+ *	@gfp_mask: allocation priority
+ *	@bs: bio_set to allocate from
+ *
+ *	Clone bio. Caller will own the returned bio, but not the actual data it
+ *	points to. Reference count of returned bio will be one.
+ */
+struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
+			     struct bio_set *bs)
+{
+	return __bio_clone_bioset(bio_src, gfp_mask, bs, 0,
+				  bio_src->bi_iter.bi_size);
+}
 EXPORT_SYMBOL(bio_clone_bioset);
 
 /**
+ * 	bio_clone_bioset_partial - clone a partial bio
+ * 	@bio_src: bio to clone
+ *	@gfp_mask: allocation priority
+ *	@bs: bio_set to allocate from
+ *	@offset: cloned starting from the offset
+ *	@size: size for the cloned bio
+ *
+ *	Clone bio. Caller will own the returned bio, but not the actual data it
+ *	points to. Reference count of returned bio will be one.
+ */
+struct bio *bio_clone_bioset_partial(struct bio *bio_src, gfp_t gfp_mask,
+				     struct bio_set *bs, int offset,
+				     int size)
+{
+	return __bio_clone_bioset(bio_src, gfp_mask, bs, offset, size);
+}
+EXPORT_SYMBOL(bio_clone_bioset_partial);
+
+/**
  *	bio_add_pc_page	-	attempt to add page to bio
  *	@q: the target queue
  *	@bio: destination bio
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7cf8a6c70a3f..8e521194f6fc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -183,7 +183,7 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 
 #define bio_iter_last(bvec, iter) ((iter).bi_size == (bvec).bv_len)
 
-static inline unsigned bio_segments(struct bio *bio)
+static inline unsigned __bio_segments(struct bio *bio, struct bvec_iter *bvec)
 {
 	unsigned segs = 0;
 	struct bio_vec bv;
@@ -205,12 +205,17 @@ static inline unsigned bio_segments(struct bio *bio)
 		break;
 	}
 
-	bio_for_each_segment(bv, bio, iter)
+	__bio_for_each_segment(bv, bio, iter, *bvec)
 		segs++;
 
 	return segs;
 }
 
+static inline unsigned bio_segments(struct bio *bio)
+{
+	return __bio_segments(bio, &bio->bi_iter);
+}
+
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
  * something like:
@@ -384,6 +389,8 @@ extern void bio_put(struct bio *);
 extern void __bio_clone_fast(struct bio *, struct bio *);
 extern struct bio *bio_clone_fast(struct bio *, gfp_t, struct bio_set *);
 extern struct bio *bio_clone_bioset(struct bio *, gfp_t, struct bio_set *bs);
+extern struct bio *bio_clone_bioset_partial(struct bio *, gfp_t,
+					    struct bio_set *, int, int);
 
 extern struct bio_set *fs_bio_set;
 
-- 
2.7.4
