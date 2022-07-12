Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB94EC43334
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 07:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiGLHD5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiGLHDw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 03:03:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057A821E02;
        Tue, 12 Jul 2022 00:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VGBCvWFSyJvzGUFgHbFC3CnRikHS4RrW+fJyeHkRqMk=; b=GnT9qOcgCICxDLpQWRYvUKIg5P
        9BxdHy4vm08m6bBUofzw9Zx12ccKcN/FgmMowsSLlz8P7yUTZqRkuhkgTG9fmF5MQ00FcTUn8H/kn
        CL216P6aZ8OR9fAN4oGvSZ2ny6rYCkArZGzN4kwk/0fKOwksF85jFOqmV8X1gYHU5C465EkXJ6K2B
        QFpW5Y1sTxZ4cyPI9fpoGwjLyC2Q7RjTe7Uk29qLmPRuHT30ok0LEKVotsZjTTBftRPepVea41SfL
        CftWZzjfjc05/MJukm2KqRTA/rBuNOYT4ahsjSgC4Gkdgbu8bD2RiNyxYCSn7VDDtNteyvDdoG4AR
        CWbxHjFg==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB9vt-008DWd-F5; Tue, 12 Jul 2022 07:03:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 4/8] md: stop using for_each_mddev in md_do_sync
Date:   Tue, 12 Jul 2022 09:03:27 +0200
Message-Id: <20220712070331.1390700-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712070331.1390700-1-hch@lst.de>
References: <20220712070331.1390700-1-hch@lst.de>
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
index 61eceef17d5fd..d22608dcb25fe 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8683,7 +8683,6 @@ void md_do_sync(struct md_thread *thread)
 	unsigned long update_time;
 	sector_t mark_cnt[SYNC_MARKS];
 	int last_mark,m;
-	struct list_head *tmp;
 	sector_t last_check;
 	int skipped = 0;
 	struct md_rdev *rdev;
@@ -8753,7 +8752,8 @@ void md_do_sync(struct md_thread *thread)
 	try_again:
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
 			goto skip;
-		for_each_mddev(mddev2, tmp) {
+		spin_lock(&all_mddevs_lock);
+		list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
 			if (mddev2 == mddev)
 				continue;
 			if (!mddev->parallel_resync
@@ -8783,7 +8783,8 @@ void md_do_sync(struct md_thread *thread)
 							desc, mdname(mddev),
 							mdname(mddev2));
 					}
-					mddev_put(mddev2);
+					spin_unlock(&all_mddevs_lock);
+
 					if (signal_pending(current))
 						flush_signals(current);
 					schedule();
@@ -8793,6 +8794,7 @@ void md_do_sync(struct md_thread *thread)
 				finish_wait(&resync_wait, &wq);
 			}
 		}
+		spin_unlock(&all_mddevs_lock);
 	} while (mddev->curr_resync < 2);
 
 	j = 0;
-- 
2.30.2

