Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10656279908
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410782; cv=none; b=DeJquG5xmpUNi+sZt4SlTGME8WOvm3W7sNSxMEHgqdFgZj9U8obhWqFiG2yPHW3SMpq1riJ1ENwOabAEq9k+PnpiJmqkZDD7IifrrxKwqbFBBbG6KZGnsD6XhaHQeW4zfZd0pBUqR0ak7H+t4ANR15CSI/75X7qyzDaRxqd7odg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410782; c=relaxed/simple;
	bh=ifEImVvrz6b9K+xg1qoR8pH2ccCdgJjjKhy0+g6vOAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP+gEvPz+Q4KbU1s3aSJghgZ3crY2YHKstU/tLU4XPAs1wgOyQjyEN/wId2NHUKeyvVQiZ2HmteJXaXgWG9RS2QftB1RpX1cXA0neQY7TlOuGhICy3HkeVCuNaKemhDr4974V3U0hHZCEytRTFEPzk5st+jZUC/P2+YuBnlmNL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8162C4CEF7;
	Wed, 14 Jan 2026 17:12:59 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH v5 04/12] md: merge mddev serialize_policy into mddev_flags
Date: Thu, 15 Jan 2026 01:12:32 +0800
Message-ID: <20260114171241.3043364-5-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260114171241.3043364-1-yukuai@fnnas.com>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
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
 drivers/md/md-bitmap.c |  4 ++--
 drivers/md/md.c        | 20 ++++++++++++--------
 drivers/md/md.h        |  4 ++--
 drivers/md/raid0.c     |  3 ++-
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid5.c     |  3 ++-
 6 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 84b7e2af6dba..dbe4c4b9a1da 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2085,7 +2085,7 @@ static void bitmap_destroy(struct mddev *mddev)
 		return;
 
 	bitmap_wait_behind_writes(mddev);
-	if (!mddev->serialize_policy)
+	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		mddev_destroy_serial_pool(mddev, NULL);
 
 	mutex_lock(&mddev->bitmap_info.mutex);
@@ -2809,7 +2809,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->serial_info_pool) {
 		/* serial_info_pool is not needed if backlog is zero */
-		if (!mddev->serialize_policy)
+		if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 			mddev_destroy_serial_pool(mddev, NULL);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index be0d33fbf988..21b0bc3088d2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -279,7 +279,8 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 
 		rdev_for_each(temp, mddev) {
 			if (!rdev) {
-				if (!mddev->serialize_policy ||
+				if (!test_bit(MD_SERIALIZE_POLICY,
+					      &mddev->flags) ||
 				    !rdev_need_serial(temp))
 					rdev_uninit_serial(temp);
 				else
@@ -5898,11 +5899,12 @@ static ssize_t serialize_policy_show(struct mddev *mddev, char *page)
 	if (mddev->pers == NULL || (mddev->pers->head.id != ID_RAID1))
 		return sprintf(page, "n/a\n");
 	else
-		return sprintf(page, "%d\n", mddev->serialize_policy);
+		return sprintf(page, "%d\n",
+			       test_bit(MD_SERIALIZE_POLICY, &mddev->flags));
 }
 
 /*
- * Setting serialize_policy to true to enforce write IO is not reordered
+ * Setting MD_SERIALIZE_POLICY enforce write IO is not reordered
  * for raid1.
  */
 static ssize_t
@@ -5915,7 +5917,7 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 
-	if (value == mddev->serialize_policy)
+	if (value == test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		return len;
 
 	err = mddev_suspend_and_lock(mddev);
@@ -5927,11 +5929,13 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		goto unlock;
 	}
 
-	if (value)
+	if (value) {
 		mddev_create_serial_pool(mddev, NULL);
-	else
+		set_bit(MD_SERIALIZE_POLICY, &mddev->flags);
+	} else {
 		mddev_destroy_serial_pool(mddev, NULL);
-	mddev->serialize_policy = value;
+		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
+	}
 unlock:
 	mddev_unlock_and_resume(mddev);
 	return err ?: len;
@@ -6828,7 +6832,7 @@ static void __md_stop_writes(struct mddev *mddev)
 		md_update_sb(mddev, 1);
 	}
 	/* disable policy to guarantee rdevs free resources for serialization */
-	mddev->serialize_policy = 0;
+	clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
 	mddev_destroy_serial_pool(mddev, NULL);
 }
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 297a104fba88..6ee18045f41c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -342,6 +342,7 @@ struct md_cluster_operations;
  * @MD_DELETED: This device is being deleted
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  * @MD_FAILLAST_DEV: Allow last rdev to be removed.
+ * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -360,6 +361,7 @@ enum mddev_flags {
 	MD_DELETED,
 	MD_HAS_SUPERBLOCK,
 	MD_FAILLAST_DEV,
+	MD_SERIALIZE_POLICY,
 };
 
 enum mddev_sb_flags {
@@ -626,8 +628,6 @@ struct mddev {
 
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
-
-	bool	serialize_policy:1;
 };
 
 enum recovery_flags {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 4d567fcf6a7c..d83b2b1c0049 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -28,7 +28,8 @@ module_param(default_layout, int, 0644);
 	 (1L << MD_FAILFAST_SUPPORTED) |\
 	 (1L << MD_HAS_PPL) |		\
 	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
-	 (1L << MD_FAILLAST_DEV))
+	 (1L << MD_FAILLAST_DEV) |	\
+	 (1L << MD_SERIALIZE_POLICY))
 
 /*
  * inform the user of the raid configuration
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 98b5c93810bb..f4c7004888af 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -542,7 +542,7 @@ static void raid1_end_write_request(struct bio *bio)
 				call_bio_endio(r1_bio);
 			}
 		}
-	} else if (rdev->mddev->serialize_policy)
+	} else if (test_bit(MD_SERIALIZE_POLICY, &rdev->mddev->flags))
 		remove_serial(rdev, lo, hi);
 	if (r1_bio->bios[mirror] == NULL)
 		rdev_dec_pending(rdev, conf->mddev);
@@ -1644,7 +1644,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
 					       &mddev->bio_set);
 
-			if (mddev->serialize_policy)
+			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 				wait_for_serialization(rdev, r1_bio);
 		}
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e6a399c52ea0..37325a053fb4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -58,7 +58,8 @@
 
 #define UNSUPPORTED_MDDEV_FLAGS		\
 	((1L << MD_FAILFAST_SUPPORTED) |	\
-	 (1L << MD_FAILLAST_DEV))
+	 (1L << MD_FAILLAST_DEV) |		\
+	 (1L << MD_SERIALIZE_POLICY))
 
 
 #define cpu_to_group(cpu) cpu_to_node(cpu)
-- 
2.51.0

