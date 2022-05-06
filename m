Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6296C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  6 May 2022 11:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391391AbiEFLlL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 May 2022 07:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391392AbiEFLlJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 May 2022 07:41:09 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B150B58E6D
        for <linux-raid@vger.kernel.org>; Fri,  6 May 2022 04:37:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651837044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3fdom/lUgmM3B8C8E97lNdVd9GtgIRk8oYB2fG2rY50=;
        b=UOOCf/k2FUGiLLjQ69jzjTjHVBeflLE6BdPjjdDmIjxZeQIdLMNHv0202t76KSesGgWIF8
        MwNJO8h86co9blNC+Wd2rKHtORxAmv51WcRHOHkyYzQ6Zobjz/tRcRmirmSHmEdNJTcTWU
        LeGaXE3SLki3rBCsvpHDpoo9ekypkDk=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     buczek@molgen.mpg.de, linux-raid@vger.kernel.org
Subject: [Update PATCH V3] md: don't unregister sync_thread with reconfig_mutex held
Date:   Fri,  6 May 2022 19:36:56 +0800
Message-Id: <20220506113656.25010-1-guoqing.jiang@linux.dev>
In-Reply-To: <20220505081641.21500-1-guoqing.jiang@linux.dev>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

Unregister sync_thread doesn't need to hold reconfig_mutex since it
doesn't reconfigure array.

And it could cause deadlock problem for raid5 as follows:

1. process A tried to reap sync thread with reconfig_mutex held after echo
   idle to sync_action.
2. raid5 sync thread was blocked if there were too many active stripes.
3. SB_CHANGE_PENDING was set (because of write IO comes from upper layer)
   which causes the number of active stripes can't be decreased.
4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was not able
   to hold reconfig_mutex.

More details in the link:
https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t

Let's call unregister thread between mddev_unlock and mddev_lock_nointr
(thanks for the report from kernel test robot <lkp@intel.com>) if the
reconfig_mutex is held, and mddev_is_locked is introduced accordingly.

Reported-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/md/md.c | 9 ++++++++-
 drivers/md/md.h | 5 +++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 309b3af906ad..525f65682356 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9432,10 +9432,17 @@ void md_reap_sync_thread(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
-	bool is_reshaped = false;
+	bool is_reshaped = false, is_locked = false;
 
+	if (mddev_is_locked(mddev)) {
+		is_locked = true;
+		mddev_unlock(mddev);
+	}
 	/* resync has finished, collect result */
 	md_unregister_thread(&mddev->sync_thread);
+	if (is_locked)
+		mddev_lock_nointr(mddev);
+
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6ac283864533..af6f3978b62b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -549,6 +549,11 @@ static inline int mddev_trylock(struct mddev *mddev)
 }
 extern void mddev_unlock(struct mddev *mddev);
 
+static inline int mddev_is_locked(struct mddev *mddev)
+{
+	return mutex_is_locked(&mddev->reconfig_mutex);
+}
+
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
 	atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
-- 
2.31.1

