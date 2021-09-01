Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FB0C432BE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E656108E
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbhIALpY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 07:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241703AbhIALpX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Sep 2021 07:45:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CB7C061575
        for <linux-raid@vger.kernel.org>; Wed,  1 Sep 2021 04:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=f0wKQ4Hfkr+1nzBiJhSprtOMQAuWfI6dwDBdIKoqMC4=; b=IEZaGqwoDqIIo0pwmmQzZ3O2EU
        YliFuRTKFAJI1GFxK01xWbxDr04gAstHsYmkz3Jv6Rgc+RFwhIdMSijV4Ho4S2ZaJawuGQ6QE9VUA
        EQaqnLsrG8yZLVQgW0Oqs5cxMQgUxsGC8qzF9Ij50y26b06L8dYXfLaA76VZ+zlc2cExr2aTGQbpX
        Cn6lSlrkA2JG0tm8BKk9LVoHWX1O77JSuvEcjRfJTatwx5iPmuF6hHnww37whSziLkP7kydXUCcCT
        ShsE3tTZw+gGQWkmtYrycKPhtFMXxTcZQ6FFqOhVCSDg48MgLhgqASjgmBDwYBgm5Zy2wicZqTtZA
        KFaus3hA==;
Received: from [2001:4bb8:180:a30:2deb:705a:5588:bf7d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLOeM-002FoU-W0; Wed, 01 Sep 2021 11:43:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH 5/5] md: properly unwind when failing to add the kobject in md_alloc
Date:   Wed,  1 Sep 2021 13:38:33 +0200
Message-Id: <20210901113833.1334886-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901113833.1334886-1-hch@lst.de>
References: <20210901113833.1334886-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Add proper error handling to delete the gendisk when failing to add
the md kobject and clean up the error unwinding in general.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b90dbf7cc2455..c322841d4edc3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5672,7 +5672,7 @@ static int md_alloc(dev_t dev, char *name)
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
 				error = -EEXIST;
-				goto abort;
+				goto out_unlock_disks_mutex;
 			}
 		spin_unlock(&all_mddevs_lock);
 	}
@@ -5685,7 +5685,7 @@ static int md_alloc(dev_t dev, char *name)
 	error = -ENOMEM;
 	disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)
-		goto abort;
+		goto out_unlock_disks_mutex;
 
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
@@ -5710,26 +5710,23 @@ static int md_alloc(dev_t dev, char *name)
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	error = add_disk(disk);
-	if (error) {
-		blk_cleanup_disk(disk);
-		goto abort;
-	}
+	if (error)
+		goto out_cleanup_disk;
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
-	if (error) {
-		/* This isn't possible, but as kobject_init_and_add is marked
-		 * __must_check, we must do something with the result
-		 */
-		pr_debug("md: cannot register %s/md - name in use\n",
-			 disk->disk_name);
-		error = 0;
-	}
- abort:
-	if (!error && mddev->kobj.sd) {
-		kobject_uevent(&mddev->kobj, KOBJ_ADD);
-		mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
-		mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
-	}
+	if (error)
+		goto out_del_gendisk;
+
+	kobject_uevent(&mddev->kobj, KOBJ_ADD);
+	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
+	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
+	goto out_unlock_disks_mutex;
+
+out_del_gendisk:
+	del_gendisk(disk);
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
+out_unlock_disks_mutex:
 	mutex_unlock(&disks_mutex);
 	mddev_put(mddev);
 	return error;
-- 
2.30.2

