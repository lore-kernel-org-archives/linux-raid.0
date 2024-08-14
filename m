Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5857615575D;
	Wed, 14 Aug 2024 07:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619742; cv=none; b=RH4VcubZCA1QAOHk8ejdo+eqjQxdetv7YAJn349mCiidWwhYq/QP6WrG49AhPcWWSfCCgdbRCLA+eGZYu7nDTlJtFf3pupZcY5W5F1cb4sSTaLNvy+JNK2pBojk75kEF+/KHUgiZD69UqEF1BV0Jc6txiUZj2uYKRLI2uK4cV5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619742; c=relaxed/simple;
	bh=j3O9BqRNaXxy95gbtcnYf/6UPR6/dvyg9R97LV/DmWc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=upqS37gNUbsstjxR++OqGJ1u/4m5maHWNjatPG9MVU/JuvZEG2xJ8Ernsc8E9i+vmC7bkdB+S62rTSXhllq9rb1TWJQGjR7UEEj/7qPQR4W2WgoN+GUklhgyardfTadvdrDNrGb52F5wBdU6gTAAvG1O27r/4wOM1v9fXltMnMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK64yl6z4f3jJG;
	Wed, 14 Aug 2024 15:15:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 650651A0359;
	Wed, 14 Aug 2024 15:15:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S32;
	Wed, 14 Aug 2024 15:15:37 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	hch@infradead.org,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next v2 28/41] md/md-bitmap: mrege md_bitmap_cond_end_sync() into bitmap_operations
Date: Wed, 14 Aug 2024 15:11:00 +0800
Message-Id: <20240814071113.346781-29-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240814071113.346781-1-yukuai1@huaweicloud.com>
References: <20240814071113.346781-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S32
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykAFyDAw1xKFW8uFWDCFg_yoWrZw1Dpw
	4DJFy3C345WFW5Xa4UA3yDuFyFy3s7trZrKryxW34fuFyqgrnrGF4rGFyjq3WDKF13JFZ0
	qwn8Kr45Cr15Wr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Also change the parameter from bitmap to mddev, to avoid access
bitmap outside md-bitmap.c as much as possible.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 6 ++++--
 drivers/md/md-bitmap.h | 2 +-
 drivers/md/raid1.c     | 6 +++---
 drivers/md/raid10.c    | 2 +-
 drivers/md/raid5.c     | 2 +-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ed814bcb1933..b92b8f997fc8 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1690,10 +1690,12 @@ static void bitmap_close_sync(struct mddev *mddev)
 	}
 }
 
-void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
+static void bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
+				 bool force)
 {
 	sector_t s = 0;
 	sector_t blocks;
+	struct bitmap *bitmap = mddev->bitmap;
 
 	if (!bitmap)
 		return;
@@ -1718,7 +1720,6 @@ void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 	bitmap->last_end_sync = jiffies;
 	sysfs_notify_dirent_safe(bitmap->mddev->sysfs_completed);
 }
-EXPORT_SYMBOL(md_bitmap_cond_end_sync);
 
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 			      sector_t old_lo, sector_t old_hi,
@@ -2744,6 +2745,7 @@ static struct bitmap_operations bitmap_ops = {
 	.endwrite		= bitmap_endwrite,
 	.start_sync		= bitmap_start_sync,
 	.end_sync		= bitmap_end_sync,
+	.cond_end_sync		= bitmap_cond_end_sync,
 	.close_sync		= bitmap_close_sync,
 
 	.update_sb		= bitmap_update_sb,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 47e157d9f6be..34c70abe8795 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -261,6 +261,7 @@ struct bitmap_operations {
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
+	void (*cond_end_sync)(struct mddev *mddev, sector_t sector, bool force);
 	void (*close_sync)(struct mddev *mddev);
 
 	void (*update_sb)(struct bitmap *bitmap);
@@ -271,7 +272,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
 				 sector_t old_lo, sector_t old_hi,
 				 sector_t new_lo, sector_t new_hi);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fffd94119f0a..869226752a63 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2827,9 +2827,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	 * sector_nr + two times RESYNC_SECTORS
 	 */
 
-	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
-		mddev_is_clustered(mddev) && (sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
-
+	mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
+		mddev_is_clustered(mddev) &&
+		(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
 	if (raise_barrier(conf, sector_nr))
 		return 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 10df08394ebb..45bcda686def 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3543,7 +3543,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * safety reason, which ensures curr_resync_completed is
 		 * updated in bitmap_cond_end_sync.
 		 */
-		md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
+		mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
 					mddev_is_clustered(mddev) &&
 					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d2b8d2517abf..87b8d19ab601 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6540,7 +6540,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		return sync_blocks * RAID5_STRIPE_SECTORS(conf);
 	}
 
-	md_bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
+	mddev->bitmap_ops->cond_end_sync(mddev, sector_nr, false);
 
 	sh = raid5_get_active_stripe(conf, NULL, sector_nr,
 				     R5_GAS_NOBLOCK);
-- 
2.39.2

