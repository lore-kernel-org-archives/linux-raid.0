Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934DB1C7013;
	Wed, 19 Feb 2025 08:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954327; cv=none; b=YnO/CluNV3W6mB4GJyhVmvjIaY2vYm0lsKdTGj8ldleOFh8c8b8HhJLRAIcRFmsJ9g+g849hpQAA2/rD714t/Mplrn5mRz4wsHfzIVQhifk8ZWKZUPbktgN3nPyekY2YscEvW7sIMl+4Ezx3S6+vRibU4QBUVa09Zq48qLrby80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954327; c=relaxed/simple;
	bh=7v9KLcPmQbOBHXtC8Fk7V+NhZOCYo9e2RAUB7jV1+Nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=povlwlsrzZYCYYURxgtIlX4txD0qneBmgmD8/vyy0Iu7gG/n3wT1AiITNahOCSxT5ahqswxkpgtxb7eu1/Tdm9F/R7xYCJ7N1+tqy4yxaYvbyuHkNp5e+YCCu+9Dn4KOAlSdhCVbaxQHsaxqzP6VXGy6nhcxndDyj0eRMMK4q8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YyVCf37NXz4f3jt3;
	Wed, 19 Feb 2025 16:38:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B48491A0F6F;
	Wed, 19 Feb 2025 16:38:38 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXvGCImLVn4yQeEQ--.36560S9;
	Wed, 19 Feb 2025 16:38:38 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 v4 05/11] md/md-bitmap: handle the case bitmap is not enabled before end_sync()
Date: Wed, 19 Feb 2025 16:34:50 +0800
Message-Id: <20250219083456.941760-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250219083456.941760-1-yukuai1@huaweicloud.com>
References: <20250219083456.941760-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXvGCImLVn4yQeEQ--.36560S9
X-Coremail-Antispam: 1UD129KBjvJXoWxXryfuF1DXrWrCryUJFy8AFb_yoWrGw4xp3
	9rJFW3uw17WFW5X3WUZ34kuFyFvwnrtr9FyFyxW3s3uFyrXF9rGF4rGFyjqw1qka4fAFZ8
	X345CrW5CF1UWrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This case can be handled without knowing internal implementation.

Prepare to introduce CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  4 ----
 drivers/md/md-bitmap.h | 11 +++++++++++
 drivers/md/raid1.c     |  6 +++---
 drivers/md/raid10.c    |  8 +++-----
 drivers/md/raid5.c     |  4 ++--
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index c7f3dfdec51f..dc937cd9d46a 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1822,10 +1822,6 @@ static void __bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
 	bitmap_counter_t *bmc;
 	unsigned long flags;
 
-	if (bitmap == NULL) {
-		*blocks = 1024;
-		return;
-	}
 	spin_lock_irqsave(&bitmap->counts.lock, flags);
 	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
 	if (bmc == NULL)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 6a5806ebb11a..fefa00bc438e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -145,4 +145,15 @@ static inline bool md_bitmap_start_sync(struct mddev *mddev, sector_t offset,
 	return mddev->bitmap_ops->start_sync(mddev, offset, blocks, degraded);
 }
 
+static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
+				      sector_t *blocks)
+{
+	if (!md_bitmap_enabled(mddev)) {
+		*blocks = 1024;
+		return;
+	}
+
+	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
+}
+
 #endif
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0cb39b8203f2..5b6a7c5e9806 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2062,7 +2062,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	/* make sure these bits don't get cleared. */
 	do {
-		mddev->bitmap_ops->end_sync(mddev, s, &sync_blocks);
+		md_bitmap_end_sync(mddev, s, &sync_blocks);
 		s += sync_blocks;
 		sectors_to_go -= sync_blocks;
 	} while (sectors_to_go > 0);
@@ -2804,8 +2804,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * We can find the current addess in mddev->curr_resync
 		 */
 		if (mddev->curr_resync < max_sector) /* aborted */
-			mddev->bitmap_ops->end_sync(mddev, mddev->curr_resync,
-						    &sync_blocks);
+			md_bitmap_end_sync(mddev, mddev->curr_resync,
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7a5062f404a6..82ff326d56aa 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3229,15 +3229,13 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (mddev->curr_resync < max_sector) { /* aborted */
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
-				mddev->bitmap_ops->end_sync(mddev,
-							    mddev->curr_resync,
-							    &sync_blocks);
+				md_bitmap_end_sync(mddev, mddev->curr_resync,
+						   &sync_blocks);
 			else for (i = 0; i < conf->geo.raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
 
-				mddev->bitmap_ops->end_sync(mddev, sect,
-							    &sync_blocks);
+				md_bitmap_end_sync(mddev, sect, &sync_blocks);
 			}
 		} else {
 			/* completed sync */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c8bf1eb29241..908b96c2b1d5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6501,8 +6501,8 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		}
 
 		if (mddev->curr_resync < max_sector) /* aborted */
-			mddev->bitmap_ops->end_sync(mddev, mddev->curr_resync,
-						    &sync_blocks);
+			md_bitmap_end_sync(mddev, mddev->curr_resync,
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 		mddev->bitmap_ops->close_sync(mddev);
-- 
2.39.2

