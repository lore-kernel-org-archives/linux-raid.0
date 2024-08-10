Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C2113D537;
	Sat, 10 Aug 2024 02:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255984; cv=none; b=IsyFE0sWF5plRQIYYb4+cO6QXZBDlgD/qwIoRO9Rkc91sjvmujAOybsfoK9TuaEJFkVURz6Vd/clV9ZKJyS0o7vdXVDujw3mPFI+As2RrtNUvokNxkDRqGpzfPRaFuW9HmO/etwU735tn/UA8NA8bCN9oRZp90Lg3RX5mabWmD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255984; c=relaxed/simple;
	bh=tDCd78oqtNMe3t9kch1dy9Ak9MX/TYUzcriY75aB3xk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lwz/U9rtCO0/HNvt9JfmrVGYNZBm6AQ17kqNaUbv6XrjMzDf3Gx9iqcObUPiqq1dzZisvFkGMcP3aDq2abmWY87FBtOkEpM2LK4+UaU1iXj3W01IY1kKqJqxPn5z3fhMn7Op6nBV83ctTlOnj9iw2EhnXKsmSJVnJW3z3fL2N2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknr3Rm1z4f3jkK;
	Sat, 10 Aug 2024 10:12:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9758B1A058E;
	Sat, 10 Aug 2024 10:12:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S19;
	Sat, 10 Aug 2024 10:12:57 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 15/26] md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:43 +0800
Message-Id: <20240810020854.797814-16-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240810020854.797814-1-yukuai1@huaweicloud.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S19
X-Coremail-Antispam: 1UD129KBjvJXoWxtF4UWFy5Wry8JFW5Gr4fuFg_yoWxGr4fp3
	yDtFy3G3y5WFW3X3WUA3yDCFyFy3s7tr9rtFyfW3s3uFykGFnxGF48GFyjq3WqkFyfAFs0
	vwn0yrW5CF1UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 15 ++++++---------
 drivers/md/md-bitmap.h | 14 +++++++++++++-
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid10.c    |  5 ++---
 drivers/md/raid5.c     |  2 +-
 5 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b20b6585fc44..d0163533da14 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1627,15 +1627,12 @@ static int bitmap_start_sync(struct bitmap *bitmap, sector_t offset,
 	return rv;
 }
 
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted)
+static void bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
+			    sector_t *blocks, int aborted)
 {
 	bitmap_counter_t *bmc;
 	unsigned long flags;
 
-	if (bitmap == NULL) {
-		*blocks = 1024;
-		return;
-	}
 	spin_lock_irqsave(&bitmap->counts.lock, flags);
 	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
 	if (bmc == NULL)
@@ -1656,7 +1653,6 @@ void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks
  unlock:
 	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 }
-EXPORT_SYMBOL(md_bitmap_end_sync);
 
 void md_bitmap_close_sync(struct bitmap *bitmap)
 {
@@ -1669,7 +1665,7 @@ void md_bitmap_close_sync(struct bitmap *bitmap)
 	if (!bitmap)
 		return;
 	while (sector < bitmap->mddev->resync_max_sectors) {
-		md_bitmap_end_sync(bitmap, sector, &blocks, 0);
+		bitmap_end_sync(bitmap, sector, &blocks, 0);
 		sector += blocks;
 	}
 }
@@ -1697,7 +1693,7 @@ void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 	sector &= ~((1ULL << bitmap->counts.chunkshift) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
-		md_bitmap_end_sync(bitmap, s, &blocks, 0);
+		bitmap_end_sync(bitmap, s, &blocks, 0);
 		s += blocks;
 	}
 	bitmap->last_end_sync = jiffies;
@@ -1713,7 +1709,7 @@ void md_bitmap_sync_with_cluster(struct mddev *mddev,
 	sector_t sector, blocks = 0;
 
 	for (sector = old_lo; sector < new_lo; ) {
-		md_bitmap_end_sync(bitmap, sector, &blocks, 0);
+		bitmap_end_sync(bitmap, sector, &blocks, 0);
 		sector += blocks;
 	}
 	WARN((blocks > new_lo) && old_lo, "alignment is not correct for lo\n");
@@ -2717,6 +2713,7 @@ static struct bitmap_operations bitmap_ops = {
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
 	.start_sync		= bitmap_start_sync,
+	.end_sync		= bitmap_end_sync,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 118141b6caeb..58c114246a2d 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -249,6 +249,8 @@ struct bitmap_operations {
 			 unsigned long sectors, int success, int behind);
 	int (*start_sync)(struct bitmap *bitmap, sector_t offset,
 			  sector_t *blocks, int degraded);
+	void (*end_sync)(struct bitmap *bitmap, sector_t offset,
+			 sector_t *blocks, int aborted);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -354,7 +356,17 @@ static inline int md_bitmap_start_sync(struct mddev *mddev, sector_t offset,
 					     degraded);
 }
 
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
+static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
+				      sector_t *blocks, int aborted)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->end_sync) {
+		*blocks = 1024;
+		return;
+	}
+
+	mddev->bitmap_ops->end_sync(mddev->bitmap, offset, blocks, aborted);
+}
+
 void md_bitmap_close_sync(struct bitmap *bitmap);
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e86cf05f9870..cf787ead3d0d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2036,7 +2036,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	/* make sure these bits don't get cleared. */
 	do {
-		md_bitmap_end_sync(mddev->bitmap, s, &sync_blocks, 1);
+		md_bitmap_end_sync(mddev, s, &sync_blocks, 1);
 		s += sync_blocks;
 		sectors_to_go -= sync_blocks;
 	} while (sectors_to_go > 0);
@@ -2782,7 +2782,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * We can find the current addess in mddev->curr_resync
 		 */
 		if (mddev->curr_resync < max_sector) /* aborted */
-			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
+			md_bitmap_end_sync(mddev, mddev->curr_resync,
 					   &sync_blocks, 1);
 		else /* completed sync */
 			conf->fullsync = 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 20c0ccf28ef5..3746692f5f1c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3191,13 +3191,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (mddev->curr_resync < max_sector) { /* aborted */
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
-				md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
+				md_bitmap_end_sync(mddev, mddev->curr_resync,
 						   &sync_blocks, 1);
 			else for (i = 0; i < conf->geo.raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
-				md_bitmap_end_sync(mddev->bitmap, sect,
-						   &sync_blocks, 1);
+				md_bitmap_end_sync(mddev, sect, &sync_blocks, 1);
 			}
 		} else {
 			/* completed sync */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a2688987a2d0..c566fcc6fd46 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6497,7 +6497,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		}
 
 		if (mddev->curr_resync < max_sector) /* aborted */
-			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
+			md_bitmap_end_sync(mddev, mddev->curr_resync,
 					   &sync_blocks, 1);
 		else /* completed sync */
 			conf->fullsync = 0;
-- 
2.39.2

