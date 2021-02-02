Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F96C433DB
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF39564ECE
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbhBBRXS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbhBBRUd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926FDC0617A9;
        Tue,  2 Feb 2021 09:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1xNd4VdNs0a6Y9GFGx9AiqZjZRBGY2oGOlLXsERzOOA=; b=GWKjXmh6QaqJtgiVxXicmw1722
        OU6MkuBFiBg85ibR+B/uW57CgL/IK23nDoFuI4jf0y1lFJdHaDtMOvucArVoPrZCVKDfppBC0+eSG
        VeuDc6P2isr/2ysdco+qTPjQ0vG6UykkdXk9Sk4YurhZv8wTOcHBkOlk9aQgf5DW3DLtM3tcIdtym
        YqRbrAAiW8/R6v5iomRsy2vjho/cwZeEWAWvzasmywyLj2/10ajEfLQG+1Bk8SfhTQEDf9RuEP8Lq
        5nHnoUszTpzl00oSMMx1GMh+n6aJyE0qTodhhNiNEReLMD//OZatES3/PS95L153r4nHptVuaX7xC
        /+FCOZgg==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zLB-00FVzz-CL; Tue, 02 Feb 2021 17:19:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 09/11] block: mark the bio as cloned in bio_iov_bvec_set
Date:   Tue,  2 Feb 2021 18:19:27 +0100
Message-Id: <20210202171929.1504939-10-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

bio_iov_bvec_set clones the bio_vecs from the iter, and thus should be
treated like a cloned bio in every respect.  That also includes not
touching bi_max_vecs as that is a property of the bio allocation and not
its current payload.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index f753201238273b..a36f955cd120b0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -937,11 +937,11 @@ static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 	WARN_ON_ONCE(BVEC_POOL_IDX(bio) != 0);
 
 	bio->bi_vcnt = iter->nr_segs;
-	bio->bi_max_vecs = iter->nr_segs;
 	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
 	bio->bi_iter.bi_bvec_done = iter->iov_offset;
 	bio->bi_iter.bi_size = iter->count;
 	bio_set_flag(bio, BIO_NO_PAGE_REF);
+	bio_set_flag(bio, BIO_CLONED);
 
 	iov_iter_advance(iter, iter->count);
 	return 0;
-- 
2.29.2

