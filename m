Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2378C7EE23
	for <linux-raid@archiver.kernel.org>; Mon,  5 Jun 2023 07:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjFEHVV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Jun 2023 03:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjFEHVU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Jun 2023 03:21:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBD898;
        Mon,  5 Jun 2023 00:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=E+0ybOJ1piPxKB/FyeoJ61KE5Hxwo4eicjZY6NegJ+c=; b=vFCGDxIf6uh3QnYk9AG6tcohxH
        2Md46KX+b1u6q6o+HhPk2k/ojn1rdbGlLQmW0ff5bOTS+TTr7UDHYurepiwzvVXjF+OtJcUbZ7oZI
        cnih5dMT2h8GWGPPL1TOkftxRiaaV3F7IqVdkvF9e5I5CnB4vFrUzrLhFCJVKvyJN4TQcNHba6D+J
        Wsr98tpUckVHQOzyL6+qiP7w2pclr8zYKvvmj2ucSeI+qrHQaXhNSf4WNzTMH9Yzqk1am+u/EeIhV
        sIbZRBiGqrWMrTXM0nUjd2McSLrFzxv6/Ge7yqhR6SkxUXcGSAI956JlcnaC8RKv/LHyWsBTQ11td
        LhdoGN3Q==;
Received: from [2001:4bb8:191:e9d5:e931:d7f5:9239:69f3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q64Wk-00EX0Y-0M;
        Mon, 05 Jun 2023 07:21:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org, axboe@kernel.dk
Cc:     johannes.thumshirn@wdc.com, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH] raid1: fix incorrect page freeing in alloc_behind_master_bio
Date:   Mon,  5 Jun 2023 09:21:14 +0200
Message-Id: <20230605072114.497609-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

free_page takes the virtual address of the memory to be freed, and
does so as an unsigned long just to make things confusing.  Use
put_page instead, which actually works on the page pointer.

Note that this is a reason why this should have used __bio_add_page
instead for this impossible to hit case..

Fixes: 2f9848178cfa ("md: raid1: use __bio_add_page for adding single page to bio")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ff89839455ec11..3570da63969b58 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1148,7 +1148,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 			goto free_pages;
 
 		if (!bio_add_page(behind_bio, page, len, 0)) {
-			free_page(page);
+			put_page(page);
 			goto free_pages;
 		}
 
-- 
2.39.2

