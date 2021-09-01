Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129ADC432BE
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E718E61090
	for <linux-raid@archiver.kernel.org>; Wed,  1 Sep 2021 11:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243848AbhIALoY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Sep 2021 07:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242892AbhIALoY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Sep 2021 07:44:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9522FC061575
        for <linux-raid@vger.kernel.org>; Wed,  1 Sep 2021 04:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=n0KL22MKAAvfTgivt2lfxgwTS6QjQy0HMDSoGQeui/g=; b=j3KkdFBVFc6a1hlIzjhCKdECur
        tz9BbS4fNL35TBVbvdM5Ob74uSSkYRbyPdd5LMus0laKA85I7x/mlUyqQqo5VhyoOvJsoDe0r9XDz
        goN2MMbfBGnUKiFY7Pb40bLTFSt7+7Oz2skCyv7jEIoL3/xFGs2YQl6F8qDP9hTURECg0WcJtqIb5
        WeI6ocSZsow7PSExnjisJrSp5FUyBsBdfnUKAg1yK12aS8oq4/R+NnwlrY2uQGYy5WPmdaAkpAN6c
        j1olwBBXidTGscx2fJCge2TiweiYLErQ0h1Q4yM2GkiWCUSd1x3cSU8oBTOrY/zihUk9w6wUkwzWc
        D4zbTKvA==;
Received: from [2001:4bb8:180:a30:2deb:705a:5588:bf7d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLOd8-002Fi6-0S; Wed, 01 Sep 2021 11:42:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Song Liu <song@kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH 4/5] md: extend disks_mutex coverage
Date:   Wed,  1 Sep 2021 13:38:32 +0200
Message-Id: <20210901113833.1334886-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210901113833.1334886-1-hch@lst.de>
References: <20210901113833.1334886-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

disks_mutex is intended to serialize md_alloc.  Extended it to also cover
the kobject_uevent call and getting the sysfs dirent to help reducing
error handling complexity.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2971dae388ef2..b90dbf7cc2455 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5725,12 +5725,12 @@ static int md_alloc(dev_t dev, char *name)
 		error = 0;
 	}
  abort:
-	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
 		kobject_uevent(&mddev->kobj, KOBJ_ADD);
 		mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 		mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
 	}
+	mutex_unlock(&disks_mutex);
 	mddev_put(mddev);
 	return error;
 }
-- 
2.30.2

