Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07653CCA479
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiGRGee (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiGRGe3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:34:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BA5165A1;
        Sun, 17 Jul 2022 23:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H74GEgv/ge8LnR247JATLdk2+7g+tUk3O1dDfM/q9o4=; b=HmKyLqlWLyCTeBgIhoB2toz0X/
        pxfGBlQ9sv54FI0FQh8OW7tMEXCPVYTx2+whiTdpL06lhm0BBiIdoRLHvmI4KjV9/r6lMZcTnMXNB
        JIoJzxifrqwVO5HhoVj6BPBqN/740qEqDFt0eYyO8T6FUHqrpdXLDFTdctjQWPFcW/dZpUNPNId2g
        3CBd61De2pvmg/QTzdg2IkiCLj0czH460FE25ARZ8MQDqfsIYT9agNueYA2wnATjFkvHLM3f1qd+i
        ed4ej3+jjoJd/KqIujTn1pi7YWAE58J4M+grwFop1Iy0DP9Uo2Al/4Y0AHnuiAMrpIi4+aecEq5Fl
        yf3bORfw==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDKKo-00BEbO-Va; Mon, 18 Jul 2022 06:34:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 04/10] md: rename md_free to md_kobj_release
Date:   Mon, 18 Jul 2022 08:34:04 +0200
Message-Id: <20220718063410.338626-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718063410.338626-1-hch@lst.de>
References: <20220718063410.338626-1-hch@lst.de>
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
index 1e658d5060842..96b4e901ff6b5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5589,7 +5589,7 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	return rv;
 }
 
-static void md_free(struct kobject *ko)
+static void md_kobj_release(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
@@ -5609,7 +5609,7 @@ static const struct sysfs_ops md_sysfs_ops = {
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

