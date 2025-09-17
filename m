Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB9932D5B5;
	Wed, 17 Sep 2025 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758102305; cv=none; b=djfM6F78RWFkAfgkVXDDipj98zeI19RxNIVwgAaHc2/KkwGqvmsfgNkPWnxvbzi8zKjXsG5fzE7pAZ5pVKFg7PssviqI06hsUgZu/FPYXzk1/BQMT4WVYB7AC2E4Dt15ss1cJELtqe+LJd1TKqDHIBXC5lUf8WGBXV1wbANW0hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758102305; c=relaxed/simple;
	bh=Cq4tVWk1lfd+aqTH8LvsgTdiNK4hHWtwrath5ATienQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dcYU3VEMJE24vUlRDUdKx8VCdLMBeBIDIzqjrm26jScJkYTWdIwl+ujS2SC+Vi/SYLeKqLtzdTAw1OUM3MemfHqdZVBLlOC32KkrHHjCI4zPRjTT4tGeWO5tvUksOhsWwo8mmZkcebNjvHC1tm1ntQ/zqnnTraNimFbodt4n7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cRYlc4vRWzKHMv9;
	Wed, 17 Sep 2025 17:45:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6A66C1A2DD5;
	Wed, 17 Sep 2025 17:45:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0Zg8poSuc1Cw--.51298S8;
	Wed, 17 Sep 2025 17:45:01 +0800 (CST)
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
Subject: [PATCH 4/7] md: factor out sync completion update into helper
Date: Wed, 17 Sep 2025 17:35:05 +0800
Message-Id: <20250917093508.456790-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250917093508.456790-1-linan666@huaweicloud.com>
References: <20250917093508.456790-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0Zg8poSuc1Cw--.51298S8
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1fGr1kGFWxKF4kKFy8Zrb_yoWrZry3p3
	yfKFnxGr1UXFW3XF47J3WkCFWF9r18trWDtrWag397Jr1fKr17GFyY9w17XryDA34kZr4Y
	q3y5Ww4DuF1xWw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1l
	Ox8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErc
	IFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I
	3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxV
	WUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAF
	wI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcI
	k0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j
	6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYzuAUUUUU
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
 drivers/md/md.c | 82 ++++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c4d765d57af7..f4f80d32db98 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9301,6 +9301,51 @@ static bool sync_io_within_limit(struct mddev *mddev)
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
+			mddev->curr_resync = MaxSector;
+		mddev->resync_offset = mddev->curr_resync;
+		break;
+	case ACTION_RECOVER:
+		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			mddev->curr_resync = MaxSector;
+		rcu_read_lock();
+		rdev_for_each_rcu(rdev, mddev)
+			if (mddev->delta_disks >= 0 &&
+			    rdev_needs_recovery(rdev, mddev->curr_resync))
+				rdev->recovery_offset = mddev->curr_resync;
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
+	/* */
+	case ACTION_CHECK:
+	default:
+		break;
+	}
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 #define UPDATE_FREQUENCY (5*60*HZ)
@@ -9316,7 +9361,6 @@ void md_do_sync(struct md_thread *thread)
 	int last_mark,m;
 	sector_t last_check;
 	int skipped = 0;
-	struct md_rdev *rdev;
 	enum sync_action action;
 	const char *desc;
 	struct blk_plug plug;
@@ -9603,46 +9647,14 @@ void md_do_sync(struct md_thread *thread)
 	}
 	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
 
-	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
-	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
-		if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
-			mddev->curr_resync = MaxSector;
-
-		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-			mddev->resync_offset = mddev->curr_resync;
-		} else {
-			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
-			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
-				rcu_read_lock();
-				rdev_for_each_rcu(rdev, mddev)
-					if (mddev->delta_disks >= 0 &&
-					    rdev_needs_recovery(rdev, mddev->curr_resync))
-						rdev->recovery_offset = mddev->curr_resync;
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

