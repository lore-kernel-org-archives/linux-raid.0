Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E548DC6FD1B
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCFVau (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjCFV3l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA72A78C95
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+kB+DVRw30a1rbq3UeK2lqfXjIHnIyxvfRpDTBv8U0=;
        b=Dt7xVXwFJuZERo2QYzcm0N6XLwP0VgYZD5qqwPAlmflfe3tdrt/MVOu0008nUrMK2y6Sqp
        PyUlo5mco6/A+KJT/GZ7g1zNvmAfGkYPv/8ej+XImxL8o2yG27k/+ZfOcIp/3BKcowY7aN
        itlHXSDdby1etpSecl4PH2Q/wKELUms=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-GIjj8wZwM9mDDUB-HJpL7Q-1; Mon, 06 Mar 2023 16:28:33 -0500
X-MC-Unique: GIjj8wZwM9mDDUB-HJpL7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77A98183B3C0
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:33 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B35A640C83B6;
        Mon,  6 Mar 2023 21:28:32 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 34/34] md: avoid return in void functions [WARNING]
Date:   Mon,  6 Mar 2023 22:27:57 +0100
Message-Id: <0d92fc7fac28675d11bf1519784cd84a1521c3ef.1678136717.git.heinzm@redhat.com>
In-Reply-To: <cover.1678136717.git.heinzm@redhat.com>
References: <cover.1678136717.git.heinzm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: heinzm <heinzm@redhat.com>
---
 drivers/md/md.c     | 1 -
 drivers/md/raid0.c  | 1 -
 drivers/md/raid10.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3d17773e058f..4ea6b685a88c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9154,7 +9154,6 @@ void md_do_sync(struct md_thread *thread)
 
 	wake_up(&resync_wait);
 	md_wakeup_thread(mddev->thread);
-	return;
 }
 EXPORT_SYMBOL_GPL(md_do_sync);
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f8897ab4baeb..e140fc37df68 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -587,7 +587,6 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 static void raid0_status(struct seq_file *seq, struct mddev *mddev)
 {
 	seq_printf(seq, " %dk chunks", mddev->chunk_sectors / 2);
-	return;
 }
 
 static void *raid0_takeover_raid45(struct mddev *mddev)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 60d7b1af229e..60b1c7b9357f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1266,7 +1266,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (mddev->gendisk)
 		trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk), r10_bio->sector);
 	submit_bio_noacct(read_bio);
-	return;
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
-- 
2.39.2

