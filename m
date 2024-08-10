Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C702149C5E;
	Sat, 10 Aug 2024 02:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255987; cv=none; b=CFJpQUC2LYVaKiUUJhVSUrijEpIvFH7gQYSJAh0iOc49lNnCw+WZvRHxS1f+VG2mBnHdwDGnAQHe6X+BcgagydIPiL/0AKLnP8nDuZgLYMiRzD3z1qNgPAIQskb8lhzAixwTkuA5rXPW2WK8GekC2n1L7C/T1+w6k1ABkML4YBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255987; c=relaxed/simple;
	bh=8KGMMYBD4oCErK23FW+dRM+iocQ2l5lpj113vR/GwRg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QslHAphOtlAHAZ7ds1QKbzKUdT3snNIMCcVFktY7RGTKh6ldO9at7IjbnTnSCwlOuRrcpB0HvE6aOJafpYrCub95rul3kl6ctK++lTdkJ0scUZRqOqlwnPJ+T881LVffFISra8z+q4aw/XUEKHR5uklDeNp+NWmCFx3U611ld7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wgknl0lYtz4f3jdV;
	Sat, 10 Aug 2024 10:12:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 979DA1A018D;
	Sat, 10 Aug 2024 10:12:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S16;
	Sat, 10 Aug 2024 10:12:56 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 12/26] md/md-bitmap: merge md_bitmap_startwrite() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:40 +0800
Message-Id: <20240810020854.797814-13-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S16
X-Coremail-Antispam: 1UD129KBjvJXoWxur43JrW7CFWUCFW7AF1UKFg_yoWrKF47pF
	4UGFya93y5ta13Xw1UCFyDuFyFy3WktrZrtrWfX3s8uFyjqFnxWF48WFyjqw1DCFy3AFZx
	Zwn8trWUGr42qFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  6 ++++--
 drivers/md/md-bitmap.h | 15 +++++++++++++--
 drivers/md/raid1.c     |  3 ++-
 drivers/md/raid10.c    |  2 +-
 drivers/md/raid5.c     |  5 ++---
 5 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b85ae1bf2b7d..75e87073e3bc 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1460,7 +1460,8 @@ __acquires(bitmap->lock)
 			&(bitmap->bp[page].map[pageoff]);
 }
 
-int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
+static int bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
+			     unsigned long sectors, int behind)
 {
 	if (!bitmap)
 		return 0;
@@ -1522,7 +1523,6 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
 	}
 	return 0;
 }
-EXPORT_SYMBOL(md_bitmap_startwrite);
 
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors, int success, int behind)
@@ -2716,6 +2716,8 @@ static struct bitmap_operations bitmap_ops = {
 	.write_all		= bitmap_write_all,
 	.dirty_bits		= bitmap_dirty_bits,
 
+	.startwrite		= bitmap_startwrite,
+
 	.update_sb		= bitmap_update_sb,
 };
 
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index b708a25bd6f4..166cc2a44909 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -243,6 +243,9 @@ struct bitmap_operations {
 	void (*write_all)(struct bitmap *bitmap);
 	void (*dirty_bits)(struct bitmap *bitmap, unsigned long s, unsigned long e);
 
+	int (*startwrite)(struct bitmap *bitmap, sector_t offset,
+			  unsigned long sectors, int behind);
+
 	void (*update_sb)(struct bitmap *bitmap);
 };
 
@@ -316,8 +319,16 @@ static inline void md_bitmap_dirty_bits(struct mddev *mddev, unsigned long s,
 }
 
 /* these are exported */
-int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
-			 unsigned long sectors, int behind);
+static inline int md_bitmap_startwrite(struct mddev *mddev, sector_t offset,
+				       unsigned long sectors, int behind)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->startwrite)
+		return -EOPNOTSUPP;
+
+	return mddev->bitmap_ops->startwrite(mddev->bitmap, offset, sectors,
+					     behind);
+}
+
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors, int success, int behind);
 int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7acfe7c9dc8d..16e741bde382 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1617,7 +1617,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				alloc_behind_master_bio(r1_bio, bio);
 			}
 
-			md_bitmap_startwrite(bitmap, r1_bio->sector, r1_bio->sectors,
+			md_bitmap_startwrite(mddev, r1_bio->sector,
+					     r1_bio->sectors,
 					     test_bit(R1BIO_BehindIO, &r1_bio->state));
 			first_clone = 0;
 		}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2a9c4ee982e0..34948fef1339 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1492,7 +1492,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	md_account_bio(mddev, &bio);
 	r10_bio->master_bio = bio;
 	atomic_set(&r10_bio->remaining, 1);
-	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
+	md_bitmap_startwrite(mddev, r10_bio->sector, r10_bio->sectors, 0);
 
 	for (i = 0; i < conf->copies; i++) {
 		if (r10_bio->devs[i].bio)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c14cf2410365..127e4b4c6c20 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3563,7 +3563,7 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 		 */
 		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		spin_unlock_irq(&sh->stripe_lock);
-		md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
+		md_bitmap_startwrite(conf->mddev, sh->sector,
 				     RAID5_STRIPE_SECTORS(conf), 0);
 		spin_lock_irq(&sh->stripe_lock);
 		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
@@ -5791,8 +5791,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 			for (d = 0;
 			     d < conf->raid_disks - conf->max_degraded;
 			     d++)
-				md_bitmap_startwrite(mddev->bitmap,
-						     sh->sector,
+				md_bitmap_startwrite(mddev, sh->sector,
 						     RAID5_STRIPE_SECTORS(conf),
 						     0);
 			sh->bm_seq = conf->seq_flush + 1;
-- 
2.39.2

