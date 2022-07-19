Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4726EC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbiGSJTe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbiGSJTE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:19:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91F83ED71;
        Tue, 19 Jul 2022 02:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nocwjO7i6WbSVuCRD6Yk/f+vI2scsvU3SxIBow/AUAg=; b=FJ1Mw/Zz4pcoHaj2siO5WOB8qj
        cxu0TKmt0GoUaJAMHyT4NtoTfyIuv1ApxNFS0CZLUHDQ5rfppR/JLQY/dNdFd5zOTlJXGFc4loFEQ
        jGsiSyXavV86uZPPb0LPSsvr0pbFt4KHnqCuaaUW6JZBXeOMPQpan2yq6Mmysy1I3VY8EjOPquj8g
        pKuFR/0I4v3K5GS4uODkNZgcC2X3fK9+Ap/uQxJHIsj6FRMbuzA0rjz1Pp0aHrzlK2OlwLCYrBDAj
        jcpHfbaI9BA1u3BQrgT857ATgg90k+Bt1bJ8p2i/qKkm2MK1Jpb1vQp2k/kAtjHhSKpo01W7YpWdB
        aaJ9HnFQ==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDjNH-007CJK-Ua; Tue, 19 Jul 2022 09:18:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/10] md: implement ->free_disk
Date:   Tue, 19 Jul 2022 11:18:17 +0200
Message-Id: <20220719091824.1064989-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220719091824.1064989-1-hch@lst.de>
References: <20220719091824.1064989-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Ensure that all private data is only freed once all accesses are done.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f1c4f8ccb939d..2ed4a303642a2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5600,12 +5600,6 @@ static void md_free(struct kobject *ko)
 
 	del_gendisk(mddev->gendisk);
 	blk_cleanup_disk(mddev->gendisk);
-
-	percpu_ref_exit(&mddev->writes_pending);
-
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-	kfree(mddev);
 }
 
 static const struct sysfs_ops md_sysfs_ops = {
@@ -7875,6 +7869,17 @@ static unsigned int md_check_events(struct gendisk *disk, unsigned int clearing)
 	return ret;
 }
 
+static void md_free_disk(struct gendisk *disk)
+{
+	struct mddev *mddev = disk->private_data;
+
+	percpu_ref_exit(&mddev->writes_pending);
+	bioset_exit(&mddev->bio_set);
+	bioset_exit(&mddev->sync_set);
+
+	kfree(mddev);
+}
+
 const struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -7888,6 +7893,7 @@ const struct block_device_operations md_fops =
 	.getgeo		= md_getgeo,
 	.check_events	= md_check_events,
 	.set_read_only	= md_set_read_only,
+	.free_disk	= md_free_disk,
 };
 
 static int md_thread(void *arg)
-- 
2.30.2

