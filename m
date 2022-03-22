Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E0CC433FE
	for <linux-raid@archiver.kernel.org>; Tue, 22 Mar 2022 15:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiCVPZb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Mar 2022 11:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiCVPZa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Mar 2022 11:25:30 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96E27E588
        for <linux-raid@vger.kernel.org>; Tue, 22 Mar 2022 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647962641; x=1679498641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zp97gpDVfMuZBvEg7MKNmXjeM0BTNWZBvQu6kGUNgcM=;
  b=RycA5cuhrvc1BX5kRAVRWUdrecnd7HJ1vdf8ro4mFDv9BUqxLKfcD3rB
   g23qi2QueTo3GuFQHP9daR9epkghfs6ZvhOhDOpAaeHuLVGIKKtp5K6/0
   +NP9lLYuQtsq2FcdCh844//BTAhxYaEUYIL3zTtvK7XDxFxdc8oxVNmK/
   Uci8kEQTbbE8t0AmHBwCp18F72WiYism9Ep3SzD+6wRsoeHJKYUfMmvwd
   rezb42WhNNKYU//rjVJ97uQUlOiiCoer49BurXco8vgLN2OlEg0KCAJan
   FvUEbWW/OvXzPfFwFb+A7g99d8xp2gyq7NZqEb0B+uHYQ6w03DQxJ6NC+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="255409958"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="255409958"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:24:01 -0700
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="543732522"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:24:00 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, guoqing.jiang@linux.dev
Subject: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
Date:   Tue, 22 Mar 2022 16:23:38 +0100
Message-Id: <20220322152339.11892-3-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There is no direct mechanism to determine raid failure outside
personality. It is done by checking rdev->flags after executing
md_error(). If "faulty" flag is not set then -EBUSY is returned to
userspace. -EBUSY means that array will be failed after drive removal.

Mdadm has special routine to handle the array failure and it is executed
if -EBUSY is returned by md.

There are at least two known reasons to not consider this mechanism
as correct:
1. drive can be removed even if array will be failed[1].
2. -EBUSY seems to be wrong status. Array is not busy, but removal
   process cannot proceed safe.

-EBUSY expectation cannot be removed without breaking compatibility
with userspace. In this patch first issue is resolved by adding support
for MD_BROKEN flag for RAID1 and RAID10. Support for RAID456 is added in
next commit.

The idea is to set the MD_BROKEN if we are sure that raid is in failed
state now. This is done in each error_handler(). In md_error() MD_BROKEN
flag is checked. If is set, then -EBUSY is returned to userspace.

As in previous commit, it causes that #mdadm --set-faulty is able to
fail array. Previously proposed workaround is valid if optional
functionality[1] is disabled.

[1] commit 9a567843f7ce("md: allow last device to be forcibly removed from
    RAID1/RAID10.")
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md.c     | 24 ++++++++++--------
 drivers/md/md.h     | 62 +++++++++++++++++++++++++--------------------
 drivers/md/raid1.c  | 43 ++++++++++++++++++-------------
 drivers/md/raid10.c | 40 +++++++++++++++++------------
 4 files changed, 98 insertions(+), 71 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3354afc9d2a3..3613b22b9097 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2984,10 +2984,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 
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
@@ -4353,10 +4354,9 @@ __ATTR_PREALLOC(resync_start, S_IRUGO|S_IWUSR,
  *     like active, but no writes have been seen for a while (100msec).
  *
  * broken
- *     RAID0/LINEAR-only: same as clean, but array is missing a member.
- *     It's useful because RAID0/LINEAR mounted-arrays aren't stopped
- *     when a member is gone, so this state will at least alert the
- *     user that something is wrong.
+*     Array is failed. It's useful because mounted-arrays aren't stopped
+*     when array is failed, so this state will at least alert the user that
+*     something is wrong.
  */
 enum array_state { clear, inactive, suspended, readonly, read_auto, clean, active,
 		   write_pending, active_idle, broken, bad_word};
@@ -7444,7 +7444,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
 		err =  -ENODEV;
 	else {
 		md_error(mddev, rdev);
-		if (!test_bit(Faulty, &rdev->flags))
+		if (test_bit(MD_BROKEN, &mddev->flags))
 			err = -EBUSY;
 	}
 	rcu_read_unlock();
@@ -7990,12 +7990,14 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (mddev->pers->level == 0 || mddev->pers->level == LEVEL_LINEAR)
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
index 13d435a303fa..3f056ec92473 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -234,34 +234,42 @@ extern int rdev_clear_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
 				int is_new);
 struct md_cluster_info;
 
-/* change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added */
+/**
+ * enum mddev_flags - md device flags.
+ * @MD_ARRAY_FIRST_USE: First use of array, needs initialization.
+ * @MD_CLOSING: If set, we are closing the array, do not open it then.
+ * @MD_JOURNAL_CLEAN: A raid with journal is already clean.
+ * @MD_HAS_JOURNAL: The raid array has journal feature set.
+ * @MD_CLUSTER_RESYNC_LOCKED: cluster raid only, which means node, already took
+ *			       resync lock, need to release the lock.
+ * @MD_FAILFAST_SUPPORTED: Using MD_FAILFAST on metadata writes is supported as
+ *			    calls to md_error() will never cause the array to
+ *			    become failed.
+ * @MD_HAS_PPL:  The raid array has PPL feature set.
+ * @MD_HAS_MULTIPLE_PPLS: The raid array has multiple PPLs feature set.
+ * @MD_ALLOW_SB_UPDATE: md_check_recovery is allowed to update the metadata
+ *			 without taking reconfig_mutex.
+ * @MD_UPDATING_SB: md_check_recovery is updating the metadata without
+ *		     explicitly holding reconfig_mutex.
+ * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not report that
+ *		   array is ready yet.
+ * @MD_BROKEN: This is used to stop writes and mark array as failed.
+ *
+ * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
+ */
 enum mddev_flags {
-	MD_ARRAY_FIRST_USE,	/* First use of array, needs initialization */
-	MD_CLOSING,		/* If set, we are closing the array, do not open
-				 * it then */
-	MD_JOURNAL_CLEAN,	/* A raid with journal is already clean */
-	MD_HAS_JOURNAL,		/* The raid array has journal feature set */
-	MD_CLUSTER_RESYNC_LOCKED, /* cluster raid only, which means node
-				   * already took resync lock, need to
-				   * release the lock */
-	MD_FAILFAST_SUPPORTED,	/* Using MD_FAILFAST on metadata writes is
-				 * supported as calls to md_error() will
-				 * never cause the array to become failed.
-				 */
-	MD_HAS_PPL,		/* The raid array has PPL feature set */
-	MD_HAS_MULTIPLE_PPLS,	/* The raid array has multiple PPLs feature set */
-	MD_ALLOW_SB_UPDATE,	/* md_check_recovery is allowed to update
-				 * the metadata without taking reconfig_mutex.
-				 */
-	MD_UPDATING_SB,		/* md_check_recovery is updating the metadata
-				 * without explicitly holding reconfig_mutex.
-				 */
-	MD_NOT_READY,		/* do_md_run() is active, so 'array_state'
-				 * must not report that array is ready yet
-				 */
-	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
-				 * I/O in case an array member is gone/failed.
-				 */
+	MD_ARRAY_FIRST_USE,
+	MD_CLOSING,
+	MD_JOURNAL_CLEAN,
+	MD_HAS_JOURNAL,
+	MD_CLUSTER_RESYNC_LOCKED,
+	MD_FAILFAST_SUPPORTED,
+	MD_HAS_PPL,
+	MD_HAS_MULTIPLE_PPLS,
+	MD_ALLOW_SB_UPDATE,
+	MD_UPDATING_SB,
+	MD_NOT_READY,
+	MD_BROKEN,
 };
 
 enum mddev_sb_flags {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9b2f9745b4e0..bd1acfb42997 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1638,30 +1638,39 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, "]");
 }
 
+/**
+ * raid1_error() - RAID1 error handler.
+ * @mddev: affected md device.
+ * @rdev: member device to fail.
+ *
+ * The routine acknowledges &rdev failure and determines new @mddev state.
+ * If it failed, then:
+ *	- &MD_BROKEN flag is set in &mddev->flags.
+ *	- recovery is disabled.
+ * Otherwise, it must be degraded:
+ *	- recovery is interrupted.
+ *	- &mddev->degraded is bumped.
+ *
+ * @rdev is marked as &Faulty excluding case when array is failed and
+ * &mddev->fail_last_dev is off.
+ */
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char b[BDEVNAME_SIZE];
 	struct r1conf *conf = mddev->private;
 	unsigned long flags;
 
-	/*
-	 * If it is not operational, then we have already marked it as dead
-	 * else if it is the last working disks with "fail_last_dev == false",
-	 * ignore the error, let the next level up know.
-	 * else mark the drive as failed
-	 */
 	spin_lock_irqsave(&conf->device_lock, flags);
-	if (test_bit(In_sync, &rdev->flags) && !mddev->fail_last_dev
-	    && (conf->raid_disks - mddev->degraded) == 1) {
-		/*
-		 * Don't fail the drive, act as though we were just a
-		 * normal single drive.
-		 * However don't try a recovery from this drive as
-		 * it is very likely to fail.
-		 */
-		conf->recovery_disabled = mddev->recovery_disabled;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		return;
+
+	if (test_bit(In_sync, &rdev->flags) &&
+	    (conf->raid_disks - mddev->degraded) == 1) {
+		set_bit(MD_BROKEN, &mddev->flags);
+
+		if (!mddev->fail_last_dev) {
+			conf->recovery_disabled = mddev->recovery_disabled;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			return;
+		}
 	}
 	set_bit(Blocked, &rdev->flags);
 	if (test_and_clear_bit(In_sync, &rdev->flags))
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c2b5a9ff85cc..06f8c48c13c3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1963,32 +1963,40 @@ static int enough(struct r10conf *conf, int ignore)
 		_enough(conf, 1, ignore);
 }
 
+/**
+ * raid10_error() - RAID10 error handler.
+ * @mddev: affected md device.
+ * @rdev: member device to fail.
+ *
+ * The routine acknowledges &rdev failure and determines new @mddev state.
+ * If it failed, then:
+ *	- &MD_BROKEN flag is set in &mddev->flags.
+ * Otherwise, it must be degraded:
+ *	- recovery is interrupted.
+ *	- &mddev->degraded is bumped.
+
+ * @rdev is marked as &Faulty excluding case when array is failed and
+ * &mddev->fail_last_dev is off.
+ */
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	char b[BDEVNAME_SIZE];
 	struct r10conf *conf = mddev->private;
 	unsigned long flags;
 
-	/*
-	 * If it is not operational, then we have already marked it as dead
-	 * else if it is the last working disks with "fail_last_dev == false",
-	 * ignore the error, let the next level up know.
-	 * else mark the drive as failed
-	 */
 	spin_lock_irqsave(&conf->device_lock, flags);
-	if (test_bit(In_sync, &rdev->flags) && !mddev->fail_last_dev
-	    && !enough(conf, rdev->raid_disk)) {
-		/*
-		 * Don't fail the drive, just return an IO error.
-		 */
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-		return;
+
+	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
+		set_bit(MD_BROKEN, &mddev->flags);
+
+		if (!mddev->fail_last_dev) {
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+			return;
+		}
 	}
 	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
-	/*
-	 * If recovery is running, make sure it aborts.
-	 */
+
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
-- 
2.26.2

