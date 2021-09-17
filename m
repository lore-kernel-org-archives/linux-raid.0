Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC22C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 17 Sep 2021 15:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F3F610A7
	for <linux-raid@archiver.kernel.org>; Fri, 17 Sep 2021 15:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242746AbhIQPgm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:36:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:53511 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242867AbhIQPgh (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 17 Sep 2021 11:36:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="308364477"
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="308364477"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 08:35:15 -0700
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="546463858"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 08:35:14 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
Date:   Fri, 17 Sep 2021 17:34:51 +0200
Message-Id: <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The idea of stopping all writes if devices is failed, introduced by
62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs if
a member is gone") seems to be reasonable so use MD_BROKEN for RAID1 and
RAID10. Support in RAID456 is added in next commit.
If userspace (mdadm) forces md to fail the device (Failure state
written via sysfs), then EBUSY is expected if array will become failed.
To achieve that, check for MD_BROKEN and if is set, then return EBUSY to
be complaint with userspace.
For faulty state, handled via ioctl, let the error_handler to decide.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md.c     | 16 ++++++++++------
 drivers/md/md.h     |  4 ++--
 drivers/md/raid1.c  |  1 +
 drivers/md/raid10.c |  1 +
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c322841d4edc..ac20eb2ddff7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -926,8 +926,9 @@ static void super_written(struct bio *bio)
 		pr_err("md: %s gets error=%d\n", __func__,
 		       blk_status_to_errno(bio->bi_status));
 		md_error(mddev, rdev);
-		if (!test_bit(Faulty, &rdev->flags)
-		    && (bio->bi_opf & MD_FAILFAST)) {
+		if (!test_bit(Faulty, &rdev->flags) &&
+		     !test_bit(MD_BROKEN, &mddev->flags) &&
+		     (bio->bi_opf & MD_FAILFAST)) {
 			set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
 			set_bit(LastDev, &rdev->flags);
 		}
@@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
-		if (test_bit(Faulty, &rdev->flags))
+
+		if (!test_bit(MD_BROKEN, &rdev->mddev->flags))
 			err = 0;
 		else
 			err = -EBUSY;
@@ -7974,12 +7976,14 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (!mddev->pers || !mddev->pers->error_handler)
 		return;
 	mddev->pers->error_handler(mddev,rdev);
-	if (mddev->degraded)
+	if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-	md_wakeup_thread(mddev->thread);
+	if (!test_bit(MD_BROKEN, &mddev->flags)) {
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
+	}
 	if (mddev->event_work.func)
 		queue_work(md_misc_wq, &mddev->event_work);
 	md_new_event(mddev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4c96c36bd01a..e01433f3b46a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -259,8 +259,8 @@ enum mddev_flags {
 	MD_NOT_READY,		/* do_md_run() is active, so 'array_state'
 				 * must not report that array is ready yet
 				 */
-	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
-				 * I/O in case an array member is gone/failed.
+	MD_BROKEN,              /* This is used to stop I/O and mark device as
+				 * dead in case an array becomes failed.
 				 */
 };
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19598bd38939..79462d860177 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1639,6 +1639,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 		 */
 		conf->recovery_disabled = mddev->recovery_disabled;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
+		set_bit(MD_BROKEN, &mddev->flags);
 		return;
 	}
 	set_bit(Blocked, &rdev->flags);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index aa2636582841..02a4d84b4d2e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1964,6 +1964,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 		 * Don't fail the drive, just return an IO error.
 		 */
 		spin_unlock_irqrestore(&conf->device_lock, flags);
+		set_bit(MD_BROKEN, &mddev->flags);
 		return;
 	}
 	if (test_and_clear_bit(In_sync, &rdev->flags))
-- 
2.26.2

