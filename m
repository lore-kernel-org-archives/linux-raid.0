Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7464AC64EC4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 21:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCFVaJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 16:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjCFV3V (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 16:29:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0779498A0
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 13:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678138104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BdHMxOZARKYfBfDyD25CfhCW4wrT+6ERM+s727/uZGI=;
        b=WFbViPOpCEtHM8G4C7RnxQZtBCCexLfb/GINLkL2ZU63RvBXwdp8q7px8/zNaBUAkwZyUF
        hf2fedI3mglfxdNaeQQtZ1MM3ujcjvRVHaAsnSscJ+YVc3SYah7h6pUU7CyyRNvfc0cxWL
        YN4KaCSf5XvX098fsVn7L7PjvF6Yty4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-krVAYvJBO6-rV4hhsU3wSg-1; Mon, 06 Mar 2023 16:28:22 -0500
X-MC-Unique: krVAYvJBO6-rV4hhsU3wSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 763873C10225
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 21:28:22 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B23A940C83B6;
        Mon,  6 Mar 2023 21:28:21 +0000 (UTC)
From:   heinzm@redhat.com
To:     linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, xni@redhat.com, dkeefe@redhat.com
Subject: [PATCH 23/34] md: fix code indent for conditional statements [WARNING]
Date:   Mon,  6 Mar 2023 22:27:46 +0100
Message-Id: <eed3b7ffa311b473a9470c3a41d2de7e1d725ba0.1678136717.git.heinzm@redhat.com>
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
 drivers/md/md-bitmap.c | 2 +-
 drivers/md/md.c        | 8 ++++----
 drivers/md/raid5.c     | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e739efe2249d..b78b3647c4e7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2327,7 +2327,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		long long offset;
 
 		if (strncmp(buf, "none", 4) == 0)
-			/* nothing to be done */;
+			; /* nothing to be done */
 		else if (strncmp(buf, "file:", 5) == 0) {
 			/* Not supported yet */
 			rv = -EINVAL;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b68b6d9dd8b6..858cbb5252df 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2053,7 +2053,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 		sb->feature_map |= cpu_to_le32(MD_FEATURE_CLUSTERED);
 
 	if (rdev->badblocks.count == 0)
-		/* Nothing to do for bad blocks*/;
+		; /* Nothing to do for bad blocks*/
 	else if (sb->bblog_offset == 0)
 		/* Cannot record bad blocks on this device */
 		md_error(mddev, rdev);
@@ -2676,7 +2676,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 		    !test_bit(Journal, &rdev->flags) &&
 		    !test_bit(In_sync, &rdev->flags) &&
 		    mddev->curr_resync_completed > rdev->recovery_offset)
-				rdev->recovery_offset = mddev->curr_resync_completed;
+			rdev->recovery_offset = mddev->curr_resync_completed;
 
 	}
 	if (!mddev->persistent) {
@@ -5854,7 +5854,7 @@ int md_run(struct mddev *mddev)
 		 * Internal Bitmap issues have been handled elsewhere.
 		 */
 		if (rdev->meta_bdev) {
-			/* Nothing to check */;
+			; /* Nothing to check */
 		} else if (rdev->data_offset < rdev->sb_start) {
 			if (mddev->dev_sectors &&
 			    rdev->data_offset + mddev->dev_sectors > rdev->sb_start) {
@@ -6151,7 +6151,7 @@ static int restart_array(struct mddev *mddev)
 	rcu_read_unlock();
 	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) && !has_journal)
 		/* Don't restart rw with journal missing/faulty */
-			return -EINVAL;
+		return -EINVAL;
 	if (has_readonly)
 		return -EROFS;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a1da82a72553..f418035da889 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4811,7 +4811,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 		clear_bit(R5_Insync, &dev->flags);
 		if (!rdev)
-			/* Not in-sync */;
+			; /* Not in-sync */
 		else if (is_bad) {
 			/* also not in-sync */
 			if (!test_bit(WriteErrorSeen, &rdev->flags) &&
@@ -7888,7 +7888,7 @@ static int raid5_run(struct mddev *mddev)
 			 */
 			if (abs(min_offset_diff) >= mddev->chunk_sectors &&
 			    abs(min_offset_diff) >= mddev->new_chunk_sectors)
-				/* not really in-place - so OK */;
+				; /* not really in-place - so OK */
 			else if (mddev->ro == 0) {
 				pr_warn("md/raid:%s: in-place reshape must be started in read-only mode - aborting\n",
 					mdname(mddev));
-- 
2.39.2

