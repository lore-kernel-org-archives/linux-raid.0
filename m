Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B20C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 11:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbiGMLbt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 07:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbiGMLbm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 07:31:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC8F102726;
        Wed, 13 Jul 2022 04:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7+vEvONgQN1JlW1sJ6AYFOXQb9AQbSdq5spcDhChHzQ=; b=Ggx93m3gDZdGFh+yL0AKL9ukAG
        JHygWl58eVYrAApYmel1hLacsfbOsiIBv9d8Wo7wp8T7jihyC5H2aC1IeEmNeNj4w0vcyNvQ5xyw9
        smN6ATUdWYL6J4gCcjLYS1WCcVV3OGLre3h2oxoazuYtzRj46xU4Ouc7lXTeQ6FH4Oyxz8jm1aH9E
        Wo+UxIdk9yJSweKyi/+grSp4miqPFEM5KIG4DR9GQkddNFlpfaSi2UiRmCejWR3aEsrx1Eq4aHdzm
        36hlY3dSMnvyNIGE+6GVL7iUvYY3HvGpu2Dj2d3VybQOF0djtLsMrz3dCzxQ+d+sCe4RTyxLHMih1
        Eok9N4FQ==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBaah-003A5J-HZ; Wed, 13 Jul 2022 11:31:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 5/9] md: stop using for_each_mddev in md_do_sync
Date:   Wed, 13 Jul 2022 13:31:21 +0200
Message-Id: <20220713113125.2232975-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713113125.2232975-1-hch@lst.de>
References: <20220713113125.2232975-1-hch@lst.de>
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
index 5346135ab51c8..a2c2e45cb4c18 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8726,7 +8726,6 @@ void md_do_sync(struct md_thread *thread)
 	unsigned long update_time;
 	sector_t mark_cnt[SYNC_MARKS];
 	int last_mark,m;
-	struct list_head *tmp;
 	sector_t last_check;
 	int skipped = 0;
 	struct md_rdev *rdev;
@@ -8790,7 +8789,8 @@ void md_do_sync(struct md_thread *thread)
 	try_again:
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto skip;
-		for_each_mddev(mddev2, tmp) {
+		spin_lock(&all_mddevs_lock);
+		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
 			if (mddev2 == mddev)
 				continue;
 			if (!mddev->parallel_resync
@@ -8822,7 +8822,8 @@ void md_do_sync(struct md_thread *thread)
 							desc, mdname(mddev),
 							mdname(mddev2));
 					}
-					mddev_put(mddev2);
+					spin_unlock(&all_mddevs_lock);
+
 					if (signal_pending(current))
 						flush_signals(current);
 					schedule();
@@ -8832,6 +8833,7 @@ void md_do_sync(struct md_thread *thread)
 				finish_wait(&resync_wait, &wq);
 			}
 		}
+		spin_unlock(&all_mddevs_lock);
 	} while (mddev->curr_resync < MD_RESYNC_DELAYED);
 
 	j = 0;
-- 
2.30.2

