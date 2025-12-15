Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7150D31B10F;
	Mon, 15 Dec 2025 03:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768550; cv=none; b=LITnKZbCESj6awj0A7xaY419ctj7/MQdBljdqbn7TOTQvDbmB/TuTZupQqDMmnCKbLY3YBrFUwx/q7IIDZM7UjCOJW4JW6Ntka0bA08sdieipE18/hiJgc++9IbpUF2g8o6qkLIuYTguWBAjwRVn+o79F62eAvVc+ieOCmVmPa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768550; c=relaxed/simple;
	bh=cWywgH99r5rjzcpnBQl1sGtGnr62U8xZWckZrytrO3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SLQ569/nAM1q9RzZjrZW3pVqJWbdoJrz1HCsdUzMQ3lAMiC4xVZVhf1syDz4iIfHRiR9RivZZKj0dZqp5N4F3jA6VQb/q+pQSFTUmVTLSS9jDwwzFNrAQNcKtM2Onv3NL91p0251Dl9zo9MMsk1XgMV+Vbhh8vZyd1U8WKvgG84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dV4tn1Lp2zYQtp8;
	Mon, 15 Dec 2025 11:15:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 11A371A01A5;
	Mon, 15 Dec 2025 11:15:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_dUfT9p8AnuAA--.53622S13;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 09/13] md: factor out sync completion update into helper
Date: Mon, 15 Dec 2025 11:04:40 +0800
Message-Id: <20251215030444.1318434-10-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251215030444.1318434-1-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_dUfT9p8AnuAA--.53622S13
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1fGr1kGF45AF1kWF43trb_yoWrZFy5p3
	yxKFnxGr18XFW3XF47J3WkuFWrury8trWDtrW3W397Jr1fKrnrGFyYvw18XryDA34kZr4Y
	q3y5Ww4DuF1xWw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOPfHDU
	UUU
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
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/md.c | 82 ++++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 29a34594c765..9d89f74196fb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9393,6 +9393,51 @@ static bool sync_io_within_limit(struct mddev *mddev)
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
@@ -9408,7 +9453,6 @@ void md_do_sync(struct md_thread *thread)
 	int last_mark,m;
 	sector_t last_check;
 	int skipped = 0;
-	struct md_rdev *rdev;
 	enum sync_action action;
 	const char *desc;
 	struct blk_plug plug;
@@ -9701,46 +9745,14 @@ void md_do_sync(struct md_thread *thread)
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

