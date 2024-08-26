Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49064185933;
	Mon, 26 Aug 2024 07:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658608; cv=none; b=HIKdx5NIIBDJt3TKAQAE+VhYnailxeK3f59jHL+xd50mKyP7dfD155RyyKmCTbNHg0KMBHWEtd/6EOqmcn0JCMFPU3GYMhVxoRPP7uPHfY/h/s6SnOaqQW6CzahyF3b/vd/uN0oVbYmF07WYSFdi9/SqSt7lfmgjuiTQabWT9Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658608; c=relaxed/simple;
	bh=3ZODMaHajuzcvKSN/6t25Nq6RZh9h9ZTsncQ6YxkgM4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h1fqECJGGi9jyLGnR7u/eC7ZEJNdjRjP/SSK4Z6dab6T5cjMbzdd+hQ8UhI/lKwtnwFWOunDCzGmvAMeGxzj3zs8ck7isME2DjBBIlQ4x2D5i2kVTVQOYOaf5bOE+lIyYJo0hjnd5/Eq+0ETlVzkcyCtGDmKkansSL01vX4FEYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WsjWJ6r4yz4f3jJF;
	Mon, 26 Aug 2024 15:49:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 699571A1A1C;
	Mon, 26 Aug 2024 15:50:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S40;
	Mon, 26 Aug 2024 15:50:03 +0800 (CST)
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
Subject: [PATCH md-6.12 v2 36/42] md/md-bitmap: merge get_bitmap_from_slot() into bitmap_operations
Date: Mon, 26 Aug 2024 15:44:46 +0800
Message-Id: <20240826074452.1490072-37-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S40
X-Coremail-Antispam: 1UD129KBjvJXoWxZFW8Gr18Jw4kKr1DAw4xWFg_yoW5uw4fpF
	4jqasxCrWrJrWagF1UWryDua45tw1ktrZrKryfGw4fWF98GFn8GF4rG3Wxt34YkF15JFsI
	qw1YkrWUur18XrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c  | 6 +++---
 drivers/md/md-bitmap.h  | 2 +-
 drivers/md/md-cluster.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0506b54f6322..a75f4216fd40 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2065,7 +2065,7 @@ static int bitmap_load(struct mddev *mddev)
 }
 
 /* caller need to free returned bitmap with md_bitmap_free() */
-struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
+static struct bitmap *bitmap_get_from_slot(struct mddev *mddev, int slot)
 {
 	int rv = 0;
 	struct bitmap *bitmap;
@@ -2084,7 +2084,6 @@ struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot)
 
 	return bitmap;
 }
-EXPORT_SYMBOL(get_bitmap_from_slot);
 
 /* Loads the bitmap associated with slot and copies the resync information
  * to our bitmap
@@ -2097,7 +2096,7 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 	struct bitmap_counts *counts;
 	struct bitmap *bitmap;
 
-	bitmap = get_bitmap_from_slot(mddev, slot);
+	bitmap = bitmap_get_from_slot(mddev, slot);
 	if (IS_ERR(bitmap)) {
 		pr_err("%s can't get bitmap from slot %d\n", __func__, slot);
 		return -1;
@@ -2782,6 +2781,7 @@ static struct bitmap_operations bitmap_ops = {
 	.get_stats		= bitmap_get_stats,
 
 	.sync_with_cluster	= bitmap_sync_with_cluster,
+	.get_from_slot		= bitmap_get_from_slot,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index d05fc2f1451e..6bcb88b71371 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -276,6 +276,7 @@ struct bitmap_operations {
 	void (*sync_with_cluster)(struct mddev *mddev,
 				  sector_t old_lo, sector_t old_hi,
 				  sector_t new_lo, sector_t new_hi);
+	struct bitmap *(*get_from_slot)(struct mddev *mddev, int slot);
 };
 
 /* the bitmap API */
@@ -283,7 +284,6 @@ void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
 
-struct bitmap *get_bitmap_from_slot(struct mddev *mddev, int slot);
 int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 			     sector_t *lo, sector_t *hi, bool clear_bits);
 void md_bitmap_set_pages(struct bitmap *bitmap, unsigned long pages);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 21cf0f38cbf8..81c630dcf9ea 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1169,7 +1169,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
 		if (i == md_cluster_ops->slot_number(mddev))
 			continue;
 
-		bitmap = get_bitmap_from_slot(mddev, i);
+		bitmap = mddev->bitmap_ops->get_from_slot(mddev, i);
 		if (IS_ERR(bitmap)) {
 			pr_err("can't get bitmap from slot %d\n", i);
 			bitmap = NULL;
@@ -1236,7 +1236,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 		if (i == current_slot)
 			continue;
 
-		bitmap = get_bitmap_from_slot(mddev, i);
+		bitmap = mddev->bitmap_ops->get_from_slot(mddev, i);
 		if (IS_ERR(bitmap)) {
 			pr_err("can't get bitmap from slot %d\n", i);
 			return -1;
-- 
2.39.2

