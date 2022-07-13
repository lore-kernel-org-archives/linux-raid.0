Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789CACCA479
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 11:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbiGMLbk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 07:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbiGMLbh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 07:31:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B9E102720;
        Wed, 13 Jul 2022 04:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=rbTZo0mQNN/DNA+MsAJn+JMvWsFE/h02GkL+IF+Hh2k=; b=RjQOKwF+wZEtJ3nUlfE4BNIHuL
        nHdA4iNnlJBxGRc56cMgr2q0rCxmgW7hveYwGyrYrK+dJeopquXvJQCSSAFG/0xuBLft+VuJxqM/N
        u145eYUKU7btkzyaIHI+Mq/GkS0EdDKbiBgg8KnpbDUrrzLpal3A2yg6EcDGX++wZySRPASrJPxAJ
        zOErHIq0kq4VgHBAGZx3USIkhiXQjRjvPLHDzmR4j/KMmVm+JsM/Ai5JoR6i4LxuXlwdfZ/JxG/O9
        8/yur7spq4sx2iY1gHY8QtgKCl/THWrf5XMT7EUxrfmcfSJ8M12mnV8382Twt+dPIaEeVlEWKnsrE
        1W2L6oIQ==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBaad-003A2V-2o; Wed, 13 Jul 2022 11:31:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 3/9] md: rename md_free to md_kobj_release
Date:   Wed, 13 Jul 2022 13:31:19 +0200
Message-Id: <20220713113125.2232975-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713113125.2232975-1-hch@lst.de>
References: <20220713113125.2232975-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The md_free name is rather misleading, so pick a better one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2beaadd202c4e..3127dcb8102ce 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5590,7 +5590,7 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	return rv;
 }
 
-static void md_free(struct kobject *ko)
+static void md_kobj_release(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
@@ -5610,7 +5610,7 @@ static const struct sysfs_ops md_sysfs_ops = {
 	.store	= md_attr_store,
 };
 static struct kobj_type md_ktype = {
-	.release	= md_free,
+	.release	= md_kobj_release,
 	.sysfs_ops	= &md_sysfs_ops,
 	.default_groups	= md_attr_groups,
 };
-- 
2.30.2

