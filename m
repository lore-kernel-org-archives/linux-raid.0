Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45851411E7;
	Sat, 10 Aug 2024 02:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255984; cv=none; b=BfCzkPxXSROBGWv85YLLzC+zhhma0NwrK11d4cRqRplY5WpKXPLHxTGjwBWswwJbe+6e/uT0GXIEVn8yZva89loBwhWj17mFpB0p+6ukgQ3cwiNstehBGv9M365kGU+QiHUnXBqLBC9Xk/luVcIAjLAB/lfgsev0KE737GT+k1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255984; c=relaxed/simple;
	bh=ytQ+ZCjobUKkClI9y2VOTywlyx2dRMYTWhjAPVSakDA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZIiMlkv7MO9zqf8apr60BrOsOMaSsUvNN+/WzcyyOfkIWPrPrT2L8uMiIQ+7+iiNatLmFsAPpRnviqFZApo+Z1IN0wjV6FtbGX7+Mfx7HSKB/c8Voo8Y4A5j04vR5uqeLhdpKZGlx/hSeQBnU4PVcrgqh0X5XkNzcLOh+yq9jGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknt67Gbz4f3jk0;
	Sat, 10 Aug 2024 10:12:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 025161A13AA;
	Sat, 10 Aug 2024 10:13:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S26;
	Sat, 10 Aug 2024 10:12:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 22/26] md/md-bitmap: merge md_bitmap_free() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:50 +0800
Message-Id: <20240810020854.797814-23-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S26
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw4kuFy7AF1kAFW3Gw1xZrb_yoW7GF45pF
	4Ut3W5GrW5JFWaqr1UArWq9a4Yyw1ktr9rKryxAw1ruF9xXFnxGF48GFy8K345CFy5JFsx
	Xw15KFs5ur4UXrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 17 +++++++----------
 drivers/md/md-bitmap.h  | 10 +++++++++-
 drivers/md/md-cluster.c | 10 +++++-----
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 199bd6757543..99c496a32e94 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1790,10 +1790,7 @@ static void bitmap_flush(struct mddev *mddev)
 	bitmap_update_sb(bitmap);
 }
 
-/*
- * free memory that was allocated
- */
-void md_bitmap_free(struct bitmap *bitmap)
+static void __bitmap_free(struct bitmap *bitmap)
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
@@ -1827,7 +1824,6 @@ void md_bitmap_free(struct bitmap *bitmap)
 	kfree(bp);
 	kfree(bitmap);
 }
-EXPORT_SYMBOL(md_bitmap_free);
 
 void md_bitmap_wait_behind_writes(struct mddev *mddev)
 {
@@ -1861,7 +1857,7 @@ static void bitmap_destroy(struct mddev *mddev)
 	mutex_unlock(&mddev->bitmap_info.mutex);
 	mddev_set_timeout(mddev, MAX_SCHEDULE_TIMEOUT, true);
 
-	md_bitmap_free(bitmap);
+	__bitmap_free(bitmap);
 }
 
 /*
@@ -1952,7 +1948,7 @@ static struct bitmap *bitmap_create(struct mddev *mddev, int slot)
 
 	return bitmap;
  error:
-	md_bitmap_free(bitmap);
+	__bitmap_free(bitmap);
 	return ERR_PTR(err);
 }
 
@@ -2013,7 +2009,7 @@ static int bitmap_load(struct mddev *mddev)
 	return err;
 }
 
-/* caller need to free returned bitmap with md_bitmap_free() */
+/* caller need to free returned bitmap with __bitmap_free() */
 static struct bitmap *bitmap_get_from_slot(struct mddev *mddev, int slot)
 {
 	int rv = 0;
@@ -2027,7 +2023,7 @@ static struct bitmap *bitmap_get_from_slot(struct mddev *mddev, int slot)
 
 	rv = md_bitmap_init_from_disk(bitmap, 0);
 	if (rv) {
-		md_bitmap_free(bitmap);
+		__bitmap_free(bitmap);
 		return ERR_PTR(rv);
 	}
 
@@ -2076,7 +2072,7 @@ static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
 	md_bitmap_unplug(mddev->bitmap);
 	*low = lo;
 	*high = hi;
-	md_bitmap_free(bitmap);
+	__bitmap_free(bitmap);
 
 	return rv;
 }
@@ -2715,6 +2711,7 @@ static struct bitmap_operations bitmap_ops = {
 	.sync_with_cluster	= bitmap_sync_with_cluster,
 	.get_from_slot		= bitmap_get_from_slot,
 	.copy_from_slot		= bitmap_copy_from_slot,
+	.free			= __bitmap_free,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index acd868e2ef5e..b5836e5ff1e3 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -263,6 +263,7 @@ struct bitmap_operations {
 	struct bitmap* (*get_from_slot)(struct mddev *mddev, int slot);
 	int (*copy_from_slot)(struct mddev *mddev, int slot,
 			      sector_t *lo, sector_t *hi, bool clear_bits);
+	void (*free)(struct bitmap *bitmap);
 };
 
 /* the bitmap API */
@@ -433,11 +434,18 @@ static inline int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	return mddev->bitmap_ops->copy_from_slot(mddev, slot, lo, hi, clear_bits);
 }
 
+static inline void md_bitmap_free(struct mddev *mddev, struct bitmap *bitmap)
+{
+	if (!mddev->bitmap_ops->free)
+		return;
+
+	return mddev->bitmap_ops->free(bitmap);
+}
+
 void md_bitmap_unplug(struct bitmap *bitmap);
 void md_bitmap_unplug_async(struct bitmap *bitmap);
 void md_bitmap_daemon_work(struct mddev *mddev);
 
-void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d608535fc06a..9e3c579703f6 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1192,12 +1192,12 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			 * can't resize bitmap
 			 */
 			goto out;
-		md_bitmap_free(bitmap);
+		md_bitmap_free(mddev, bitmap);
 	}
 
 	return 0;
 out:
-	md_bitmap_free(bitmap);
+	md_bitmap_free(mddev, bitmap);
 	update_bitmap_size(mddev, oldsize);
 	return -1;
 }
@@ -1238,7 +1238,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 		bm_lockres = lockres_init(mddev, str, NULL, 1);
 		if (!bm_lockres) {
 			pr_err("md-cluster: Cannot initialize %s\n", str);
-			md_bitmap_free(bitmap);
+			md_bitmap_free(mddev, bitmap);
 			return -1;
 		}
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
@@ -1253,11 +1253,11 @@ static int cluster_check_sync_size(struct mddev *mddev)
 			sync_size = sb->sync_size;
 		else if (sync_size != sb->sync_size) {
 			kunmap_atomic(sb);
-			md_bitmap_free(bitmap);
+			md_bitmap_free(mddev, bitmap);
 			return -1;
 		}
 		kunmap_atomic(sb);
-		md_bitmap_free(bitmap);
+		md_bitmap_free(mddev, bitmap);
 	}
 
 	return (my_sync_size == sync_size) ? 0 : -1;
-- 
2.39.2

