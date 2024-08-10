Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435BB14D715;
	Sat, 10 Aug 2024 02:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255990; cv=none; b=DzHew3uvmU5xh0Je7VPmXyzQHBWXzQSuq3tSlPsOnu8HgqlhDOgp21UjERnqZ4id5qiYoFL1hTtUO9GXZJyw4O8TTLf1CEJjMFkwkoliHiXr866V5NIixMyx+ZOpBoxOZ/Fl5zXcIWu9jjWZq8T+GEVXqY1+Ufiv8EUdH7Ru3dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255990; c=relaxed/simple;
	bh=aQ3S0oPGZfpRLApuclwyt0A5xu9fFRSZCcGxPQI+wR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pcI5uqxaS1yS9ryMtcLcVXcsNfpaG7frFnCa9TiSkmJOaWMqL/ibZhzGlOvpcNXB/mBZexkAKJ5lZqXJM0btMxZwOgPeeZESsfpjt+EyE+nxkoV04cmoKvyjVZqe8PNdFO/FC+5ccksi6TfoXD8hl/Y9/26ksIqCpShOXBBMh9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknp11j2z4f3jrt;
	Sat, 10 Aug 2024 10:12:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A26961A13AA;
	Sat, 10 Aug 2024 10:12:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S25;
	Sat, 10 Aug 2024 10:12:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 21/26] md/md-bitmap: merge md_bitmap_copy_from_slot() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:49 +0800
Message-Id: <20240810020854.797814-22-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S25
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1xAF43WF47JFyxJFWxXrb_yoW5Ww4xpF
	4UtasxG3y5JFWaq3WUZFyDua45tr1ktrZrKryxGw1ruFy3WF98GF1rG3W8t34rKF1rJFsI
	q3W5KrWrCr1FqF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c |  7 +++----
 drivers/md/md-bitmap.h | 14 ++++++++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index f6c0334708ee..199bd6757543 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2037,8 +2037,8 @@ static struct bitmap *bitmap_get_from_slot(struct mddev *mddev, int slot)
 /* Loads the bitmap associated with slot and copies the resync information
  * to our bitmap
  */
-int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
-		sector_t *low, sector_t *high, bool clear_bits)
+static int bitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
+				 sector_t *high, bool clear_bits)
 {
 	int rv = 0, i, j;
 	sector_t block, lo = 0, hi = 0;
@@ -2080,8 +2080,6 @@ int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
 
 	return rv;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_copy_from_slot);
-
 
 static void bitmap_status(struct seq_file *seq, struct bitmap *bitmap)
 {
@@ -2716,6 +2714,7 @@ static struct bitmap_operations bitmap_ops = {
 	.resize			= bitmap_resize,
 	.sync_with_cluster	= bitmap_sync_with_cluster,
 	.get_from_slot		= bitmap_get_from_slot,
+	.copy_from_slot		= bitmap_copy_from_slot,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 199fb961b11f..acd868e2ef5e 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -261,6 +261,8 @@ struct bitmap_operations {
 				  sector_t old_lo, sector_t old_hi,
 				  sector_t new_lo, sector_t new_hi);
 	struct bitmap* (*get_from_slot)(struct mddev *mddev, int slot);
+	int (*copy_from_slot)(struct mddev *mddev, int slot,
+			      sector_t *lo, sector_t *hi, bool clear_bits);
 };
 
 /* the bitmap API */
@@ -421,12 +423,20 @@ static inline struct bitmap *md_bitmap_get_from_slot(struct mddev *mddev,
 	return mddev->bitmap_ops->get_from_slot(mddev, slot);
 }
 
+static inline int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
+					   sector_t *lo, sector_t *hi,
+					   bool clear_bits)
+{
+	if (!mddev->bitmap_ops->copy_from_slot)
+		return -EOPNOTSUPP;
+
+	return mddev->bitmap_ops->copy_from_slot(mddev, slot, lo, hi, clear_bits);
+}
+
 void md_bitmap_unplug(struct bitmap *bitmap);
 void md_bitmap_unplug_async(struct bitmap *bitmap);
 void md_bitmap_daemon_work(struct mddev *mddev);
 
-int md_bitmap_copy_from_slot(struct mddev *mddev, int slot,
-			     sector_t *lo, sector_t *hi, bool clear_bits);
 void md_bitmap_free(struct bitmap *bitmap);
 void md_bitmap_wait_behind_writes(struct mddev *mddev);
 
-- 
2.39.2

