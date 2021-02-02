Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8481C43331
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83CF964F92
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhBBRWw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbhBBRUW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372F8C06178B;
        Tue,  2 Feb 2021 09:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3DPZPVEJCpp8aCspJJGnZ9XcdJYbrrI8RHiy3Z1pli8=; b=E/73xjC/KnM8IxUJUAl58bCFDP
        AC1CezAtuBVBcSSsNEOTEhEgZljTGoAniuX9V4FX7PwjquyU1yKbZBLTrywoHQ0ttPnlVxxpQ6140
        Ic5BDUEP4Cgv42bZw1TVcOGaBApFn17VPCjt48o8KVIPi+RtBztkmStYZoQYDd6tbYk8HMEdXwBfp
        1mWBO9bAArOxHS0fLBJuyWauaI2/kOoiEJQYfxlp8pdA/ownqstG+Tm/SYv1b+94Zc/nblcso1U94
        TJzaI0r13xeBHi8HZaGJlDULJZrgxbjSAWasVLWysFJtvek/iDmFhrQ0YxIMyoDQdW7UiT2DGAtoD
        fEAlI8TQ==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zL0-00FVyf-MY; Tue, 02 Feb 2021 17:19:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 04/11] block: streamline bvec_alloc
Date:   Tue,  2 Feb 2021 18:19:22 +0100
Message-Id: <20210202171929.1504939-5-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Avoid the pointless goto by trying the slab allocation first and falling
through to the mempool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c2152c4bf8a317..321b3479a154da 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -172,8 +172,6 @@ static inline gfp_t bvec_alloc_gfp(gfp_t gfp)
 struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 			   mempool_t *pool)
 {
-	struct bio_vec *bvl;
-
 	/*
 	 * see comment near bvec_array define!
 	 */
@@ -201,28 +199,24 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 	}
 
 	/*
-	 * idx now points to the pool we want to allocate from. only the
-	 * 1-vec entry pool is mempool backed.
+	 * Try a slab allocation first for all smaller allocations.  If that
+	 * fails and __GFP_DIRECT_RECLAIM is set retry with the mempool.
+	 * The mempool is sized to handle up to BIO_MAX_PAGES entries.
 	 */
-	if (*idx == BVEC_POOL_MAX) {
-fallback:
-		bvl = mempool_alloc(pool, gfp_mask);
-	} else {
+	if (*idx < BVEC_POOL_MAX) {
 		struct biovec_slab *bvs = bvec_slabs + *idx;
+		struct bio_vec *bvl;
 
-		/*
-		 * Try a slab allocation. If this fails and __GFP_DIRECT_RECLAIM
-		 * is set, retry with the 1-entry mempool
-		 */
 		bvl = kmem_cache_alloc(bvs->slab, bvec_alloc_gfp(gfp_mask));
-		if (unlikely(!bvl && (gfp_mask & __GFP_DIRECT_RECLAIM))) {
-			*idx = BVEC_POOL_MAX;
-			goto fallback;
+		if (likely(bvl) || !(gfp_mask & __GFP_DIRECT_RECLAIM)) {
+			(*idx)++;
+			return bvl;
 		}
+		*idx = BVEC_POOL_MAX;
 	}
 
 	(*idx)++;
-	return bvl;
+	return mempool_alloc(pool, gfp_mask);
 }
 
 void bio_uninit(struct bio *bio)
-- 
2.29.2

