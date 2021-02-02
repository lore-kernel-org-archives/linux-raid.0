Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE6CC433DB
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E57CA64F86
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbhBBRXN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbhBBRU1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F57C061794;
        Tue,  2 Feb 2021 09:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gzcu4+dRUcQzh49aoQSeBmh/ymPj9zTPCZ6FvuUeaus=; b=d9fnb/iuta2fxP3T5IMP1wtg0A
        LP7YZiGkQYe9FZdtVwjc/r0aVUwJbAr4iD3B93N1KJMw9R6ARe9rV3l0GUQ08DMqaWeejpEf+LcK2
        hsBTKqDB+Vizet8oUO7B2/S3A+AHkwKlphzCcgiApqKMLRZxc7W/4aS5TFTU2uxiGqPXsgieBhI5P
        lvLnaunRhdrVlVXEPYzuiVphdt83/rQ006S8/MhAoXSj9nZ96Ab8opcjzGMDQJMeykrz4lkQEMj4r
        HNFKvdUuVgAprl5jiEhbZj9gfPDs2HU+Zbs8pFL43nL4GyDw4oa0+HqAkPqFz1bbWd/wIqpGn2ygl
        ZMuHQDLQ==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zL6-00FVzY-0H; Tue, 02 Feb 2021 17:19:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 07/11] block: remove a layer of indentation in bio_iov_iter_get_pages
Date:   Tue,  2 Feb 2021 18:19:25 +0100
Message-Id: <20210202171929.1504939-8-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Remove a pointless layer of indentation after a return statement.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3d28d4723f6f2f..dd3b2a01c9bfaa 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1081,15 +1081,15 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		bio_iov_bvec_set(bio, iter);
 		bio_set_flag(bio, BIO_NO_PAGE_REF);
 		return 0;
-	} else {
-		do {
-			if (bio_op(bio) == REQ_OP_ZONE_APPEND)
-				ret = __bio_iov_append_get_pages(bio, iter);
-			else
-				ret = __bio_iov_iter_get_pages(bio, iter);
-		} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 	}
 
+	do {
+		if (bio_op(bio) == REQ_OP_ZONE_APPEND)
+			ret = __bio_iov_append_get_pages(bio, iter);
+		else
+			ret = __bio_iov_iter_get_pages(bio, iter);
+	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
+
 	/* don't account direct I/O as memory stall */
 	bio_clear_flag(bio, BIO_WORKINGSET);
 	return bio->bi_vcnt ? 0 : ret;
-- 
2.29.2

