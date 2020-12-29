Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A248C4332D
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E66FE21D7F
	for <linux-raid@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgL2J3K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Dec 2020 04:29:10 -0500
Received: from mail.synology.com ([211.23.38.101]:43842 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbgL2J3J (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 29 Dec 2020 04:29:09 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2020 04:29:08 EST
Received: from localhost.localdomain (unknown [10.17.198.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 2F468CE781A8;
        Tue, 29 Dec 2020 17:21:11 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1609233671; bh=+HZP5cRN+7/h1y9v1UgB0m/4rcblDdZQnet7m+Cvsr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ibOi+n8kxRmwMYYkbv1i5HuBGPg/p0V+t5xh1paJDG2ZhEQm13uL6lck2AWtJkzto
         bPE3dd0jUK79NZ8x7AP0MpVkK0IGTqiqfqRgJsIoohiqQL8bGoVWUqOYpxOJPKhqDf
         72vkohsIU4shoTs06qKHbXnhEtRsmPBx9ccXKc2I=
From:   dannyshih <dannyshih@synology.com>
To:     axboe@kernel.dk
Cc:     agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
        song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, Danny Shih <dannyshih@synology.com>
Subject: [PATCH 2/4] block: use submit_bio_noacct_add_head for split bio sending back
Date:   Tue, 29 Dec 2020 17:18:40 +0800
Message-Id: <1609233522-25837-3-git-send-email-dannyshih@synology.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Danny Shih <dannyshih@synology.com>

Use submit_bio_noacct_add_head when sending split bio back to itself.
Otherwise, it might be handled after the lately split bio.

Signed-off-by: Danny Shih <dannyshih@synology.com>
Reviewed-by: Allen Peng <allenpeng@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
---
 block/blk-merge.c | 2 +-
 block/bounce.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 808768f..e6ddcef0 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -347,7 +347,7 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 
 		bio_chain(split, *bio);
 		trace_block_split(split, (*bio)->bi_iter.bi_sector);
-		submit_bio_noacct(*bio);
+		submit_bio_noacct_add_head(*bio);
 		*bio = split;
 	}
 }
diff --git a/block/bounce.c b/block/bounce.c
index d3f51ac..0b4db65 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -308,7 +308,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	if (!passthrough && sectors < bio_sectors(*bio_orig)) {
 		bio = bio_split(*bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
 		bio_chain(bio, *bio_orig);
-		submit_bio_noacct(*bio_orig);
+		submit_bio_noacct_add_head(*bio_orig);
 		*bio_orig = bio;
 	}
 	bio = bounce_clone_bio(*bio_orig, GFP_NOIO, passthrough ? NULL :
-- 
2.7.4

