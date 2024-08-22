Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD011C287;
	Thu, 22 Aug 2024 02:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295137; cv=none; b=ri/oORmWBFMmANlKMWGeMneeCdN7hwQTrjjdJVSSYYnO+PcsJvAI89t/UVJW7fI8LpWFZumhCVb3lvnGUMm6TAlp5+S9ZAL29lwjamtnkfpEZiOlOa9BFsZqtgQQ74xOgzyMyGaVOwEYnrs7wzJ7iGDn+ahjGHMRPPZPlpiEpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295137; c=relaxed/simple;
	bh=fFw14eW9jRvww5NPWerUHcokjImd0D2bBlmhLmwS9VA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n4dzoTNvF7R71m8ZhTXwYXfm/zS9LbeEPBx0pgfXr4A9kp5rHtXcBxzmX/qZ1IRbcPPAlpPvyBWrnimddt0+//qxwbyxc0DAmLprMH7cN1Xtix2qhftOJSY7sIFKM93Vq6UQOyYJR/1hdwSUaRto/BQJLQLsBV7Fl+Hd1vJimyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wq75T48l9z4f3jsK;
	Thu, 22 Aug 2024 10:51:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C626B1A18BF;
	Thu, 22 Aug 2024 10:52:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S30;
	Thu, 22 Aug 2024 10:52:11 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	l@damenly.org,
	xni@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 26/41] md/md-bitmap: merge md_bitmap_end_sync() into bitmap_operations
Date: Thu, 22 Aug 2024 10:47:03 +0800
Message-Id: <20240822024718.2158259-27-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
References: <20240822024718.2158259-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S30
X-Coremail-Antispam: 1UD129KBjvJXoWxXFykAFyDAw17Cw4rWF1kGrg_yoW7Jw1xp3
	9rJa43Cw43WFW3X3WUA34kuFyFvwn7trZrtFyxW3s3WFykWFnxGF4rGFyjqw1qkFyfAFZ8
	Zwn0yrW5CF1UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
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
index de837ce20f9e..c03e94416191 100644
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
@@ -2745,6 +2744,7 @@ static struct bitmap_operations bitmap_ops = {
 	.startwrite		= bitmap_startwrite,
 	.endwrite		= bitmap_endwrite,
 	.start_sync		= bitmap_start_sync,
+	.end_sync		= bitmap_end_sync,
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 6691524bdc80..d6f2d5979da4 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -261,6 +261,7 @@ struct bitmap_operations {
 			 unsigned long sectors, bool success, bool behind);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
+	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
@@ -270,8 +271,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
-			sector_t *blocks);
 void md_bitmap_close_sync(struct bitmap *bitmap);
 void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, bool force);
 void md_bitmap_sync_with_cluster(struct mddev *mddev,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd7e3011a6e6..e5942f0d6fd2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2039,7 +2039,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	/* make sure these bits don't get cleared. */
 	do {
-		md_bitmap_end_sync(mddev->bitmap, s, &sync_blocks);
+		mddev->bitmap_ops->end_sync(mddev, s, &sync_blocks);
 		s += sync_blocks;
 		sectors_to_go -= sync_blocks;
 	} while (sectors_to_go > 0);
@@ -2785,8 +2785,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
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
index 33372d30fa99..15299a7774a0 100644
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

