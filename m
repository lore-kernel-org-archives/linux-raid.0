Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69A2C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 29 Apr 2022 05:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbiD2FM6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Apr 2022 01:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiD2FM5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Apr 2022 01:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 234BF220C4
        for <linux-raid@vger.kernel.org>; Thu, 28 Apr 2022 22:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651208976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=7nUykxwIBhm1DKolZr77bIvB9wsQ2z+ZIOuL5mI5vuI=;
        b=aVMGONrrRf9Yloy+I5AxC79ZrnVPHVUvlr172HULdyWsPr31cvS3chfzTpY+Lm2dabzdFM
        tNPjwAT6r9Y/yj+ivAloXorhVdezzn02LWUC69TTkhyaXuq8P4JKHwafXAmgsa6j5GuBVP
        X77EOw62K7LC4NAPOZ0cp0EQdtjt7MQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-Y8MsjQ8gPeK0yEcDouPHxg-1; Fri, 29 Apr 2022 01:09:33 -0400
X-MC-Unique: Y8MsjQ8gPeK0yEcDouPHxg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4B8885A5A8;
        Fri, 29 Apr 2022 05:09:32 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0FBA7AD5;
        Fri, 29 Apr 2022 05:09:29 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com, heinzm@redhat.com,
        ffan@redhat.com
Subject: [PATCH 1/1] Don't set mddev private to NULL in raid0 pers->free
Date:   Fri, 29 Apr 2022 13:09:27 +0800
Message-Id: <1651208967-4701-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It panics when reshaping from raid0 to other raid levels. raid0 sets
mddev->private to NULL. It's the reason that causes the problem.
Function level_store finds new pers and create new conf, then it
calls oldpers->free. In oldpers->free, raid0 sets mddev->private
to NULL again. And __md_stop is the right position to set
mddev->private to NULL.

And this patch also deletes double free memory codes. io_acct_set
is free in pers->free.

Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
Reported-by: Fine Fan <ffan@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 4 ----
 drivers/md/raid0.c | 1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 707e802..55b6412e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5598,8 +5598,6 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 	kfree(mddev);
 }
 
@@ -6285,8 +6283,6 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e11701e..5fa0d40 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -362,7 +362,6 @@ static void free_conf(struct mddev *mddev, struct r0conf *conf)
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	mddev->private = NULL;
 }
 
 static void raid0_free(struct mddev *mddev, void *priv)
-- 
2.7.5

