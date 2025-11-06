Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7484832A3C9;
	Thu,  6 Nov 2025 12:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430893; cv=none; b=lpZdcvMJPAvCErxYGCiy/BULa4p45lbnNpKQ6xlDdhO4/K/OOgRrcrlvXt4bXIw+TM2wh9hGluygAXXn9plyzhbIAp3qaetcjxIoEvFco5fyTvjR5UlmFr4jxt+e4b84P1Su44Q3mjn0/zqQMw8WECA47AWiHXd8M5snCJW0aQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430893; c=relaxed/simple;
	bh=4z4AAoxg3wDBA83KA+almwiGh7FzyQTNuQFiIMvLbZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eJKquf2LTgfweQdamZFLQrkdjcXFgDqAjXT5emgXg0IbKy9e44pvkdhgL4kyI+IE6nIfLYSldd4zCaYYPFRBV0tT3wqidhk0RZ9XxEymMJCVhLyR5oxSMurdENV3wH8aXO8pXFemlwwI5ao4lC00LApGukpZZH+SjJzzXGgVdXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYP30Q3zKHMmN;
	Thu,  6 Nov 2025 20:07:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 1C9EF1A018D;
	Thu,  6 Nov 2025 20:08:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S11;
	Thu, 06 Nov 2025 20:08:01 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 07/11] md: factor out sync completion update into helper
Date: Thu,  6 Nov 2025 19:59:31 +0800
Message-Id: <20251106115935.2148714-8-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251106115935.2148714-1-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S11
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1fGr1kGF45AF1kWF43trb_yoWrZry3p3
	yfKFnxGr1UXFW3XF47J3WkAFWrury8tryDtrW3W397Jr1fKrnrGFyY9w1UXryDA34kZr4Y
	q3y5Ww4DuF1xWw7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQeOt
	UUUUU==
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
index 71988d8f5154..76fd9407e022 100644
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
@@ -9609,46 +9653,14 @@ void md_do_sync(struct md_thread *thread)
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

