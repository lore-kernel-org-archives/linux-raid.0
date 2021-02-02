Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C738C43381
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0495164F97
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237468AbhBBRWv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbhBBRUU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53D5C06174A;
        Tue,  2 Feb 2021 09:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=o/jNAoTc1vK1IlciktmTcbvVypdWXAwN060jb4aaI0I=; b=IdJAwdZTt3ZZ3HkvxjERCioY21
        4cBi7Wmt0PXDCE2Rr/ilHimSRUbFIorLKwUPjgvfCX/wK5LUF4NWbuePndp/WAhG4OwZt4+9JnEuj
        OgUPoNh3kYHnp5+Y6qR0VrhAWidtIbGltCs8bnxGG8pgE4NdnEQ6502UFiEs/OEiapVvXuq37WmfD
        aI7nwQpHHMiwZLMAuCD8KjzxjnwAOdtmIPowmOT/2ZMnGBkdmLDnVQGCnixroI6NhPyzniZWCCV3O
        iL5ehwwAhe2rEeWjYRxLvujNQcNnN104tyXacfZ+W2CplPh4aD5YwGfCjc9qjnyStLAq9wbtwgIiy
        f1gLgjJA==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zKw-00FVyQ-JC; Tue, 02 Feb 2021 17:19:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 02/11] block: move struct biovec_slab to bio.c
Date:   Tue,  2 Feb 2021 18:19:20 +0100
Message-Id: <20210202171929.1504939-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

struct biovec_slab is only used inside of bio.c, so move it there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 6 ++++++
 include/linux/bio.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index cee2d310f02e78..2c359dadfdf6dc 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -25,6 +25,12 @@
 #include "blk.h"
 #include "blk-rq-qos.h"
 
+struct biovec_slab {
+	int nr_vecs;
+	char *name;
+	struct kmem_cache *slab;
+};
+
 /*
  * if you change this list, also change bvec_alloc or things will
  * break badly! cannot be bigger than what you can fit into an
diff --git a/include/linux/bio.h b/include/linux/bio.h
index c74857cf12528c..4a84207dd99663 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -720,12 +720,6 @@ struct bio_set {
 	struct workqueue_struct	*rescue_workqueue;
 };
 
-struct biovec_slab {
-	int nr_vecs;
-	char *name;
-	struct kmem_cache *slab;
-};
-
 static inline bool bioset_initialized(struct bio_set *bs)
 {
 	return bs->bio_slab != NULL;
-- 
2.29.2

