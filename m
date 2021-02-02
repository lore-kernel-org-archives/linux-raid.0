Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83B9C4332D
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8EFC64F8F
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbhBBRWt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbhBBRUS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AFFC06178A;
        Tue,  2 Feb 2021 09:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ckVLrqEZ/nvhPdDGmu6boD/JzKn2uJR9m1tHgmZoT3c=; b=mY31gL6NEvtXV+lhqKxbjz36jX
        uUaP4icq5RYmuYDjh3afWlS/evt5ksO4iyv22whUmWMShJfYGwj+E1u4QKi3siuwY0wo3liZ3FQK+
        MR5RLpqi1swVVZyWeoU11iFo7DAdmQRXYYUzCtIUS4neb3onL4LFBofXNWmYn+xlA+CFjz4hpOETx
        N5MW2maSqa8klFvlDh1vue63yewDtqh/j90FMr7qNTHGTjlml0UNMOqcu8II1ATQo4X6XhPou6bb9
        LZZYY7wCkdKZi77opxi2yRcYmXgEHZO+RlLxtlX672ALSWU49JWHjoZC9xtfPAhb9k29ezdjK2s//
        cNq35fDw==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zKu-00FVyJ-Np; Tue, 02 Feb 2021 17:19:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 01/11] block: reuse BIO_INLINE_VECS for integrity bvecs
Date:   Tue,  2 Feb 2021 18:19:19 +0100
Message-Id: <20210202171929.1504939-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

bvec_alloc always uses biovec_slabs, and thus always needs to use the
same number of inline vecs.  Share a single definition for the data
and integrity bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 6 ++----
 block/bio.c           | 6 ------
 block/blk.h           | 1 +
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index c3e5abcfdc98c3..19617fa326c35f 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -14,8 +14,6 @@
 #include <linux/slab.h>
 #include "blk.h"
 
-#define BIP_INLINE_VECS	4
-
 static struct kmem_cache *bip_slab;
 static struct workqueue_struct *kintegrityd_wq;
 
@@ -63,7 +61,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 		inline_vecs = nr_vecs;
 	} else {
 		bip = mempool_alloc(&bs->bio_integrity_pool, gfp_mask);
-		inline_vecs = BIP_INLINE_VECS;
+		inline_vecs = BIO_INLINE_VECS;
 	}
 
 	if (unlikely(!bip))
@@ -470,6 +468,6 @@ void __init bio_integrity_init(void)
 
 	bip_slab = kmem_cache_create("bio_integrity_payload",
 				     sizeof(struct bio_integrity_payload) +
-				     sizeof(struct bio_vec) * BIP_INLINE_VECS,
+				     sizeof(struct bio_vec) * BIO_INLINE_VECS,
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
diff --git a/block/bio.c b/block/bio.c
index 757fee46cefc79..cee2d310f02e78 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -25,12 +25,6 @@
 #include "blk.h"
 #include "blk-rq-qos.h"
 
-/*
- * Test patch to inline a certain number of bi_io_vec's inside the bio
- * itself, to shrink a bio data allocation from two mempool calls to one
- */
-#define BIO_INLINE_VECS		4
-
 /*
  * if you change this list, also change bvec_alloc or things will
  * break badly! cannot be bigger than what you can fit into an
diff --git a/block/blk.h b/block/blk.h
index 0198335c583881..e022a0d0f2ce45 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -55,6 +55,7 @@ void blk_free_flush_queue(struct blk_flush_queue *q);
 
 void blk_freeze_queue(struct request_queue *q);
 
+#define BIO_INLINE_VECS 4
 struct bio_vec *bvec_alloc(gfp_t, int, unsigned long *, mempool_t *);
 void bvec_free(mempool_t *, struct bio_vec *, unsigned int);
 unsigned int bvec_nr_vecs(unsigned short idx);
-- 
2.29.2

