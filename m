Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7CD2D8792;
	Mon, 24 Nov 2025 06:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965934; cv=none; b=PJ+bPc+sy8Ig1vFkxgjhO2n+mOm3/Qg8HrgyX/ZFPHxIo53Clw24ZvF7rxNP9nUGQsNGRujijTaMc2rhaEEUI2urRtIdHs20ydf/QU78sIEGRbwAGUz6vb3qNtosMgRpk62qpy3ckl233a5IBexy5Kn+8mrI1juLW/0KxoyW4PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965934; c=relaxed/simple;
	bh=YCEhcbzzKskmy/tIRthlfoQQbVMSSnqzu3amjU6jMto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beh8pc3Mn1xV1sb0PERo5ox9vJxG6F0OAKq6YXgniOHPVeVJA9Xh7ptkkd7s0cx3Km5Ou4oZKS7snEsfZXkggWvK3SAxlQC1PE3aZyp1YtVnjFmQuYb7A91zToHqFAHFYJkL76o9b2mi+MtqcWPMcAGn01n6Vj2h6xK8pE6D7Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CEFC116C6;
	Mon, 24 Nov 2025 06:32:12 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 03/11] md: merge mddev serialize_policy into mddev_flags
Date: Mon, 24 Nov 2025 14:31:55 +0800
Message-ID: <20251124063203.1692144-4-yukuai@fnnas.com>
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
index 5dcfd0371090..5833cbff4acf 100644
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
@@ -5897,11 +5898,12 @@ static ssize_t serialize_policy_show(struct mddev *mddev, char *page)
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
@@ -5914,7 +5916,7 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err)
 		return err;
 
-	if (value == mddev->serialize_policy)
+	if (value == test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
 		return len;
 
 	err = mddev_suspend_and_lock(mddev);
@@ -5926,11 +5928,13 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -6827,7 +6831,7 @@ static void __md_stop_writes(struct mddev *mddev)
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
index 012d8402af28..bf1f3ab59c83 100644
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
index 74f6729864fa..f405ba7b99a7 100644
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

