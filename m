Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94C9C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbiGRGen (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiGRGej (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:34:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC62165A9;
        Sun, 17 Jul 2022 23:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mogEPJ1AFupYejtyXfVTGuEvwvoN7uEarrVCXIkkvR4=; b=XJKP+tbMjBqJAA4yaLMMIop4cD
        BPxoWFjZYoWRghNpTVPHHNmn+bZHjhoFCRQmkeOXkF0inZ1c9ouDPYMg3qSxZ6g57AlQEPCS19ppg
        CUotUYRKcblnLmSi8LkpOczxpzJ4Wi1pKPbGqyIbzkUYEsIRtaCE36ODLwFD2VylfihLXpkFDqT9S
        ukIxaK7klkrnyCT9asv+eB1S17o+zIz6095nwrMVShb3U/eXjKLaBedtUG5xsy0OpK79Qx+jgn//U
        0Ya146pU93lUxIEFW99no9rYipnjYP6/FU+dUWPTnd9qJlZRGyXZVqFyqChRNaZEEA+0ErEt3UZ4e
        +S5l6Uog==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDKKy-00BEel-B8; Mon, 18 Jul 2022 06:34:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 07/10] md: stop using for_each_mddev in md_notify_reboot
Date:   Mon, 18 Jul 2022 08:34:07 +0200
Message-Id: <20220718063410.338626-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718063410.338626-1-hch@lst.de>
References: <20220718063410.338626-1-hch@lst.de>
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
index 687f320c7ec4a..44e4071b43148 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9587,11 +9587,13 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
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
@@ -9600,7 +9602,11 @@ static int md_notify_reboot(struct notifier_block *this,
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

