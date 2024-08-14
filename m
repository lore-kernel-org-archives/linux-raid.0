Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481D115ECEC;
	Wed, 14 Aug 2024 07:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619746; cv=none; b=tRPCM/N5BkkRaJ7/C/eOXf6hsoS8OIXszEEWZbYDEkxoIu551CDITq+RkSypQZaNFJSV5JV/YoDFop3whClML105P+fsQ6hSedtG9PqbnqsfxONqZJnub0wzYBbdAP9khBDkb60G76jas1lhZ96ePhJkSTkdmMZQk9y4jqCRFqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619746; c=relaxed/simple;
	bh=NNwMSYeBRPz1LOZBV8/1icdJEABurp8xJrojSb4+D5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XFup4ItSxNRxqiSS/hi4PeotU+ijKtllKOixm5x554WyNhqoq/mnao0HjeoaS7l9zyZ6EdnsRPrh13bC8NGWJ1NrgAt2vQfWK3F+UvXVpr/cxSOnz0zPk5aO6jVIYhDvKp3bRptxjQxqt00aesFrfyI6P/3fnAIj7rjhHe46FKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKKC5D7Sz4f3jdV;
	Wed, 14 Aug 2024 15:15:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7928C1A14D4;
	Wed, 14 Aug 2024 15:15:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S42;
	Wed, 14 Aug 2024 15:15:41 +0800 (CST)
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
Subject: [PATCH RFC -next v2 38/41] md/md-bitmap: merge md_bitmap_free() into bitmap_operations
Date: Wed, 14 Aug 2024 15:11:10 +0800
Message-Id: <20240814071113.346781-39-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S42
X-Coremail-Antispam: 1UD129KBjvJXoWxur43ArWfWryUWFykAw45Awb_yoW5tFy7pF
	42qa45Gr45JrW3Xr1UJryq9Fyrtw1ktr9rKFyxCw1fuF9xXFnxKF4rGFyDK34rGFy3AFsx
	X3Z8tr4kur4UXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
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
index f53e3a62c4e2..eb7c5e552acf 100644
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
@@ -2771,6 +2767,7 @@ static struct bitmap_operations bitmap_ops = {
 	.get_from_slot		= bitmap_get_from_slot,
 	.copy_from_slot		= bitmap_copy_from_slot,
 	.set_pages		= bitmap_set_pages,
+	.free			= md_bitmap_free,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d5bbadc1f6fd..d0037665a4dc 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -279,14 +279,13 @@ struct bitmap_operations {
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
 
 static inline u64 md_bitmap_events_cleared(struct mddev *mddev)
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 64a4ccbe68c0..da94f7251da7 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1200,12 +1200,12 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
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
@@ -1248,7 +1248,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 		bm_lockres = lockres_init(mddev, str, NULL, 1);
 		if (!bm_lockres) {
 			pr_err("md-cluster: Cannot initialize %s\n", str);
-			md_bitmap_free(bitmap);
+			mddev->bitmap_ops->free(bitmap);
 			return -1;
 		}
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
@@ -1259,17 +1259,17 @@ static int cluster_check_sync_size(struct mddev *mddev)
 
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

