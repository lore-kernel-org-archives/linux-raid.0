Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDEE14EC56;
	Wed, 14 Aug 2024 07:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723619740; cv=none; b=K8hgFDpUqUuTfgSIgZeAV0hE9FflT3ww/h1H8VJNDoZ7mwT6PSdMdc6dHt0IiMSHEoQ+urSxSiEMz/yDdf27g7h/2PZWvmtgJoiT6qhIkFCuF1r6flXYs1xPSEeg3e5rjm79UDZKMcINrmQhdD4wGdb9c5PtFvvY2O38gxQtsxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723619740; c=relaxed/simple;
	bh=eJVidopmL3BVvgJVPZ1PVwqSKs/h9XTYx62CiDodPuw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j9hu0VxsoFkAWLKSIdCF6mF8vHHd2nG6HMsscSfY1Vma7bppoZUZ2DzS6AsyzWt38uIY4oc3sUDoku9gtct5owagch92hmgDLtve132LVPBxmw0QPhzwz40phph+Zs1HBSNY0SCW5F1euDHir0V9IdnX/oEMJisbGg/ZGRWU8PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WkKK54PGsz4f3jdF;
	Wed, 14 Aug 2024 15:15:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5C5901A07B6;
	Wed, 14 Aug 2024 15:15:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHboSLWbxmIxKbBg--.47745S27;
	Wed, 14 Aug 2024 15:15:35 +0800 (CST)
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
Subject: [PATCH RFC -next v2 23/41] md/md-bitmap: merge md_bitmap_endwrite() into bitmap_operations
Date: Wed, 14 Aug 2024 15:10:55 +0800
Message-Id: <20240814071113.346781-24-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBHboSLWbxmIxKbBg--.47745S27
X-Coremail-Antispam: 1UD129KBjvJXoW3XrWkXw15tr4xurWUWw4Durg_yoWxKrW5pa
	9rJFyfC3y5tF9xZw1UAFWDuFyFvw1kKrZrtrWfG3s5ua4qvr90gF48WFW8Kw1DCFy3AFy3
	Z3Z8trWUGrW2qFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
	1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQFxUU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

So that the implementation won't be exposed, and it'll be possible
to invent a new bitmap by replacing bitmap_operations.

Also change the parameter from bitmap to mddev, to avoid access
bitmap outside md-bitmap.c as much as possible. And change the type
of 'success' and behind' from int to bool.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c   |  9 ++++++---
 drivers/md/md-bitmap.h   |  4 ++--
 drivers/md/raid1.c       | 12 +++++++-----
 drivers/md/raid10.c      | 11 ++++++-----
 drivers/md/raid5-cache.c |  8 ++++----
 drivers/md/raid5.c       | 18 ++++++++++--------
 6 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 1387d5bbf8a1..8da6e889d5f1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1524,11 +1524,14 @@ static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
 	return 0;
 }
 
-void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind)
+static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
+			    unsigned long sectors, bool success, bool behind)
 {
+	struct bitmap *bitmap = mddev->bitmap;
+
 	if (!bitmap)
 		return;
+
 	if (behind) {
 		if (atomic_dec_and_test(&bitmap->behind_writes))
 			wake_up(&bitmap->behind_wait);
@@ -1575,7 +1578,6 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			sectors = 0;
 	}
 }
-EXPORT_SYMBOL(md_bitmap_endwrite);
 
 static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 			       int degraded)
@@ -2728,6 +2730,7 @@ static struct bitmap_operations bitmap_ops = {
 	.dirty_bits		= bitmap_dirty_bits,
 
 	.startwrite		= bitmap_startwrite,
+	.endwrite		= bitmap_endwrite,
 
 	.update_sb		= bitmap_update_sb,
 	.get_stats		= bitmap_get_stats,
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cc76b4a69a31..223dc5d6f4e4 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -256,6 +256,8 @@ struct bitmap_operations {
 
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors, bool behind);
+	void (*endwrite)(struct mddev *mddev, sector_t offset,
+			 unsigned long sectors, bool success, bool behind);
 
 	void (*update_sb)(struct bitmap *bitmap);
 	int (*get_stats)(struct bitmap *bitmap, struct md_bitmap_stats *stats);
@@ -265,8 +267,6 @@ struct bitmap_operations {
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
 /* these are exported */
-void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind);
 int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
 void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
 void md_bitmap_close_sync(struct bitmap *bitmap);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e07b3a0427cb..aeee09965817 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -411,18 +411,20 @@ static void raid1_end_read_request(struct bio *bio)
 
 static void close_write(struct r1bio *r1_bio)
 {
+	struct mddev *mddev = r1_bio->mddev;
+
 	/* it really is the end of this request */
 	if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
 		bio_free_pages(r1_bio->behind_master_bio);
 		bio_put(r1_bio->behind_master_bio);
 		r1_bio->behind_master_bio = NULL;
 	}
+
 	/* clear the bitmap if all writes complete successfully */
-	md_bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
-			   r1_bio->sectors,
-			   !test_bit(R1BIO_Degraded, &r1_bio->state),
-			   test_bit(R1BIO_BehindIO, &r1_bio->state));
-	md_write_end(r1_bio->mddev);
+	mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors,
+				    !test_bit(R1BIO_Degraded, &r1_bio->state),
+				    test_bit(R1BIO_BehindIO, &r1_bio->state));
+	md_write_end(mddev);
 }
 
 static void r1_bio_write_done(struct r1bio *r1_bio)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 96de2d68c913..52f29b907ab6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -426,12 +426,13 @@ static void raid10_end_read_request(struct bio *bio)
 
 static void close_write(struct r10bio *r10_bio)
 {
+	struct mddev *mddev = r10_bio->mddev;
+
 	/* clear the bitmap if all writes complete successfully */
-	md_bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
-			   r10_bio->sectors,
-			   !test_bit(R10BIO_Degraded, &r10_bio->state),
-			   0);
-	md_write_end(r10_bio->mddev);
+	mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors,
+				    !test_bit(R10BIO_Degraded, &r10_bio->state),
+				    false);
+	md_write_end(mddev);
 }
 
 static void one_write_done(struct r10bio *r10_bio)
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 874874fe4fa1..23f2cbcf1a6c 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -313,10 +313,10 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 		if (sh->dev[i].written) {
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf),
-					   !test_bit(STRIPE_DEGRADED, &sh->state),
-					   0);
+			conf->mddev->bitmap_ops->endwrite(conf->mddev,
+					sh->sector, RAID5_STRIPE_SECTORS(conf),
+					!test_bit(STRIPE_DEGRADED, &sh->state),
+					false);
 		}
 	}
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c24036d1e6da..93d582b9f922 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3663,8 +3663,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bi = nextbi;
 		}
 		if (bitmap_end)
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0, 0);
+			conf->mddev->bitmap_ops->endwrite(conf->mddev,
+					sh->sector, RAID5_STRIPE_SECTORS(conf),
+					false, false);
 		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
@@ -3709,8 +3710,9 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			}
 		}
 		if (bitmap_end)
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0, 0);
+			conf->mddev->bitmap_ops->endwrite(conf->mddev,
+					sh->sector, RAID5_STRIPE_SECTORS(conf),
+					false, false);
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -4059,10 +4061,10 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					bio_endio(wbi);
 					wbi = wbi2;
 				}
-				md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						   RAID5_STRIPE_SECTORS(conf),
-						   !test_bit(STRIPE_DEGRADED, &sh->state),
-						   0);
+				conf->mddev->bitmap_ops->endwrite(conf->mddev,
+					sh->sector, RAID5_STRIPE_SECTORS(conf),
+					!test_bit(STRIPE_DEGRADED, &sh->state),
+					false);
 				if (head_sh->batch_head) {
 					sh = list_first_entry(&sh->batch_list,
 							      struct stripe_head,
-- 
2.39.2

