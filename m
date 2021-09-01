Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8009DC432BE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D30060F6C
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243870AbhIALlH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 07:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243350AbhIALlG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Sep 2021 07:41:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DFBC061575
        for <linux-raid@vger.kernel.org>; Wed,  1 Sep 2021 04:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0oaKLMJBA7OZ0Mv8Tu4EWEBL0wo7jvKspGWY5kPFkqM=; b=UekCfTiUmO/y6a2VNnSITkx5eL
        J+WtjbTXLcyJ2Sk7525ZHNjgRu6jPFQ2wItQ3G4LdkHWJ2EIAjUe/mg2xdsaINaOJNSa8XeA/Yacl
        v48xyCjiDuML7dEQzOnYdL+KtOAL4CKDPmzGEsxk9LUTWTMoMIyzqbGZgUSRpL8HnZybeeAHDRUj6
        qAKc12Ys9fNuZ7f9ewM5smrmg1/SA4JVAYLKSOcsVLpMexYBrA4ga71Ow8fLeX1OoRO//BL1UBD0O
        sTpSc522KGFc5OwcSOs0Uw/YulRWkonZ25TuD9WioC+lo6PceaK44PzfIuKttfZuhOq9o4zUFfpLG
        oB+WcjyA==;
Received: from [2001:4bb8:180:a30:2deb:705a:5588:bf7d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLOaC-002FTn-FX; Wed, 01 Sep 2021 11:39:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-raid@vger.kernel.org,
        syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com
Subject: [PATCH 1/5] md: fix a lock order reversal in md_alloc
Date:   Wed,  1 Sep 2021 13:38:29 +0200
Message-Id: <20210901113833.1334886-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901113833.1334886-1-hch@lst.de>
References: <20210901113833.1334886-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Commit b0140891a8cea3 ("md: Fix race when creating a new md device.")
not only moved assigning mddev->gendisk before calling add_disk, which
fixes the races described in the commit log, but also added a
mddev->open_mutex critical section over add_disk and creation of the
md kobj.  Adding a kobject after add_disk is racy vs deleting the gendisk
right after adding it, but md already prevents against that by holding
a mddev->active reference.

On the other hand taking this lock added a lock order reversal with what
is not disk->open_mutex (used to be bdev->bd_mutex when the commit was
added) for partition devices, which need that lock for the internal open
for the partition scan, and a recent commit also takes it for
non-partitioned devices, leading to further lockdep splatter.

Fixes: b0140891a8ce ("md: Fix race when creating a new md device.")
Fixes: d62633873590 ("block: support delayed holder registration")
Reported-by: syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: syzbot+fadc0aaf497e6a493b9f@syzkaller.appspotmail.com
---
 drivers/md/md.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ae8fe54ea3581..6c0c3d0d905aa 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5700,10 +5700,6 @@ static int md_alloc(dev_t dev, char *name)
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
-	/* As soon as we call add_disk(), another thread could get
-	 * through to md_open, so make sure it doesn't get too far
-	 */
-	mutex_lock(&mddev->open_mutex);
 	add_disk(disk);
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
@@ -5718,7 +5714,6 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		pr_debug("pointless warning\n");
-	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
-- 
2.30.2

