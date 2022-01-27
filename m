Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AED3C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 27 Jan 2022 15:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbiA0Pj1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Jan 2022 10:39:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:9378 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240146AbiA0Pj0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 27 Jan 2022 10:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643297966; x=1674833966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ps8IngODEfBzxTLwPz7yxBFU+HhUtigd7YchHyG0Zro=;
  b=n53fzR+GT0rLzn9Ax9CF8nbaY3HftTHOwu8yDuxxHxqnwTJ5N8HtsXm7
   PkQTjEecSbelwa/JNU/1Gdt3hYShRUh5BJxAG2qHAjJdXrPjjE78xXydP
   54Bma3qlaS2aUTceT55lVvIWn5FGIFcjspmu37Sh71Tvoq0CYVFZTqlHs
   o9qpAX4Yge0EDVazUKLr1+EiQsyZc7OekeZacFLVW2jkqvR4HT4yupACK
   yE916zvotIz+ydevgNbENGMOHdbzfvKMP2JTSYDg1hFx+13wATqIA9+xd
   jwiKwaO5UpLITzhI+wWYgbFlpcFDzx1kZqaamxIMhrwAMUSzNt2dPAvf+
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="247107857"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="247107857"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:39:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="696692398"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:39:25 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
Date:   Thu, 27 Jan 2022 16:39:09 +0100
Message-Id: <20220127153912.26856-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
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
This patch adds appropriate error_handler for raid0 and linear.

It also adopts md_error(), we only want to call .error_handler for those
levels. mddev->pers->sync_request is additionally checked, its existence
implies a level with redundancy.

Usage of error_handler causes that disk failure can be requested from
userspace. User can fail the array via #mdadm --set-faulty command. This
is not safe and will be fixed in mdadm. It is correctable because failed
state is not recorded in the metadata. After next assembly array will be
read-write again. For safety reason is better to keep MD_BROKEN in
runtime only.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/md-linear.c | 15 ++++++++++++++-
 drivers/md/md.c        |  6 +++++-
 drivers/md/md.h        | 10 ++--------
 drivers/md/raid0.c     | 15 ++++++++++++++-
 4 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 1ff51647a682..3c368e3e4641 100644
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
@@ -281,6 +282,17 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
 }
 
+static void linear_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags)) {
+		char *md_name = mdname(mddev);
+
+		pr_crit("md/linear%s: Disk failure on %pg detected.\n"
+			"md/linear:%s: Cannot continue, failing array.\n",
+			md_name, rdev->bdev, md_name);
+	}
+}
+
 static void linear_quiesce(struct mddev *mddev, int state)
 {
 }
@@ -297,6 +309,7 @@ static struct md_personality linear_personality =
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
 	.quiesce	= linear_quiesce,
+	.error_handler	= linear_error,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e8666bdc0d28..f888ef197765 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7982,7 +7982,11 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 
 	if (!mddev->pers || !mddev->pers->error_handler)
 		return;
-	mddev->pers->error_handler(mddev,rdev);
+	mddev->pers->error_handler(mddev, rdev);
+
+	if (!mddev->pers->sync_request)
+		return;
+
 	if (mddev->degraded)
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	sysfs_notify_dirent_safe(rdev->sysfs_state);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 53ea7a6961de..bc3f2094d0b6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -762,15 +762,9 @@ extern void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
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
index 62c8b6adac70..707efb3825f0 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -564,8 +564,9 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		return true;
 	}
 
-	if (unlikely(is_mddev_broken(tmp_dev, "raid0"))) {
+	if (unlikely(is_rdev_broken(tmp_dev))) {
 		bio_io_error(bio);
+		md_error(mddev, tmp_dev);
 		return true;
 	}
 
@@ -588,6 +589,17 @@ static void raid0_status(struct seq_file *seq, struct mddev *mddev)
 	return;
 }
 
+static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags)) {
+		char *md_name = mdname(mddev);
+
+		pr_crit("md/raid0%s: Disk failure on %pg detected.\n"
+			"md/raid0:%s: Cannot continue, failing array.\n",
+			md_name, rdev->bdev, md_name);
+	}
+}
+
 static void *raid0_takeover_raid45(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
@@ -763,6 +775,7 @@ static struct md_personality raid0_personality=
 	.size		= raid0_size,
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
+	.error_handler	= raid0_error,
 };
 
 static int __init raid0_init (void)
-- 
2.26.2

