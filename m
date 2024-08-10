Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069B6130499;
	Sat, 10 Aug 2024 02:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255988; cv=none; b=SIJ9R+bIXZAcRxx/xfBkwA5cZyNeDdKKj9g2pI5Gv3EFBibPyMb7/IjfyFx/T7ewpyOiu1fJhagYOi3Jzo1Pqm7QfodxCcokP5Poz2wlHkLBN2TTmzP2dlPJfAI5JKSYCmVI7lLXSAaouPcWnWz3oo9gJsvJsxFM2YECeUK+G4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255988; c=relaxed/simple;
	bh=GF/k2FBC297lPmJcv4z2avEr2mmu+H5jGLUps8CdbY4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hXJdzrhi91ESbHCmmBy3bO1fZvUnW8gAJ7J1xkYyH2QOQX00sdmRsOXWYGNNy3F4LOAvxwzwudPUnH0bqJMj3eQK0Exv3SuMGVNIQLoemCBKNmhIb4lxyLRg0uoqk/0Z1KlRRSbpDx079hdZTqBTmQODvIxsQG4roBkPP2Cvl+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknn5lbFz4f3jrs;
	Sat, 10 Aug 2024 10:12:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 51D891A174A;
	Sat, 10 Aug 2024 10:12:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S24;
	Sat, 10 Aug 2024 10:12:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 20/26] md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:48 +0800
Message-Id: <20240810020854.797814-21-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S24
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWUur1DAw1DAw48JryDAwb_yoWrGw1rpF
	4Uta43CrWrJrWagr1UuFyDAa45tw1ktr9rKryfGw4fuF9xWF98GF4rG3W8t34YkF15JFsI
	qw4YkrWUur1rXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Also rename it to md_bitmap_get_from_slot().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  |  6 +++---
 drivers/md/md-bitmap.h  | 11 ++++++++++-
 drivers/md/md-cluster.c |  4 ++--
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ed43139b52f4..f6c0334708ee 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2014,7 +2014,7 @@ static int bitmap_load(struct mddev *mddev)
 }
 
 /* caller need to free returned bitmap with md_bitmap_free() */
-struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
+static struct bitmap *bitmap_get_from_slot(struct mddev *mddev, int slot)
 {
 	int rv = 0;
 	struct bitmap *bitmap;
@@ -2033,7 +2033,6 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 
 	return bitmap;
 }
-EXPORT_SYMBOL(get_bitmap_from_slot);
 
 /* Loads the bitmap associated with slot and copies the resync information
  * to our bitmap
@@ -2046,7 +2045,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	struct bitmap_counts *counts;
 	struct bitmap *bitmap;
 
-	bitmap = get_bitmap_from_slot(mddev, slot);
+	bitmap = bitmap_get_from_slot(mddev, slot);
 	if (IS_ERR(bitmap)) {
 		pr_err("%s can't get bitmap from slot %d\n", __func__, slot);
 		return -1;
@@ -2716,6 +2715,7 @@ static struct bitmap_operations bitmap_ops = {
 	.update_sb		= bitmap_update_sb,
 	.resize			= bitmap_resize,
 	.sync_with_cluster	= bitmap_sync_with_cluster,
+	.get_from_slot		= bitmap_get_from_slot,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 37edf8626a60..199fb961b11f 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -260,6 +260,7 @@ struct bitmap_operations {
 	void (*sync_with_cluster)(struct bitmap *bitmap,
 				  sector_t old_lo, sector_t old_hi,
 				  sector_t new_lo, sector_t new_hi);
+	struct bitmap* (*get_from_slot)(struct mddev *mddev, int slot);
 };
 
 /* the bitmap API */
@@ -411,11 +412,19 @@ static inline void md_bitmap_sync_with_cluster(struct mddev *mddev,
 					     new_lo, new_hi);
 }
 
+static inline struct bitmap *md_bitmap_get_from_slot(struct mddev *mddev,
+						     int slot)
+{
+	if (!mddev->bitmap_ops->get_from_slot)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return mddev->bitmap_ops->get_from_slot(mddev, slot);
+}
+
 void md_bitmap_unplug(struct bitmap *bitmap);
 void md_bitmap_unplug_async(struct bitmap *bitmap);
 void md_bitmap_daemon_work(struct mddev *mddev);
 
-struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
 void md_bitmap_free(struct bitmap *bitmap);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index d843ea190e7b..d608535fc06a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1162,7 +1162,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		if (i == md_cluster_ops->slot_number(mddev))
 			continue;
 
-		bitmap = get_bitmap_from_slot(mddev, i);
+		bitmap = md_bitmap_get_from_slot(mddev, i);
 		if (IS_ERR(bitmap)) {
 			pr_err("can't get bitmap from slot %d\n", i);
 			bitmap = NULL;
@@ -1224,7 +1224,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 		if (i == current_slot)
 			continue;
 
-		bitmap = get_bitmap_from_slot(mddev, i);
+		bitmap = md_bitmap_get_from_slot(mddev, i);
 		if (IS_ERR(bitmap)) {
 			pr_err("can't get bitmap from slot %d\n", i);
 			return -1;
-- 
2.39.2

