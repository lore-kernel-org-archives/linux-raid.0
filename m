Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FA8C43334
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 07:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbiGLHDr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbiGLHDn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 03:03:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8835FC4;
        Tue, 12 Jul 2022 00:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HqJd/2x5sjcj/LdazTSU5TghyM7h4+2d06ouXMkXsLk=; b=fxKBPjNj9wcQv0gWVoCzbD3Hx+
        VTqPUXdiF/rtlZuYF8UK25jplX56j3FrXp3dNyY7DzBzYN5Ldk0UkNlIv81yZYaY3DjVPe9A6AdKj
        dhi94jo9PV6Uf4pEDopkXrmjSGIBNNqyuwof7H4e+lmsexEMtjyivWSNp471mNoTIUMSBEfz7DQ4v
        zjGehI7+ruuYIrQqflZX/4XBI4IqDBex0nAQtC2Rz0+TWeuypYV7mJmTCfGsF8UXPlD4y0OEKdquj
        EHNz0WTXs6wyxzOIWmiMSPyqhUOZR9LQcBwI7h1j22qNThS92uMguXdTb4AltEP6AwZ7z0dtcM8Wl
        wdLcRhvg==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB9vo-008DTe-9j; Tue, 12 Jul 2022 07:03:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 2/8] md: implement ->free_disk
Date:   Tue, 12 Jul 2022 09:03:25 +0200
Message-Id: <20220712070331.1390700-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712070331.1390700-1-hch@lst.de>
References: <20220712070331.1390700-1-hch@lst.de>
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
index 861d6a9481b2e..ae076a7a87796 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5581,11 +5581,6 @@ static void md_free(struct kobject *ko)
 		del_gendisk(mddev->gendisk);
 		put_disk(mddev->gendisk);
 	}
-	percpu_ref_exit(&mddev->writes_pending);
-
-	bioset_exit(&mddev->bio_set);
-	bioset_exit(&mddev->sync_set);
-	kfree(mddev);
 }
 
 static const struct sysfs_ops md_sysfs_ops = {
@@ -7844,6 +7839,17 @@ static unsigned int md_check_events(struct gendisk *disk, unsigned int clearing)
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
@@ -7857,6 +7863,7 @@ const struct block_device_operations md_fops =
 	.getgeo		= md_getgeo,
 	.check_events	= md_check_events,
 	.set_read_only	= md_set_read_only,
+	.free_disk	= md_free_disk,
 };
 
 static int md_thread(void *arg)
-- 
2.30.2

