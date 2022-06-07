Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23D3C43334
	for <linux-raid@archiver.kernel.org>; Tue,  7 Jun 2022 02:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbiFGCEu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 22:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiFGCEs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 22:04:48 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFCCB82FC
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 19:04:46 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654567485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TNlkkZVMt0IfBkdsudQr5LZWFi8g1UIlc9MG36QgI5M=;
        b=i+M9Uh4ZnocppWQisqJpjLSwbE9u1WaElrCRwOaC1p6dP0cG1tV3HpZiOOjpkAy/ee+fel
        8O3d4IDlHYkQ54YCIqb1khJCqmfn/jk3jNpRKMIQRcos8YoxGseoVO6XMWDFRW3y3frSCq
        UGrB9Yob8KC1tK2Td+O+k1+tjXxrChI=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     buczek@molgen.mpg.de, logang@deltatee.com,
        linux-raid@vger.kernel.org
Subject: [PATCH 1/2] Revert "md: don't unregister sync_thread with reconfig_mutex held"
Date:   Tue,  7 Jun 2022 10:03:56 +0800
Message-Id: <20220607020357.14831-2-guoqing.jiang@linux.dev>
In-Reply-To: <20220607020357.14831-1-guoqing.jiang@linux.dev>
References: <20220607020357.14831-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The 07reshape5intr test is broke because of below path.

    md_reap_sync_thread
            -> mddev_unlock
            -> md_unregister_thread(&mddev->sync_thread)

And md_check_recovery is triggered by,

mddev_unlock -> md_wakeup_thread(mddev->thread)

then mddev->reshape_position is set to MaxSector in raid5_finish_reshape
since MD_RECOVERY_INTR is cleared in md_check_recovery, which means
feature_map is not set with MD_FEATURE_RESHAPE_ACTIVE and superblock's
reshape_position can't be updated accordingly.

Fixes: 8b48ec23cc51a ("md: don't unregister sync_thread with reconfig_mutex held")
Reported-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/dm-raid.c |  2 +-
 drivers/md/md.c      | 14 +++++---------
 drivers/md/md.h      |  2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 5e41fbae3f6b..9526ccbedafb 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3725,7 +3725,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev, false);
+			md_reap_sync_thread(mddev);
 		}
 	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5c8efef13881..2e83a19e3aba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4831,7 +4831,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 				flush_workqueue(md_misc_wq);
 			if (mddev->sync_thread) {
 				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_reap_sync_thread(mddev, true);
+				md_reap_sync_thread(mddev);
 			}
 			mddev_unlock(mddev);
 		}
@@ -6197,7 +6197,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_reap_sync_thread(mddev, true);
+		md_reap_sync_thread(mddev);
 	}
 
 	del_timer_sync(&mddev->safemode_timer);
@@ -9303,7 +9303,7 @@ void md_check_recovery(struct mddev *mddev)
 			 * ->spare_active and clear saved_raid_disk
 			 */
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev, true);
+			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
@@ -9338,7 +9338,7 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			md_reap_sync_thread(mddev, true);
+			md_reap_sync_thread(mddev);
 			goto unlock;
 		}
 		/* Set RUNNING before clearing NEEDED to avoid
@@ -9411,18 +9411,14 @@ void md_check_recovery(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_check_recovery);
 
-void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
+void md_reap_sync_thread(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
 	bool is_reshaped = false;
 
-	if (reconfig_mutex_held)
-		mddev_unlock(mddev);
 	/* resync has finished, collect result */
 	md_unregister_thread(&mddev->sync_thread);
-	if (reconfig_mutex_held)
-		mddev_lock_nointr(mddev);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 82465a4b1588..ba8224fd68e9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -719,7 +719,7 @@ extern struct md_thread *md_register_thread(
 extern void md_unregister_thread(struct md_thread **threadp);
 extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
-extern void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held);
+extern void md_reap_sync_thread(struct mddev *mddev);
 extern int mddev_init_writes_pending(struct mddev *mddev);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
-- 
2.31.1

