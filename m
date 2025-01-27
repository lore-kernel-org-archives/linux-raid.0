Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950F31FCFFE;
	Mon, 27 Jan 2025 08:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968401; cv=none; b=O/o3kDnCkZgyIOa+qLzSukuMeQUeG/OAfQiNjh/r/QIKUdPyB4UOueNKDzh1iUEQ/Z7AaoQeugHhU4TFdQOYIwKn9ejukSUpZ7vQoiMhqvXNMTrgTlFhyULcf3dgFb+3AvkWbKbkJorktwJMMvUvhkFMIWBxCHvZRbuUouHdiIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968401; c=relaxed/simple;
	bh=xPBlHwrcmnkzewS+Q3fxP/aLcJPlWSAuhn7qsOamPd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ac+9TUe44PSP/lzTpfXlHvMxPHYEhbGLwCKoB7QJufbMeqaY32fn5lhLB9OSfe2fe91yuNARebgiSPPTwngiOXidzHtDfa0wmYxT/gCyruBMJUNHcT0TBvQw4+T5v3eHZ5G8aos/xIp2cgnCgVn0QJ+NdinZj8uCuTJZmV2kODs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YhMmk67J1z4f3kGD;
	Mon, 27 Jan 2025 16:59:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A34D91A16BE;
	Mon, 27 Jan 2025 16:59:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa18IS5dnHix+CA--.52181S10;
	Mon, 27 Jan 2025 16:59:55 +0800 (CST)
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
Subject: [PATCH 6.6 6/6] md/md-bitmap: move bitmap_{start, end}write to md upper layer
Date: Mon, 27 Jan 2025 16:53:51 +0800
Message-Id: <20250127085351.3198083-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250127085351.3198083-1-yukuai1@huaweicloud.com>
References: <20250127085351.3198083-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa18IS5dnHix+CA--.52181S10
X-Coremail-Antispam: 1UD129KBjvAXoW3ZrWrtr15XF48Gr4Utr4fXwb_yoW8Gry3uo
	Z7AFy5Xrn8Wr4xXryrJr45JFW3Wr1DKr15A345Gr1DWFZrJrnYqw1IkrW3Jr17tr13ZF4f
	Zry7J3WUJr4UJrnxn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUOb7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s0DM28Irc
	Ia0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l
	84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJV
	WxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw
	0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUo73v
	UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit cd5fc653381811f1e0ba65f5d169918cab61476f upstream.

There are two BUG reports that raid5 will hang at
bitmap_startwrite([1],[2]), root cause is that bitmap start write and end
write is unbalanced, it's not quite clear where, and while reviewing raid5
code, it's found that bitmap operations can be optimized. For example,
for a 4 disks raid5, with chunksize=8k, if user issue a IO (0 + 48k) to
the array:

┌────────────────────────────────────────────────────────────┐
│chunk 0                                                     │
│      ┌────────────┬─────────────┬─────────────┬────────────┼
│  sh0 │A0: 0 + 4k  │A1: 8k + 4k  │A2: 16k + 4k │A3: P       │
│      ┼────────────┼─────────────┼─────────────┼────────────┼
│  sh1 │B0: 4k + 4k │B1: 12k + 4k │B2: 20k + 4k │B3: P       │
┼──────┴────────────┴─────────────┴─────────────┴────────────┼
│chunk 1                                                     │
│      ┌────────────┬─────────────┬─────────────┬────────────┤
│  sh2 │C0: 24k + 4k│C1: 32k + 4k │C2: P        │C3: 40k + 4k│
│      ┼────────────┼─────────────┼─────────────┼────────────┼
│  sh3 │D0: 28k + 4k│D1: 36k + 4k │D2: P        │D3: 44k + 4k│
└──────┴────────────┴─────────────┴─────────────┴────────────┘

Before this patch, 4 stripe head will be used, and each sh will attach
bio for 3 disks, and each attached bio will trigger
bitmap_startwrite() once, which means total 12 times.
 - 3 times (0 + 4k), for (A0, A1 and A2)
 - 3 times (4 + 4k), for (B0, B1 and B2)
 - 3 times (8 + 4k), for (C0, C1 and C3)
 - 3 times (12 + 4k), for (D0, D1 and D3)

After this patch, md upper layer will calculate that IO range (0 + 48k)
is corresponding to the bitmap (0 + 16k), and call bitmap_startwrite()
just once.

Noted that this patch will align bitmap ranges to the chunks, for example,
if user issue a IO (0 + 4k) to array:

- Before this patch, 1 time (0 + 4k), for A0;
- After this patch, 1 time (0 + 8k) for chunk 0;

Usually, one bitmap bit will represent more than one disk chunk, and this
doesn't have any difference. And even if user really created a array
that one chunk contain multiple bits, the overhead is that more data
will be recovered after power failure.

Also remove STRIPE_BITMAP_PENDING since it's not used anymore.

[1] https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
[2] https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250109015145.158868-6-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
---
 drivers/md/md-bitmap.c   |  2 --
 drivers/md/md.c          | 26 +++++++++++++++++++++
 drivers/md/md.h          |  2 ++
 drivers/md/raid1.c       |  5 ----
 drivers/md/raid10.c      |  4 ----
 drivers/md/raid5-cache.c |  2 --
 drivers/md/raid5.c       | 50 ++++------------------------------------
 drivers/md/raid5.h       |  3 ---
 8 files changed, 33 insertions(+), 61 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 1bb99102f7cc..2085b1705f14 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1517,7 +1517,6 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(md_bitmap_startwrite);
 
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			unsigned long sectors)
@@ -1564,7 +1563,6 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			sectors = 0;
 	}
 }
-EXPORT_SYMBOL_GPL(md_bitmap_endwrite);
 
 static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 			       int degraded)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1f6770c5cc0..9bc19a5a4119 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8713,12 +8713,32 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
+static void md_bitmap_start(struct mddev *mddev,
+			    struct md_io_clone *md_io_clone)
+{
+	if (mddev->pers->bitmap_sector)
+		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
+					   &md_io_clone->sectors);
+
+	md_bitmap_startwrite(mddev->bitmap, md_io_clone->offset,
+			     md_io_clone->sectors);
+}
+
+static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
+{
+	md_bitmap_endwrite(mddev->bitmap, md_io_clone->offset,
+			   md_io_clone->sectors);
+}
+
 static void md_end_clone_io(struct bio *bio)
 {
 	struct md_io_clone *md_io_clone = bio->bi_private;
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
+	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
+		md_bitmap_end(mddev, md_io_clone);
+
 	if (bio->bi_status && !orig_bio->bi_status)
 		orig_bio->bi_status = bio->bi_status;
 
@@ -8743,6 +8763,12 @@ static void md_clone_bio(struct mddev *mddev, struct bio **bio)
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 
+	if (bio_data_dir(*bio) == WRITE && mddev->bitmap) {
+		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
+		md_io_clone->sectors = bio_sectors(*bio);
+		md_bitmap_start(mddev, md_io_clone);
+	}
+
 	clone->bi_end_io = md_end_clone_io;
 	clone->bi_private = md_io_clone;
 	*bio = clone;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f395f4562bb9..f29fa8650cd0 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -746,6 +746,8 @@ struct md_io_clone {
 	struct mddev	*mddev;
 	struct bio	*orig_bio;
 	unsigned long	start_time;
+	sector_t	offset;
+	unsigned long	sectors;
 	struct bio	bio_clone;
 };
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b5601acc810f..65309da1dca3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -421,9 +421,6 @@ static void close_write(struct r1bio *r1_bio)
 	}
 	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
 		md_bitmap_end_behind_write(r1_bio->mddev);
-	/* clear the bitmap if all writes complete successfully */
-	md_bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
-			   r1_bio->sectors);
 	md_write_end(r1_bio->mddev);
 }
 
@@ -1517,8 +1514,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 			if (test_bit(R1BIO_BehindIO, &r1_bio->state))
 				md_bitmap_start_behind_write(mddev);
-			md_bitmap_startwrite(bitmap, r1_bio->sector,
-					     r1_bio->sectors);
 			first_clone = 0;
 		}
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0b04ae46b52e..c300fd609ef0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -427,9 +427,6 @@ static void raid10_end_read_request(struct bio *bio)
 
 static void close_write(struct r10bio *r10_bio)
 {
-	/* clear the bitmap if all writes complete successfully */
-	md_bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
-			   r10_bio->sectors);
 	md_write_end(r10_bio->mddev);
 }
 
@@ -1541,7 +1538,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	md_account_bio(mddev, &bio);
 	r10_bio->master_bio = bio;
 	atomic_set(&r10_bio->remaining, 1);
-	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors);
 
 	for (i = 0; i < conf->copies; i++) {
 		if (r10_bio->devs[i].bio)
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 8a0c8e78891f..53f3718c01eb 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -313,8 +313,6 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 		if (sh->dev[i].written) {
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf));
 		}
 	}
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0918386bb8ea..f69e4a6a8a59 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -905,7 +905,6 @@ static bool stripe_can_batch(struct stripe_head *sh)
 	if (raid5_has_log(conf) || raid5_has_ppl(conf))
 		return false;
 	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
-		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
 		is_full_stripe_write(sh);
 }
 
@@ -3587,29 +3586,9 @@ static void __add_stripe_bio(struct stripe_head *sh, struct bio *bi,
 		 (*bip)->bi_iter.bi_sector, sh->sector, dd_idx,
 		 sh->dev[dd_idx].sector);
 
-	if (conf->mddev->bitmap && firstwrite) {
-		/* Cannot hold spinlock over bitmap_startwrite,
-		 * but must ensure this isn't added to a batch until
-		 * we have added to the bitmap and set bm_seq.
-		 * So set STRIPE_BITMAP_PENDING to prevent
-		 * batching.
-		 * If multiple __add_stripe_bio() calls race here they
-		 * much all set STRIPE_BITMAP_PENDING.  So only the first one
-		 * to complete "bitmap_startwrite" gets to set
-		 * STRIPE_BIT_DELAY.  This is important as once a stripe
-		 * is added to a batch, STRIPE_BIT_DELAY cannot be changed
-		 * any more.
-		 */
-		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
-		spin_unlock_irq(&sh->stripe_lock);
-		md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-				     RAID5_STRIPE_SECTORS(conf));
-		spin_lock_irq(&sh->stripe_lock);
-		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
-		if (!sh->batch_head) {
-			sh->bm_seq = conf->seq_flush+1;
-			set_bit(STRIPE_BIT_DELAY, &sh->state);
-		}
+	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
+		sh->bm_seq = conf->seq_flush+1;
+		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 }
 
@@ -3660,7 +3639,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 	BUG_ON(sh->batch_head);
 	for (i = disks; i--; ) {
 		struct bio *bi;
-		int bitmap_end = 0;
 
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			struct md_rdev *rdev;
@@ -3687,8 +3665,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		sh->dev[i].towrite = NULL;
 		sh->overwrite_disks = 0;
 		spin_unlock_irq(&sh->stripe_lock);
-		if (bi)
-			bitmap_end = 1;
 
 		log_stripe_write_finished(sh);
 
@@ -3703,10 +3679,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			bio_io_error(bi);
 			bi = nextbi;
 		}
-		if (bitmap_end)
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf));
-		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
@@ -3715,7 +3687,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			sh->dev[i].page = sh->dev[i].orig_page;
 		}
 
-		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_iter.bi_sector <
 		       sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
 			struct bio *bi2 = r5_next_bio(conf, bi, sh->dev[i].sector);
@@ -3749,9 +3720,6 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 				bi = nextbi;
 			}
 		}
-		if (bitmap_end)
-			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf));
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -4102,8 +4070,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					bio_endio(wbi);
 					wbi = wbi2;
 				}
-				md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						   RAID5_STRIPE_SECTORS(conf));
+
 				if (head_sh->batch_head) {
 					sh = list_first_entry(&sh->batch_list,
 							      struct stripe_head,
@@ -4935,8 +4902,7 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 					  (1 << STRIPE_COMPUTE_RUN)  |
 					  (1 << STRIPE_DISCARD) |
 					  (1 << STRIPE_BATCH_READY) |
-					  (1 << STRIPE_BATCH_ERR) |
-					  (1 << STRIPE_BITMAP_PENDING)),
+					  (1 << STRIPE_BATCH_ERR)),
 			"stripe state: %lx\n", sh->state);
 		WARN_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
 					      (1 << STRIPE_REPLACED)),
@@ -5840,12 +5806,6 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		}
 		spin_unlock_irq(&sh->stripe_lock);
 		if (conf->mddev->bitmap) {
-			for (d = 0;
-			     d < conf->raid_disks - conf->max_degraded;
-			     d++)
-				md_bitmap_startwrite(mddev->bitmap,
-						     sh->sector,
-						     RAID5_STRIPE_SECTORS(conf));
 			sh->bm_seq = conf->seq_flush + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 80948057b877..fd6171553880 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -371,9 +371,6 @@ enum {
 	STRIPE_ON_RELEASE_LIST,
 	STRIPE_BATCH_READY,
 	STRIPE_BATCH_ERR,
-	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
-				 * to batch yet.
-				 */
 	STRIPE_LOG_TRAPPED,	/* trapped into log (see raid5-cache.c)
 				 * this bit is used in two scenarios:
 				 *
-- 
2.39.2

