Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1219BC43462
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C641761221
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhDLIFy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 04:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbhDLIFx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 04:05:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06203C061574
        for <linux-raid@vger.kernel.org>; Mon, 12 Apr 2021 01:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Gl2XV7oYqKlD4VLBXoVFJJOvRo/DGaOYQXpKkbjLpUU=; b=zxQO3Bfm0xVIav+4oH3u1p8GVF
        4+mZL7ENfxEA9KykyJOobC53AK5etfDuZIzoaHJ2ssii27nNyOkAINdJMsRwSeS0VVyGLhmrbXWoa
        5d6U7sZgv2qTtpats0Cs7yYh76uKGLesfBHpzHknEMgQ1vTG0qjBABfpWr5JIqPXMz8qlTn3q6ACs
        TKs5XFvl28aAmu7m/cotHqiINoixeQDm/+rBFaHhIelHPIie+lZp5xSzBYm4xS0JtavrEucnWUz00
        9KzCCU3fP8rz3JZb5wIK/bk3iQ45NQiUZwmE4ZmK7njmg00ed5UY+66N32M8zlG9oQLDBZc/hNRcj
        dopLBegQ==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVrZf-005xMV-9b; Mon, 12 Apr 2021 08:05:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] md: factor out a mddev_alloc_unit helper from mddev_find
Date:   Mon, 12 Apr 2021 10:05:28 +0200
Message-Id: <20210412080530.2583868-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412080530.2583868-1-hch@lst.de>
References: <20210412080530.2583868-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Split out a self contained helper to find a free minor for the md
"unit" number.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce5f4e0f43180..8ef06330fc66e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -745,6 +745,27 @@ static struct mddev *mddev_find_locked(dev_t unit)
 	return NULL;
 }
 
+/* find an unused unit number */
+static dev_t mddev_alloc_unit(void)
+{
+	static int next_minor = 512;
+	int start = next_minor;
+	bool is_free = 0;
+	dev_t dev = 0;
+
+	while (!is_free) {
+		dev = MKDEV(MD_MAJOR, next_minor);
+		next_minor++;
+		if (next_minor > MINORMASK)
+			next_minor = 0;
+		if (next_minor == start)
+			return 0;		/* Oh dear, all in use. */
+		is_free = !mddev_find_locked(dev);
+	}
+
+	return dev;
+}
+
 static struct mddev *mddev_find(dev_t unit)
 {
 	struct mddev *mddev;
@@ -787,27 +808,13 @@ static struct mddev *mddev_find_or_alloc(dev_t unit)
 			return new;
 		}
 	} else if (new) {
-		/* find an unused unit number */
-		static int next_minor = 512;
-		int start = next_minor;
-		int is_free = 0;
-		int dev = 0;
-		while (!is_free) {
-			dev = MKDEV(MD_MAJOR, next_minor);
-			next_minor++;
-			if (next_minor > MINORMASK)
-				next_minor = 0;
-			if (next_minor == start) {
-				/* Oh dear, all in use. */
-				spin_unlock(&all_mddevs_lock);
-				kfree(new);
-				return NULL;
-			}
-
-			is_free = !mddev_find_locked(dev);
+		new->unit = mddev_alloc_unit();
+		if (!new->unit) {
+			spin_unlock(&all_mddevs_lock);
+			kfree(new);
+			return NULL;
 		}
-		new->unit = dev;
-		new->md_minor = MINOR(dev);
+		new->md_minor = MINOR(new->unit);
 		new->hold_active = UNTIL_STOP;
 		list_add(&new->all_mddevs, &all_mddevs);
 		spin_unlock(&all_mddevs_lock);
-- 
2.30.1

