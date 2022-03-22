Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4D0C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 22 Mar 2022 15:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237546AbiCVPZ3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Mar 2022 11:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiCVPZ0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Mar 2022 11:25:26 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EEB6324
        for <linux-raid@vger.kernel.org>; Tue, 22 Mar 2022 08:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647962639; x=1679498639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MmEJx7mTs1nedGjU3jldmTw6lUqU+e17e0aVNN1BLB8=;
  b=KTMRFVNWNO7Ogd3eJCqsZWDqy5ugzRwwkwUGJyG8uieu4dMjMw08L8cf
   yL+M8FDtJQrHRMiUUFnEJeVh1V5dBEvP1N6QiIMf5pGyQajRuiszOKYLk
   JE4mZeNgFv/GzvYFAwK0ewGUB3UF//aqmyIqhMbw9bJwwn9nJBselgdvA
   fUu5XgwCBMoMTMuDYSahKjHbiFHEk22jPYnzu3hYdWrqu0zhzds3XpSQl
   2rrwZlu+POETujgVfRJfMfI1ekBmE4pzDV/xoK58+Z35rMkwPdXSNWhlr
   SM5a2qeYHQ4DxiajQMrwg+5j7iSzwfbzYh1eM3j8HwkienWcPLEGErwqj
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="255409937"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="255409937"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:23:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="543732511"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 08:23:57 -0700
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, guoqing.jiang@linux.dev
Subject: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
Date:   Tue, 22 Mar 2022 16:23:37 +0100
Message-Id: <20220322152339.11892-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Patch 62f7b1989c0 ("md raid0/linear: Mark array as 'broken' and fail BIOs
if a member is gone") allowed to finish writes earlier (before level
dependent actions) for non-redundant arrays.

To achieve that MD_BROKEN is added to mddev->flags if drive disappearance
is detected. This is done in is_mddev_broken() which is confusing and not
consistent with other levels where error_handler() is used.
This patch adds appropriate error_handler for raid0 and linear and adopt
md_error() to the change.

Usage of error_handler causes that disk failure can be requested from
userspace. User can fail the array via #mdadm --set-faulty command. This
is not safe and will be fixed in mdadm. It is correctable because failed
state is not recorded in the metadata. After next assembly array will be
read-write again. For safety reason is better to keep MD_BROKEN in
runtime only.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md-linear.c | 14 +++++++++++++-
 drivers/md/md.c        |  6 +++++-
 drivers/md/md.h        | 10 ++--------
 drivers/md/raid0.c     | 14 +++++++++++++-
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 1ff51647a682..c33cd28f1dba 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -233,7 +233,8 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
 		     bio_sector < start_sector))
 		goto out_of_bounds;
 
-	if (unlikely(is_mddev_broken(tmp_dev->rdev, "linear"))) {
+	if (unlikely(is_rdev_broken(tmp_dev->rdev))) {
+		md_error(mddev, tmp_dev->rdev);
 		bio_io_error(bio);
 		return true;
 	}
@@ -281,6 +282,16 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
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
@@ -297,6 +308,7 @@ static struct md_personality linear_personality =
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
 	.quiesce	= linear_quiesce,
+	.error_handler	= linear_error,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0a89f072dae0..3354afc9d2a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7985,7 +7985,11 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (!mddev->pers || !mddev->pers->error_handler)
 		return;
-	mddev->pers->error_handler(mddev,rdev);
+	mddev->pers->error_handler(mddev, rdev);
+
+	if (mddev->pers->level == 0 || mddev->pers->level == LEVEL_LINEAR)
+		return;
+
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f1bf3625ef4c..13d435a303fa 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -764,15 +764,9 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
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
index b59a77b31b90..b402e3dc4ead 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -582,8 +582,9 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		return true;
 	}
 
-	if (unlikely(is_mddev_broken(tmp_dev, "raid0"))) {
+	if (unlikely(is_rdev_broken(tmp_dev))) {
 		bio_io_error(bio);
+		md_error(mddev, tmp_dev);
 		return true;
 	}
 
@@ -606,6 +607,16 @@ static void raid0_status(struct seq_file *seq, struct mddev *mddev)
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
@@ -781,6 +792,7 @@ static struct md_personality raid0_personality=
 	.size		= raid0_size,
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
+	.error_handler	= raid0_error,
 };
 
 static int __init raid0_init (void)
-- 
2.26.2

