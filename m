Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4546C432BE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB95B61057
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243900AbhIALnH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 07:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243793AbhIALnH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Sep 2021 07:43:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB36C061575
        for <linux-raid@vger.kernel.org>; Wed,  1 Sep 2021 04:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NlQ/5QNQwKtRKzhBC7Qr8aZuIkXWNxfzBMtBHCRkAAw=; b=Nao1l0RYyldyXI3ikDDoOUPDGS
        di0Ro7GcbtxtLk1q9ywrJ2Oam26XnzYFCoFj4QBqDsEKT7eQcBP9xI8X7AZPs1uSV1DIYgetZ4xGe
        40TJumgCTRGHRVXZLxPRp1oDMYNCm5vY3IFuLBzvuC6r5W0irr6QaLn3P2zTRL03pqIjsjb2x4wuC
        mCWS6iNFz7rXAj381TmaATCIhGeTvP/IW7bOMlbnYdh7YOTG1eN2hAFUgMIBZE8iMfx8lWl2H3MDt
        r0ayh0v6zPw7ROpdLY0vjuGZ+dX2IqGPGS5Xh3UTmy2rYlJ0HYOFWaUFwavFZJSMoU0tqeCoVRJbU
        qfchfLAw==;
Received: from [2001:4bb8:180:a30:2deb:705a:5588:bf7d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLOcC-002FdO-88; Wed, 01 Sep 2021 11:41:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH 3/5] md: add the bitmap group to the default groups for the md kobject
Date:   Wed,  1 Sep 2021 13:38:31 +0200
Message-Id: <20210901113833.1334886-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901113833.1334886-1-hch@lst.de>
References: <20210901113833.1334886-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Replace the deprecated default_attrs with the default_groups mechanism,
and add the always visible bitmap group to the groups created add
kobject_add time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6bd5ad3c30b41..2971dae388ef2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5490,6 +5490,10 @@ static struct attribute *md_default_attrs[] = {
 	NULL,
 };
 
+static const struct attribute_group md_default_group = {
+	.attrs = md_default_attrs,
+};
+
 static struct attribute *md_redundancy_attrs[] = {
 	&md_scan_mode.attr,
 	&md_last_scan_mode.attr,
@@ -5512,6 +5516,12 @@ static const struct attribute_group md_redundancy_group = {
 	.attrs = md_redundancy_attrs,
 };
 
+static const struct attribute_group *md_attr_groups[] = {
+	&md_default_group,
+	&md_bitmap_group,
+	NULL,
+};
+
 static ssize_t
 md_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 {
@@ -5587,7 +5597,7 @@ static const struct sysfs_ops md_sysfs_ops = {
 static struct kobj_type md_ktype = {
 	.release	= md_free,
 	.sysfs_ops	= &md_sysfs_ops,
-	.default_attrs	= md_default_attrs,
+	.default_groups	= md_attr_groups,
 };
 
 int mdp_major = 0;
@@ -5596,7 +5606,6 @@ static void mddev_delayed_delete(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, del_work);
 
-	sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
 	kobject_del(&mddev->kobj);
 	kobject_put(&mddev->kobj);
 }
@@ -5715,9 +5724,6 @@ static int md_alloc(dev_t dev, char *name)
 			 disk->disk_name);
 		error = 0;
 	}
-	if (mddev->kobj.sd &&
-	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
-		pr_debug("pointless warning\n");
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
-- 
2.30.2

