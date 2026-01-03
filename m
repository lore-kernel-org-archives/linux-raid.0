Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A46A30E0F5
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455164; cv=none; b=dhVc72miU5jGfbH7NPRr0JdgxCs6q9ndRS8eHaf6a0TlmAzqIcLpoieek+peh4do54/W08SLvoXb9i9zN9nM3hS1PfYL1zjGUtfG8Ew8xaNkYm2ROD+Af329YWDkCSVaaxQh8KGb5BHGpNJiaSo8N/CbZXSo4ozvHjYgClSSXMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455164; c=relaxed/simple;
	bh=0VXbvBFxTBC9qTO8HEOe0ijBGTubw3xQBzyfTj3VqZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlLOmL40ZcgjZihKrrm6FFna5mKtgamjgXlQbcJoXdBaWR0MqqQPOUpr/Kkyot8oTYC/bA8l3re3DftgXQXLdgOyBfJUn1SIJU+y6tnV6Gb+DNybj81gfrmTkzd9w3SLLY1HHxX7l/utrZkw3MBkInLmVqmS8t8CaT+Y0/kExGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB40C113D0;
	Sat,  3 Jan 2026 15:46:01 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 02/11] md: merge mddev faillast_dev into mddev_flags
Date: Sat,  3 Jan 2026 23:45:34 +0800
Message-ID: <20260103154543.832844-3-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
References: <20260103154543.832844-1-yukuai@fnnas.com>
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
Reviewed-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c     | 10 ++++++----
 drivers/md/md.h     |  3 ++-
 drivers/md/raid0.c  |  3 ++-
 drivers/md/raid1.c  |  4 ++--
 drivers/md/raid10.c |  4 ++--
 drivers/md/raid5.c  |  5 ++++-
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 91a30ed6b01e..be0d33fbf988 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5865,11 +5865,11 @@ __ATTR(consistency_policy, S_IRUGO | S_IWUSR, consistency_policy_show,
 
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
@@ -5882,8 +5882,10 @@ fail_last_dev_store(struct mddev *mddev, const char *buf, size_t len)
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
index 985c377356eb..4d567fcf6a7c 100644
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
index e57ce3295292..441bc838f250 100644
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

