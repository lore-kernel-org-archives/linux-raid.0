Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6605178289;
	Thu, 22 Aug 2024 02:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295134; cv=none; b=RnA0I9o130ZG89AO04yZdKqxbw1jR6Dt0eX9HJLW2XCRKV3dGnIbOfCflOBrsemFK0qw4dymVOuuGfV/Fi+GQUYn9uQQC5hDBtKNKNo5zVpcSQ+UpwH2mHRPVBn1BObI2PwRowpds4emnxMnJ9ZIIQid+0y4rdxevH3zOhH8Zo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295134; c=relaxed/simple;
	bh=NHWvoDZAUaROAjuqz2b9OyP3Mq0tOJCqHg/XkKq/mY0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6+H6V88WBS7s6Cw1GPLQQ7qVEDzHtzL+uJ25Nox1X/NJfPAUqubLKT8C0GvWYa2nK1IwVsjjx3goM5wKyOOxar6OyIq1FDYYzCQgmDhusYsn3lBatgQyF4F/JEBzyNJ+Zna7G9R651r392+IK/EgsNwNh2S4LEP9Dp5zTDwcrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wq75P0Jtqz4f3nJr;
	Thu, 22 Aug 2024 10:51:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2CF471A0568;
	Thu, 22 Aug 2024 10:52:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoTNp8ZmyXl2CQ--.42363S22;
	Thu, 22 Aug 2024 10:52:07 +0800 (CST)
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
Subject: [PATCH md-6.12 18/41] md/md-bitmap: merge md_bitmap_status() into bitmap_operations
Date: Thu, 22 Aug 2024 10:46:55 +0800
Message-Id: <20240822024718.2158259-19-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAXPoTNp8ZmyXl2CQ--.42363S22
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr18KFWrKrWktr48AF1UZFb_yoW7ZFy5pa
	yjqa45Cr45XrWrXw1UXFyv9Fy5Xwn5Kr9rtryxK3s5CFnFqFnxuF4xGFyUtw1UCFy3AFsx
	Zw45tr4UW3yjqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  |  4 ++--
 drivers/md/md-bitmap.h  |  3 +--
 drivers/md/md-cluster.c |  8 ++++----
 drivers/md/md.c         | 11 ++++++-----
 drivers/md/raid1.c      |  2 +-
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8008a5ab7b6a..e1ae50c7a551 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2105,7 +2105,7 @@ void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
 }
 EXPORT_SYMBOL_GPL(md_bitmap_set_pages);
 
-int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
+static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
 	struct bitmap_storage *storage;
 	struct bitmap_counts *counts;
@@ -2131,7 +2131,6 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	stats->events_cleared = bitmap->events_cleared;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		  int chunksize, int init)
@@ -2723,6 +2722,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 
 	.update_sb		= bitmap_update_sb,
+	.get_stats		= bitmap_get_stats,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index ca0d8696136f..1df238cb82f0 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -253,6 +253,7 @@ struct bitmap_operations {
 	void (*flush)(struct mddev *mddev);
 
 	void (*update_sb)(struct bitmap *bitmap);
+	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 };
 
 /* the bitmap API */
@@ -260,8 +261,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
-
 int  md_bitmap_setallbits(struct bitmap *bitmap);
 void md_bitmap_write_all(struct bitmap *bitmap);
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index ca30881556bd..a5f1135cc1fa 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1148,7 +1148,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 	unsigned long my_pages;
 	int i, rv;
 
-	rv = md_bitmap_get_stats(bitmap, &stats);
+	rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 	if (rv)
 		return rv;
 
@@ -1175,7 +1175,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			goto out;
 		}
 
-		rv = md_bitmap_get_stats(bitmap, &stats);
+		rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 		if (rv)
 			goto out;
 		/*
@@ -1225,7 +1225,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 	char str[64];
 	int i, rv;
 
-	rv = md_bitmap_get_stats(bitmap, &stats);
+	rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 	if (rv)
 		return rv;
 
@@ -1258,7 +1258,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 			mddev->bitmap_ops->update_sb(bitmap);
 		lockres_free(bm_lockres);
 
-		rv = md_bitmap_get_stats(bitmap, &stats);
+		rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 		if (rv) {
 			md_bitmap_free(bitmap);
 			return rv;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ce92fe943f61..3a612094bc2d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1378,7 +1378,7 @@ static u64 md_bitmap_events_cleared(struct mddev *mddev)
 	struct md_bitmap_stats stats;
 	int err;
 
-	err = md_bitmap_get_stats(mddev->bitmap, &stats);
+	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 	if (err)
 		return 0;
 
@@ -2354,11 +2354,12 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 		return 0;
 
 	if (!rdev->mddev->bitmap_info.file) {
+		struct mddev *mddev = rdev->mddev;
 		struct md_bitmap_stats stats;
 		int err;
 
-		err = md_bitmap_get_stats(rdev->mddev->bitmap, &stats);
-		if (!err && rdev->sb_start + rdev->mddev->bitmap_info.offset +
+		err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
+		if (!err && rdev->sb_start + mddev->bitmap_info.offset +
 		    stats.file_pages * (PAGE_SIZE >> 9) > new_offset)
 			return 0;
 	}
@@ -7588,7 +7589,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		} else {
 			struct md_bitmap_stats stats;
 
-			rv = md_bitmap_get_stats(mddev->bitmap, &stats);
+			rv = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 			if (rv)
 				goto err;
 
@@ -8388,7 +8389,7 @@ static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
 	unsigned long chunk_kb;
 	int err;
 
-	err = md_bitmap_get_stats(mddev->bitmap, &stats);
+	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 	if (err)
 		return;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f9861f9103c2..d0bc5565057e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1612,7 +1612,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			 * Not if there are too many, or cannot
 			 * allocate memory, or a reader on WriteMostly
 			 * is waiting for behind writes to flush */
-			err = md_bitmap_get_stats(bitmap, &stats);
+			err = mddev->bitmap_ops->get_stats(bitmap, &stats);
 			if (!err && write_behind && !stats.behind_wait &&
 			    stats.behind_writes < max_write_behind)
 				alloc_behind_master_bio(r1_bio, bio);
-- 
2.39.2

