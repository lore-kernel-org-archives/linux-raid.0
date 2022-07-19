Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED0ECCA481
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiGSJTt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbiGSJTI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:19:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B833E748;
        Tue, 19 Jul 2022 02:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zWfrdXUaEINEnISTogNv+v0vjHXsopu7YXHg0pes71U=; b=4ygIZ+l0jNxB0zcHYBSQapoVTE
        3STI3WBoxGUyj+lMbY6E71H8KBmEjXA+19f8j++sz7yp+vVb3XJ62+43uuePGL91ydxgv+GFfOebJ
        CnqG3vcQI5kMp3elMuWu4rJdjd+ShP9sH7d1mn8LfFBLi0fEZgEuXOHwSGAlhu00NmkuLPE1epyss
        0FcnyaGQlINF9uH+wvCNhVh4qnA2cwHTsbWAoUvcuS6a4Yeji3xLqLMVvHs8G6a4YBAr0hdkMJSqI
        vwNrBnEufetFQaJbCkMQssQVsJJ52NK7DbGwCXAfulDI4xRvpwQj6OqoJYQ9onLTBdXn1eJcv+H56
        qJTWfcow==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDjNU-007Ce9-RU; Tue, 19 Jul 2022 09:18:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/10] md: stop using for_each_mddev in md_do_sync
Date:   Tue, 19 Jul 2022 11:18:20 +0200
Message-Id: <20220719091824.1064989-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220719091824.1064989-1-hch@lst.de>
References: <20220719091824.1064989-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Just do a plain list_for_each that only grabs a mddev reference in
the case where the thread sleeps and restarts the list iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 581cebd5478d6..bd87d59086947 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8723,7 +8723,6 @@ void md_do_sync(struct md_thread *thread)
 	unsigned long update_time;
 	sector_t mark_cnt[SYNC_MARKS];
 	int last_mark,m;
-	struct list_head *tmp;
 	sector_t last_check;
 	int skipped = 0;
 	struct md_rdev *rdev;
@@ -8787,7 +8786,8 @@ void md_do_sync(struct md_thread *thread)
 	try_again:
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto skip;
-		for_each_mddev(mddev2, tmp) {
+		spin_lock(&all_mddevs_lock);
+		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
 			if (mddev2 == mddev)
 				continue;
 			if (!mddev->parallel_resync
@@ -8819,7 +8819,8 @@ void md_do_sync(struct md_thread *thread)
 							desc, mdname(mddev),
 							mdname(mddev2));
 					}
-					mddev_put(mddev2);
+					spin_unlock(&all_mddevs_lock);
+
 					if (signal_pending(current))
 						flush_signals(current);
 					schedule();
@@ -8829,6 +8830,7 @@ void md_do_sync(struct md_thread *thread)
 				finish_wait(&resync_wait, &wq);
 			}
 		}
+		spin_unlock(&all_mddevs_lock);
 	} while (mddev->curr_resync < MD_RESYNC_DELAYED);
 
 	j = 0;
-- 
2.30.2

