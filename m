Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9D82116E9
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907212; cv=none; b=Xr05GPP9+tr5sYSSjOvi9md/mz9fUyU5D7f9HRWB9mBTTGLD7+zHDKwtfXC1kMF4JEMMDRY4WUUqqDcj3W52KEWbNyRbCMk9R7JzJcTqyodUM8LsUjA8EsUT4VAj0zoq9VSTlzehPAjLTt7Q2G4mqIa8jgJOKXlefBtQtjdRqwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907212; c=relaxed/simple;
	bh=cOfq4KuYWwf9fTsv9HVCLaINypPQ5fZG+j38sLzQweg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJGVqBFehaG6G7ahJacCAkHm+Wj08rXUunaERoQqxL/le2BBnmMjQXQyIeSwljl2cOl6Q6UwBfI+xu1Vfktm5KuAUK37YpZOaoL2Gvwkj85NWnZ0U1xnhvv/5CwLs/Qhu7CqX0xQDm7PzuRUirGA6urpwC1xqc8ZUUazG0sFOZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEwjpReO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEwjpReO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA8C4CEE3;
	Mon,  7 Jul 2025 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907211;
	bh=cOfq4KuYWwf9fTsv9HVCLaINypPQ5fZG+j38sLzQweg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEwjpReOvhJTGIZzCwowHq13kkPyauFo/Lg1cw5swbaL+OSE72NEbyovZEpg0JPwk
	 oj9873OwuJbIiVbn/P4o3qwmB+fw/vcpiFZo9J6z3ObuAJwQlpTdR9G0pfABnSZm/7
	 rCfUb7prFB2t93AkfgDt7AN1zBtQAYJ4YoZ1eZKte6ALKK8Xv0zNd++Fd/KUAdxsy7
	 1OhpAzf5TpwaOHY/C2gnjRhM4CjS5rZZEH5R1nUfca3x9Q761bEOGx6p0gOLvCF0Wx
	 vlX3oOfwrzXLZyLT5AaOxSf5Rs1XHud4n8sH367qs4xT/k0B/JU3dzjybnrPVlq5Lh
	 QVZC/wDkHtbIA==
From: Yu Kuai <yukuai@kernel.org>
To: hch@lst.de,
	hare@suse.de,
	xni@redhat.com,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 09/11] md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
Date: Tue,  8 Jul 2025 00:52:00 +0800
Message-ID: <20250707165202.11073-10-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707165202.11073-1-yukuai@kernel.org>
References: <20250707165202.11073-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

This flag is used by llbitmap in later patches to skip raid456 initial
recover and delay building initial xor data to first write.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 12 +++++++++++-
 drivers/md/md.h |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 373bee3a7da4..43322d884055 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9164,6 +9164,14 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 				start = rdev->recovery_offset;
 		rcu_read_unlock();
 
+		/*
+		 * If there are no spares, and raid456 lazy initial recover is
+		 * requested.
+		 */
+		if (test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery) &&
+		    start == MaxSector)
+			start = 0;
+
 		/* If there is a bitmap, we need to make sure all
 		 * writes that started before we added a spare
 		 * complete before we start doing a recovery.
@@ -9721,6 +9729,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	if (mddev->recovery_cp < MaxSector) {
 		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+		clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 		return true;
 	}
 
@@ -9730,7 +9739,7 @@ static bool md_choose_sync_action(struct mddev *mddev, int *spares)
 	 * re-add.
 	 */
 	*spares = remove_and_add_spares(mddev, NULL);
-	if (*spares) {
+	if (*spares || test_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery)) {
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
@@ -10053,6 +10062,7 @@ void md_reap_sync_thread(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
+	clear_bit(MD_RECOVERY_LAZY_RECOVER, &mddev->recovery);
 	/*
 	 * We call mddev->cluster_ops->update_size here because sync_size could
 	 * be changed by md_update_sb, and MD_RECOVERY_RESHAPE is cleared,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ed23215c880a..ea8dc5810f24 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -667,6 +667,8 @@ enum recovery_flags {
 	MD_RECOVERY_RESHAPE,
 	/* remote node is running resync thread */
 	MD_RESYNCING_REMOTE,
+	/* raid456 lazy initial recover */
+	MD_RECOVERY_LAZY_RECOVER,
 };
 
 enum md_ro_state {
-- 
2.43.0

