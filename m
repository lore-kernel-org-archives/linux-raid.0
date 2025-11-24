Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE872D8792;
	Mon, 24 Nov 2025 06:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965932; cv=none; b=U2loaJHhFRL2jyFHA8/re1NqUnYWFBgt9Q9r//s3LS2tD6wZBN1vVtU6H3wHiFdqZgFRm1PelF5Uat9ZauHz3ZYMTuoGFeGWkES9r2w3VSBIdHVwFPk3Y9RXovL/y2mejtyubkY/v4K0lheuEzIArgUarDTzIFNpt+s8bzYKAME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965932; c=relaxed/simple;
	bh=IFXq/xbL3NhZp2EYpZqx8LIbTGlkGApWGpHbmu2WmtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfkPFa8xv1vNeG/rqaNhdPwgF7egz64/p3gA48H0xwsWKINz2hvpYz/QfqUIUE+n4ix/kUO2A3RdcXNLwad4Z3XoCOWF2mx8xtkoPm8IOAXp7J7lDDPSUFKga84Hg3O8q1biHLVl5rtHdhgisnC8TTJAPMdBTbOy6y3PRcXnCl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A44C4CEF1;
	Mon, 24 Nov 2025 06:32:09 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 02/11] md: merge mddev faillast_dev into mddev_flags
Date: Mon, 24 Nov 2025 14:31:54 +0800
Message-ID: <20251124063203.1692144-3-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251124063203.1692144-1-yukuai@fnnas.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is not need to use a separate field in struct mddev, there are no
functional changes.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c     | 10 ++++++----
 drivers/md/md.h     |  3 ++-
 drivers/md/raid0.c  |  3 ++-
 drivers/md/raid1.c  |  4 ++--
 drivers/md/raid10.c |  4 ++--
 drivers/md/raid5.c  |  5 ++++-
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b49fdee11a03..5dcfd0371090 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5864,11 +5864,11 @@ __ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
 
 static ssize_t fail_last_dev_show(struct mddev *mddev, char *page)
 {
-	return sprintf(page, "%d\n", mddev->fail_last_dev);
+	return sprintf(page, "%d\n", test_bit(MD_FAILLAST_DEV, &mddev->flags));
 }
 
 /*
- * Setting fail_last_dev to true to allow last device to be forcibly removed
+ * Setting MD_FAILLAST_DEV to allow last device to be forcibly removed
  * from RAID1/RAID10.
  */
 static ssize_t
@@ -5881,8 +5881,10 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	if (ret)
 		return ret;
 
-	if (value != mddev->fail_last_dev)
-		mddev->fail_last_dev = value;
+	if (value)
+		set_bit(MD_FAILLAST_DEV, &mddev->flags);
+	else
+		clear_bit(MD_FAILLAST_DEV, &mddev->flags);
 
 	return len;
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4c9aa600edd..297a104fba88 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -341,6 +341,7 @@ struct md_cluster_operations;
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
  * @MD_DELETED: This device is being deleted
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
+ * @MD_FAILLAST_DEV: Allow last rdev to be removed.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -358,6 +359,7 @@ enum mddev_flags {
 	MD_DO_DELETE,
 	MD_DELETED,
 	MD_HAS_SUPERBLOCK,
+	MD_FAILLAST_DEV,
 };
 
 enum mddev_sb_flags {
@@ -625,7 +627,6 @@ struct mddev {
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
-	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
 };
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 47aee1b1d4d1..012d8402af28 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -27,7 +27,8 @@ module_param(default_layout, int, 0644);
 	 (1L << MD_JOURNAL_CLEAN) |	\
 	 (1L << MD_FAILFAST_SUPPORTED) |\
 	 (1L << MD_HAS_PPL) |		\
-	 (1L << MD_HAS_MULTIPLE_PPLS))
+	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
+	 (1L << MD_FAILLAST_DEV))
 
 /*
  * inform the user of the raid configuration
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57d50465eed1..98b5c93810bb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1746,7 +1746,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
  *	- &mddev->degraded is bumped.
  *
  * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * MD_FAILLAST_DEV is not set.
  */
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -1759,7 +1759,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	    (conf->raid_disks - mddev->degraded) == 1) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
-		if (!mddev->fail_last_dev) {
+		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
 			conf->recovery_disabled = mddev->recovery_disabled;
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 84be4cc7e873..09328e032f14 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1990,7 +1990,7 @@ static int enough(struct r10conf *conf, int ignore)
  *	- &mddev->degraded is bumped.
  *
  * @rdev is marked as &Faulty excluding case when array is failed and
- * &mddev->fail_last_dev is off.
+ * MD_FAILLAST_DEV is not set.
  */
 static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -2002,7 +2002,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_bit(In_sync, &rdev->flags) && !enough(conf, rdev->raid_disk)) {
 		set_bit(MD_BROKEN, &mddev->flags);
 
-		if (!mddev->fail_last_dev) {
+		if (!test_bit(MD_FAILLAST_DEV, &mddev->flags)) {
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cdbc7eba5c54..74f6729864fa 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -56,7 +56,10 @@
 #include "md-bitmap.h"
 #include "raid5-log.h"
 
-#define UNSUPPORTED_MDDEV_FLAGS	(1L << MD_FAILFAST_SUPPORTED)
+#define UNSUPPORTED_MDDEV_FLAGS		\
+	((1L << MD_FAILFAST_SUPPORTED) |	\
+	 (1L << MD_FAILLAST_DEV))
+
 
 #define cpu_to_group(cpu) cpu_to_node(cpu)
 #define ANY_GROUP NUMA_NO_NODE
-- 
2.51.0

