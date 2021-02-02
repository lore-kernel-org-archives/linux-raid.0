Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC346C433E6
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F9064F86
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbhBBRXC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237233AbhBBRUY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E156C06178C;
        Tue,  2 Feb 2021 09:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Jnc7vDN7b0htNAKxkVbrPDEfN2BY9ixn/lFhxacZrfE=; b=uUsLHkC/O1dDcnI8vrllHvPVoF
        w6LHveABmeTmwe7u0qbJclkQ+E0Bikz/OUVwOW56r4RnVTSpIt1N0gp7iSDbosHswwbjs2aM41wNj
        gmNR29lwWi3DrCUtbDPDMZaTdCf6fATOz8IdhHfJyirSItrfPw60PWKC6h960YfphmpstWNP/zmiS
        /8obJkcVLF8ZKjFT5W//Sjj3MfwWZTkvK00oFv6UJIy9T3BHsypAwuYW89AJO1QcM9b+cRCozEGiB
        fixAojavS8OBzwmTZelzYpp2CN0cBZlvvCvxcAvChAySJykvD53VBpllFnXKtnwSqDtGWdAFgnNma
        IyiVWG6g==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zL2-00FVyl-Ec; Tue, 02 Feb 2021 17:19:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 05/11] block: remove the 1 and 4 vec bvec_slabs entries
Date:   Tue,  2 Feb 2021 18:19:23 +0100
Message-Id: <20210202171929.1504939-6-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

All bios with up to 4 bvecs use the inline bvecs in the bio itself, so
don't bother to define bvec_slabs entries for them.  Also decruftify
the bvec_slabs definition and initialization while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 53 ++++++++++++++++-------------------------------------
 1 file changed, 16 insertions(+), 37 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 321b3479a154da..ae241252ea14e5 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -25,23 +25,17 @@
 #include "blk.h"
 #include "blk-rq-qos.h"
 
-struct biovec_slab {
+static struct biovec_slab {
 	int nr_vecs;
 	char *name;
 	struct kmem_cache *slab;
+} bvec_slabs[] __read_mostly = {
+	{ .nr_vecs = 16, .name = "biovec-16" },
+	{ .nr_vecs = 64, .name = "biovec-64" },
+	{ .nr_vecs = 128, .name = "biovec-128" },
+	{ .nr_vecs = BIO_MAX_PAGES, .name = "biovec-max" },
 };
 
-/*
- * if you change this list, also change bvec_alloc or things will
- * break badly! cannot be bigger than what you can fit into an
- * unsigned short
- */
-#define BV(x, n) { .nr_vecs = x, .name = "biovec-"#n }
-static struct biovec_slab bvec_slabs[BVEC_POOL_NR] __read_mostly = {
-	BV(1, 1), BV(4, 4), BV(16, 16), BV(64, 64), BV(128, 128), BV(BIO_MAX_PAGES, max),
-};
-#undef BV
-
 /*
  * fs_bio_set is the bio_set containing bio and iovec memory pools used by
  * IO code that does not need private memory pools.
@@ -176,12 +170,7 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 	 * see comment near bvec_array define!
 	 */
 	switch (nr) {
-	case 1:
-		*idx = 0;
-		break;
-	case 2 ... 4:
-		*idx = 1;
-		break;
+	/* smaller bios use inline vecs */
 	case 5 ... 16:
 		*idx = 2;
 		break;
@@ -1613,31 +1602,21 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 }
 EXPORT_SYMBOL(bioset_init_from_src);
 
-static void __init biovec_init_slabs(void)
+static int __init init_bio(void)
 {
 	int i;
 
-	for (i = 0; i < BVEC_POOL_NR; i++) {
-		int size;
-		struct biovec_slab *bvs = bvec_slabs + i;
-
-		if (bvs->nr_vecs <= BIO_INLINE_VECS) {
-			bvs->slab = NULL;
-			continue;
-		}
-
-		size = bvs->nr_vecs * sizeof(struct bio_vec);
-		bvs->slab = kmem_cache_create(bvs->name, size, 0,
-                                SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-	}
-}
-
-static int __init init_bio(void)
-{
 	BUILD_BUG_ON(BIO_FLAG_LAST > BVEC_POOL_OFFSET);
 
 	bio_integrity_init();
-	biovec_init_slabs();
+
+	for (i = 0; i < ARRAY_SIZE(bvec_slabs); i++) {
+		struct biovec_slab *bvs = bvec_slabs + i;
+
+		bvs->slab = kmem_cache_create(bvs->name,
+				bvs->nr_vecs * sizeof(struct bio_vec), 0,
+				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+	}
 
 	if (bioset_init(&fs_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS))
 		panic("bio: can't allocate bios\n");
-- 
2.29.2

