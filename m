Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9AAC43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiGRGe3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiGRGe1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:34:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077161659C;
        Sun, 17 Jul 2022 23:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3OnEHcX5sJqDDc+ex3UslwHYRE9IOkqFI+YDR+b217Y=; b=eG6QtKXXSb30e8R7+hfAYpw6ct
        vWeM+ebTB79ohd/wD9hTJqUi1P9rUl7z3/mJdZsRK6qerTCAps8T6Wg2ybnJWsYB9Zbk04dHXrBSs
        ki8mx0lqfbYfQpLjUQLwcN9C1EtbeK9c55QMI/97he1G1Z77IAEy1c9OFcY3qdomoVo3bdPUEu5k9
        PyNuUrurplMCVcwEvYPAV7zQHQJASjNyix6J3myBxmCQK3r1mEcMijlYr1ZshUe2WJAt7XfJpYXDP
        1X1fEdshDmPp+mMfd4sfxGSG7h/CEa9Jnnq4dBwSupRqLhXq+ZbZXuJUEjRzF+uvVsfKovb7ZjiMA
        qxm0m72g==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDKKl-00BEaA-Ko; Mon, 18 Jul 2022 06:34:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 03/10] md: implement ->free_disk
Date:   Mon, 18 Jul 2022 08:34:03 +0200
Message-Id: <20220718063410.338626-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718063410.338626-1-hch@lst.de>
References: <20220718063410.338626-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Ensure that all private data is only freed once all accesses are done.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 64c7c24d267bc..1e658d5060842 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5602,11 +5602,6 @@ static void md_free(struct kobject *ko)
 		del_gendisk(mddev->gendisk);
 		blk_cleanup_disk(mddev->gendisk);
 	}
-	percpu_ref_exit(&mddev->writes_pending);
-
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-	kfree(mddev);
 }
 
 static const struct sysfs_ops md_sysfs_ops = {
@@ -7876,6 +7871,17 @@ static unsigned int md_check_events(struct gendisk *disk, unsigned int clearing)
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
@@ -7889,6 +7895,7 @@ const struct block_device_operations md_fops =
 	.getgeo		= md_getgeo,
 	.check_events	= md_check_events,
 	.set_read_only	= md_set_read_only,
+	.free_disk	= md_free_disk,
 };
 
 static int md_thread(void *arg)
-- 
2.30.2

