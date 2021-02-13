Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE13DC43381
	for <linux-raid@archiver.kernel.org>; Sat, 13 Feb 2021 00:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B9F364E02
	for <linux-raid@archiver.kernel.org>; Sat, 13 Feb 2021 00:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhBMAvC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Feb 2021 19:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhBMAvA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 Feb 2021 19:51:00 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDF7C061574
        for <linux-raid@vger.kernel.org>; Fri, 12 Feb 2021 16:50:19 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id df22so1931682edb.1
        for <linux-raid@vger.kernel.org>; Fri, 12 Feb 2021 16:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Vjj9qYSvQfQbP8LLjapg+ws1IefrfhkmMhOgFWMI9Dc=;
        b=fAbGDvI1TGWPqn3td7hD3uOCkZf4pzLKmA3WZsUtAjKRG4gWfC6ZZk6Pd1FMJGoWS7
         +A7ouz97ZPcaxOuZUsr1gjXTH2UIL7FSDEQUCRZE0emHUDXNdTUSr0qjkTjMtNhUH36L
         ydZlLAIN4WYkk/61UOAh/oEz+8q0JN2zsk6yJ6Mo+OEhrcvHTIXPaLdAo41ySifGVInH
         o7F6/YfiV+oDGeRSZ68CDUBTF3MruMCAdXP5VfJNUzDOrtHnc40CWS4LrENM18EaKYEx
         /HABoz8P0Y085huuwTaMi6Wg7fJzS3a/+4yG1rjViXmrPN1l0otdG8EXoCQCpdnrdEbW
         XArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vjj9qYSvQfQbP8LLjapg+ws1IefrfhkmMhOgFWMI9Dc=;
        b=nbvvcUeHKhTFDnadhtWla5+D/SUdp9vn7TwjQB/AuD/IEww5o7Inv6bs9ipWVHIjtP
         w77mWQhe0CCwHRI4UVl9qy7caFHU0U8/vYcrHIB3/8U51SxBtyePTl3nLAEDp9jUHTPg
         xx4t6eiw8NUChCL3MoIR1Vxw+G2XIQbltm0Ztg8QRkGcOM/DXQQH43FLMhwTYz7iVQVg
         5hIdO8Y3HjfG9LRSGNgNaHri5ESto1jgh0PxQPCmKFqknbwNPfDYd7FratojsqTQqAVA
         e6WZGnd6uCvWLhf4rOTkAGIJ781l3Z7GRyTJDrCRieTCJlT/CzK683TbUIbwG6HEDzH+
         2HVQ==
X-Gm-Message-State: AOAM531QyvT+g79bptVINS8OaYYNpler72N687KjYwjTJk/kdDz+vhGd
        E+57Sx6lkF8Y0qWq7gT+X9rOFQ==
X-Google-Smtp-Source: ABdhPJwUUaMKuOdiJtXAePFBpMkAkKWzwNC9+NnwNOWYpuQaM5sgSKzXETgpdcKfunQ5LYMJm75ilQ==
X-Received: by 2002:aa7:ce13:: with SMTP id d19mr6123370edv.208.1613177418112;
        Fri, 12 Feb 2021 16:50:18 -0800 (PST)
Received: from gqjiang-home.profitbricks.net ([240e:304:2c81:30a4:4403:7938:f6d4:38b1])
        by smtp.gmail.com with ESMTPSA id q10sm393817edr.51.2021.02.12.16.50.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Feb 2021 16:50:17 -0800 (PST)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     song@kernel.org
Cc:     agk@redhat.com, snitzer@redhat.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex held
Date:   Sat, 13 Feb 2021 01:49:59 +0100
Message-Id: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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

And add one parameter to md_reap_sync_thread since it could be called by
dm-raid which doesn't hold reconfig_mutex.

Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
V2:
1. add one parameter to md_reap_sync_thread per Jack's suggestion.

 drivers/md/dm-raid.c |  2 +-
 drivers/md/md.c      | 14 +++++++++-----
 drivers/md/md.h      |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index cab12b2..0c4cbba 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, false);
 		}
 	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
 		return -EBUSY;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ca40942..0c12b7f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4857,7 +4857,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 				flush_workqueue(md_misc_wq);
 			if (mddev->sync_thread) {
 				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_reap_sync_thread(mddev);
+				md_reap_sync_thread(mddev, true);
 			}
 			mddev_unlock(mddev);
 		}
@@ -6234,7 +6234,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_reap_sync_thread(mddev);
+		md_reap_sync_thread(mddev, true);
 	}
 
 	del_timer_sync(&mddev->safemode_timer);
@@ -9256,7 +9256,7 @@ void md_check_recovery(struct mddev *mddev)
 			 * ->spare_active and clear saved_raid_disk
 			 */
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, true);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
@@ -9291,7 +9291,7 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			md_reap_sync_thread(mddev);
+			md_reap_sync_thread(mddev, true);
 			goto unlock;
 		}
 		/* Set RUNNING before clearing NEEDED to avoid
@@ -9364,14 +9364,18 @@ void md_check_recovery(struct mddev *mddev)
 }
 EXPORT_SYMBOL(md_check_recovery);
 
-void md_reap_sync_thread(struct mddev *mddev)
+void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
 {
 	struct md_rdev *rdev;
 	sector_t old_dev_sectors = mddev->dev_sectors;
 	bool is_reshaped = false;
 
 	/* resync has finished, collect result */
+	if (reconfig_mutex_held)
+		mddev_unlock(mddev);
 	md_unregister_thread(&mddev->sync_thread);
+	if (reconfig_mutex_held)
+		mddev_lock_nointr(mddev);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 34070ab..7ae3d98 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -705,7 +705,7 @@ extern struct md_thread *md_register_thread(
 extern void md_unregister_thread(struct md_thread **threadp);
 extern void md_wakeup_thread(struct md_thread *thread);
 extern void md_check_recovery(struct mddev *mddev);
-extern void md_reap_sync_thread(struct mddev *mddev);
+extern void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held);
 extern int mddev_init_writes_pending(struct mddev *mddev);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
-- 
2.7.4

