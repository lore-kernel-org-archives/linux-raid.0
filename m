Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BEF1B2182;
	Mon, 10 Feb 2025 07:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739173230; cv=none; b=F8m3oJI325y0uWhsQA/3WJI8AgNIKE8Ydrsy//6i+kRTbLnP8K+m4JvJRM1yw25dVIfyFUij9X1kONut3uwtVNEwwjwLTs9XnvYNXlIK3J9V/5Q1q7THlQRg6QOonGkWEWIIlnvebYHEv/4uyI3plZMni6eoVAMn6bup+d8YgCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739173230; c=relaxed/simple;
	bh=he4x93GomLsweL/AD/f8G9x4DWs0xnRJGXb1kDKCdyg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KjW65StWcSup1I5OM9zD/OorSOKBDwW4zJ7qn/hryvkS/trv/7zLCruNJlp2PgqluVopoJUpYyFmdGgKQRqkw/h/10vF6f/a6+gGHCS5B+wsO5q7zUlwRS4dd7Hu86cY9tijhuG0ky7pQ5i4y4QGg296KqRulo1P5bQCk1NlO+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YrxLN05Wpz4f3lVh;
	Mon, 10 Feb 2025 15:39:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9DCA11A1944;
	Mon, 10 Feb 2025 15:40:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa19cralnS0S5DQ--.28027S7;
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
Subject: [PATCH 6.6 v2 3/6] md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
Date: Mon, 10 Feb 2025 15:33:19 +0800
Message-Id: <20250210073322.3315094-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHa19cralnS0S5DQ--.28027S7
X-Coremail-Antispam: 1UD129KBjvAXoW3tFyUAr1rZw4fKFWDtrW3Awb_yoW8JrWrZo
	Z5ZwnI9a1Fqw1fXFyDtr1fJFW3WasYk34Sya1fWrs8WFZxXa4Fqr1xGrWfG3yDtryfZF43
	ZFy2qr48JF4rAw17n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUY_7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM28IrcIa0x
	kI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
	jcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr
	1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_GF
	yl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWU
	JVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7V
	AKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42
	IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUO_MaUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit 4f0e7d0e03b7b80af84759a9e7cfb0f81ac4adae upstream.

For the case that IO failed for one rdev, the bit will be mark as NEEDED
in following cases:

1) If badblocks is set and rdev is not faulty;
2) If rdev is faulty;

Case 1) is useless because synchronize data to badblocks make no sense.
Case 2) can be replaced with mddev->degraded.

Also remove R1BIO_Degraded, R10BIO_Degraded and STRIPE_DEGRADED since
case 2) no longer use them.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250109015145.158868-3-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
[ Resolve minor conflicts ]
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c   | 19 ++++++++++---------
 drivers/md/md-bitmap.h   |  2 +-
 drivers/md/raid1.c       | 27 +++------------------------
 drivers/md/raid1.h       |  1 -
 drivers/md/raid10.c      | 23 +++--------------------
 drivers/md/raid10.h      |  1 -
 drivers/md/raid5-cache.c |  4 +---
 drivers/md/raid5.c       | 14 +++-----------
 drivers/md/raid5.h       |  1 -
 9 files changed, 21 insertions(+), 71 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 6cd50ab69c2a..1bb99102f7cc 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1520,7 +1520,7 @@ int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
 EXPORT_SYMBOL_GPL(md_bitmap_startwrite);
 
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success)
+			unsigned long sectors)
 {
 	if (!bitmap)
 		return;
@@ -1537,15 +1537,16 @@ void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
 			return;
 		}
 
-		if (success && !bitmap->mddev->degraded &&
-		    bitmap->events_cleared < bitmap->mddev->events) {
-			bitmap->events_cleared = bitmap->mddev->events;
-			bitmap->need_sync = 1;
-			sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
-		}
-
-		if (!success && !NEEDED(*bmc))
+		if (!bitmap->mddev->degraded) {
+			if (bitmap->events_cleared < bitmap->mddev->events) {
+				bitmap->events_cleared = bitmap->mddev->events;
+				bitmap->need_sync = 1;
+				sysfs_notify_dirent_safe(
+						bitmap->sysfs_can_clear);
+			}
+		} else if (!NEEDED(*bmc)) {
 			*bmc |= NEEDED_MASK;
+		}
 
 		if (COUNTER(*bmc) == COUNTER_MAX)
 			wake_up(&bitmap->overflow_wait);
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index cc5e0b49b0b5..8b89e260a93b 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -255,7 +255,7 @@ void md_bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long
 int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
 			 unsigned long sectors);
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success);
+			unsigned long sectors);
 void md_bitmap_start_behind_write(struct mddev *mddev);
 void md_bitmap_end_behind_write(struct mddev *mddev);
 int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ae3cafa415f2..b5601acc810f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -423,8 +423,7 @@ static void close_write(struct r1bio *r1_bio)
 		md_bitmap_end_behind_write(r1_bio->mddev);
 	/* clear the bitmap if all writes complete successfully */
 	md_bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
-			   r1_bio->sectors,
-			   !test_bit(R1BIO_Degraded, &r1_bio->state));
+			   r1_bio->sectors);
 	md_write_end(r1_bio->mddev);
 }
 
@@ -481,8 +480,6 @@ static void raid1_end_write_request(struct bio *bio)
 		if (!test_bit(Faulty, &rdev->flags))
 			set_bit(R1BIO_WriteError, &r1_bio->state);
 		else {
-			/* Fail the request */
-			set_bit(R1BIO_Degraded, &r1_bio->state);
 			/* Finished with this branch */
 			r1_bio->bios[mirror] = NULL;
 			to_put = bio;
@@ -1415,11 +1412,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			break;
 		}
 		r1_bio->bios[i] = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags)) {
-			if (i < conf->raid_disks)
-				set_bit(R1BIO_Degraded, &r1_bio->state);
+		if (!rdev || test_bit(Faulty, &rdev->flags))
 			continue;
-		}
 
 		atomic_inc(&rdev->nr_pending);
 		if (test_bit(WriteErrorSeen, &rdev->flags)) {
@@ -1445,16 +1439,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 					 */
 					max_sectors = bad_sectors;
 				rdev_dec_pending(rdev, mddev);
-				/* We don't set R1BIO_Degraded as that
-				 * only applies if the disk is
-				 * missing, so it might be re-added,
-				 * and we want to know to recover this
-				 * chunk.
-				 * In this case the device is here,
-				 * and the fact that this chunk is not
-				 * in-sync is recorded in the bad
-				 * block log
-				 */
 				continue;
 			}
 			if (is_bad) {
@@ -2479,12 +2463,9 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * errors.
 			 */
 			fail = true;
-			if (!narrow_write_error(r1_bio, m)) {
+			if (!narrow_write_error(r1_bio, m))
 				md_error(conf->mddev,
 					 conf->mirrors[m].rdev);
-				/* an I/O failed, we can't clear the bitmap */
-				set_bit(R1BIO_Degraded, &r1_bio->state);
-			}
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
@@ -2576,8 +2557,6 @@ static void raid1d(struct md_thread *thread)
 			list_del(&r1_bio->retry_list);
 			idx = sector_to_idx(r1_bio->sector);
 			atomic_dec(&conf->nr_queued[idx]);
-			if (mddev->degraded)
-				set_bit(R1BIO_Degraded, &r1_bio->state);
 			if (test_bit(R1BIO_WriteError, &r1_bio->state))
 				close_write(r1_bio);
 			raid_end_bio_io(r1_bio);
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 14d4211a123a..44f2390a8866 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -187,7 +187,6 @@ struct r1bio {
 enum r1bio_state {
 	R1BIO_Uptodate,
 	R1BIO_IsSync,
-	R1BIO_Degraded,
 	R1BIO_BehindIO,
 /* Set ReadError on bios that experience a readerror so that
  * raid1d knows what to do with them.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7033cbff61cf..0b04ae46b52e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -429,8 +429,7 @@ static void close_write(struct r10bio *r10_bio)
 {
 	/* clear the bitmap if all writes complete successfully */
 	md_bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
-			   r10_bio->sectors,
-			   !test_bit(R10BIO_Degraded, &r10_bio->state));
+			   r10_bio->sectors);
 	md_write_end(r10_bio->mddev);
 }
 
@@ -500,7 +499,6 @@ static void raid10_end_write_request(struct bio *bio)
 				set_bit(R10BIO_WriteError, &r10_bio->state);
 			else {
 				/* Fail the request */
-				set_bit(R10BIO_Degraded, &r10_bio->state);
 				r10_bio->devs[slot].bio = NULL;
 				to_put = bio;
 				dec_rdev = 1;
@@ -1489,10 +1487,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->devs[i].bio = NULL;
 		r10_bio->devs[i].repl_bio = NULL;
 
-		if (!rdev && !rrdev) {
-			set_bit(R10BIO_Degraded, &r10_bio->state);
+		if (!rdev && !rrdev)
 			continue;
-		}
 		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			sector_t dev_sector = r10_bio->devs[i].addr;
@@ -1509,14 +1505,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 					 * to other devices yet
 					 */
 					max_sectors = bad_sectors;
-				/* We don't set R10BIO_Degraded as that
-				 * only applies if the disk is missing,
-				 * so it might be re-added, and we want to
-				 * know to recover this chunk.
-				 * In this case the device is here, and the
-				 * fact that this chunk is not in-sync is
-				 * recorded in the bad block log.
-				 */
 				continue;
 			}
 			if (is_bad) {
@@ -3062,11 +3050,8 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
 				fail = true;
-				if (!narrow_write_error(r10_bio, m)) {
+				if (!narrow_write_error(r10_bio, m))
 					md_error(conf->mddev, rdev);
-					set_bit(R10BIO_Degraded,
-						&r10_bio->state);
-				}
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
@@ -3125,8 +3110,6 @@ static void raid10d(struct md_thread *thread)
 			r10_bio = list_first_entry(&tmp, struct r10bio,
 						   retry_list);
 			list_del(&r10_bio->retry_list);
-			if (mddev->degraded)
-				set_bit(R10BIO_Degraded, &r10_bio->state);
 
 			if (test_bit(R10BIO_WriteError,
 				     &r10_bio->state))
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 2e75e88d0802..3f16ad6904a9 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -161,7 +161,6 @@ enum r10bio_state {
 	R10BIO_IsSync,
 	R10BIO_IsRecover,
 	R10BIO_IsReshape,
-	R10BIO_Degraded,
 /* Set ReadError on bios that experience a read error
  * so that raid10d knows what to do with them.
  */
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 763bf0dcead8..8a0c8e78891f 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -314,9 +314,7 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf),
-					   !test_bit(STRIPE_DEGRADED,
-						     &sh->state));
+					   RAID5_STRIPE_SECTORS(conf));
 		}
 	}
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3484d649610d..b2d0f35eec63 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1359,8 +1359,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				submit_bio_noacct(rbi);
 		}
 		if (!rdev && !rrdev) {
-			if (op_is_write(op))
-				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %d on disc %d for sector %llu\n",
 				bi->bi_opf, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
@@ -2925,7 +2923,6 @@ static void raid5_end_write_request(struct bio *bi)
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
 		if (bi->bi_status) {
-			set_bit(STRIPE_DEGRADED, &sh->state);
 			set_bit(WriteErrorSeen, &rdev->flags);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))
@@ -3708,7 +3705,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		}
 		if (bitmap_end)
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0);
+					   RAID5_STRIPE_SECTORS(conf));
 		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
@@ -3754,7 +3751,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		}
 		if (bitmap_end)
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0);
+					   RAID5_STRIPE_SECTORS(conf));
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -4106,9 +4103,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					wbi = wbi2;
 				}
 				md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-						   RAID5_STRIPE_SECTORS(conf),
-						   !test_bit(STRIPE_DEGRADED,
-							     &sh->state));
+						   RAID5_STRIPE_SECTORS(conf));
 				if (head_sh->batch_head) {
 					sh = list_first_entry(&sh->batch_list,
 							      struct stripe_head,
@@ -4385,7 +4380,6 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
 		s->locked++;
 		set_bit(R5_Wantwrite, &dev->flags);
 
-		clear_bit(STRIPE_DEGRADED, &sh->state);
 		set_bit(STRIPE_INSYNC, &sh->state);
 		break;
 	case check_state_run:
@@ -4542,7 +4536,6 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 			clear_bit(R5_Wantwrite, &dev->flags);
 			s->locked--;
 		}
-		clear_bit(STRIPE_DEGRADED, &sh->state);
 
 		set_bit(STRIPE_INSYNC, &sh->state);
 		break;
@@ -4951,7 +4944,6 @@ static void break_stripe_batch_list(struct stripe_head *head_sh,
 
 		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
 					    (1 << STRIPE_PREREAD_ACTIVE) |
-					    (1 << STRIPE_DEGRADED) |
 					    (1 << STRIPE_ON_UNPLUG_LIST)),
 			      head_sh->state & (1 << STRIPE_INSYNC));
 
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 97a795979a35..80948057b877 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -358,7 +358,6 @@ enum {
 	STRIPE_REPLACED,
 	STRIPE_PREREAD_ACTIVE,
 	STRIPE_DELAYED,
-	STRIPE_DEGRADED,
 	STRIPE_BIT_DELAY,
 	STRIPE_EXPANDING,
 	STRIPE_EXPAND_SOURCE,
-- 
2.39.2

