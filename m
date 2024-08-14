Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053ED153BF8;
	Wed, 14 Aug 2024 07:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619741; cv=none; b=ZLvUqy5G7lEKfsR1zJGcffJM/06xs0Jzwjx4dgUckIVbEzh6Gv0RYqrk373tE4bPPtHLRubJKKk4hihntqD5xuX+gmVJjpogKFUhpLohHc9q3FHeEnczgzHy5wmvhCODImR4VyH07GRJ/n4Oaul2xmQ7oAQ0U1L8Rkn5lRGdsno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619741; c=relaxed/simple;
	bh=pKR4FBftL3SgfyC0/trydJbIBytSF12A26a2zPepzpc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X6qPAdkOOaK/1OfSiGvqr6y4dOb+uaocOisG0FxBJCHnhrDP3tufdlqAI9dlon/ohCCGEZFDaHpmx+yuDHDhE2K3QmqvGt738nzp/ba2ka+jykFReo+llsadwHjoQp5N80IU9bTXJwSKConYsblXq4WZc0LBk+nsfKVN9wQllqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK53Jtjz4f3jJG;
	Wed, 14 Aug 2024 15:15:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2D6CB1A018D;
	Wed, 14 Aug 2024 15:15:36 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S29;
	Wed, 14 Aug 2024 15:15:35 +0800 (CST)
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
Subject: [PATCH RFC -next v2 25/41] md/md-bitmap: remove the parameter 'aborted' for md_bitmap_end_sync()
Date: Wed, 14 Aug 2024 15:10:57 +0800
Message-Id: <20240814071113.346781-26-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S29
X-Coremail-Antispam: 1UD129KBjvJXoW3WFW3ury8KF17tFyUJw1xuFg_yoW7WF4kpa
	yDJFy3G345WFW3X3WUA3yDCFyFyas7tr9rtFyfW3sxuFy8WFnxGF48Ga4jq3WqkF13AFZ0
	qwn8GrW5CFyUXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

For internal callers, aborted are always set to false, while for
external callers, aborted are always set to true.

Hence there is no need to always pass in true for exported api.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 15 +++++++++++----
 drivers/md/md-bitmap.h |  3 ++-
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid10.c    |  4 ++--
 drivers/md/raid5.c     |  2 +-
 5 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index e42a0433e926..c18ce8e4ea72 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1634,7 +1634,8 @@ static bool bitmap_start_sync(struct mddev *mddev, sector_t offset,
 	return rv;
 }
 
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted)
+static void __bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
+			      sector_t *blocks, bool aborted)
 {
 	bitmap_counter_t *bmc;
 	unsigned long flags;
@@ -1663,6 +1664,12 @@ void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks
  unlock:
 	spin_unlock_irqrestore(&bitmap->counts.lock, flags);
 }
+
+void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
+			sector_t *blocks)
+{
+	__bitmap_end_sync(bitmap, offset, blocks, true);
+}
 EXPORT_SYMBOL(md_bitmap_end_sync);
 
 void md_bitmap_close_sync(struct bitmap *bitmap)
@@ -1676,7 +1683,7 @@ void md_bitmap_close_sync(struct bitmap *bitmap)
 	if (!bitmap)
 		return;
 	while (sector < bitmap->mddev->resync_max_sectors) {
-		md_bitmap_end_sync(bitmap, sector, &blocks, 0);
+		__bitmap_end_sync(bitmap, sector, &blocks, false);
 		sector += blocks;
 	}
 }
@@ -1704,7 +1711,7 @@ void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force)
 	sector &= ~((1ULL << bitmap->counts.chunkshift) - 1);
 	s = 0;
 	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
-		md_bitmap_end_sync(bitmap, s, &blocks, 0);
+		__bitmap_end_sync(bitmap, s, &blocks, false);
 		s += blocks;
 	}
 	bitmap->last_end_sync = jiffies;
@@ -1720,7 +1727,7 @@ void md_bitmap_sync_with_cluster(struct mddev *mddev,
 	sector_t sector, blocks = 0;
 
 	for (sector = old_lo; sector < new_lo; ) {
-		md_bitmap_end_sync(bitmap, sector, &blocks, 0);
+		__bitmap_end_sync(bitmap, sector, &blocks, false);
 		sector += blocks;
 	}
 	WARN((blocks > new_lo) && old_lo, "alignment is not correct for lo\n");
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 6fba3ff2f949..68324757da5a 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -269,7 +269,8 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
+void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
+			sector_t *blocks);
 void md_bitmap_close_sync(struct bitmap *bitmap);
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 555b56d15d92..1be06a476acf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2038,7 +2038,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	/* make sure these bits don't get cleared. */
 	do {
-		md_bitmap_end_sync(mddev->bitmap, s, &sync_blocks, 1);
+		md_bitmap_end_sync(mddev->bitmap, s, &sync_blocks);
 		s += sync_blocks;
 		sectors_to_go -= sync_blocks;
 	} while (sectors_to_go > 0);
@@ -2785,7 +2785,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 */
 		if (mddev->curr_resync < max_sector) /* aborted */
 			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-					   &sync_blocks, 1);
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2ab641166c8c..821219dc973e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3195,12 +3195,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (mddev->curr_resync < max_sector) { /* aborted */
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 				md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-						   &sync_blocks, 1);
+						   &sync_blocks);
 			else for (i = 0; i < conf->geo.raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
 				md_bitmap_end_sync(mddev->bitmap, sect,
-						   &sync_blocks, 1);
+						   &sync_blocks);
 			}
 		} else {
 			/* completed sync */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 313904dd6555..3e9fed1e1153 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6498,7 +6498,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 
 		if (mddev->curr_resync < max_sector) /* aborted */
 			md_bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
-					   &sync_blocks, 1);
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 		md_bitmap_close_sync(mddev->bitmap);
-- 
2.39.2

