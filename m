Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FD8C636CD
	for <linux-raid@archiver.kernel.org>; Tue, 31 Jan 2023 05:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjAaFSQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Jan 2023 00:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjAaFSJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Jan 2023 00:18:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7F315CAE
        for <linux-raid@vger.kernel.org>; Mon, 30 Jan 2023 21:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675142243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeD0SNKxvhzd7nHEdrLKl1kCKQQdc6SzbvnR0DU/uAA=;
        b=em9R1z9T2mZOG/oQ8q00WCDKUUgPFpUBxiIMjs3B4a/xVAWgCwPe8eJb+37F2eh6ryX2nv
        NXztl9ahEKo45HeB/mMBMK+K7A7scxWbCP1NkmMx43Cdj1kNS8kR6yjropibr6GXIGHjPw
        KcmEAr6jIXCRcfR2vR12SNHplORZVZU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-ubaixzDuNei9XOCQRT9E6g-1; Tue, 31 Jan 2023 00:17:20 -0500
X-MC-Unique: ubaixzDuNei9XOCQRT9E6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8DAD1C05155;
        Tue, 31 Jan 2023 05:17:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-52.pek2.redhat.com [10.72.12.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CC22175A2;
        Tue, 31 Jan 2023 05:17:16 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, ming.lei@redhat.com,
        ncroxon@redhat.com, heinzm@redhat.com
Subject: [PATCH 1/2] md: Factor out is_md_suspended helper
Date:   Tue, 31 Jan 2023 13:17:09 +0800
Message-Id: <20230131051710.87961-2-xni@redhat.com>
In-Reply-To: <20230131051710.87961-1-xni@redhat.com>
References: <20230131051710.87961-1-xni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

