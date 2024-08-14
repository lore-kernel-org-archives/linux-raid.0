Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5864EAD5A;
	Wed, 14 Aug 2024 07:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619738; cv=none; b=TLniZrkKbimBoledbWy98Tp3jsT0mHUcebxsjewPBD3i8+Wt2NgEdxny9FBMUayM0Stza6SwAEKKXEia/hyUE7/bUG4ZVv1ft0iutAP7MD2Gr5eVjb9ioOMBf3VXNingMRkqO/+NNYGGjIpSILBtgXJOiPeyilQPrTNSAaXhiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619738; c=relaxed/simple;
	bh=tlAAIG5TYAPd5q8YK67RthTWQcquMOu83ZIZNeyiKbk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xuq3qRm1vQcQx7+ew65C3gbw9Sic9ynifjkcOiNOGwYE8grPnzMLKJr/svYT34Y8IHrPoXG1jgEE3V7L0QRvGOC6iBfnBzLwpazWC1+XqDUPz8eLvsEG5BVBFaevDWY7aciOETZ4Hurvor+y1j3pkydWA1uXK4VUPJaIqE/EZe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WkKK7735Nz4f3jZL;
	Wed, 14 Aug 2024 15:15:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 52A641A18AE;
	Wed, 14 Aug 2024 15:15:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S22;
	Wed, 14 Aug 2024 15:15:33 +0800 (CST)
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
Subject: [PATCH RFC -next v2 18/41] md/md-bitmap: merge md_bitmap_status() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:50 +0800
Message-Id: <20240814071113.346781-19-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S22
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr18KFWrKrWktr48AF1UZFb_yoW7CF15pa
	yUXa45Cr45XFWrXr1UJFyv9FyYqwn5Kr9rtryxK34rCF9FqFnxuF4xGFyUtw15CFy3AFsx
	Zw15tr4UW3yjqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 4 ++--
 drivers/md/md-bitmap.h  | 5 ++---
 drivers/md/md-cluster.c | 8 ++++----
 drivers/md/md.c         | 6 +++---
 drivers/md/raid1.c      | 2 +-
 5 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9692acb8cb04..d4164f096d0c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2105,7 +2105,7 @@ void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
 }
 EXPORT_SYMBOL_GPL(md_bitmap_set_pages);
 
-int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
+static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
 	bitmap_super_t *sb;
 	struct bitmap_counts *counts;
@@ -2128,7 +2128,6 @@ int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 	stats->behind_wait = wq_has_sleeper(&bitmap->behind_wait);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
 
 int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		  int chunksize, int init)
@@ -2720,6 +2719,7 @@ static struct bitmap_operations bitmap_ops = {
 	.flush			= bitmap_flush,
 
 	.update_sb		= bitmap_update_sb,
+	.get_stats		= bitmap_get_stats,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b2d4e71a478a..5dc61df1aa40 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -252,6 +252,7 @@ struct bitmap_operations {
 	void (*flush)(struct mddev *mddev);
 
 	void (*update_sb)(struct bitmap *bitmap);
+	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
 };
 
 /* the bitmap API */
@@ -259,8 +260,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are used only by md/bitmap */
 
-int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats);
-
 int  md_bitmap_setallbits(struct bitmap *bitmap);
 void md_bitmap_write_all(struct bitmap *bitmap);
 
@@ -295,7 +294,7 @@ void md_bitmap_wait_behind_writes(struct mddev *mddev);
 static inline u64 md_bitmap_events_cleared(struct mddev *mddev)
 {
 	struct md_bitmap_stats stats;
-	int err = md_bitmap_get_stats(mddev->bitmap, &stats);
+	int err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 
 	if (err)
 		return 0;
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 77111968e276..31108832dd9b 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1150,7 +1150,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 	char str[64];
 	int i, rv;
 
-	rv = md_bitmap_get_stats(bitmap, &stats);
+	rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 	if (rv)
 		return rv;
 
@@ -1174,7 +1174,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			goto out;
 		}
 
-		rv = md_bitmap_get_stats(bitmap, &stats);
+		rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 		if (rv)
 			goto out;
 		/*
@@ -1223,7 +1223,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 	struct dlm_lock_resource *bm_lockres;
 	struct md_bitmap_stats stats;
 
-	rv = md_bitmap_get_stats(bitmap, &stats);
+	rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 	if (rv)
 		return rv;
 
@@ -1256,7 +1256,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 			mddev->bitmap_ops->update_sb(bitmap);
 		lockres_free(bm_lockres);
 
-		rv = md_bitmap_get_stats(bitmap, &stats);
+		rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 		if (rv) {
 			md_bitmap_free(bitmap);
 			return rv;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ecfe957279e5..29dd6bc86f3f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2345,7 +2345,7 @@ super_1_allow_new_offset(struct md_rdev *rdev,
 	if (rdev->sb_start + (32+4)*2 > new_offset)
 		return 0;
 
-	err = md_bitmap_get_stats(bitmap, &stats);
+	err = rdev->mddev->bitmap_ops->get_stats(bitmap, &stats);
 	if (!err && !rdev->mddev->bitmap_info.file &&
 	    rdev->sb_start + rdev->mddev->bitmap_info.offset +
 	    stats.file_pages * (PAGE_SIZE>>9) > new_offset)
@@ -7575,7 +7575,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 		} else {
 			struct md_bitmap_stats stats;
 
-			rv = md_bitmap_get_stats(mddev->bitmap, &stats);
+			rv = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 			if (rv)
 				goto err;
 
@@ -8372,7 +8372,7 @@ static void md_bitmap_status(struct seq_file *seq, struct mddev *mddev)
 {
 	struct md_bitmap_stats stats;
 	unsigned long chunk_kb;
-	int err = md_bitmap_get_stats(mddev->bitmap, &stats);
+	int err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
 
 	if (err)
 		return;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bfd2d63d1c59..5e1a487bd4de 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1604,7 +1604,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		if (first_clone) {
 			struct md_bitmap_stats stats;
-			int err = md_bitmap_get_stats(bitmap, &stats);
+			int err = mddev->bitmap_ops->get_stats(bitmap, &stats);
 
 			/* do behind I/O ?
 			 * Not if there are too many, or cannot
-- 
2.39.2

