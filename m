Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94A1C43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbiGSJTp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiGSJTG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:19:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0574D20BED;
        Tue, 19 Jul 2022 02:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dDio3M6WZynlI3D8LqbZP0zRRde4k/um6zzVs7sbfp0=; b=FeX18HQeOoTsGe9aULlJe+4rJr
        HI61QYSTm1T7gN0ZYbc8H+FeYwFDkh2DijD5R9bZSFVSijMZ4i/t0qwLHHShSteCMGwgNHP4Jm+ZA
        s5811G5b/J9XaISziwzON+tsgibPH1nKym4wsT8b1QFq85vzAm/7bQ5oQ/Qc1N/D4wguaBOHte/lq
        3eBDnFZSGBltUQW3NxNw7JKFkCydCC1lEOYATDK49iM8QHs7JmLWW1F/nPelUjDxqOMtmRE09VEgi
        YbS21xR8QIT3FBhOzA5MItL8nQQkhiu+FxW5c+lQcTPTGMi3MmGBcvwq5xyAwPuBaD83cXUSfT6HM
        N/KznlOw==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDjNM-007COO-4m; Tue, 19 Jul 2022 09:18:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/10] md: rename md_free to md_kobj_release
Date:   Tue, 19 Jul 2022 11:18:18 +0200
Message-Id: <20220719091824.1064989-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220719091824.1064989-1-hch@lst.de>
References: <20220719091824.1064989-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The md_free name is rather misleading, so pick a better one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2ed4a303642a2..bbb3157450670 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5589,7 +5589,7 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	return rv;
 }
 
-static void md_free(struct kobject *ko)
+static void md_kobj_release(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
@@ -5607,7 +5607,7 @@ static const struct sysfs_ops md_sysfs_ops = {
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

