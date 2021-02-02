Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFEAC433DB
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10E964F8D
	for <linux-raid@archiver.kernel.org>; Tue,  2 Feb 2021 17:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbhBBRXK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Feb 2021 12:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237243AbhBBRU0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Feb 2021 12:20:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DADC061793;
        Tue,  2 Feb 2021 09:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=bnwameR66FVk2TzMwO3FMz7nrTIgAi0+i3BRst7/0S8=; b=iMuTjZ3Cq3Tov59Gsy5Zqetet6
        q/JakmW1uYpxjlJPeRN7U2n9zBzVbDpsNwhStcAiOPMlHjDTW/QH2ejxKG8DEuzOmw3lQMX4i5ZQn
        f4O4+nkkE40nzP0esREcEJo3K5DcEDQea8nkCQOnW6mO62ep0D/MRpatptIF7apufauigg2lRhgCl
        t9HcdUjF+Rgb8JlxEmrSzDW80tJL5nWo7eagOw3Hqv8vogQPRs+e8FIlNKFZ7faQHoqywMRh2cRdJ
        Y2wc8wJ1qVIQKQHWCYXXyGXbtB3MQCs+IesKLMG6uzLguI0Zy93sLZe18xJUYMThOeH+ng/p5GlYH
        yi22dsfg==;
Received: from [2001:4bb8:198:6bf4:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6zL4-00FVys-6f; Tue, 02 Feb 2021 17:19:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 06/11] block: turn the nr_iovecs argument to bio_alloc* into an unsigned short
Date:   Tue,  2 Feb 2021 18:19:24 +0100
Message-Id: <20210202171929.1504939-7-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202171929.1504939-1-hch@lst.de>
References: <20210202171929.1504939-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The bi_max_vecs and bi_vcnt fields are defined as unsigned short, so
don't allow passing larger values in.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 4 ++--
 include/linux/bio.h | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index ae241252ea14e5..3d28d4723f6f2f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -407,7 +407,7 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
  *
  * Returns: Pointer to new bio on success, NULL on failure.
  */
-struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
+struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned short nr_iovecs,
 			     struct bio_set *bs)
 {
 	gfp_t saved_gfp = gfp_mask;
@@ -493,7 +493,7 @@ EXPORT_SYMBOL(bio_alloc_bioset);
  *
  * Returns: Pointer to new bio on success, NULL on failure.
  */
-struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs)
 {
 	struct bio *bio;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4a84207dd99663..9ceeb8ecdb7f23 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -407,8 +407,9 @@ extern void bioset_exit(struct bio_set *);
 extern int biovec_init_pool(mempool_t *pool, int pool_entries);
 extern int bioset_init_from_src(struct bio_set *bs, struct bio_set *src);
 
-extern struct bio *bio_alloc_bioset(gfp_t, unsigned int, struct bio_set *);
-struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs);
+struct bio *bio_alloc_bioset(gfp_t gfp, unsigned short nr_iovecs,
+		struct bio_set *bs);
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
 extern void bio_put(struct bio *);
 
 extern void __bio_clone_fast(struct bio *, struct bio *);
@@ -416,7 +417,7 @@ extern struct bio *bio_clone_fast(struct bio *, gfp_t, struct bio_set *);
 
 extern struct bio_set fs_bio_set;
 
-static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
+static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned short nr_iovecs)
 {
 	return bio_alloc_bioset(gfp_mask, nr_iovecs, &fs_bio_set);
 }
-- 
2.29.2

