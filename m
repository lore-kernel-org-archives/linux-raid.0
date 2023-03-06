Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E35C61DA4
	for <linux-raid@archiver.kernel.org>; Mon,  6 Mar 2023 13:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjCFNEF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 08:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjCFNEE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 08:04:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6C72CC6E
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 05:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678107813; x=1709643813;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lhAOIcG7iYapCTVbIjJGO+StSqakWeIClTbu0TdjhSI=;
  b=fMmH4I4Y+57u1CpUeT0wN/+iiETKZR4kxVJ3gd8lZ7gpuFAQ075kS/wZ
   4vtgINbmzWdT1yBJfkIxK5TJVa4S5x0bqZcB3LOX3s16Iy8elEvKpKtMi
   0/pR2xviHLPXswv8QNI/0+OAihMTmVB1YzoDe//nu3FoBtKCqfBXX185h
   b9J/zMBY1dynuouyuOss8fRHEMxWwasrFqBszyFquw5UhqqctlMq2UCmg
   5hHWEKrubQgWr6VaPdCnFQlw++2cR8kYxQdc/S+EaqsRltyxaKHBXBPgy
   FkvjtjecQimb4csfD9uQL+SUL5wQD+hsvnmLaKAS/ZeyI4TK/6b83k7Do
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="400367508"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="400367508"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 05:03:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="678466392"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="678466392"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.105.40])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 05:03:27 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, guoqing.jiang@linux.dev, xni@redhat.com
Subject: [PATCH] raid0, linear, md: add error_handlers
Date:   Mon,  6 Mar 2023 14:03:17 +0100
Message-Id: <20230306130317.3418-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

After the commit 9631abdbf406c("md: Set MD_BROKEN for RAID1 and RAID10")
MD_BROKEN must be set if array is failed because state_store() checks it.
If it is set then -EBUSY is returned to userspace.

For raid0 and linear MD_BROKEN is not set by error_handler(). As a result
mdadm is unable to trigger clean-up actions. It is a regression.

This patch adds appropriate error_handler for raid0 and linear. The
error handler sets MD_BROKEN for this device.

Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---

We decided to drop this patch. Xiao determined that there is a regression
so bringing it back. I can implement it differently to avoid
error_handlers() if you still see them as overhead.

https://lore.kernel.org/linux-raid/CAPhsuW4ZkqRQpW7UA45m_EB_sGcxL84RAg2JS5ZcZ8seGwMj+g@mail.gmail.com/

 drivers/md/md-linear.c | 14 +++++++++++++-
 drivers/md/md.c        |  3 +++
 drivers/md/md.h        | 10 ++--------
 drivers/md/raid0.c     | 14 +++++++++++++-
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 6e7797b4e738..4eb72b9dd933 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -223,7 +223,8 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		     bio_sector < start_sector))
 		goto out_of_bounds;
 
-	if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
+	if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
+		md_error(mddev, tmp_dev->rdev);
 		bio_io_error(bio);
 		return true;
 	}
@@ -270,6 +271,16 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
 }
 
+static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
+		char *md_name = mdname(mddev);
+
+		pr_crit("md/linear%s: Disk failure on %pg detected, failing array.\n",
+			md_name, rdev->bdev);
+	}
+}
+
 static void linear_quiesce(struct mddev *mddev, int state)
 {
 }
@@ -286,6 +297,7 @@ static struct md_personality linear_personality =
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
 	.quiesce	= linear_quiesce,
+	.error_handler	= linear_error,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 927a43db5dfb..d95cf47ff924 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7974,6 +7974,9 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 		return;
 	mddev->pers->error_handler(mddev, rdev);
 
+	if (mddev->pers->level == 0 || mddev->pers->level == LEVEL_LINEAR)
+		return;
+
 	if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index e148e3c83b0d..fd8f260ed5f8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -790,15 +790,9 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
 
-static inline bool is_mddev_broken(struct md_rdev *rdev, const char *md_type)
+static inline bool is_rdev_broken(struct md_rdev *rdev)
 {
-	if (!disk_live(rdev->bdev->bd_disk)) {
-		if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
-			pr_warn("md: %s: %s array has a missing/failed member\n",
-				mdname(rdev->mddev), md_type);
-		return true;
-	}
-	return false;
+	return !disk_live(rdev->bdev->bd_disk);
 }
 
 static inline void rdev_dec_pending(struct md_rdev *rdev, struct mddev *mddev)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index b536befd8898..f8ee9a95e25d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -569,8 +569,9 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		return true;
 	}
 
-	if (unlikely(is_mddev_broken(tmp_dev, "raid0"))) {
+	if (unlikely(is_rdev_broken(tmp_dev))) {
 		bio_io_error(bio);
+		md_error(mddev, tmp_dev);
 		return true;
 	}
 
@@ -592,6 +593,16 @@ static void raid0_status(struct seq_file *seq, struct mddev *mddev)
 	return;
 }
 
+static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
+		char *md_name = mdname(mddev);
+
+		pr_crit("md/raid0%s: Disk failure on %pg detected, failing array.\n",
+			md_name, rdev->bdev);
+	}
+}
+
 static void *raid0_takeover_raid45(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
@@ -767,6 +778,7 @@ static struct md_personality raid0_personality=
 	.size		= raid0_size,
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
+	.error_handler	= raid0_error,
 };
 
 static int __init raid0_init (void)
-- 
2.26.2

