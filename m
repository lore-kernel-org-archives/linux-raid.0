Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D37D18786E;
	Mon, 26 Aug 2024 07:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658609; cv=none; b=ktqPKspHfat/ti1+yfyB2v4lVEGH0HYVg0M6+PSsJP7U9qsm0fkhDkfiiyonw8DWfYonW37ieUDoMqvT/tWDmrbbkN1/o+HyLrwkoclnSIiA0Z8VqzUb/4q3t3jmlKTfydo0bLXNXxmZFjVytFubeSNP7iiuxi1bV6Jcm2ZqgOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658609; c=relaxed/simple;
	bh=NG4bFIDkFbeRvODbKQnG2xQmTnZ6XvKUMrR1dUMS5YI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FNf0o5mKIYk1W622MeMAvwbL2u6HGVH9pVYdwbJ1utxMvCZjCrfR9U6Sw94FiIxMdGsolzwhcybGW5/AWzRFXfJeEfZHqLrHL11XjKLrhE2q3zt+hTvLaLTwUHYxqWV5LtldfgsaVGVGyk37w68Fmb9Q/234m/Xl9/dx/Im/x8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjWK27Thz4f3l1s;
	Mon, 26 Aug 2024 15:49:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A2C1A1A0359;
	Mon, 26 Aug 2024 15:50:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S43;
	Mon, 26 Aug 2024 15:50:04 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2 39/42] md/md-bitmap: merge md_bitmap_free() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:49 +0800
Message-Id: <20240826074452.1490072-40-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S43
X-Coremail-Antispam: 1UD129KBjvJXoWxur47WrWDuw1rJrW5XFW8WFg_yoW5tFyUpF
	47ta45Gw45XrW3Xr1UJryq9FyFyw1ktr9rKFyxCwn5uF9rXFnxKF48GFyDK34rCFy3AFsx
	Xwn8tr4kur4UXF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
	xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
o invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  |  7 ++-----
 drivers/md/md-bitmap.h  |  3 +--
 drivers/md/md-cluster.c | 12 ++++++------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 70818c56004f..62e4f9d5a559 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1828,10 +1828,7 @@ static void bitmap_flush(struct mddev *mddev)
 	bitmap_update_sb(bitmap);
 }
 
-/*
- * free memory that was allocated
- */
-void md_bitmap_free(struct bitmap *bitmap)
+static void md_bitmap_free(struct bitmap *bitmap)
 {
 	unsigned long k, pages;
 	struct bitmap_page *bp;
@@ -1865,7 +1862,6 @@ void md_bitmap_free(struct bitmap *bitmap)
 	kfree(bp);
 	kfree(bitmap);
 }
-EXPORT_SYMBOL(md_bitmap_free);
 
 void md_bitmap_wait_behind_writes(struct mddev *mddev)
 {
@@ -2782,6 +2778,7 @@ static struct bitmap_operations bitmap_ops = {
 	.get_from_slot		= bitmap_get_from_slot,
 	.copy_from_slot		= bitmap_copy_from_slot,
 	.set_pages		= bitmap_set_pages,
+	.free			= md_bitmap_free,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 7fee98e3d517..7f6cc6f616b3 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -280,14 +280,13 @@ struct bitmap_operations {
 	int (*copy_from_slot)(struct mddev *mddev, int slot, sector_t *lo,
 			      sector_t *hi, bool clear_bits);
 	void (*set_pages)(struct bitmap *bitmap, unsigned long pages);
+	void (*free)(struct bitmap *bitmap);
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-
-void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
 static inline bool md_bitmap_enabled(struct bitmap *bitmap)
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 3296925b8455..7647ce4f76fa 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1201,12 +1201,12 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 			 * can't resize bitmap
 			 */
 			goto out;
-		md_bitmap_free(bitmap);
+		mddev->bitmap_ops->free(bitmap);
 	}
 
 	return 0;
 out:
-	md_bitmap_free(bitmap);
+	mddev->bitmap_ops->free(bitmap);
 	update_bitmap_size(mddev, oldsize);
 	return -1;
 }
@@ -1250,7 +1250,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 		bm_lockres = lockres_init(mddev, str, NULL, 1);
 		if (!bm_lockres) {
 			pr_err("md-cluster: Cannot initialize %s\n", str);
-			md_bitmap_free(bitmap);
+			mddev->bitmap_ops->free(bitmap);
 			return -1;
 		}
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
@@ -1261,17 +1261,17 @@ static int cluster_check_sync_size(struct mddev *mddev)
 
 		rv = mddev->bitmap_ops->get_stats(bitmap, &stats);
 		if (rv) {
-			md_bitmap_free(bitmap);
+			mddev->bitmap_ops->free(bitmap);
 			return rv;
 		}
 
 		if (sync_size == 0) {
 			sync_size = stats.sync_size;
 		} else if (sync_size != stats.sync_size) {
-			md_bitmap_free(bitmap);
+			mddev->bitmap_ops->free(bitmap);
 			return -1;
 		}
-		md_bitmap_free(bitmap);
+		mddev->bitmap_ops->free(bitmap);
 	}
 
 	return (my_sync_size == sync_size) ? 0 : -1;
-- 
2.39.2

