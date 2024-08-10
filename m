Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D60B14A0B5;
	Sat, 10 Aug 2024 02:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255988; cv=none; b=cp8nDztq6mezzHljoWMAM7ildm3qibxIhbD++ZB4lPDuDl5syRCQbU2Z4+OTSdvhwXbPpE49ESKaBJxbX+jGO34FgVTrT4RMgi7qQhWP2JwKH2HEJkuhmukRiT/dB2baq/o3Vu+qofVKxxibfygevS1jB8hRZYCPQClEFbYbyds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255988; c=relaxed/simple;
	bh=85UhZxktp/puF1w3TBxQjXWLFJnQgLthqCk8//atkdI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ieaqm8K8eSFyAuL7yhVBQCzLCabbLO1T1E7S7t6XMaO08t1q8Q44j/Xr52WzjpaIIRfJkj2wStgdmOe8ILH4rNTNVhbhgjoGFWqgxbscJUM95Ur/ysfWqGIafvqeUPZrUMdbJu5QpV1KrJFtUZx78D7Cvb1v4CXVpvm0dYDEPeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknm3ZgCz4f3jJ4;
	Sat, 10 Aug 2024 10:12:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 05AC61A1745;
	Sat, 10 Aug 2024 10:12:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S20;
	Sat, 10 Aug 2024 10:12:57 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 16/26] md/md-bitmap: merge md_bitmap_close_sync() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:44 +0800
Message-Id: <20240810020854.797814-17-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S20
X-Coremail-Antispam: 1UD129KBjvJXoWxurW3XFy3CFWDWFWxuw1fCrg_yoWrCw1Dpa
	yDJry3C345WFW3X345A3yDu3WFyas7tr9rKryfG3s3uFykXF9xJF4rGa4jq3WqgF13JFZ0
	vws8trW5CF15XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c |  9 ++++-----
 drivers/md/md-bitmap.h | 10 +++++++++-
 drivers/md/raid1.c     |  2 +-
 drivers/md/raid10.c    |  2 +-
 drivers/md/raid5.c     |  2 +-
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index d0163533da14..100551868484 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1654,7 +1654,7 @@ static void bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
 	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 }
 
-void md_bitmap_close_sync(struct bitmap *bitmap)
+static void bitmap_close_sync(struct bitmap *bitmap)
 {
 	/* Sync has finished, and any bitmap chunks that weren't synced
 	 * properly have been aborted.  It remains to us to clear the
@@ -1662,14 +1662,12 @@ void md_bitmap_close_sync(struct bitmap *bitmap)
 	 */
 	sector_t sector = 0;
 	sector_t blocks;
-	if (!bitmap)
-		return;
+
 	while (sector < bitmap->mddev->resync_max_sectors) {
 		bitmap_end_sync(bitmap, sector, &blocks, 0);
 		sector += blocks;
 	}
 }
-EXPORT_SYMBOL(md_bitmap_close_sync);
 
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 {
@@ -1986,7 +1984,7 @@ static int bitmap_load(struct mddev *mddev)
 		bitmap_start_sync(bitmap, sector, &blocks, 0);
 		sector += blocks;
 	}
-	md_bitmap_close_sync(bitmap);
+	bitmap_close_sync(bitmap);
 
 	if (mddev->degraded == 0
 	    || bitmap->events_cleared == mddev->events)
@@ -2714,6 +2712,7 @@ static struct bitmap_operations bitmap_ops = {
 	.endwrite		= bitmap_endwrite,
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
+	.close_sync		= bitmap_close_sync,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 58c114246a2d..56ede16ce5fe 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -251,6 +251,7 @@ struct bitmap_operations {
 			  sector_t *blocks, int degraded);
 	void (*end_sync)(struct bitmap *bitmap, sector_t offset,
 			 sector_t *blocks, int aborted);
+	void (*close_sync)(struct bitmap *bitmap);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -367,7 +368,14 @@ static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
 	mddev->bitmap_ops->end_sync(mddev->bitmap, offset, blocks, aborted);
 }
 
-void md_bitmap_close_sync(struct bitmap *bitmap);
+static inline void md_bitmap_close_sync(struct mddev *mddev)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->close_sync)
+		return;
+
+	mddev->bitmap_ops->close_sync(mddev->bitmap);
+}
+
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 				 sector_t old_lo, sector_t old_hi,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cf787ead3d0d..8f5beba4184c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2787,7 +2787,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		else /* completed sync */
 			conf->fullsync = 0;
 
-		md_bitmap_close_sync(mddev->bitmap);
+		md_bitmap_close_sync(mddev);
 		close_sync(conf);
 
 		if (mddev_is_clustered(mddev)) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3746692f5f1c..19035e9950f1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3216,7 +3216,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			}
 			conf->fullsync = 0;
 		}
-		md_bitmap_close_sync(mddev->bitmap);
+		md_bitmap_close_sync(mddev);
 		close_sync(conf);
 		*skipped = 1;
 		return sectors_skipped;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c566fcc6fd46..06f8a4a55b2b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6501,7 +6501,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 					   &sync_blocks, 1);
 		else /* completed sync */
 			conf->fullsync = 0;
-		md_bitmap_close_sync(mddev->bitmap);
+		md_bitmap_close_sync(mddev);
 
 		return 0;
 	}
-- 
2.39.2

