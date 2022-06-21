Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FA8C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 21 Jun 2022 03:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344970AbiFUDLz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 23:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345090AbiFUDLu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 23:11:50 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DECF20BC5
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 20:11:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655781104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HWMq7ZxGBdORRFn0E5Hh0qFtyEiRfrpTySj/u1goT1o=;
        b=Eo5D1C61htlK3X5HnON/6SDK7jTkXlySiw2k0DLohYdEKGogfuSZXLscg2i/20P09PB6ah
        MM9C9oNxr6V3FOBlq6aL/7ZQh8Cf13zZTUp7+w/Qoza3TZAW/PtCRKZU7X1fbzuBDUa2Iy
        C6hy91uOmJbm+upM7LRW4HVgB4jrbEs=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     buczek@molgen.mpg.de, logang@deltatee.com,
        linux-raid@vger.kernel.org
Subject: [PATCH V2] md: unlock mddev before reap sync_thread in action_store
Date:   Tue, 21 Jun 2022 11:11:29 +0800
Message-Id: <20220621031129.24778-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
with reconfig_mutex held") fixed is related with action_store path, other
callers which reap sync_thread didn't need to be changed.

Let's pull md_unregister_thread from md_reap_sync_thread, then fix previous
bug with belows.

1. unlock mddev before md_reap_sync_thread in action_store.
2. save reshape_position before unlock, then restore it to ensure position
   not changed accidentally by others.

Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
V2 changes:
1. add set_bit(MD_RECOVERY_INTR, &mddev->recovery) before unregister sync thread

And I didn't find regression with this version after run mdadm tests.

 drivers/md/dm-raid.c |  1 +
 drivers/md/md.c      | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9526ccbedafb..d43b8075c055 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3725,6 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_unregister_thread(&mddev->sync_thread);
 			md_reap_sync_thread(mddev);
 		}
 	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7ecb0bffda0..04bab0511312 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4830,6 +4830,19 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			if (work_pending(&mddev->del_work))
 				flush_workqueue(md_misc_wq);
 			if (mddev->sync_thread) {
+				sector_t save_rp = mddev->reshape_position;
+
+				mddev_unlock(mddev);
+				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+				md_unregister_thread(&mddev->sync_thread);
+				mddev_lock_nointr(mddev);
+				/*
+				 * set RECOVERY_INTR again and restore reshape
+				 * position in case others changed them after
+				 * got lock, eg, reshape_position_store and
+				 * md_check_recovery.
+				 */
+				mddev->reshape_position = save_rp;
 				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 				md_reap_sync_thread(mddev);
 			}
@@ -6197,6 +6210,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		md_unregister_thread(&mddev->sync_thread);
 		md_reap_sync_thread(mddev);
 	}
 
@@ -9303,6 +9317,7 @@ void md_check_recovery(struct mddev *mddev)
 			 * ->spare_active and clear saved_raid_disk
 			 */
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+			md_unregister_thread(&mddev->sync_thread);
 			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -9338,6 +9353,7 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
+			md_unregister_thread(&mddev->sync_thread);
 			md_reap_sync_thread(mddev);
 			goto unlock;
 		}
@@ -9417,8 +9433,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	sector_t old_dev_sectors = mddev->dev_sectors;
 	bool is_reshaped = false;
 
-	/* resync has finished, collect result */
-	md_unregister_thread(&mddev->sync_thread);
+	/* sync_thread should be unregistered, collect result */
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
-- 
2.31.1

