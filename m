Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCCFC43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 06:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiGRGeY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 02:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiGRGeW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 02:34:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C4116594;
        Sun, 17 Jul 2022 23:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cjwKi4HxCRombhdyRPiXy4DdKFfz9lw7rZgj0RAlg1Q=; b=dkN9DHYwgIihtlhMGZnY2kJFmn
        YFNypBsoJTakVM+ZEqqVzdH065PG3c4hhQVoVr2GFkR94uvOyuxCgLW8kHHCg+IY+fnEssqJ6w3/H
        i0GAifsor5cDw2IXMdHhBxG/42ZvZR6B+BmR//MyYiDJ+0kXxBcKILNQD0wGBchHDiaVEiANWjA67
        CYIY4IeZ2Zz77hyM0CMtmf64EUil1cdHEdx4OXcTXZjrCdqd9sYCbSO8PZg3piUK3b6cfp7IoS7Mj
        ZXgaHmMHe73rgxlLi1/YqNNlcvD0shNI988EsLLR2cMx2br5ZSUTRCU5/YbYdYZgPYX4Qk710ViqP
        yFQD8wEA==;
Received: from 089144198117.atnat0007.highway.a1.net ([89.144.198.117] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDKKh-00BEYh-4v; Mon, 18 Jul 2022 06:34:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [PATCH 02/10] md: fix error handling in md_alloc
Date:   Mon, 18 Jul 2022 08:34:02 +0200
Message-Id: <20220718063410.338626-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718063410.338626-1-hch@lst.de>
References: <20220718063410.338626-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Error handling in md_alloc is a mess.  Untangle it to just free the mddev
directly before add_disk is called and thus the gendisk is globally
visible.  After that clear the hold flag and let the mddev_put take care
of cleaning up the mddev through the usual mechanisms.

Fixes: 5e55e2f5fc95 ("[PATCH] md: convert compile time warnings into runtime warnings")
Fixes: 9be68dd7ac0e ("md: add error handling support for add_disk()")
Fixes: 7ad1069166c0 ("md: properly unwind when failing to add the kobject in md_alloc")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a49ddc9454ff6..64c7c24d267bc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -790,6 +790,15 @@ static struct mddev *mddev_alloc(dev_t unit)
 	return ERR_PTR(error);
 }
 
+static void mddev_free(struct mddev *mddev)
+{
+	spin_lock(&all_mddevs_lock);
+	list_del(&mddev->all_mddevs);
+	spin_unlock(&all_mddevs_lock);
+
+	kfree(mddev);
+}
+
 static const struct attribute_group md_redundancy_group;
 
 void mddev_unlock(struct mddev *mddev)
@@ -5662,8 +5671,8 @@ int md_alloc(dev_t dev, char *name)
 	mutex_lock(&disks_mutex);
 	mddev = mddev_alloc(dev);
 	if (IS_ERR(mddev)) {
-		mutex_unlock(&disks_mutex);
-		return PTR_ERR(mddev);
+		error = PTR_ERR(mddev);
+		goto out_unlock;
 	}
 
 	partitioned = (MAJOR(mddev->unit) != MD_MAJOR);
@@ -5681,7 +5690,7 @@ int md_alloc(dev_t dev, char *name)
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
 				error = -EEXIST;
-				goto out_unlock_disks_mutex;
+				goto out_free_mddev;
 			}
 		spin_unlock(&all_mddevs_lock);
 	}
@@ -5694,7 +5703,7 @@ int md_alloc(dev_t dev, char *name)
 	error = -ENOMEM;
 	disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)
-		goto out_unlock_disks_mutex;
+		goto out_free_mddev;
 
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
@@ -5715,26 +5724,36 @@ int md_alloc(dev_t dev, char *name)
 	mddev->gendisk = disk;
 	error = add_disk(disk);
 	if (error)
-		goto out_cleanup_disk;
+		goto out_put_disk;
 
 	kobject_init(&mddev->kobj, &md_ktype);
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
-	if (error)
-		goto out_del_gendisk;
+	if (error) {
+		/*
+		 * The disk is already live at this point.  Clear the hold flag
+		 * and let mddev_put take care of the deletion, as it isn't any
+		 * different from a normal close on last release now.
+		 */
+		mddev->hold_active = 0;
+		goto done;
+	}
 
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
-	goto out_unlock_disks_mutex;
 
-out_del_gendisk:
-	del_gendisk(disk);
-out_cleanup_disk:
-	blk_cleanup_disk(disk);
-out_unlock_disks_mutex:
+done:
 	mutex_unlock(&disks_mutex);
 	mddev_put(mddev);
 	return error;
+
+out_put_disk:
+	put_disk(disk);
+out_free_mddev:
+	mddev_free(mddev);
+out_unlock:
+	mutex_unlock(&disks_mutex);
+	return error;
 }
 
 static void md_probe(dev_t dev)
-- 
2.30.2

