Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492A813D62A;
	Sat, 10 Aug 2024 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255983; cv=none; b=RiiRyDmDhs7jmRn2e5sEKOX82/D7kQ3G0IvPPOWO7elaTctKxMQ6ad7hJDotPbJ0YY7ZiAxtS8ONkmV97v5BM3wGqBPJAMs6E/oc4rcXik6QbU5n2iDpsVpsF6PKdhIVaWooNp5leEbpAVwBqJb/HvpnTwwxua1oIcKZMrmPDa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255983; c=relaxed/simple;
	bh=bQNaMQmHAUF6WPw1dSnt9QTvbt9vHp3n+0DyGR5TaK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rGVIklsJ9QRXyeJo81MLxw6u8NfXgrkVIbB5VUggaXiGhzc4eLXSm8diWGaC8AefzzGiqB2PPFLzhbidjofRDAzzlDUEmYfFpmieR58eXWUaQ3LksgFA8Z6bIt4ufiRAWkwz1YcpoVa6Ib6VoZqJgil3zKIZaj9ywg4uM4PWgIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknl6QBFz4f3jHy;
	Sat, 10 Aug 2024 10:12:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5E7421A058E;
	Sat, 10 Aug 2024 10:12:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S21;
	Sat, 10 Aug 2024 10:12:58 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 17/26] md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:45 +0800
Message-Id: <20240810020854.797814-18-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S21
X-Coremail-Antispam: 1UD129KBjvJXoWxur47tryrXFyDAFykAr4kCrg_yoWrZr4rpa
	yDtFy3C345WFW3Xa4UA3yDuFyFyas7tFZrKFyxW34fuFyDXFnxGF4rGa4jq3WDKF13JFZ0
	qw45Kr45Cr1kWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c |  7 +++----
 drivers/md/md-bitmap.h | 11 ++++++++++-
 drivers/md/raid1.c     |  2 +-
 drivers/md/raid10.c    |  2 +-
 drivers/md/raid5.c     |  2 +-
 5 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 100551868484..3c09de471634 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1669,13 +1669,12 @@ static void bitmap_close_sync(struct bitmap *bitmap)
 	}
 }
 
-void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
+static void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector,
+				 bool force)
 {
 	sector_t s = 0;
 	sector_t blocks;
 
-	if (!bitmap)
-		return;
 	if (sector == 0) {
 		bitmap->last_end_sync = jiffies;
 		return;
@@ -1697,7 +1696,6 @@ void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 	bitmap->last_end_sync = jiffies;
 	sysfs_notify_dirent_safe(bitmap->mddev->sysfs_completed);
 }
-EXPORT_SYMBOL(md_bitmap_cond_end_sync);
 
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 			      sector_t old_lo, sector_t old_hi,
@@ -2713,6 +2711,7 @@ static struct bitmap_operations bitmap_ops = {
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
 	.close_sync		= bitmap_close_sync,
+	.cond_end_sync		= bitmap_cond_end_sync,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 56ede16ce5fe..71c3610dca7b 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -252,6 +252,7 @@ struct bitmap_operations {
 	void (*end_sync)(struct bitmap *bitmap, sector_t offset,
 			 sector_t *blocks, int aborted);
 	void (*close_sync)(struct bitmap *bitmap);
+	void (*cond_end_sync)(struct bitmap *bitmap, sector_t sector, bool force);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -376,7 +377,15 @@ static inline void md_bitmap_close_sync(struct mddev *mddev)
 	mddev->bitmap_ops->close_sync(mddev->bitmap);
 }
 
-void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
+static inline void md_bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
+					   bool force)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->cond_end_sync)
+		return;
+
+	mddev->bitmap_ops->cond_end_sync(mddev->bitmap, sector, force);
+}
+
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 				 sector_t old_lo, sector_t old_hi,
 				 sector_t new_lo, sector_t new_hi);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8f5beba4184c..c8cd6036441b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2825,7 +2825,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	 * sector_nr + two times RESYNC_SECTORS
 	 */
 
-	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
+	md_bitmap_cond_end_sync(mddev, sector_nr,
 		mddev_is_clustered(mddev) && (sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 19035e9950f1..1ea9b4117b08 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3536,7 +3536,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * safety reason, which ensures curr_resync_completed is
 		 * updated in bitmap_cond_end_sync.
 		 */
-		md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
+		md_bitmap_cond_end_sync(mddev, sector_nr,
 					mddev_is_clustered(mddev) &&
 					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 06f8a4a55b2b..8f0de56c0b23 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6539,7 +6539,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		return sync_blocks * RAID5_STRIPE_SECTORS(conf);
 	}
 
-	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
+	md_bitmap_cond_end_sync(mddev, sector_nr, false);
 
 	sh = raid5_get_active_stripe(conf, NULL, sector_nr,
 				     R5_GAS_NOBLOCK);
-- 
2.39.2

