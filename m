Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67487C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 16 Dec 2021 14:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhLPOxO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 09:53:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:29659 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234948AbhLPOxO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 16 Dec 2021 09:53:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="220190283"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="220190283"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:52:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="466094014"
Received: from mtkaczyk-devel.igk.intel.com ([10.102.102.23])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 06:52:50 -0800
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and linear
Date:   Thu, 16 Dec 2021 15:52:20 +0100
Message-Id: <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
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
index 1ff51647a682..415d2615d17a 100644
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
+	char b[BDEVNAME_SIZE];
+
+	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
+		pr_crit("md/linear%s: Disk failure on %s detected.\n"
+			"md/linear:%s: Cannot continue, failing array.\n",
+			mdname(mddev), bdevname(rdev->bdev, b),
+			mdname(mddev));
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
index 62c8b6adac70..cb9edd65d8a9 100644
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
+	char b[BDEVNAME_SIZE];
+
+	if (!test_and_set_bit(MD_BROKEN, &rdev->mddev->flags))
+		pr_crit("md/raid0%s: Disk failure on %s detected.\n"
+			"md/raid0:%s: Cannot continue, failing array.\n",
+			mdname(mddev), bdevname(rdev->bdev, b),
+			mdname(mddev));
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

