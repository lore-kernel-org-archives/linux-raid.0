Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891F5C433DB
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FC364F8D
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237257AbhBBRXP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbhBBRUa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2B5C0617A7;
        Tue,  2 Feb 2021 09:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wG6tXktssOWQ56eeV+I0U7eYogGdokbPYfEur/kWUlQ=; b=tk5XUWkrX57/xWKSIUba8QjL4+
        mBFGvS8oCwhazfZTK3pby9OkHrkDCQaQNtlRXlnzG6qpi6p+xiPZWNVl+Ch6S1xDqQFCnsRIyoQQf
        Aln2q8LubJyEHifigzp9CwdLd5QvGK3fKdBcTZ81XU8OSByV192kkf5eFMP1ulJxNH88em2OTgYkE
        D+tVmpMJNRgQ7q+xhaGrdPx2KOelrDdJY0uCaQrLMyE2la31Warl4IC/KNqAkB3EKh7fdca+mDi3b
        kmgDR3UF+x4PJsqC8kAT4lFBNJyhVEYL4Uy+yDu2//WBozGiW81PuOx2Xjiqoh0xXrDbogXCtvNFz
        MWVOYtVQ==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zL8-00FVzj-4d; Tue, 02 Feb 2021 17:19:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 08/11] block: set BIO_NO_PAGE_REF in bio_iov_bvec_set
Date:   Tue,  2 Feb 2021 18:19:26 +0100
Message-Id: <20210202171929.1504939-9-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

bio_iov_bvec_set assigns the foreign bvec, so setting the NO_PAGE_REF
directly there seems like the best fit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index dd3b2a01c9bfaa..f753201238273b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -941,6 +941,7 @@ static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
 	bio->bi_iter.bi_bvec_done = iter->iov_offset;
 	bio->bi_iter.bi_size = iter->count;
+	bio_set_flag(bio, BIO_NO_PAGE_REF);
 
 	iov_iter_advance(iter, iter->count);
 	return 0;
@@ -1078,9 +1079,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	if (iov_iter_is_bvec(iter)) {
 		if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
 			return -EINVAL;
-		bio_iov_bvec_set(bio, iter);
-		bio_set_flag(bio, BIO_NO_PAGE_REF);
-		return 0;
+		return bio_iov_bvec_set(bio, iter);
 	}
 
 	do {
-- 
2.29.2

