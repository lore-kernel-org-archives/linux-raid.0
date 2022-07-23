Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C1EC43334
	for <linux-raid@archiver.kernel.org>; Sat, 23 Jul 2022 06:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbiGWGZQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Jul 2022 02:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiGWGZP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Jul 2022 02:25:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B73DFC6
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 23:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=o6u0o8mMlWsBfjWv6bhtjRoNtWPCcDpE2/eddkVWt2Y=; b=OJbsoC8Nqfx3VtT4lnDUzCVtcK
        Ki2T1i557nQSrcxyenrOwrIX1KRxoGAHSBaNYmf70QWX2gkaXvjS9QQQEUZz9EMq7WfhmWP+XQFM9
        IK/49B5JJ7yAAr8ERfenFf/5aDBCCB/LxgX2RL+FJEdLfAsgApCHxctoJXjqd/YQq6GLdugwwZzzb
        EWJVJ08SuY9ynedUB3PCk95sRlxGRfJ/jioXY86cT95KnH/l94oGIczhyCK6GwoAjPeZyz3bVuL8J
        k3aO1uLtP8mG7lUiaj98eUR3oFDcKh4cYQtG7Uz1g/VO4JTZ/h3XoGEJBvomMiuSyQbdmaNEFlNsk
        Zp2EzWwQ==;
Received: from [2001:4bb8:199:fe1f:951f:1322:520f:5e75] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oF8Ze-00GKaX-7f; Sat, 23 Jul 2022 06:25:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH] md: remove a superfluous semicolon
Date:   Sat, 23 Jul 2022 08:25:12 +0200
Message-Id: <20220723062512.2210253-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

No use for a semicolon at the end of a loop block.

Reporte-by:  kernel test robot <lkp@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 673a39042208c..2b2267be5c329 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8205,7 +8205,7 @@ static void *md_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 			break;
 		mddev = next_mddev;
 		tmp = mddev->all_mddevs.next;
-	};
+	}
 	spin_unlock(&all_mddevs_lock);
 
 	if (to_put)
-- 
2.30.2

