Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843C72D322E
	for <linux-raid@vger.kernel.org>; Wed, 14 Jan 2026 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410776; cv=none; b=CXjr1Yd1WX7FAQhRkUj3XmDbGFcRhWAMzgWjmTFtaFKjGrsMZUpQMJfP9W2tUx60q/fcqBcD0bIvrpoJ8ov7tAA9/GeMyxBh/IOv4D9j6U4qx+FTbPjuqw2qHAygSEK9DcN8tc9n2Jrn4OsL5XK5+oS+/PvdgJrWGGBAV4MZS3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410776; c=relaxed/simple;
	bh=1pXG+4nxndon+Ub7D0aa5F0tfVga0/ae+BbHb8elDjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJXfn1nVamBGALsPMPBfSR1IzVgB4jbXn2WZvLGrOPBGfyMMdBmvimvXVdM7agkxlaqAKPVE3DukPj69tryT1RC/vtCXPQHtL2p4SWLnYxARE42d19iPay3M8jvUYuwshVQiIfKxKqSBV75du52a1FqKZMAJenl3X680uaxki/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7FAC19421;
	Wed, 14 Jan 2026 17:12:52 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com,
	dan.carpenter@linaro.org
Subject: [PATCH v5 02/12] md: merge mddev has_superblock into mddev_flags
Date: Thu, 15 Jan 2026 01:12:30 +0800
Message-ID: <20260114171241.3043364-3-yukuai@fnnas.com>
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
 drivers/md/md.c | 6 +++---
 drivers/md/md.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e5922a682953..91a30ed6b01e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6463,7 +6463,7 @@ int md_run(struct mddev *mddev)
 	 * the only valid external interface is through the md
 	 * device.
 	 */
-	mddev->has_superblocks = false;
+	clear_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
 	rdev_for_each(rdev, mddev) {
 		if (test_bit(Faulty, &rdev->flags))
 			continue;
@@ -6476,7 +6476,7 @@ int md_run(struct mddev *mddev)
 		}
 
 		if (rdev->sb_page)
-			mddev->has_superblocks = true;
+			set_bit(MD_HAS_SUPERBLOCK, &mddev->flags);
 
 		/* perform some consistency tests on the device.
 		 * We don't want the data to overlap the metadata,
@@ -9086,7 +9086,7 @@ void md_write_start(struct mddev *mddev, struct bio *bi)
 	rcu_read_unlock();
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
-	if (!mddev->has_superblocks)
+	if (!test_bit(MD_HAS_SUPERBLOCK, &mddev->flags))
 		return;
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6985f2829bbd..b4c9aa600edd 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -340,6 +340,7 @@ struct md_cluster_operations;
  *		   array is ready yet.
  * @MD_BROKEN: This is used to stop writes and mark array as failed.
  * @MD_DELETED: This device is being deleted
+ * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -356,6 +357,7 @@ enum mddev_flags {
 	MD_BROKEN,
 	MD_DO_DELETE,
 	MD_DELETED,
+	MD_HAS_SUPERBLOCK,
 };
 
 enum mddev_sb_flags {
@@ -623,7 +625,6 @@ struct mddev {
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
-	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
 };
-- 
2.51.0

