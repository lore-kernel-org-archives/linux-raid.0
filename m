Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B6F1ADC86;
	Mon, 10 Feb 2025 07:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739173230; cv=none; b=trSGXAWwaGfshLL1POaeCthxYOI2HMsp5gmcC3ojDhk+szRIS2mhOWl4Z3m5mIHhNKve9Slz46WShZ43UjJELQNKXw+OMoCOungO9hivWuk0H7gw7yfrpR5Jw9vlRYWdfUwRy1nLfhlXYbLOpTIp9PylKS/u2/QgGtZYCMvGl0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739173230; c=relaxed/simple;
	bh=uo9YzpsCijE/WGfyIam+ftIm8z2Pj5O900BkNyHgY7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gZcWE8XHqvapUBUtey7bGUEsRrTEh7ibngKSZX2Bf/97cJ+MYTtn21GfIeoZxTkVSZwQMhL2/iowGEdmw/2UgLjaLnbTHGsPae7KOxGRRVszUV3sAnfIakaPNQr1nedcyxiOLT3n+qwMJw7H500ZgebfeGAV1Abq2Jx+oot69gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YrxLN6xnJz4f3jY6;
	Mon, 10 Feb 2025 15:39:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3CC1F1A0C47;
	Mon, 10 Feb 2025 15:40:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa19cralnS0S5DQ--.28027S6;
	Mon, 10 Feb 2025 15:40:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 6.6 v2 2/6] md/md-bitmap: factor behind write counters out from bitmap_{start/end}write()
Date: Mon, 10 Feb 2025 15:33:18 +0800
Message-Id: <20250210073322.3315094-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210073322.3315094-1-yukuai1@huaweicloud.com>
References: <20250210073322.3315094-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa19cralnS0S5DQ--.28027S6
X-Coremail-Antispam: 1UD129KBjvJXoWxtrWkGr1ftryktr15KFy8Krg_yoWfKFy8pa
	yDJr9xC3y5tFW3Zw1DAFWDuF1Fvw1kKr9rtrWrW3s093WjyF90gF48WFy0gw1DAFy3AFW3
	Zan8JrWUCrWjqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtVW8Zw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUczV8UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit 08c50142a128dcb2d7060aa3b4c5db8837f7a46a upstream.

behind_write is only used in raid1, prepare to refactor
bitmap_{start/end}write(), there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/r/20250109015145.158868-2-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
[There is no bitmap_operations, resolve conflicts by exporting new api
md_bitmap_{start,end}_behind_write]
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c   | 60 +++++++++++++++++++++++++---------------
 drivers/md/md-bitmap.h   |  6 ++--
 drivers/md/raid1.c       | 11 +++++---
 drivers/md/raid10.c      |  5 ++--
 drivers/md/raid5-cache.c |  4 +--
 drivers/md/raid5.c       | 13 ++++-----
 6 files changed, 59 insertions(+), 40 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ba63076cd8f2..6cd50ab69c2a 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1465,22 +1465,12 @@ __acquires(bitmap->lock)
 			&(bitmap->bp[page].map[pageoff]);
 }
 
-int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
+int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
+			 unsigned long sectors)
 {
 	if (!bitmap)
 		return 0;
 
-	if (behind) {
-		int bw;
-		atomic_inc(&bitmap->behind_writes);
-		bw = atomic_read(&bitmap->behind_writes);
-		if (bw > bitmap->behind_writes_used)
-			bitmap->behind_writes_used = bw;
-
-		pr_debug("inc write-behind count %d/%lu\n",
-			 bw, bitmap->mddev->bitmap_info.max_write_behind);
-	}
-
 	while (sectors) {
 		sector_t blocks;
 		bitmap_counter_t *bmc;
@@ -1527,20 +1517,13 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long s
 	}
 	return 0;
 }
-EXPORT_SYMBOL(md_bitmap_startwrite);
+EXPORT_SYMBOL_GPL(md_bitmap_startwrite);
 
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind)
+			unsigned long sectors, int success)
 {
 	if (!bitmap)
 		return;
-	if (behind) {
-		if (atomic_dec_and_test(&bitmap->behind_writes))
-			wake_up(&bitmap->behind_wait);
-		pr_debug("dec write-behind count %d/%lu\n",
-			 atomic_read(&bitmap->behind_writes),
-			 bitmap->mddev->bitmap_info.max_write_behind);
-	}
 
 	while (sectors) {
 		sector_t blocks;
@@ -1580,7 +1563,7 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			sectors = 0;
 	}
 }
-EXPORT_SYMBOL(md_bitmap_endwrite);
+EXPORT_SYMBOL_GPL(md_bitmap_endwrite);
 
 static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 			       int degraded)
@@ -1842,6 +1825,39 @@ void md_bitmap_free(struct bitmap *bitmap)
 }
 EXPORT_SYMBOL(md_bitmap_free);
 
+void md_bitmap_start_behind_write(struct mddev *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+	int bw;
+
+	if (!bitmap)
+		return;
+
+	atomic_inc(&bitmap->behind_writes);
+	bw = atomic_read(&bitmap->behind_writes);
+	if (bw > bitmap->behind_writes_used)
+		bitmap->behind_writes_used = bw;
+
+	pr_debug("inc write-behind count %d/%lu\n",
+		 bw, bitmap->mddev->bitmap_info.max_write_behind);
+}
+EXPORT_SYMBOL_GPL(md_bitmap_start_behind_write);
+
+void md_bitmap_end_behind_write(struct mddev *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		return;
+
+	if (atomic_dec_and_test(&bitmap->behind_writes))
+		wake_up(&bitmap->behind_wait);
+	pr_debug("dec write-behind count %d/%lu\n",
+		 atomic_read(&bitmap->behind_writes),
+		 bitmap->mddev->bitmap_info.max_write_behind);
+}
+EXPORT_SYMBOL_GPL(md_bitmap_end_behind_write);
+
 void md_bitmap_wait_behind_writes(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index bb9eb418780a..cc5e0b49b0b5 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -253,9 +253,11 @@ void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long
 
 /* these are exported */
 int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
-			 unsigned long sectors, int behind);
+			 unsigned long sectors);
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind);
+			unsigned long sectors, int success);
+void md_bitmap_start_behind_write(struct mddev *mddev);
+void md_bitmap_end_behind_write(struct mddev *mddev);
 int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
 void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
 void md_bitmap_close_sync(struct bitmap *bitmap);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cc02e7ec72c0..ae3cafa415f2 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -419,11 +419,12 @@ static void close_write(struct r1bio *r1_bio)
 		bio_put(r1_bio->behind_master_bio);
 		r1_bio->behind_master_bio = NULL;
 	}
+	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
+		md_bitmap_end_behind_write(r1_bio->mddev);
 	/* clear the bitmap if all writes complete successfully */
 	md_bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
 			   r1_bio->sectors,
-			   !test_bit(R1BIO_Degraded, &r1_bio->state),
-			   test_bit(R1BIO_BehindIO, &r1_bio->state));
+			   !test_bit(R1BIO_Degraded, &r1_bio->state));
 	md_write_end(r1_bio->mddev);
 }
 
@@ -1530,8 +1531,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				alloc_behind_master_bio(r1_bio, bio);
 			}
 
-			md_bitmap_startwrite(bitmap, r1_bio->sector, r1_bio->sectors,
-					     test_bit(R1BIO_BehindIO, &r1_bio->state));
+			if (test_bit(R1BIO_BehindIO, &r1_bio->state))
+				md_bitmap_start_behind_write(mddev);
+			md_bitmap_startwrite(bitmap, r1_bio->sector,
+					     r1_bio->sectors);
 			first_clone = 0;
 		}
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 023413120851..7033cbff61cf 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -430,8 +430,7 @@ static void close_write(struct r10bio *r10_bio)
 	/* clear the bitmap if all writes complete successfully */
 	md_bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
 			   r10_bio->sectors,
-			   !test_bit(R10BIO_Degraded, &r10_bio->state),
-			   0);
+			   !test_bit(R10BIO_Degraded, &r10_bio->state));
 	md_write_end(r10_bio->mddev);
 }
 
@@ -1554,7 +1553,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	md_account_bio(mddev, &bio);
 	r10_bio->master_bio = bio;
 	atomic_set(&r10_bio->remaining, 1);
-	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
+	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors);
 
 	for (i = 0; i < conf->copies; i++) {
 		if (r10_bio->devs[i].bio)
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 889bba60d6ff..763bf0dcead8 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -315,8 +315,8 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					   RAID5_STRIPE_SECTORS(conf),
-					   !test_bit(STRIPE_DEGRADED, &sh->state),
-					   0);
+					   !test_bit(STRIPE_DEGRADED,
+						     &sh->state));
 		}
 	}
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3923063eada9..3484d649610d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3606,7 +3606,7 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		spin_unlock_irq(&sh->stripe_lock);
 		md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-				     RAID5_STRIPE_SECTORS(conf), 0);
+				     RAID5_STRIPE_SECTORS(conf));
 		spin_lock_irq(&sh->stripe_lock);
 		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		if (!sh->batch_head) {
@@ -3708,7 +3708,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		}
 		if (bitmap_end)
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0, 0);
+					   RAID5_STRIPE_SECTORS(conf), 0);
 		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
@@ -3754,7 +3754,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		}
 		if (bitmap_end)
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0, 0);
+					   RAID5_STRIPE_SECTORS(conf), 0);
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -4107,8 +4107,8 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 				}
 				md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 						   RAID5_STRIPE_SECTORS(conf),
-						   !test_bit(STRIPE_DEGRADED, &sh->state),
-						   0);
+						   !test_bit(STRIPE_DEGRADED,
+							     &sh->state));
 				if (head_sh->batch_head) {
 					sh = list_first_entry(&sh->batch_list,
 							      struct stripe_head,
@@ -5853,8 +5853,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 			     d++)
 				md_bitmap_startwrite(mddev->bitmap,
 						     sh->sector,
-						     RAID5_STRIPE_SECTORS(conf),
-						     0);
+						     RAID5_STRIPE_SECTORS(conf));
 			sh->bm_seq = conf->seq_flush + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
-- 
2.39.2

