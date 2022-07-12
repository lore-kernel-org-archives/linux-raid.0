Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C25C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 07:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiGLHDp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 03:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiGLHDk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 03:03:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064CC13F69;
        Tue, 12 Jul 2022 00:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Y14NJeDF6CQlqUBjPJyx5SA2wcq9gTkLyPra7r2mhxw=; b=ho3Rn4HlQrev6/LuFhpRD4JbXV
        VBEWq/KjAzT+jVLD04pVJtRy2hXSV3Fq7ybxl68o3wd7l9GcBKE1PgjNQKdc4q0SjKJq8MEBjyeaB
        s0wnGOlnDeUkLw+zVbX/9TtkX995xfgoY3pcYBXX8SoUfaZ2GnNOUN3xOq2wUCPEfQhLvR9QoWTJ6
        oPKTc9n6sZYwf11M5YolJyu78e20yeQWkRPb7XCeWq8H31OrqzCsAg/fFElaBjyBjUo1fJ0PbspAn
        EF0RsmCofPS4WmzH50oAW/opmnn/I6XzwQx70XZr80rpQVSazpSoxyM+eZCaEHwuXiXGPQVB1U9bS
        znpENsng==;
Received: from ip4d15c27d.dynamic.kabel-deutschland.de ([77.21.194.125] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB9vl-008DSN-Ez; Tue, 12 Jul 2022 07:03:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 1/8] md: fix kobject_add error handling
Date:   Tue, 12 Jul 2022 09:03:24 +0200
Message-Id: <20220712070331.1390700-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712070331.1390700-1-hch@lst.de>
References: <20220712070331.1390700-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Always use the deferred kobject_put from mddev_put to clean up a mddev.
To make sure that happens properly clear the hold_active on error,
and clear the ->gendisk field and put the disk manually when ->add_disk
fails to avoid a double free.

Fixes: 5e55e2f5fc95 ("[PATCH] md: convert compile time warnings into runtime warnings")
Fixes: 9be68dd7ac0e ("md: add error handling support for add_disk()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 076255ec9ba18..861d6a9481b2e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5703,23 +5703,23 @@ static int md_alloc(dev_t dev, char *name)
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	error = add_disk(disk);
-	if (error)
-		goto out_cleanup_disk;
+	if (error) {
+		mddev->gendisk = NULL;
+		put_disk(disk);
+		goto out_unlock_disks_mutex;
+	}
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error)
-		goto out_del_gendisk;
+		goto out_unlock_disks_mutex;
 
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
-	goto out_unlock_disks_mutex;
 
-out_del_gendisk:
-	del_gendisk(disk);
-out_cleanup_disk:
-	put_disk(disk);
 out_unlock_disks_mutex:
+	if (error)
+		mddev->hold_active = 0;
 	mutex_unlock(&disks_mutex);
 	mddev_put(mddev);
 	return error;
-- 
2.30.2

