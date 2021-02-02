Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82E7C433E0
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E7564ECE
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbhBBRYj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237396AbhBBRWS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:22:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6308FC0617AB;
        Tue,  2 Feb 2021 09:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=cglO6BMsvHI1YUCpMMymW5TemFbeCypKyIhLh9bNVCU=; b=C3uAZJ3UtUozcPglde692Btty4
        0JHmu8sZ1bpN0jzGYnzjTocCjZ3EAUjfrBfQ+rUOkQXSFJdLWei06jp0tIV/Du0CmA8YGISwo9k7F
        F3My0jwHqYFpF6Q9F5jYACEZNIbPBm8PCzfy9Y+x45DfYLH7ZLY874UQ3DVNhtjH5RTO1icw3rATK
        h6GA9loCKXm7YC2ihP+iRvrPVyDEdcsxXmhSTlNJF+U7EBS77FFCjZDvuvQvJ8UCTxEJjC8mbPk0A
        dckyBxbCgUoy+G2tjNRY2CwgSyMSkzQ4WlyVyjYMbTLGjuOlxlZKwdY8kHDo9XkZehgvT01oJrI0l
        kWVisUGQ==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zLG-00FW14-NS; Tue, 02 Feb 2021 17:19:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 11/11] block: use bi_max_vecs to find the bvec pool
Date:   Tue,  2 Feb 2021 18:19:29 +0100
Message-Id: <20210202171929.1504939-12-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Instead of encoding of the bvec pool using magic bio flags, just use
a helper to find the pool based on the max_vecs value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c     |  11 ++--
 block/bio.c               | 104 ++++++++++++++++----------------------
 block/blk.h               |   6 +--
 include/linux/bio.h       |   1 -
 include/linux/blk_types.h |  29 +----------
 5 files changed, 51 insertions(+), 100 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 19617fa326c35f..dfa652122a2dc8 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -28,7 +28,7 @@ static void __bio_integrity_free(struct bio_set *bs,
 	if (bs && mempool_initialized(&bs->bio_integrity_pool)) {
 		if (bip->bip_vec)
 			bvec_free(&bs->bvec_integrity_pool, bip->bip_vec,
-				  bip->bip_slab);
+				  bip->bip_max_vcnt);
 		mempool_free(bip, &bs->bio_integrity_pool);
 	} else {
 		kfree(bip);
@@ -70,14 +70,11 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 	memset(bip, 0, sizeof(*bip));
 
 	if (nr_vecs > inline_vecs) {
-		unsigned long idx = 0;
-
-		bip->bip_vec = bvec_alloc(gfp_mask, nr_vecs, &idx,
-					  &bs->bvec_integrity_pool);
+		bip->bip_max_vcnt = nr_vecs;
+		bip->bip_vec = bvec_alloc(&bs->bvec_integrity_pool,
+					  &bip->bip_max_vcnt, gfp_mask);
 		if (!bip->bip_vec)
 			goto err;
-		bip->bip_max_vcnt = bvec_nr_vecs(idx);
-		bip->bip_slab = idx;
 	} else {
 		bip->bip_vec = bip->bip_inline_vecs;
 		bip->bip_max_vcnt = inline_vecs;
diff --git a/block/bio.c b/block/bio.c
index a36f955cd120b0..a0eabe2f8b07a5 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -36,6 +36,24 @@ static struct biovec_slab {
 	{ .nr_vecs = BIO_MAX_PAGES, .name = "biovec-max" },
 };
 
+static struct biovec_slab *biovec_slab(unsigned short nr_vecs)
+{
+	switch (nr_vecs) {
+	/* smaller bios use inline vecs */
+	case 5 ... 16:
+		return &bvec_slabs[0];
+	case 17 ... 64:
+		return &bvec_slabs[1];
+	case 65 ... 128:
+		return &bvec_slabs[2];
+	case 129 ... BIO_MAX_PAGES:
+		return &bvec_slabs[3];
+	default:
+		BUG();
+		return NULL;
+	}
+}
+
 /*
  * fs_bio_set is the bio_set containing bio and iovec memory pools used by
  * IO code that does not need private memory pools.
@@ -131,26 +149,14 @@ static void bio_put_slab(struct bio_set *bs)
 	mutex_unlock(&bio_slab_lock);
 }
 
-unsigned int bvec_nr_vecs(unsigned short idx)
+void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned short nr_vecs)
 {
-	return bvec_slabs[--idx].nr_vecs;
-}
+	BIO_BUG_ON(nr_vecs > BIO_MAX_PAGES);
 
-void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned int idx)
-{
-	if (!idx)
-		return;
-	idx--;
-
-	BIO_BUG_ON(idx >= BVEC_POOL_NR);
-
-	if (idx == BVEC_POOL_MAX) {
+	if (nr_vecs == BIO_MAX_PAGES)
 		mempool_free(bv, pool);
-	} else {
-		struct biovec_slab *bvs = bvec_slabs + idx;
-
-		kmem_cache_free(bvs->slab, bv);
-	}
+	else if (nr_vecs > BIO_INLINE_VECS)
+		kmem_cache_free(biovec_slab(nr_vecs)->slab, bv);
 }
 
 /*
@@ -163,48 +169,34 @@ static inline gfp_t bvec_alloc_gfp(gfp_t gfp)
 		__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 }
 
-struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
-			   mempool_t *pool)
+struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
+		gfp_t gfp_mask)
 {
+	struct biovec_slab *bvs = biovec_slab(*nr_vecs);
+
+	if (WARN_ON_ONCE(!bvs))
+		return NULL;
+
 	/*
-	 * see comment near bvec_array define!
+	 * Upgrade the nr_vecs request to take full advantage of the allocation.
+	 * We also rely on this in the bvec_free path.
 	 */
-	switch (nr) {
-	/* smaller bios use inline vecs */
-	case 5 ... 16:
-		*idx = 2;
-		break;
-	case 17 ... 64:
-		*idx = 3;
-		break;
-	case 65 ... 128:
-		*idx = 4;
-		break;
-	case 129 ... BIO_MAX_PAGES:
-		*idx = 5;
-		break;
-	default:
-		return NULL;
-	}
+	*nr_vecs = bvs->nr_vecs;
 
 	/*
 	 * Try a slab allocation first for all smaller allocations.  If that
 	 * fails and __GFP_DIRECT_RECLAIM is set retry with the mempool.
 	 * The mempool is sized to handle up to BIO_MAX_PAGES entries.
 	 */
-	if (*idx < BVEC_POOL_MAX) {
-		struct biovec_slab *bvs = bvec_slabs + *idx;
+	if (*nr_vecs < BIO_MAX_PAGES) {
 		struct bio_vec *bvl;
 
 		bvl = kmem_cache_alloc(bvs->slab, bvec_alloc_gfp(gfp_mask));
-		if (likely(bvl) || !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
-			(*idx)++;
+		if (likely(bvl) || !(gfp_mask & __GFP_DIRECT_RECLAIM))
 			return bvl;
-		}
-		*idx = BVEC_POOL_MAX;
+		*nr_vecs = BIO_MAX_PAGES;
 	}
 
-	(*idx)++;
 	return mempool_alloc(pool, gfp_mask);
 }
 
@@ -231,7 +223,7 @@ static void bio_free(struct bio *bio)
 	bio_uninit(bio);
 
 	if (bs) {
-		bvec_free(&bs->bvec_pool, bio->bi_io_vec, BVEC_POOL_IDX(bio));
+		bvec_free(&bs->bvec_pool, bio->bi_io_vec, bio->bi_max_vecs);
 
 		/*
 		 * If we have front padding, adjust the bio pointer before freeing
@@ -275,12 +267,8 @@ EXPORT_SYMBOL(bio_init);
  */
 void bio_reset(struct bio *bio)
 {
-	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
-
 	bio_uninit(bio);
-
 	memset(bio, 0, BIO_RESET_BYTES);
-	bio->bi_flags = flags;
 	atomic_set(&bio->__bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_reset);
@@ -453,22 +441,18 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned short nr_iovecs,
 
 	bio = p + bs->front_pad;
 	if (nr_iovecs > BIO_INLINE_VECS) {
-		unsigned long idx = 0;
 		struct bio_vec *bvl = NULL;
 
-		bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
+		bvl = bvec_alloc(&bs->bvec_pool, &nr_iovecs, gfp_mask);
 		if (!bvl && gfp_mask != saved_gfp) {
 			punt_bios_to_rescuer(bs);
 			gfp_mask = saved_gfp;
-			bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx,
-					 &bs->bvec_pool);
+			bvl = bvec_alloc(&bs->bvec_pool, &nr_iovecs, gfp_mask);
 		}
-
 		if (unlikely(!bvl))
 			goto err_free;
 
-		bio_init(bio, bvl, bvec_nr_vecs(idx));
-		bio->bi_flags |= idx << BVEC_POOL_OFFSET;
+		bio_init(bio, bvl, nr_iovecs);
 	} else if (nr_iovecs) {
 		bio_init(bio, bio->bi_inline_vecs, BIO_INLINE_VECS);
 	} else {
@@ -644,7 +628,7 @@ EXPORT_SYMBOL(bio_put);
  */
 void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 {
-	BUG_ON(bio->bi_pool && BVEC_POOL_IDX(bio));
+	WARN_ON_ONCE(bio->bi_pool && bio->bi_max_vecs);
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
@@ -934,7 +918,7 @@ EXPORT_SYMBOL_GPL(bio_release_pages);
 
 static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 {
-	WARN_ON_ONCE(BVEC_POOL_IDX(bio) != 0);
+	WARN_ON_ONCE(bio->bi_max_vecs);
 
 	bio->bi_vcnt = iter->nr_segs;
 	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
@@ -1495,7 +1479,7 @@ EXPORT_SYMBOL_GPL(bio_trim);
  */
 int biovec_init_pool(mempool_t *pool, int pool_entries)
 {
-	struct biovec_slab *bp = bvec_slabs + BVEC_POOL_MAX;
+	struct biovec_slab *bp = bvec_slabs + ARRAY_SIZE(bvec_slabs) - 1;
 
 	return mempool_init_slab_pool(pool, pool_entries, bp->slab);
 }
@@ -1605,8 +1589,6 @@ static int __init init_bio(void)
 {
 	int i;
 
-	BUILD_BUG_ON(BIO_FLAG_LAST > BVEC_POOL_OFFSET);
-
 	bio_integrity_init();
 
 	for (i = 0; i < ARRAY_SIZE(bvec_slabs); i++) {
diff --git a/block/blk.h b/block/blk.h
index e022a0d0f2ce45..bfc4d526f6261c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -56,9 +56,9 @@ void blk_free_flush_queue(struct blk_flush_queue *q);
 void blk_freeze_queue(struct request_queue *q);
 
 #define BIO_INLINE_VECS 4
-struct bio_vec *bvec_alloc(gfp_t, int, unsigned long *, mempool_t *);
-void bvec_free(mempool_t *, struct bio_vec *, unsigned int);
-unsigned int bvec_nr_vecs(unsigned short idx);
+struct bio_vec *bvec_alloc(mempool_t *pool, unsigned short *nr_vecs,
+		gfp_t gfp_mask);
+void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned short nr_vecs);
 
 static inline bool biovec_phys_mergeable(struct request_queue *q,
 		struct bio_vec *vec1, struct bio_vec *vec2)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9ceeb8ecdb7f23..3cbbaf76906edb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -329,7 +329,6 @@ struct bio_integrity_payload {
 
 	struct bvec_iter	bip_iter;
 
-	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
 	unsigned short		bip_flags;	/* control flags */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1bc6f6a01070fc..db026b6ec15ab7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -227,7 +227,7 @@ struct bio {
 						 * top bits REQ_OP. Use
 						 * accessors.
 						 */
-	unsigned short		bi_flags;	/* status, etc and bvec pool number */
+	unsigned short		bi_flags;	/* BIO_* below */
 	unsigned short		bi_ioprio;
 	unsigned short		bi_write_hint;
 	blk_status_t		bi_status;
@@ -307,33 +307,6 @@ enum {
 	BIO_FLAG_LAST
 };
 
-/* See BVEC_POOL_OFFSET below before adding new flags */
-
-/*
- * We support 6 different bvec pools, the last one is magic in that it
- * is backed by a mempool.
- */
-#define BVEC_POOL_NR		6
-#define BVEC_POOL_MAX		(BVEC_POOL_NR - 1)
-
-/*
- * Top 3 bits of bio flags indicate the pool the bvecs came from.  We add
- * 1 to the actual index so that 0 indicates that there are no bvecs to be
- * freed.
- */
-#define BVEC_POOL_BITS		(3)
-#define BVEC_POOL_OFFSET	(16 - BVEC_POOL_BITS)
-#define BVEC_POOL_IDX(bio)	((bio)->bi_flags >> BVEC_POOL_OFFSET)
-#if (1<< BVEC_POOL_BITS) < (BVEC_POOL_NR+1)
-# error "BVEC_POOL_BITS is too small"
-#endif
-
-/*
- * Flags starting here get preserved by bio_reset() - this includes
- * only BVEC_POOL_IDX()
- */
-#define BIO_RESET_BITS	BVEC_POOL_OFFSET
-
 typedef __u32 __bitwise blk_mq_req_flags_t;
 
 /*
-- 
2.29.2

