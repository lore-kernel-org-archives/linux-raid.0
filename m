Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD22C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbiGSJTw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiGSJTI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:19:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CB33ED76;
        Tue, 19 Jul 2022 02:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xw5Z1sy7vt2KlQduSrrum+ZM/79fUw9gyDM1dqFUOvY=; b=RY2HPNzSTAaOVeqnzjEMmvFp4n
        q+6XDUkM6apog7+b6bG+e/+7g9b8307E8EoQZBzzp7siGGjPQp0Z+6wUoX76hloB3J8kN3zbwQypM
        ixhQs8ikhyUCqSqxzIf+Iwm0qGl7kfRDjVPtCVq571BvjT4sRga7c5jaa3rzLO8F8LKrWyHikdwPQ
        JvpfiMc5Va53h7f+yelqfvyInsZbhB9YmtJs71M5HwUNZgfkdg56B+luxbVZzVXqxArw5eLsB9iHW
        Xy4KfEn/jLIiD+y0SRrJiYj9hjf6Yeg5M26/cO3r+SVFNq520uWIQuWm1VnLLo/YvDApI7qhe32WS
        xil5ECHg==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDjNZ-007CkS-1a; Tue, 19 Jul 2022 09:18:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/10] md: stop using for_each_mddev in md_notify_reboot
Date:   Tue, 19 Jul 2022 11:18:21 +0200
Message-Id: <20220719091824.1064989-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220719091824.1064989-1-hch@lst.de>
References: <20220719091824.1064989-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Just do a simple list_for_each_entry_safe on all_mddevs, and only grab a
reference when we drop the lock.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bd87d59086947..ede817286cacd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9585,11 +9585,13 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
-	struct list_head *tmp;
-	struct mddev *mddev;
+	struct mddev *mddev, *n;
 	int need_delay = 0;
 
-	for_each_mddev(mddev, tmp) {
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry_safe(mddev, n, &all_mddevs, all_mddevs) {
+		mddev_get(mddev);
+		spin_unlock(&all_mddevs_lock);
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
 				__md_stop_writes(mddev);
@@ -9598,7 +9600,11 @@ static int md_notify_reboot(struct notifier_block *this,
 			mddev_unlock(mddev);
 		}
 		need_delay = 1;
+		mddev_put(mddev);
+		spin_lock(&all_mddevs_lock);
 	}
+	spin_unlock(&all_mddevs_lock);
+
 	/*
 	 * certain more exotic SCSI devices are known to be
 	 * volatile wrt too early system reboots. While the
-- 
2.30.2

