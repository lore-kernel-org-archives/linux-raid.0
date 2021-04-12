Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791D9C43460
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54DA56103D
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237175AbhDLIF5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 04:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhDLIF4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 04:05:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1866C061574
        for <linux-raid@vger.kernel.org>; Mon, 12 Apr 2021 01:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OzVd5ikNPzAzKIw4danrwfHuzdleA2QgNA0zLwkIcgU=; b=XnbcCTWL3V7S+PcE3xvueEbpwp
        MhqVCirvD7WtsnDDUQozMpi6E6IVgwRbiy9cl4dXAZFhrs7/iDGneZ34MBtFoAPj5AAfECUvhX6Ii
        BPLi5yAjEtcdX/Lmr8i6C9herCk+FHOAisd2VAWkJLKZTrDUFtSyJLEM+FSvFSwkjVOQq3iKjOanx
        viyP7wqhqM9nvUl8b05a48wjx9CnGfLbjpPc3Pv+TgCPpBBeCjWwy/jJku4Q120LjLvxzi/ABPHzT
        8Ze6z0p9tQQfHGNOnS73M8ARmG0fghLpEIR2dv0Z67H2Oys3GnA82nEB/SDa44o2Iu+EhN4ry8Of9
        OSKgSnJw==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVrZh-005xMa-Tv; Mon, 12 Apr 2021 08:05:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3] md: refactor mddev_find_or_alloc
Date:   Mon, 12 Apr 2021 10:05:29 +0200
Message-Id: <20210412080530.2583868-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412080530.2583868-1-hch@lst.de>
References: <20210412080530.2583868-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Allocate the new mddev first speculatively, which greatly simplifies
the code flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 60 ++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 36 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8ef06330fc66e4..de6f8e511c14e7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -784,57 +784,45 @@ static struct mddev *mddev_find(dev_t unit)
 
 static struct mddev *mddev_find_or_alloc(dev_t unit)
 {
-	struct mddev *mddev, *new = NULL;
+	struct mddev *mddev = NULL, *new;
 
 	if (unit && MAJOR(unit) != MD_MAJOR)
-		unit &= ~((1<<MdpMinorShift)-1);
+		unit &= ~((1 << MdpMinorShift) - 1);
 
- retry:
-	spin_lock(&all_mddevs_lock);
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return NULL;
+	mddev_init(new);
 
+	spin_lock(&all_mddevs_lock);
 	if (unit) {
 		mddev = mddev_find_locked(unit);
 		if (mddev) {
 			mddev_get(mddev);
-			spin_unlock(&all_mddevs_lock);
-			kfree(new);
-			return mddev;
+			goto out_free_new;
 		}
 
-		if (new) {
-			list_add(&new->all_mddevs, &all_mddevs);
-			spin_unlock(&all_mddevs_lock);
-			new->hold_active = UNTIL_IOCTL;
-			return new;
-		}
-	} else if (new) {
+		new->unit = unit;
+		if (MAJOR(unit) == MD_MAJOR)
+			new->md_minor = MINOR(unit);
+		else
+			new->md_minor = MINOR(unit) >> MdpMinorShift;
+		new->hold_active = UNTIL_IOCTL;
+	} else {
 		new->unit = mddev_alloc_unit();
-		if (!new->unit) {
-			spin_unlock(&all_mddevs_lock);
-			kfree(new);
-			return NULL;
-		}
+		if (!new->unit)
+			goto out_free_new;
 		new->md_minor = MINOR(new->unit);
 		new->hold_active = UNTIL_STOP;
-		list_add(&new->all_mddevs, &all_mddevs);
-		spin_unlock(&all_mddevs_lock);
-		return new;
 	}
-	spin_unlock(&all_mddevs_lock);
-
-	new = kzalloc(sizeof(*new), GFP_KERNEL);
-	if (!new)
-		return NULL;
 
-	new->unit = unit;
-	if (MAJOR(unit) == MD_MAJOR)
-		new->md_minor = MINOR(unit);
-	else
-		new->md_minor = MINOR(unit) >> MdpMinorShift;
-
-	mddev_init(new);
-
-	goto retry;
+	list_add(&new->all_mddevs, &all_mddevs);
+	spin_unlock(&all_mddevs_lock);
+	return new;
+out_free_new:
+	spin_unlock(&all_mddevs_lock);
+	kfree(new);
+	return mddev;
 }
 
 static struct attribute_group md_redundancy_group;
-- 
2.30.1

