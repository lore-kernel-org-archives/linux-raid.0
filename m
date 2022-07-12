Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F74C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 07:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiGLHEF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbiGLHDy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 03:03:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B349C286E5;
        Tue, 12 Jul 2022 00:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mzCSAg5B5OmRv/K/foUA71C+W0d66BglOtnfbSo+NRk=; b=eDVmxaHUCaFvOcMvpImrykZW2x
        feTodMSnpeNtEYvIF/I+2vPqShEmiOw9vG5AS+UAUlS/lfODYbdGT5xBKPtqn2qJi+NBkCVxTlxa/
        3nWr8ckgVCek4UClSCsyOA0MDrmQtmFurm2N6ysCdIIcgtAFS6SFaAhO80fTgTaUFq4SJdZC5JuRM
        NNccxR1dk9VBbLhWaXA7AGclJi4EENCvbaf5cHQeP2DJVPu5SYCYnC8AKCshJLKYR0zKbJvLPDZ0H
        Bkg5fPh95RHkDzk/GMVzpNbGZRXetSdlnrdPjKyn23v4c7Ce88ys/LAtXlxukC0C7MURfzsM6FKPM
        hyDJj5Pw==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB9vw-008DXo-75; Tue, 12 Jul 2022 07:03:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 5/8] md: stop using for_each_mddev in md_notify_reboot
Date:   Tue, 12 Jul 2022 09:03:28 +0200
Message-Id: <20220712070331.1390700-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712070331.1390700-1-hch@lst.de>
References: <20220712070331.1390700-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Just do a simple list_for_each_entry_safe on all_mddevs, and only grab a
reference when we drop the lock.

Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d22608dcb25fe..73abeaed0b6fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9547,11 +9547,13 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
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
@@ -9560,7 +9562,11 @@ static int md_notify_reboot(struct notifier_block *this,
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

