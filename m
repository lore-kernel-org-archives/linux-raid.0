Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EC2C433ED
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598146121E
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 08:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbhDLIF7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 04:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbhDLIF6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 04:05:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46751C061574
        for <linux-raid@vger.kernel.org>; Mon, 12 Apr 2021 01:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=30z+awj04nelQwFHpVIynSHTFy8GFuYFIIefLyrqg0Y=; b=ebzXS4vxxSmosSk3ouIW0sUwKU
        dgj5Dat3Q1aS70tCEF4eBc3P4GxyMasGGVcKovRmzlywram9EOmUyZxoBIi7uJmfJhF+vf6GOsQyy
        Yr/N7gtWgejwUFlwNraj8FK6vdH1fpe2qr8D1kvuoLgYyr6v3K2MgYAUplOXNgteYW7MCthBKcI+V
        op79+dsiZKrCmPmPJE/rzoRr10H8wbLeX88nOrvB0ENHp5Wkt2u3PQ5BGhRAZ9ycc+fwKuikFO2/l
        8dNYhAWEJDn18ph5zipm8H+8VVmNNGQM5TAwPqXBhyuNjeHNiOYFCi73oa2ixW3GzcM7Ty9qu/FkI
        K4QFr1Zw==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVrZk-005xMo-HP; Mon, 12 Apr 2021 08:05:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/3] md: do not return existing mddevs from mddev_find_or_alloc
Date:   Mon, 12 Apr 2021 10:05:30 +0200
Message-Id: <20210412080530.2583868-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412080530.2583868-1-hch@lst.de>
References: <20210412080530.2583868-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Instead of returning an existing mddev, just for it to be discarded
later directly return -EEXIST.  Rename the function to mddev_alloc now
that it doesn't find an existing mddev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index de6f8e511c14e7..af9bdb907b2b47 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -782,26 +782,24 @@ static struct mddev *mddev_find(dev_t unit)
 	return mddev;
 }
 
-static struct mddev *mddev_find_or_alloc(dev_t unit)
+static struct mddev *mddev_alloc(dev_t unit)
 {
-	struct mddev *mddev = NULL, *new;
+	struct mddev *new;
+	int error;
 
 	if (unit && MAJOR(unit) != MD_MAJOR)
 		unit &= ~((1 << MdpMinorShift) - 1);
 
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	mddev_init(new);
 
 	spin_lock(&all_mddevs_lock);
 	if (unit) {
-		mddev = mddev_find_locked(unit);
-		if (mddev) {
-			mddev_get(mddev);
+		error = -EEXIST;
+		if (mddev_find_locked(unit))
 			goto out_free_new;
-		}
-
 		new->unit = unit;
 		if (MAJOR(unit) == MD_MAJOR)
 			new->md_minor = MINOR(unit);
@@ -809,6 +807,7 @@ static struct mddev *mddev_find_or_alloc(dev_t unit)
 			new->md_minor = MINOR(unit) >> MdpMinorShift;
 		new->hold_active = UNTIL_IOCTL;
 	} else {
+		error = -ENODEV;
 		new->unit = mddev_alloc_unit();
 		if (!new->unit)
 			goto out_free_new;
@@ -822,7 +821,7 @@ static struct mddev *mddev_find_or_alloc(dev_t unit)
 out_free_new:
 	spin_unlock(&all_mddevs_lock);
 	kfree(new);
-	return mddev;
+	return ERR_PTR(error);
 }
 
 static struct attribute_group md_redundancy_group;
@@ -5661,29 +5660,29 @@ static int md_alloc(dev_t dev, char *name)
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find_or_alloc(dev);
+	struct mddev *mddev;
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
 	int unit;
-	int error;
-
-	if (!mddev)
-		return -ENODEV;
+	int error ;
 
-	partitioned = (MAJOR(mddev->unit) != MD_MAJOR);
-	shift = partitioned ? MdpMinorShift : 0;
-	unit = MINOR(mddev->unit) >> shift;
-
-	/* wait for any previous instance of this device to be
-	 * completely removed (mddev_delayed_delete).
+	/*
+	 * Wait for any previous instance of this device to be completely
+	 * removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
 
 	mutex_lock(&disks_mutex);
-	error = -EEXIST;
-	if (mddev->gendisk)
-		goto abort;
+	mddev = mddev_alloc(dev);
+	if (IS_ERR(mddev)) {
+		mutex_unlock(&disks_mutex);
+		return PTR_ERR(mddev);
+	}
+
+	partitioned = (MAJOR(mddev->unit) != MD_MAJOR);
+	shift = partitioned ? MdpMinorShift : 0;
+	unit = MINOR(mddev->unit) >> shift;
 
 	if (name && !dev) {
 		/* Need to ensure that 'name' is not a duplicate.
@@ -5695,6 +5694,7 @@ static int md_alloc(dev_t dev, char *name)
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
+				error = -EEXIST;
 				goto abort;
 			}
 		spin_unlock(&all_mddevs_lock);
-- 
2.30.1

