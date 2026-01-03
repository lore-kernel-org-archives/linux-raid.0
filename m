Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8609A17BB35
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767455161; cv=none; b=cwftK3NMdvNsCmX6ardC44goNvZCvCESPf+ktonWaeiBtbl8gVQOciTHl85T/NMv9Out5TDBLqN7TiiX5qgSVQkTZ8DIeHFsxox8hxdjypSTsu6qv6e1Q2wsOxZ5GV/dc5nHVo09Mw7fAS0F5iO+W9lshxAT+71UqQDwrebGWWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767455161; c=relaxed/simple;
	bh=1pXG+4nxndon+Ub7D0aa5F0tfVga0/ae+BbHb8elDjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFwpcYtWU/DC1Olmb4JM6Txe/D+aryjCcObfcdVxd89nrT+wytK6mhtNdz1yVodmZfGAAhu6JLQj7hf3XdKLgV1+/5syU8qYCkeNnAzA3dQZZjIv8OUvbigIsk9TuSvuPesfvBSRjU8xzOZXvo0jXIsgiTJ2hJrgWMoiD+uL/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F4BC113D0;
	Sat,  3 Jan 2026 15:45:57 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: yukuai@fnnas.com,
	colyli@fnnas.com,
	linan122@huawei.com
Subject: [PATCH v2 01/11] md: merge mddev has_superblock into mddev_flags
Date: Sat,  3 Jan 2026 23:45:33 +0800
Message-ID: <20260103154543.832844-2-yukuai@fnnas.com>
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

