Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFEB154C0B;
	Wed, 14 Aug 2024 07:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619743; cv=none; b=WQNrYHIibz673ZB0o8GiydCrrbznarBYQQEJpwTN4wCN6JJCxSfY2k+WdrjcoDUDAFX/+HiYPYy6a/tzOvsPkIe97jEjy8Bpa7TMzG7oWWiZtYHAae//cJDZELQ4eALXd+eg8jEruHAIgRquejHzoJFIptR0fwk0iZbMzeWx5Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619743; c=relaxed/simple;
	bh=d9M05RoSBiWH9iId5wAN+QUoDgjWwJ5mB18mWJ9Cias=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fsatsJML1uKiPOLNHb+R2vpBRB3piMHjb0qXbm+BStu7GOvMV8WU+i1JvPGiGP8rnh/yLiwJG6pdocBzja6yEpPy5UWIvMIIrzewW/SQigUN7VTlNgHEgihzqkPx3+XfBQApFF82sYeGigud9JLaMYGkX6yrPG44bBRF2UTZx9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKKC1fJlz4f3jM1;
	Wed, 14 Aug 2024 15:15:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8D9261A1637;
	Wed, 14 Aug 2024 15:15:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S30;
	Wed, 14 Aug 2024 15:15:36 +0800 (CST)
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
Subject: [PATCH RFC -next v2 26/41] md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:58 +0800
Message-Id: <20240814071113.346781-27-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S30
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykAFyDAw17Cw4rWr4DArb_yoW7Jw1xp3
	9rJFy3Ww43WFW5X3WUA34kCFyFv3s7tr9rtFyfW3s3uFykXFnxGF4rGFyjqw1qkFy3AFZ8
	Zwn0yrW5CF1UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c |  8 ++++----
 drivers/md/md-bitmap.h |  3 +--
 drivers/md/raid1.c     |  6 +++---
 drivers/md/raid10.c    | 10 ++++++----
 drivers/md/raid5.c     |  4 ++--
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index c18ce8e4ea72..b3649f1d1200 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1665,12 +1665,11 @@ static void __bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
 	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 }
 
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
-			sector_t *blocks)
+static void bitmap_end_sync(struct mddev *mddev, sector_t offset,
+			    sector_t *blocks)
 {
-	__bitmap_end_sync(bitmap, offset, blocks, true);
+	__bitmap_end_sync(mddev->bitmap, offset, blocks, true);
 }
-EXPORT_SYMBOL(md_bitmap_end_sync);
 
 void md_bitmap_close_sync(struct bitmap *bitmap)
 {
@@ -2742,6 +2741,7 @@ static struct bitmap_operations bitmap_ops = {
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
 	.start_sync		= bitmap_start_sync,
+	.end_sync		= bitmap_end_sync,
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 68324757da5a..ff0ca61147e9 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -260,6 +260,7 @@ struct bitmap_operations {
 			 unsigned long sectors, bool success, bool behind);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
+	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
@@ -269,8 +270,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
-			sector_t *blocks);
 void md_bitmap_close_sync(struct bitmap *bitmap);
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1be06a476acf..e7e9e52db795 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2038,7 +2038,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	/* make sure these bits don't get cleared. */
 	do {
-		md_bitmap_end_sync(mddev->bitmap, s, &sync_blocks);
+		mddev->bitmap_ops->end_sync(mddev, s, &sync_blocks);
 		s += sync_blocks;
 		sectors_to_go -= sync_blocks;
 	} while (sectors_to_go > 0);
@@ -2784,8 +2784,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * We can find the current addess in mddev->curr_resync
 		 */
 		if (mddev->curr_resync < max_sector) /* aborted */
-			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-					   &sync_blocks);
+			mddev->bitmap_ops->end_sync(mddev, mddev->curr_resync,
+						    &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 821219dc973e..694522fb5584 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3194,13 +3194,15 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (mddev->curr_resync < max_sector) { /* aborted */
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
-				md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-						   &sync_blocks);
+				mddev->bitmap_ops->end_sync(mddev,
+							    mddev->curr_resync,
+							    &sync_blocks);
 			else for (i = 0; i < conf->geo.raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
-				md_bitmap_end_sync(mddev->bitmap, sect,
-						   &sync_blocks);
+
+				mddev->bitmap_ops->end_sync(mddev, sect,
+							    &sync_blocks);
 			}
 		} else {
 			/* completed sync */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3e9fed1e1153..89ae149bf28e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6497,8 +6497,8 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		}
 
 		if (mddev->curr_resync < max_sector) /* aborted */
-			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-					   &sync_blocks);
+			mddev->bitmap_ops->end_sync(mddev, mddev->curr_resync,
+						    &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 		md_bitmap_close_sync(mddev->bitmap);
-- 
2.39.2

