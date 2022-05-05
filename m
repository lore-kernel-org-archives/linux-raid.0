Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4310C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  5 May 2022 08:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347356AbiEEIXE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 May 2022 04:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347943AbiEEIWQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 May 2022 04:22:16 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E3D49F08
        for <linux-raid@vger.kernel.org>; Thu,  5 May 2022 01:18:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651738695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rrHvNre0QoOydm+/sQ3+KHs8pM78/cPKPR5Osskv/4k=;
        b=u8Hp5WHpViYMVu43DSZakxtrrIe9iLrl0ERyO+jcLtzf1SI5xV3Sto7xh+776DhsK7L4bF
        MeQunZ5wUDDQsva5ls+EbUbJP7E9UbBiOVxAaHnJzFBNN/Ff22WD0btf+cQ9DUT0rMGQG9
        F258juOxji4HnRtzBB7Z0p03CzOS3io=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     buczek@molgen.mpg.de, linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: [PATCH V3 1/2] md: don't unregister sync_thread with reconfig_mutex held
Date:   Thu,  5 May 2022 16:16:40 +0800
Message-Id: <20220505081641.21500-2-guoqing.jiang@linux.dev>
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

Let's call md_unregister_thread between mddev_unlock and mddev_lock if
reconfig_mutex is held, and mddev_is_locked is introduced accordingly.

Reported-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
v2: https://lore.kernel.org/all/1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com/#t
v1: https://lore.kernel.org/all/1612923676-18294-1-git-send-email-guoqing.jiang@cloud.ionos.com/

 drivers/md/md.c | 9 ++++++++-
 drivers/md/md.h | 5 +++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 309b3af906ad..a70e7f0f9268 100644
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
+		mddev_lock(mddev);
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

