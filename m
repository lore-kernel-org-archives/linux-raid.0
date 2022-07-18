Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2739ACCA479
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiGRGej (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiGRGeg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:34:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC015822;
        Sun, 17 Jul 2022 23:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H50lfvGOS9SaO9Dm7DJU5AbgKIBUefx/R/cDgUx6bVE=; b=42wCqnMNIZnH/uxsD+ZdebdaKl
        UIVtZteQ4hAGJScevVaRPniewIuNC8wBt7LEOxrFJhdXzKny3blsHqqQTLOT5yKffG4+fpSztEwSw
        mJYmjCkX0AqSW10ULMAWRA4LJULYyZ9hDzE59t+i/b5CNIrFhoMWuxzv/E+r2tfp6lGpjKvbgaieW
        YmkCSPNlvf1Kk0ozI+EigKryCpJwJWNW55o+eQVGA7hDCQ6XDLFLq54k/vl0RqIgSXNaRS1ra1HMv
        63oV8uETmOsth5aksmGgHt49NEuvz9LSWdnEQHq/msYyLflCK98gIQ35lZI0+MGulJc5WpGHNipcy
        0QqNsJew==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDKKv-00BEe4-5d; Mon, 18 Jul 2022 06:34:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 06/10] md: stop using for_each_mddev in md_do_sync
Date:   Mon, 18 Jul 2022 08:34:06 +0200
Message-Id: <20220718063410.338626-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718063410.338626-1-hch@lst.de>
References: <20220718063410.338626-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Just do a plain list_for_each that only grabs a mddev reference in
the case where the thread sleeps and restarts the list iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c8a5f9340060a..687f320c7ec4a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8725,7 +8725,6 @@ void md_do_sync(struct md_thread *thread)
 	unsigned long update_time;
 	sector_t mark_cnt[SYNC_MARKS];
 	int last_mark,m;
-	struct list_head *tmp;
 	sector_t last_check;
 	int skipped = 0;
 	struct md_rdev *rdev;
@@ -8789,7 +8788,8 @@ void md_do_sync(struct md_thread *thread)
 	try_again:
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto skip;
-		for_each_mddev(mddev2, tmp) {
+		spin_lock(&all_mddevs_lock);
+		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
 			if (mddev2 == mddev)
 				continue;
 			if (!mddev->parallel_resync
@@ -8821,7 +8821,8 @@ void md_do_sync(struct md_thread *thread)
 							desc, mdname(mddev),
 							mdname(mddev2));
 					}
-					mddev_put(mddev2);
+					spin_unlock(&all_mddevs_lock);
+
 					if (signal_pending(current))
 						flush_signals(current);
 					schedule();
@@ -8831,6 +8832,7 @@ void md_do_sync(struct md_thread *thread)
 				finish_wait(&resync_wait, &wq);
 			}
 		}
+		spin_unlock(&all_mddevs_lock);
 	} while (mddev->curr_resync < MD_RESYNC_DELAYED);
 
 	j = 0;
-- 
2.30.2

