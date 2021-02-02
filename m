Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953A9C433E9
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6689564F93
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbhBBRWv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237125AbhBBRUU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD65EC061786;
        Tue,  2 Feb 2021 09:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=95u1PNGHAZt2zBJX0kr9HAVDzuiUuPn5GLY5wA0M1s0=; b=KIyoOYO92PThA9DEQnMrhxQBPa
        yCcMY4HEN7AO+n0cXjg/HBSFyK4JYGeK8+xmz4SGTrHXgLVGsv16P/lzhVfK8w1evDapCiE6VRUPv
        Ypxb0xt1R0M6iqzNtf78CswvzmWJTnjdL9ibzPvrRVEwGW4eNr/ci1zNMpMip2/9q/DLlDU8VqnvX
        0sJdiKr/+hAqlgj+i2i8SSrPDhqwWQgEk2YBFy5tEGxUXoJjVQ8qdlBn5n1qGtCu6iugovlwP2d0q
        9+TvdfkXGSoiKDKJcR4oSQfuvDYqJRk+DVKkUMWGX1xThDnFtZ4JW6bBCF0BbYtc5Uy1xB+1bLMfX
        TJtcDBBw==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zKy-00FVyX-Fa; Tue, 02 Feb 2021 17:19:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 03/11] block: factor out a bvec_alloc_gfp helper
Date:   Tue,  2 Feb 2021 18:19:21 +0100
Message-Id: <20210202171929.1504939-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Clean up bvec_alloc a little by factoring out a helper for the gfp_t
manipulations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2c359dadfdf6dc..c2152c4bf8a317 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -159,6 +159,16 @@ void bvec_free(mempool_t *pool, struct bio_vec *bv, unsigned int idx)
 	}
 }
 
+/*
+ * Make the first allocation restricted and don't dump info on allocation
+ * failures, since we'll fall back to the mempool in case of failure.
+ */
+static inline gfp_t bvec_alloc_gfp(gfp_t gfp)
+{
+	return (gfp & ~(__GFP_DIRECT_RECLAIM | __GFP_IO)) |
+		__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+}
+
 struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 			   mempool_t *pool)
 {
@@ -199,20 +209,12 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 		bvl = mempool_alloc(pool, gfp_mask);
 	} else {
 		struct biovec_slab *bvs = bvec_slabs + *idx;
-		gfp_t __gfp_mask = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_IO);
-
-		/*
-		 * Make this allocation restricted and don't dump info on
-		 * allocation failures, since we'll fallback to the mempool
-		 * in case of failure.
-		 */
-		__gfp_mask |= __GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
 
 		/*
 		 * Try a slab allocation. If this fails and __GFP_DIRECT_RECLAIM
 		 * is set, retry with the 1-entry mempool
 		 */
-		bvl = kmem_cache_alloc(bvs->slab, __gfp_mask);
+		bvl = kmem_cache_alloc(bvs->slab, bvec_alloc_gfp(gfp_mask));
 		if (unlikely(!bvl && (gfp_mask & __GFP_DIRECT_RECLAIM))) {
 			*idx = BVEC_POOL_MAX;
 			goto fallback;
-- 
2.29.2

