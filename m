Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D74D2367A8;
	Thu, 11 Sep 2025 02:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757556855; cv=none; b=f+h/e2Qph+uQ9qXD8Hkdx6ixr/60mMUcZLcAXOXoIvN1QFPSaC4Ft5RnNTSot9SgpNG9Rx04sTmwnL1C+GRlTuQMz+P8Vf+K4TA8l5dDRQUL7Te7bViAo68TmY5jMxJiJiwlG8Y9Dq520UeSb3wzXErLA2duR8iv3Lqd2FRE95g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757556855; c=relaxed/simple;
	bh=/wJnKc14oOrRa+msdKdJWf6KvTeiaJcEDP9iio+mXPc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h0dloRqzHUy7o5+U83cTXfIw7hMBgqqlKkH0QC6vKmEYkKyxK+EkcGgpkcocNObQ01IeBfRHtDPmXX+e3Z98Quv2EpUUNjlrqacVQHm/uo35X9eQx1d/7COxmgFyFN7+yphis84xg3jwEPW0Bis+5T7/oVQ1mGPkUhyV+wVvXv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cMh2B4lG2zKHMsF;
	Thu, 11 Sep 2025 10:14:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E5B881A125E;
	Thu, 11 Sep 2025 10:14:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAncIxwMMJonK1mCA--.55496S6;
	Thu, 11 Sep 2025 10:14:10 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH 3/3] md: factor out sync completion update into helper
Date: Thu, 11 Sep 2025 10:04:41 +0800
Message-Id: <20250911020441.2858174-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250911020441.2858174-1-linan666@huaweicloud.com>
References: <20250911020441.2858174-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIxwMMJonK1mCA--.55496S6
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1fGr1kGF45AF1kWF43trb_yoWrur1rp3
	yftF9xGr1UXFWaqF47J3WkAFWrury8trWDtrWag3yfJr1fKrnrGFyFvw1xXryDA3sYyr45
	X345Wr4Du3W7Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUml14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	AKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E
	4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjfU173vUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Repeatedly reading 'mddev->recovery' flags in md_do_sync() may introduce
potential risk if this flag is modified during sync, leading to incorrect
offset updates. Therefore, replace direct 'mddev->recovery' checks with
'action'.

Move sync completion update logic into helper md_finish_sync(), which
improves readability and maintainability.

The reshape completion update remains safe as it only updated after
successful reshape when MD_RECOVERY_INTR is not set and 'curr_resync'
equals 'max_sectors'.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 80 +++++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f3abfc140481..a77c59527d4c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9298,6 +9298,49 @@ static bool sync_io_within_limit(struct mddev *mddev)
 	       (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
 }
 
+/*
+ * Update sync offset and mddev status when sync completes
+ */
+static void md_finish_sync(struct mddev *mddev, enum sync_action action)
+{
+	struct md_rdev *rdev;
+
+	switch (action) {
+	case ACTION_RESYNC:
+	case ACTION_REPAIR:
+		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			mddev->curr_resync_completed = MaxSector;
+		mddev->resync_offset = mddev->curr_resync_completed;
+		break;
+	case ACTION_RECOVER:
+		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			mddev->curr_resync_completed = MaxSector;
+		rcu_read_lock();
+		rdev_for_each_rcu(rdev, mddev)
+			if (mddev->delta_disks >= 0 &&
+			    rdev_needs_recovery(rdev, mddev->curr_resync_completed))
+				rdev->recovery_offset = mddev->curr_resync_completed;
+		rcu_read_unlock();
+		break;
+	case ACTION_RESHAPE:
+		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
+		    mddev->delta_disks > 0 &&
+		    mddev->pers->finish_reshape &&
+		    mddev->pers->size &&
+		    !mddev_is_dm(mddev)) {
+			mddev_lock_nointr(mddev);
+			md_set_array_sectors(mddev, mddev->pers->size(mddev, 0, 0));
+			mddev_unlock(mddev);
+			if (!mddev_is_clustered(mddev))
+				set_capacity_and_notify(mddev->gendisk,
+							mddev->array_sectors);
+		}
+		break;
+	default:
+		break;
+	}
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 #define UPDATE_FREQUENCY (5*60*HZ)
@@ -9313,7 +9356,6 @@ void md_do_sync(struct md_thread *thread)
 	int last_mark,m;
 	sector_t last_check;
 	int skipped = 0;
-	struct md_rdev *rdev;
 	enum sync_action action;
 	const char *desc;
 	struct blk_plug plug;
@@ -9603,46 +9645,14 @@ void md_do_sync(struct md_thread *thread)
 	}
 	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
 
-	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
-	    mddev->curr_resync_completed > MD_RESYNC_ACTIVE) {
-		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-			mddev->curr_resync_completed = MaxSector;
-
-		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-			mddev->resync_offset = mddev->curr_resync_completed;
-		} else {
-			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
-				rcu_read_lock();
-				rdev_for_each_rcu(rdev, mddev)
-					if (mddev->delta_disks >= 0 &&
-					    rdev_needs_recovery(rdev, mddev->curr_resync_completed))
-						rdev->recovery_offset = mddev->curr_resync_completed;
-				rcu_read_unlock();
-			}
-		}
-	}
+	if (mddev->curr_resync > MD_RESYNC_ACTIVE)
+		md_finish_sync(mddev, action);
  skip:
 	/* set CHANGE_PENDING here since maybe another update is needed,
 	 * so other nodes are informed. It should be harmless for normal
 	 * raid */
 	set_mask_bits(&mddev->sb_flags, 0,
 		      BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));
-
-	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-			!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
-			mddev->delta_disks > 0 &&
-			mddev->pers->finish_reshape &&
-			mddev->pers->size &&
-			!mddev_is_dm(mddev)) {
-		mddev_lock_nointr(mddev);
-		md_set_array_sectors(mddev, mddev->pers->size(mddev, 0, 0));
-		mddev_unlock(mddev);
-		if (!mddev_is_clustered(mddev))
-			set_capacity_and_notify(mddev->gendisk,
-						mddev->array_sectors);
-	}
-
 	spin_lock(&mddev->lock);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 		/* We completed so min/max setting can be forgotten if used. */
-- 
2.39.2

