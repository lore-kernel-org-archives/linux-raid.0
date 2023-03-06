Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC49C64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjCFV3c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:29:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCFV26 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:28:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D35426589
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F+DzmMLOoRoEzNcgs9SyKQpcswOawUDYafoDOg6uQeQ=;
        b=Yrmd8IbWdcdfIPDZv+kPoIw01QB6SGEmSTsgufot0htTZK7qg0XgI4W8ZNoNU+u0SeUbLE
        2GBJw2kQWN3hi7S3juD75YPyKlWEs9DjwRwPe9nc68FtA8Fwxge4xwG9/t6x2F3oAiC02D
        xhRDlL6k3MMGOS3yE2VhtN6T1ZmRODI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-BDd9RW0hMwy2BAp9CH5_zw-1; Mon, 06 Mar 2023 16:28:06 -0500
X-MC-Unique: BDd9RW0hMwy2BAp9CH5_zw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C84C1380611F
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:05 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1285E40B40E4;
        Mon,  6 Mar 2023 21:28:04 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 07/34] md: consistent spacing around operators [ERROR]
Date:   Mon,  6 Mar 2023 22:27:30 +0100
Message-Id: <ccd10a2449c109e29d8b2ba4b41424dd882caf74.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 24e55e2cf4db..e6ff0da6ebb6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -111,7 +111,7 @@ static bool md_is_rdwr(struct mddev *mddev)
  */
 #define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
 /* Default safemode delay: 200 msec */
-#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
+#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 + 1)
 /*
  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
  * is 1000 KB/sec, so the extra system load does not show up that much.
@@ -1460,7 +1460,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->cp_events_hi = (mddev->events>>32);
 		sb->cp_events_lo = (u32)mddev->events;
 		if (mddev->recovery_cp == MaxSector)
-			sb->state = (1<< MD_SB_CLEAN);
+			sb->state = (1<<MD_SB_CLEAN);
 	} else
 		sb->recovery_cp = 0;
 
@@ -9011,8 +9011,8 @@ void md_do_sync(struct md_thread *thread)
 		cond_resched();
 
 		recovery_done = io_sectors - atomic_read(&mddev->recovery_active);
-		currspeed = ((unsigned long)(recovery_done - mddev->resync_mark_cnt))/2
-			/((jiffies-mddev->resync_mark)/HZ +1) +1;
+		currspeed = ((unsigned long)(recovery_done - mddev->resync_mark_cnt)) / 2
+			    / ((jiffies-mddev->resync_mark)/HZ + 1) + 1;
 
 		if (currspeed > speed_min(mddev)) {
 			if (currspeed > speed_max(mddev)) {
-- 
2.39.2

