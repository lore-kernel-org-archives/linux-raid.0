Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C75C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 14:53:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237955AbhLPOxP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 09:53:15 -0500
Received: from mga17.intel.com ([192.55.52.151]:29659 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237040AbhLPOxP (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 16 Dec 2021 09:53:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="220190299"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="220190299"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:52:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="466094021"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:52:52 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
Date:   Thu, 16 Dec 2021 15:52:21 +0100
Message-Id: <20211216145222.15370-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There was no direct mechanism to determine raid failure outside
personality. It was done by checking rdev->flags after executing
md_error(). If "faulty" was not set then -EBUSY was returned to
userspace. It causes that mdadm expects -EBUSY if the array
becomes failed. There are some reasons to not consider this mechanism
as correct:
- drive can't be failed for different reasons.
- there are path where -EBUSY is not reported and drive removal leads
to failed array, without notification for userspace.
- in the array failure case -EBUSY seems to be wrong status. Array is
not busy, but removal process cannot proceed safe.

-EBUSY expectation cannot be removed without breaking compatibility
with userspace, but we can adopt the failed state verification method.

In this patch MD_BROKEN flag support, used to mark non-redundant array
as dead, is added to RAID1 and RAID10. Support for RAID456 is added in
next commit.

Now the array failure can be checked, so verify MD_BROKEN flag, however
still return -EBUSY to userspace.

As in previous commit, it causes that #mdadm --set-faulty is able to
mark array as failed. Previously proposed workaround is valid if optional
functionality 9a567843f79("md: allow last device to be forcibly
removed from RAID1/RAID10.") is disabled.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md.c     | 17 ++++++++++-------
 drivers/md/md.h     |  4 ++--
 drivers/md/raid1.c  |  1 +
 drivers/md/raid10.c |  1 +
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f888ef197765..fda8473f96b8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2983,10 +2983,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
-		if (test_bit(Faulty, &rdev->flags))
-			err = 0;
-		else
+
+		if (test_bit(MD_BROKEN, &rdev->mddev->flags))
 			err = -EBUSY;
+		else
+			err = 0;
 	} else if (cmd_match(buf, "remove")) {
 		if (rdev->mddev->pers) {
 			clear_bit(Blocked, &rdev->flags);
@@ -7441,7 +7442,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
 		err =  -ENODEV;
 	else {
 		md_error(mddev, rdev);
-		if (!test_bit(Faulty, &rdev->flags))
+		if (test_bit(MD_BROKEN, &mddev->flags))
 			err = -EBUSY;
 	}
 	rcu_read_unlock();
@@ -7987,12 +7988,14 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (!mddev->pers->sync_request)
 		return;
 
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
 	md_new_event();
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bc3f2094d0b6..d3a897868695 100644
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
index 7dc8026cf6ee..45dc75f90476 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1638,6 +1638,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 		 */
 		conf->recovery_disabled = mddev->recovery_disabled;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
+		set_bit(MD_BROKEN, &mddev->flags);
 		return;
 	}
 	set_bit(Blocked, &rdev->flags);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dde98f65bd04..d7cefd212e6b 100644
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

