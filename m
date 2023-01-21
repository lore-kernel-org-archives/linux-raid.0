Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7ACC27C76
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 01:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjAUBkh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Jan 2023 20:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjAUBkh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Jan 2023 20:40:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09D87E4A7
        for <linux-raid@vger.kernel.org>; Fri, 20 Jan 2023 17:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674265188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeD0SNKxvhzd7nHEdrLKl1kCKQQdc6SzbvnR0DU/uAA=;
        b=A/YOSLexIhBPuFtxxHPIjlOJXjQdNkLkwhwZ3GpWPOE1Z3ygJmnu6k/PKXNRTD0IvzRmVq
        R4vSFU2cPAuyun6O7+KRUidFPJ33BgJH2xJRX7dUM0a3Z001ZdWSzFAl9Va5UQWfzb/9Y/
        kAw94AppEqFlzCFjqKQrKIgkVFkWAUg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-F1pDMeAePe2l2vanL-TFtQ-1; Fri, 20 Jan 2023 20:39:47 -0500
X-MC-Unique: F1pDMeAePe2l2vanL-TFtQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EE9485CCE1;
        Sat, 21 Jan 2023 01:39:47 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-10.pek2.redhat.com [10.72.13.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 827ED2166B2A;
        Sat, 21 Jan 2023 01:39:44 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH 1/2] md: Factor out is_md_suspended helper
Date:   Sat, 21 Jan 2023 09:39:36 +0800
Message-Id: <20230121013937.97576-2-xni@redhat.com>
In-Reply-To: <20230121013937.97576-1-xni@redhat.com>
References: <20230121013937.97576-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This helper function will be used in next patch. It's easy for
understanding.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 775f1dde190a..d3627aad981a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -380,6 +380,13 @@ EXPORT_SYMBOL_GPL(md_new_event);
 static LIST_HEAD(all_mddevs);
 static DEFINE_SPINLOCK(all_mddevs_lock);
 
+static bool is_md_suspended(struct mddev *mddev)
+{
+	if (mddev->suspended)
+		return true;
+	else
+		return false;
+}
 /* Rather than calling directly into the personality make_request function,
  * IO requests come here first so that we can check if the device is
  * being suspended pending a reconfiguration.
@@ -389,7 +396,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
  */
 static bool is_suspended(struct mddev *mddev, struct bio *bio)
 {
-	if (mddev->suspended)
+	if (is_md_suspended(mddev))
 		return true;
 	if (bio_data_dir(bio) != WRITE)
 		return false;
@@ -434,7 +441,7 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 		goto check_suspended;
 	}
 
-	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
+	if (atomic_dec_and_test(&mddev->active_io) && is_md_suspended(mddev))
 		wake_up(&mddev->sb_wait);
 }
 EXPORT_SYMBOL(md_handle_request);
@@ -6217,7 +6224,7 @@ EXPORT_SYMBOL_GPL(md_stop_writes);
 static void mddev_detach(struct mddev *mddev)
 {
 	md_bitmap_wait_behind_writes(mddev);
-	if (mddev->pers && mddev->pers->quiesce && !mddev->suspended) {
+	if (mddev->pers && mddev->pers->quiesce && !is_md_suspended(mddev)) {
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
 	}
@@ -8529,7 +8536,7 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
 		return true;
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
-		   mddev->suspended);
+		   is_md_suspended(mddev));
 	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
 		percpu_ref_put(&mddev->writes_pending);
 		return false;
@@ -9257,7 +9264,7 @@ void md_check_recovery(struct mddev *mddev)
 		wake_up(&mddev->sb_wait);
 	}
 
-	if (mddev->suspended)
+	if (is_md_suspended(mddev))
 		return;
 
 	if (mddev->bitmap)
-- 
2.32.0 (Apple Git-132)

