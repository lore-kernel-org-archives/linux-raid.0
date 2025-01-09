Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB52221345;
	Thu,  9 Jan 2025 01:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736387809; cv=none; b=arIl8LrMESNBkcdLR7hJevXt/qG6jT3yZ/KmXQjlwiq2StEMOIOY+YZjk04N4hOJKktiLRv+LL/zl3YeIREZWaL535q06nO9FSQZisnaQhV0faxKQpTyE4LU4uPS2Vg1B44z90pN1Cj0TDT4wlwFvPkP1cu8PK2+o98ogu9Iq/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736387809; c=relaxed/simple;
	bh=/qcelbv0tg3mBSh4E9DZULPHKc+YIKxZXWIPO3yDEu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=US8Ap5o8mtni2xBOsxKBakrdRc97B886c+AMXN2zfQ2IXOnOeS7zOHgu8QKEsTc9kYEODBIoSNYvJZIEzO11YpQbdfs1i9iTHIsYXXfpjnzkx92zWcu97S6jXzKovVJ5nmtqcF1GfuVShV4tE5jI92yVrkhPA+LVs6DLgmBgAZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YT7Dk3BStz4f3kvv;
	Thu,  9 Jan 2025 09:56:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D20761A09F1;
	Thu,  9 Jan 2025 09:56:43 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCH61_YLH9nk+G_AQ--.844S8;
	Thu, 09 Jan 2025 09:56:43 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	xni@redhat.com,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.14 4/5] md/raid5: implement pers->bitmap_sector()
Date: Thu,  9 Jan 2025 09:51:44 +0800
Message-Id: <20250109015145.158868-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250109015145.158868-1-yukuai1@huaweicloud.com>
References: <20250109015145.158868-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH61_YLH9nk+G_AQ--.844S8
X-Coremail-Antispam: 1UD129KBjvJXoW3GFy5AFWfury7JF1DZr17GFg_yoWxKFW8pa
	yayFy2grWqqrn0gwsxJw1vgFyFkrZFkrW5tasrW34Ikw1fGr97Z3WUGwn0gF1UCFy3Jr45
	tw1UAFW8Cr4qga7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Bitmap is used for the whole array for raid1/raid10, hence IO for the
array can be used directly for bitmap. However, bitmap is used for
underlying disks for raid5, hence IO for the array can't be used
directly for bitmap.

Implement pers->bitmap_sector() for raid5 to convert IO ranges from the
array to the underlying disks.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 145 ++++++++++++++++++++++++++++++---------------
 1 file changed, 98 insertions(+), 47 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a5a619400d8f..5377f4c3fffc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -63,6 +63,13 @@
 
 #define RAID5_MAX_REQ_STRIPES 256
 
+enum reshape_loc {
+	LOC_NO_RESHAPE,
+	LOC_AHEAD_OF_RESHAPE,
+	LOC_INSIDE_RESHAPE,
+	LOC_BEHIND_RESHAPE,
+};
+
 static bool devices_handle_discard_safely = false;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
@@ -2947,6 +2954,94 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
 	r5c_update_on_rdev_error(mddev, rdev);
 }
 
+static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
+			     sector_t reshape_sector)
+{
+	return mddev->reshape_backwards ? sector < reshape_sector :
+					  sector >= reshape_sector;
+}
+
+static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
+				   sector_t max, sector_t reshape_sector)
+{
+	return mddev->reshape_backwards ? max < reshape_sector :
+					  min >= reshape_sector;
+}
+
+static enum reshape_loc get_reshape_loc(struct mddev *mddev,
+		struct r5conf *conf, sector_t logical_sector)
+{
+	sector_t reshape_progress, reshape_safe;
+	/*
+	 * Spinlock is needed as reshape_progress may be
+	 * 64bit on a 32bit platform, and so it might be
+	 * possible to see a half-updated value
+	 * Of course reshape_progress could change after
+	 * the lock is dropped, so once we get a reference
+	 * to the stripe that we think it is, we will have
+	 * to check again.
+	 */
+	spin_lock_irq(&conf->device_lock);
+	reshape_progress = conf->reshape_progress;
+	reshape_safe = conf->reshape_safe;
+	spin_unlock_irq(&conf->device_lock);
+	if (reshape_progress == MaxSector)
+		return LOC_NO_RESHAPE;
+	if (ahead_of_reshape(mddev, logical_sector, reshape_progress))
+		return LOC_AHEAD_OF_RESHAPE;
+	if (ahead_of_reshape(mddev, logical_sector, reshape_safe))
+		return LOC_INSIDE_RESHAPE;
+	return LOC_BEHIND_RESHAPE;
+}
+
+static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
+				unsigned long *sectors)
+{
+	struct r5conf *conf = mddev->private;
+	sector_t start = *offset;
+	sector_t end = start + *sectors;
+	sector_t prev_start = start;
+	sector_t prev_end = end;
+	int sectors_per_chunk;
+	enum reshape_loc loc;
+	int dd_idx;
+
+	sectors_per_chunk = conf->chunk_sectors *
+		(conf->raid_disks - conf->max_degraded);
+	start = round_down(start, sectors_per_chunk);
+	end = round_up(end, sectors_per_chunk);
+
+	start = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
+	end = raid5_compute_sector(conf, end, 0, &dd_idx, NULL);
+
+	/*
+	 * For LOC_INSIDE_RESHAPE, this IO will wait for reshape to make
+	 * progress, hence it's the same as LOC_BEHIND_RESHAPE.
+	 */
+	loc = get_reshape_loc(mddev, conf, prev_start);
+	if (likely(loc != LOC_AHEAD_OF_RESHAPE)) {
+		*offset = start;
+		*sectors = end - start;
+		return;
+	}
+
+	sectors_per_chunk = conf->prev_chunk_sectors *
+		(conf->previous_raid_disks - conf->max_degraded);
+	prev_start = round_down(prev_start, sectors_per_chunk);
+	prev_end = round_down(prev_end, sectors_per_chunk);
+
+	prev_start = raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
+	prev_end = raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);
+
+	/*
+	 * for LOC_AHEAD_OF_RESHAPE, reshape can make progress before this IO
+	 * is handled in make_stripe_request(), we can't know this here hence
+	 * we set bits for both.
+	 */
+	*offset = min(start, prev_start);
+	*sectors = max(end, prev_end) - *offset;
+}
+
 /*
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
@@ -5792,20 +5887,6 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	bio_endio(bi);
 }
 
-static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
-			     sector_t reshape_sector)
-{
-	return mddev->reshape_backwards ? sector < reshape_sector :
-					  sector >= reshape_sector;
-}
-
-static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
-				   sector_t max, sector_t reshape_sector)
-{
-	return mddev->reshape_backwards ? max < reshape_sector :
-					  min >= reshape_sector;
-}
-
 static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
 				    struct stripe_head *sh)
 {
@@ -5885,39 +5966,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
 	return 1;
 }
 
-enum reshape_loc {
-	LOC_NO_RESHAPE,
-	LOC_AHEAD_OF_RESHAPE,
-	LOC_INSIDE_RESHAPE,
-	LOC_BEHIND_RESHAPE,
-};
-
-static enum reshape_loc get_reshape_loc(struct mddev *mddev,
-		struct r5conf *conf, sector_t logical_sector)
-{
-	sector_t reshape_progress, reshape_safe;
-	/*
-	 * Spinlock is needed as reshape_progress may be
-	 * 64bit on a 32bit platform, and so it might be
-	 * possible to see a half-updated value
-	 * Of course reshape_progress could change after
-	 * the lock is dropped, so once we get a reference
-	 * to the stripe that we think it is, we will have
-	 * to check again.
-	 */
-	spin_lock_irq(&conf->device_lock);
-	reshape_progress = conf->reshape_progress;
-	reshape_safe = conf->reshape_safe;
-	spin_unlock_irq(&conf->device_lock);
-	if (reshape_progress == MaxSector)
-		return LOC_NO_RESHAPE;
-	if (ahead_of_reshape(mddev, logical_sector, reshape_progress))
-		return LOC_AHEAD_OF_RESHAPE;
-	if (ahead_of_reshape(mddev, logical_sector, reshape_safe))
-		return LOC_INSIDE_RESHAPE;
-	return LOC_BEHIND_RESHAPE;
-}
-
 static enum stripe_result make_stripe_request(struct mddev *mddev,
 		struct r5conf *conf, struct stripe_request_ctx *ctx,
 		sector_t logical_sector, struct bio *bi)
@@ -8966,6 +9014,7 @@ static struct md_personality raid6_personality =
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 static struct md_personality raid5_personality =
 {
@@ -8991,6 +9040,7 @@ static struct md_personality raid5_personality =
 	.takeover	= raid5_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static struct md_personality raid4_personality =
@@ -9017,6 +9067,7 @@ static struct md_personality raid4_personality =
 	.takeover	= raid4_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static int __init raid5_init(void)
-- 
2.39.2

