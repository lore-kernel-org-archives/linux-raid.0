Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066A8186603;
	Mon, 26 Aug 2024 07:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658609; cv=none; b=kjrcasLq5eQpONDwJBoXCQcQbgav6TYT4cXluej77pBmJYqME+rKPqJpkldvo8qvmKD1OcRZISh8+t7CdELetTde3kLSDQn7DtVjP/eFCCywacfWHESPIxlL0+ZaeesKklFzbMdAqn7N4WeVqCReMitwqgZ8nk6NGt4mO2NTcEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658609; c=relaxed/simple;
	bh=zAIyQKZh2QlqPwAPB6pT6FzqXfgypaqhIcmFOID/y5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AEn+CHcYRHbJ/ynIkvBCQLSGerii5JF/UAb/yr973hD/ZE6LmDahceDkBrhqzig5Fems8HaHuPaPEeanvcXthTxB4HVHBxOGNE6+HJciAx5n1+cpBGPjKabHpNmwkvfJdO7Cmp8lH4HH6CgzfvpOuq6F0MUkUxC0v26iITsj1pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjWK5WxSz4f3jXX;
	Mon, 26 Aug 2024 15:49:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3D81A1A1A1C;
	Mon, 26 Aug 2024 15:50:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S42;
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
Subject: [PATCH md-6.12 v2 38/42] md/md-bitmap: merge md_bitmap_set_pages() into struct bitmap_operations
Date: Mon, 26 Aug 2024 15:44:48 +0800
Message-Id: <20240826074452.1490072-39-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S42
X-Coremail-Antispam: 1UD129KBjvJXoWxur47GF1UZryUCFyfWry7GFg_yoW5Gw18pF
	4jqasxC3y3JFZIq3WUXryDCa4rtw1DtrZrKryfC395uFy7XF9xKF48Ga47tw18GFy3JFsI
	qw15KryUur18XFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

o that the implementation won't be exposed, and it'll be possible
o invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 4 ++--
 drivers/md/md-bitmap.h  | 2 +-
 drivers/md/md-cluster.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 25126cdee4e1..70818c56004f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2132,11 +2132,10 @@ static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
 	return rv;
 }
 
-void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
+static void bitmap_set_pages(struct bitmap *bitmap, unsigned long pages)
 {
 	bitmap->counts.pages = pages;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_set_pages);
 
 static int bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
 {
@@ -2782,6 +2781,7 @@ static struct bitmap_operations bitmap_ops = {
 	.sync_with_cluster	= bitmap_sync_with_cluster,
 	.get_from_slot		= bitmap_get_from_slot,
 	.copy_from_slot		= bitmap_copy_from_slot,
+	.set_pages		= bitmap_set_pages,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 94d9a6ae244a..7fee98e3d517 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -279,6 +279,7 @@ struct bitmap_operations {
 	struct bitmap *(*get_from_slot)(struct mddev *mddev, int slot);
 	int (*copy_from_slot)(struct mddev *mddev, int slot, sector_t *lo,
 			      sector_t *hi, bool clear_bits);
+	void (*set_pages)(struct bitmap *bitmap, unsigned long pages);
 };
 
 /* the bitmap API */
@@ -286,7 +287,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages);
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 515f46983ace..3296925b8455 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1192,7 +1192,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		bm_lockres->flags |= DLM_LKF_NOQUEUE;
 		rv = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);
 		if (!rv)
-			md_bitmap_set_pages(bitmap, my_pages);
+			mddev->bitmap_ops->set_pages(bitmap, my_pages);
 		lockres_free(bm_lockres);
 
 		if (my_pages != stats.pages)
-- 
2.39.2

