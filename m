Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6332614A0AA;
	Sat, 10 Aug 2024 02:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255987; cv=none; b=CnrdWZYu+YENZpZi2yXgjfSxIqFWKwwixJ8rJEHWBtDaz4zYey4vFquWPNml16qOplx+o4EdpoDQTnKl26UHAZCiad8wvsvDwqf8GliylFMdgC1f+EZfDFKkLGticFkGTE9Uy1xymBTUc4qv9fNr3kuGAUjYn0F7xI9bByPYbBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255987; c=relaxed/simple;
	bh=JWUJ+/sdpbN5vmS9PwBk/EOLMtVQyw8njMOOh6kT50M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JtLvnI1IoaQgkuVEI/VK9BF20x0mbC1t5aN1N0eBQfiKRfswATLyqLm0RpDe7BUzWE1CmTZ1D0FX0DK2TT8tGlR02NSk8KM8omZwR/WDqNKaqs1KVG86lR+O+2FBw0Oma+Ws4aPXJotLtPlfVofYHPMdjV1GaTdm04uSN4s5SmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknl5Xtdz4f3jrp;
	Sat, 10 Aug 2024 10:12:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 476101A0359;
	Sat, 10 Aug 2024 10:12:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S18;
	Sat, 10 Aug 2024 10:12:57 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 14/26] md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:42 +0800
Message-Id: <20240810020854.797814-15-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S18
X-Coremail-Antispam: 1UD129KBjvJXoW3JrW3GF18JF1xCFy7uF48WFg_yoWxuF1kpa
	1DJFy3K3y5Way5Xa4UCryDuF1Fyas7trZrtryfWwn8uFykGFnrXF40gFyjq3WUGFy3tFZ0
	vwn0yF45CryaqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c | 10 +++++-----
 drivers/md/md-bitmap.h | 13 ++++++++++++-
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid10.c    |  6 +++---
 drivers/md/raid5.c     |  4 ++--
 5 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index d726e571406d..b20b6585fc44 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1604,8 +1604,8 @@ static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t
 	return rv;
 }
 
-int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
-			 int degraded)
+static int bitmap_start_sync(struct bitmap *bitmap, sector_t offset,
+			     sector_t *blocks, int degraded)
 {
 	/* bitmap_start_sync must always report on multiples of whole
 	 * pages, otherwise resync (which is very PAGE_SIZE based) will
@@ -1626,7 +1626,6 @@ int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *block
 	}
 	return rv;
 }
-EXPORT_SYMBOL(md_bitmap_start_sync);
 
 void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted)
 {
@@ -1720,7 +1719,7 @@ void md_bitmap_sync_with_cluster(struct mddev *mddev,
 	WARN((blocks > new_lo) && old_lo, "alignment is not correct for lo\n");
 
 	for (sector = old_hi; sector < new_hi; ) {
-		md_bitmap_start_sync(bitmap, sector, &blocks, 0);
+		bitmap_start_sync(bitmap, sector, &blocks, 0);
 		sector += blocks;
 	}
 	WARN((blocks > new_hi) && old_hi, "alignment is not correct for hi\n");
@@ -1988,7 +1987,7 @@ static int bitmap_load(struct mddev *mddev)
 	 */
 	while (sector < mddev->resync_max_sectors) {
 		sector_t blocks;
-		md_bitmap_start_sync(bitmap, sector, &blocks, 0);
+		bitmap_start_sync(bitmap, sector, &blocks, 0);
 		sector += blocks;
 	}
 	md_bitmap_close_sync(bitmap);
@@ -2717,6 +2716,7 @@ static struct bitmap_operations bitmap_ops = {
 
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
+	.start_sync		= bitmap_start_sync,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 3a8be496d9b2..118141b6caeb 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -247,6 +247,8 @@ struct bitmap_operations {
 			  unsigned long sectors, int behind);
 	void (*endwrite)(struct bitmap *bitmap, sector_t offset,
 			 unsigned long sectors, int success, int behind);
+	int (*start_sync)(struct bitmap *bitmap, sector_t offset,
+			  sector_t *blocks, int degraded);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -342,7 +344,16 @@ static inline void md_bitmap_endwrite(struct mddev *mddev, sector_t offset,
 				    behind);
 }
 
-int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
+static inline int md_bitmap_start_sync(struct mddev *mddev, sector_t offset,
+				       sector_t *blocks, int degraded)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->start_sync)
+		return -EOPNOTSUPP;
+
+	return mddev->bitmap_ops->start_sync(mddev->bitmap, offset, blocks,
+					     degraded);
+}
+
 void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
 void md_bitmap_close_sync(struct bitmap *bitmap);
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 670ed59d3453..e86cf05f9870 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2807,7 +2807,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	/* before building a request, check if we can skip these blocks..
 	 * This call the bitmap_start_sync doesn't actually record anything
 	 */
-	if (!md_bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
+	if (!md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, 1) &&
 	    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		/* We can skip this block, and probably several more */
 		*skipped = 1;
@@ -2982,7 +2982,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (len == 0)
 			break;
 		if (sync_blocks == 0) {
-			if (!md_bitmap_start_sync(mddev->bitmap, sector_nr,
+			if (!md_bitmap_start_sync(mddev, sector_nr,
 						  &sync_blocks, still_degraded) &&
 			    !conf->fullsync &&
 			    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2876686a9bf2..20c0ccf28ef5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3319,7 +3319,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			 * we only need to recover the block if it is set in
 			 * the bitmap
 			 */
-			must_sync = md_bitmap_start_sync(mddev->bitmap, sect,
+			must_sync = md_bitmap_start_sync(mddev, sect,
 							 &sync_blocks, 1);
 			if (sync_blocks < max_sync)
 				max_sync = sync_blocks;
@@ -3363,7 +3363,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				}
 			}
 
-			must_sync = md_bitmap_start_sync(mddev->bitmap, sect,
+			must_sync = md_bitmap_start_sync(mddev, sect,
 							 &sync_blocks, still_degraded);
 
 			any_working = 0;
@@ -3541,7 +3541,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					mddev_is_clustered(mddev) &&
 					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
-		if (!md_bitmap_start_sync(mddev->bitmap, sector_nr,
+		if (!md_bitmap_start_sync(mddev, sector_nr,
 					  &sync_blocks, mddev->degraded) &&
 		    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED,
 						 &mddev->recovery)) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2e54115da719..a2688987a2d0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6530,7 +6530,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	}
 	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    !conf->fullsync &&
-	    !md_bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, 1) &&
+	    !md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, 1) &&
 	    sync_blocks >= RAID5_STRIPE_SECTORS(conf)) {
 		/* we can skip this block, and probably more */
 		do_div(sync_blocks, RAID5_STRIPE_SECTORS(conf));
@@ -6561,7 +6561,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 			still_degraded = 1;
 	}
 
-	md_bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
+	md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, still_degraded);
 
 	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
 	set_bit(STRIPE_HANDLE, &sh->state);
-- 
2.39.2

