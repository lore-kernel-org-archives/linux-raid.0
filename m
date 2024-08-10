Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3FD13CFB9;
	Sat, 10 Aug 2024 02:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255982; cv=none; b=eXr3OamDztMYDBiLze9ZOTkeuYY6RSsC4DZlqPKOe4KxN5PhjaR76NGLIbvn1kHZZWqIY6vDlusKQYehjiyyhLXo1w7csHsomxH0BO+xj5qZtb/FFerSHYPy0E+oYo5gNjsruCEFjB7FtfrZVkoPezwE3GUoNUqXkcxgF4S3aEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255982; c=relaxed/simple;
	bh=lNo99pSAZdtkSebDL8Wq6jBs0LkdHcTUK07tuvqHdpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e4ei/QAXs/ohi4Gu00f+p/nMGl23wlNNw5brZyulBUKJhOEBOHKnnpSY6u8b6cSYdzpQcbJWvawW7Y6RKUs8y5j2wPzWryoDn9aBWoI0svKB53tzcJLA3JQ58kX9/I9bR5CzvgSX3L5bb+tB8TVgxU9Uc8aaVwG6C1z5kq2ivwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wgknq6KQVz4f3jkP;
	Sat, 10 Aug 2024 10:12:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 079251A018D;
	Sat, 10 Aug 2024 10:12:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WizLZmErwLBQ--.1937S17;
	Sat, 10 Aug 2024 10:12:56 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC -next 13/26] md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
Date: Sat, 10 Aug 2024 10:08:41 +0800
Message-Id: <20240810020854.797814-14-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHL4WizLZmErwLBQ--.1937S17
X-Coremail-Antispam: 1UD129KBjvJXoW3JFWkCw1kuFyfCrW8ur4kZwb_yoW7tr4kpa
	yUJrySk3y5tFZxZw1UAFyDuFyFv34kKrZrtrWfW3s8ua4jgF90gF48WFW0qw1DCF1ayFWa
	vw15trWUGrWjqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
 drivers/md/md-bitmap.c   |  6 +++---
 drivers/md/md-bitmap.h   | 15 +++++++++++++--
 drivers/md/raid1.c       |  3 +--
 drivers/md/raid10.c      |  3 +--
 drivers/md/raid5-cache.c |  2 +-
 drivers/md/raid5.c       |  6 +++---
 6 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 75e87073e3bc..d726e571406d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1524,8 +1524,8 @@ static int bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
 	return 0;
 }
 
-void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind)
+static void bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
+			    unsigned long sectors, int success, int behind)
 {
 	if (!bitmap)
 		return;
@@ -1575,7 +1575,6 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			sectors = 0;
 	}
 }
-EXPORT_SYMBOL(md_bitmap_endwrite);
 
 static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 			       int degraded)
@@ -2717,6 +2716,7 @@ static struct bitmap_operations bitmap_ops = {
 	.dirty_bits		= bitmap_dirty_bits,
 
 	.startwrite		= bitmap_startwrite,
+	.endwrite		= bitmap_endwrite,
 
 	.update_sb		= bitmap_update_sb,
 };
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 166cc2a44909..3a8be496d9b2 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -245,6 +245,8 @@ struct bitmap_operations {
 
 	int (*startwrite)(struct bitmap *bitmap, sector_t offset,
 			  unsigned long sectors, int behind);
+	void (*endwrite)(struct bitmap *bitmap, sector_t offset,
+			 unsigned long sectors, int success, int behind);
 
 	void (*update_sb)(struct bitmap *bitmap);
 };
@@ -329,8 +331,17 @@ static inline int md_bitmap_startwrite(struct mddev *mddev, sector_t offset,
 					     behind);
 }
 
-void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind);
+static inline void md_bitmap_endwrite(struct mddev *mddev, sector_t offset,
+				      unsigned long sectors, int success,
+				      int behind)
+{
+	if (!mddev->bitmap || !mddev->bitmap_ops->endwrite)
+		return;
+
+	mddev->bitmap_ops->endwrite(mddev->bitmap, offset, sectors, success,
+				    behind);
+}
+
 int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
 void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
 void md_bitmap_close_sync(struct bitmap *bitmap);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 16e741bde382..670ed59d3453 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -418,8 +418,7 @@ static void close_write(struct r1bio *r1_bio)
 		r1_bio->behind_master_bio = NULL;
 	}
 	/* clear the bitmap if all writes complete successfully */
-	md_bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
-			   r1_bio->sectors,
+	md_bitmap_endwrite(r1_bio->mddev, r1_bio->sector, r1_bio->sectors,
 			   !test_bit(R1BIO_Degraded, &r1_bio->state),
 			   test_bit(R1BIO_BehindIO, &r1_bio->state));
 	md_write_end(r1_bio->mddev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 34948fef1339..2876686a9bf2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -427,8 +427,7 @@ static void raid10_end_read_request(struct bio *bio)
 static void close_write(struct r10bio *r10_bio)
 {
 	/* clear the bitmap if all writes complete successfully */
-	md_bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
-			   r10_bio->sectors,
+	md_bitmap_endwrite(r10_bio->mddev, r10_bio->sector, r10_bio->sectors,
 			   !test_bit(R10BIO_Degraded, &r10_bio->state),
 			   0);
 	md_write_end(r10_bio->mddev);
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 874874fe4fa1..1b007276371c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -313,7 +313,7 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 		if (sh->dev[i].written) {
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+			md_bitmap_endwrite(conf->mddev, sh->sector,
 					   RAID5_STRIPE_SECTORS(conf),
 					   !test_bit(STRIPE_DEGRADED, &sh->state),
 					   0);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 127e4b4c6c20..2e54115da719 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3663,7 +3663,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi = nextbi;
 		}
 		if (bitmap_end)
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+			md_bitmap_endwrite(conf->mddev, sh->sector,
 					   RAID5_STRIPE_SECTORS(conf), 0, 0);
 		bitmap_end = 0;
 		/* and fail all 'written' */
@@ -3709,7 +3709,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			}
 		}
 		if (bitmap_end)
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+			md_bitmap_endwrite(conf->mddev, sh->sector,
 					   RAID5_STRIPE_SECTORS(conf), 0, 0);
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
@@ -4059,7 +4059,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					bio_endio(wbi);
 					wbi = wbi2;
 				}
-				md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
+				md_bitmap_endwrite(conf->mddev, sh->sector,
 						   RAID5_STRIPE_SECTORS(conf),
 						   !test_bit(STRIPE_DEGRADED, &sh->state),
 						   0);
-- 
2.39.2

