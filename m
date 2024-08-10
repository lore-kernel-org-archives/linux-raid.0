Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E54413D8B0;
	Sat, 10 Aug 2024 02:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255983; cv=none; b=eMn2jD/5Y+MK7b74M5ffe3LnvB8VqoWmFfUJnoBDRedKz+K68f9ei3NycxQ1RWQ5IDAw9Ggjmp0R4dUhVfzGWx5CVQt5QWC4YGywNhzVqH9LGkWiLrUDSkcx6ERuvOsDoY9+00XNEShKlZdDkKn1/LvdVnc6P6KYCVQee9GVQ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255983; c=relaxed/simple;
	bh=gtCoLl16b57j359Qvp2Gr6UuGv5YQ8u3l67VlSQ4J90=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nvlB+rTpz+6nI90k/l4in2J5Qv+hQclaEUt0lShP6I5UXM371f0p+P9BrsOl5wkV9y+MPlwfJUC603epIxqJKwz7Zx6cpk1gPWkmUQDE3ZtrlJltf5BS2KZ7rfVAsWTxIDXtbVFLvVHBXNu+BWeuza9UMEPDI2gjgZmckOIqTnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknm1l1vz4f3jJ1;
	Sat, 10 Aug 2024 10:12:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B33CF1A1737;
	Sat, 10 Aug 2024 10:12:58 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S22;
	Sat, 10 Aug 2024 10:12:58 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 18/26] md/md-bitmap: merge bitmap_sync_with_cluster() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:46 +0800
Message-Id: <20240810020854.797814-19-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S22
X-Coremail-Antispam: 1UD129KBjvJXoWxurW3XFyrJr4xZryDZr15twb_yoW5AF1rpr
	WUKa43Gry3JFZIq3WUZryDuFyFv34kJr9rtryxW34rCFyDJrnxGF4rG3ZFqw4DGF4fJFs0
	vw15KF45ur18XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  9 ++++-----
 drivers/md/md-bitmap.h | 16 +++++++++++++---
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 3c09de471634..8828175ad442 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1697,11 +1697,10 @@ static void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector,
 	sysfs_notify_dirent_safe(bitmap->mddev->sysfs_completed);
 }
 
-void md_bitmap_sync_with_cluster(struct mddev *mddev,
-			      sector_t old_lo, sector_t old_hi,
-			      sector_t new_lo, sector_t new_hi)
+static void bitmap_sync_with_cluster(struct bitmap *bitmap,
+				     sector_t old_lo, sector_t old_hi,
+				     sector_t new_lo, sector_t new_hi)
 {
-	struct bitmap *bitmap = mddev->bitmap;
 	sector_t sector, blocks = 0;
 
 	for (sector = old_lo; sector < new_lo; ) {
@@ -1716,7 +1715,6 @@ void md_bitmap_sync_with_cluster(struct mddev *mddev,
 	}
 	WARN((blocks > new_hi) && old_hi, "alignment is not correct for hi\n");
 }
-EXPORT_SYMBOL(md_bitmap_sync_with_cluster);
 
 static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
 {
@@ -2714,6 +2712,7 @@ static struct bitmap_operations bitmap_ops = {
 	.cond_end_sync		= bitmap_cond_end_sync,
 
 	.update_sb		= bitmap_update_sb,
+	.sync_with_cluster	= bitmap_sync_with_cluster,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 71c3610dca7b..5a77b6d8358b 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -255,6 +255,9 @@ struct bitmap_operations {
 	void (*cond_end_sync)(struct bitmap *bitmap, sector_t sector, bool force);
 
 	void (*update_sb)(struct bitmap *bitmap);
+	void (*sync_with_cluster)(struct bitmap *bitmap,
+				  sector_t old_lo, sector_t old_hi,
+				  sector_t new_lo, sector_t new_hi);
 };
 
 /* the bitmap API */
@@ -386,9 +389,16 @@ static inline void md_bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
 	mddev->bitmap_ops->cond_end_sync(mddev->bitmap, sector, force);
 }
 
-void md_bitmap_sync_with_cluster(struct mddev *mddev,
-				 sector_t old_lo, sector_t old_hi,
-				 sector_t new_lo, sector_t new_hi);
+static inline void md_bitmap_sync_with_cluster(struct mddev *mddev,
+					       sector_t old_lo, sector_t old_hi,
+					       sector_t new_lo, sector_t new_hi)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->sync_with_cluster)
+		return;
+
+	mddev->bitmap_ops->sync_with_cluster(mddev->bitmap, old_lo, old_hi,
+					     new_lo, new_hi);
+}
 
 void md_bitmap_unplug(struct bitmap *bitmap);
 void md_bitmap_unplug_async(struct bitmap *bitmap);
-- 
2.39.2

