Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0736C43334
	for <linux-raid@archiver.kernel.org>; Thu,  2 Jun 2022 13:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbiFBNpZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Jun 2022 09:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiFBNpX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Jun 2022 09:45:23 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9362997BE
        for <linux-raid@vger.kernel.org>; Thu,  2 Jun 2022 06:45:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654177518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/5tYrl+aa+2cb1C5++JzzqszjuE8NbJf1R8MKi7i1hg=;
        b=rmyflNRgzj/tHUJ4GjoTpS+SnV9wCrSgUaKoaegiEFheDY79VZtypoGSZRDIIXV247Yx/+
        KlCU/NA+SWxf8TJAfLOm5FEThJ/I2IzF2c8AtFtnE5PBgEex+dwyJo9RaLTZ2JbzzQYNs9
        2Y9psS3cdZ+MkmbAX+vYePwQmYs8fd4=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, buczek@molgen.mpg.de,
        logang@deltatee.com
Subject: [PATCH] md: only unlock mddev from action_store
Date:   Thu,  2 Jun 2022 21:45:09 +0800
Message-Id: <20220602134509.16662-1-guoqing.jiang@linux.dev>
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

Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
with reconfig_mutex held") fixed is related with action_store path, other
callers which reap sync_thread didn't need to be changed, let's

1. only unlock mddev in md_reap_sync_thread if caller is action_store,
   so the parameter is renamed to reflect the change.
2. save some contexts (MD_RECOVERY_INTR and reshape_position) since they
   could be changed by other processes, then restore them after get lock
   again.

Fixes: 8b48ec23cc51a ("md: don't unregister sync_thread with reconfig_mutex held")
Reported-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
I suppose the previous bug still can be fixed with the change, but it is
better to verify it. Donald, could you help to test the new code?

Thanks,
Guoqing

 drivers/md/md.c | 24 ++++++++++++++++++------
 drivers/md/md.h |  2 +-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5c8efef13881..3387260dd55b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6197,7 +6197,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_reap_sync_thread(mddev, true);
+		md_reap_sync_thread(mddev, false);
 	}
 
 	del_timer_sync(&mddev->safemode_timer);
@@ -9303,7 +9303,7 @@ void md_check_recovery(struct mddev *mddev)
 			 * ->spare_active and clear saved_raid_disk
 			 */
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev, true);
+			md_reap_sync_thread(mddev, false);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
@@ -9338,7 +9338,7 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			md_reap_sync_thread(mddev, true);
+			md_reap_sync_thread(mddev, false);
 			goto unlock;
 		}
 		/* Set RUNNING before clearing NEEDED to avoid
@@ -9411,18 +9411,30 @@ void md_check_recovery(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_check_recovery);
 
-void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
+void md_reap_sync_thread(struct mddev *mddev, bool unlock_mddev)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
+	sector_t old_reshape_position;
 	bool is_reshaped = false;
+	bool is_interrupted = false;
 
-	if (reconfig_mutex_held)
+	if (unlock_mddev) {
+		old_reshape_position = mddev->reshape_position;
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			is_interrupted = true;
 		mddev_unlock(mddev);
+	}
 	/* resync has finished, collect result */
 	md_unregister_thread(&mddev->sync_thread);
-	if (reconfig_mutex_held)
+	if (unlock_mddev) {
 		mddev_lock_nointr(mddev);
+		/* restore the previous flag and position */
+		mddev->reshape_position = old_reshape_position;
+		if (is_interrupted)
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+	}
+
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 82465a4b1588..3e3ff3b20e81 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -719,7 +719,7 @@ extern struct md_thread *md_register_thread(
 extern void md_unregister_thread(struct md_thread **threadp);
 extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
-extern void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held);
+extern void md_reap_sync_thread(struct mddev *mddev, bool unlock_mddev);
 extern int mddev_init_writes_pending(struct mddev *mddev);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
-- 
2.31.1

