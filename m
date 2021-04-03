Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E7C7C433B4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 16:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398CC6124C
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 16:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhDCQPo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Apr 2021 12:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbhDCQPo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Apr 2021 12:15:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C55EC0613E6
        for <linux-raid@vger.kernel.org>; Sat,  3 Apr 2021 09:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lilAHvdrZ/GHnUOo34lDYzlLq0VBDpF++ySY8rjZikg=; b=mEdhlbdefIlMOx6nZWfaWRHjI0
        gPFIhhcwO3Ecoax5n92lvt4WoAmGCbO0hGxHqsQvvAtcHBWWTMUUwh4LmX2D7HHDhxVVgy3lf/ESw
        dDslyxTtRuIjNSW6pGuXsvCkRw40MI9pMmunih4JgTvpmzeRiL7PZ9p71V0CiCwCQFONuZeVYZkzc
        dM7WGnlfnpLBZDleyTdy0143lwlc4G7dB+Ig+bVHrDOX2/uIO1QVXFzuTZTYnRRJtyouVJX2UluDd
        oPnOIbaWIijyFJmzkR7oefhF8iUSDHh7GkI1qGfPhPZSfMKLfsgrlKLS1HJYcDX6bNhC8zIWwK4wT
        IGPqrAKQ==;
Received: from [2001:4bb8:180:7517:4144:afdd:43c5:e0fc] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSivu-000PJ4-Ts; Sat, 03 Apr 2021 16:15:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org, Zhao Heming <heming.zhao@suse.com>
Cc:     lidong.zhong@suse.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md: factor out a mddev_find_locked helper from mddev_find
Date:   Sat,  3 Apr 2021 18:15:28 +0200
Message-Id: <20210403161529.659555-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210403161529.659555-1-hch@lst.de>
References: <20210403161529.659555-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Factor out a self-contained helper to just lookup a mddev by the dev_t
"unit".

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 368cad6cd53a6e..5692427e78ba37 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -734,6 +734,17 @@ void mddev_init(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
+static struct mddev *mddev_find_locked(dev_t unit)
+{
+	struct mddev *mddev;
+
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs)
+		if (mddev->unit == unit)
+			return mddev;
+
+	return NULL;
+}
+
 static struct mddev *mddev_find(dev_t unit)
 {
 	struct mddev *mddev, *new = NULL;
@@ -745,13 +756,13 @@ static struct mddev *mddev_find(dev_t unit)
 	spin_lock(&all_mddevs_lock);
 
 	if (unit) {
-		list_for_each_entry(mddev, &all_mddevs, all_mddevs)
-			if (mddev->unit == unit) {
-				mddev_get(mddev);
-				spin_unlock(&all_mddevs_lock);
-				kfree(new);
-				return mddev;
-			}
+		mddev = mddev_find_locked(unit);
+		if (mddev) {
+			mddev_get(mddev);
+			spin_unlock(&all_mddevs_lock);
+			kfree(new);
+			return mddev;
+		}
 
 		if (new) {
 			list_add(&new->all_mddevs, &all_mddevs);
@@ -777,12 +788,7 @@ static struct mddev *mddev_find(dev_t unit)
 				return NULL;
 			}
 
-			is_free = 1;
-			list_for_each_entry(mddev, &all_mddevs, all_mddevs)
-				if (mddev->unit == dev) {
-					is_free = 0;
-					break;
-				}
+			is_free = !mddev_find_locked(dev);
 		}
 		new->unit = dev;
 		new->md_minor = MINOR(dev);
-- 
2.30.1

