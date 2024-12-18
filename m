Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1A819CD17;
	Wed, 18 Dec 2024 12:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734524437; cv=none; b=U1ux7lURT4BnsZAW+mj6/lcEZB8WaRNQWAaZ0FGfAxCpXha7i1paiCXcZfnANWOK17pFReWp5aYnz6957Cgst7yyyDgLIknpPnkhG67Z0Cfs319vz2v1yGOd48bavTaGfZoW9lholS0s4+jNW4r8RhYeqe2sx627dZjMpOQlel8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734524437; c=relaxed/simple;
	bh=0fA7GHad5tvjgVxKgv9f7m9XLZ9Wc/v2D6NFisrjjpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjL9rjqcBmZDs11dEXIQHN3g+QzOpBKu80yxyqQy50gzYCVuo5eVo1BguJ+RekpfQ4EYce8g7oOLeXYjK5feGZpJcthXdFvTx3jmX0bDy9r3bBT8ngnEAIJKYbb1M1rAIlCJMTuKQjWirjBRpCKxTL2ZSLoZAyilUn9zgLTWILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NNn+cWKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NNn+cWKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB4FC4CED4;
	Wed, 18 Dec 2024 12:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734524436;
	bh=0fA7GHad5tvjgVxKgv9f7m9XLZ9Wc/v2D6NFisrjjpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNn+cWKyAQyC1ag2Y7XQFCZd2mIO0SA+QzrkyfCINb4BTWpenPEcPEJtaPeSSdWGl
	 /N6EFG2eV+TpO1evk3EQyxDWVp6HAPMSgL8evBAoKS1WkFVQshqNW0QvKheLtxr3cp
	 WKTPGKGXlhd24onHbhj2Gacx50ifoAu2FOI+alYpYH3JF1bHXaJPq48XdsoTlwqH1f
	 +4EJeYaEfsRIxJGaqAla839Kk5DXgd0ONnEZtBVzb6onwnKmaPc6x/o4TnII5XQO55
	 6bTQArqX1Q9d/8BCbMu0VfM0Q2VJOTsAG9PJHYeEvF6u/LYW6lhvjaawH4NMskkTab
	 O5XzkTmxGaxOA==
From: yukuai@kernel.org
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@hauwei.com,
	yangerkun@huawei.com,
	Yu Kuai <yukuai@kernel.org>
Subject: [PATCH v2 md-6.14 2/5] md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
Date: Wed, 18 Dec 2024 20:17:42 +0800
Message-ID: <20241218121745.2459-3-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241218121745.2459-1-yukuai@kernel.org>
References: <20241218121745.2459-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

It is useless, because for the case IO failed for one rdev:

- If badblocks is set and rdev is not faulty, there is no need to
 mark the bit as NEEDED;
- If rdev is faulty, then mddev->degraded will be set, and we can use
it to mard the bit as NEEDED;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai@kernel.org>
---
 drivers/md/md-bitmap.c   | 19 ++++++++++---------
 drivers/md/md-bitmap.h   |  2 +-
 drivers/md/raid1.c       |  3 +--
 drivers/md/raid10.c      |  3 +--
 drivers/md/raid5-cache.c |  3 +--
 drivers/md/raid5.c       |  9 +++------
 6 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 84fb4cc67d5e..b40a84b01085 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1726,7 +1726,7 @@ static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
 }
 
 static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
-			    unsigned long sectors, bool success)
+			    unsigned long sectors)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -1745,15 +1745,16 @@ static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
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
index e87a1f493d3c..31c93019c76b 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -92,7 +92,7 @@ struct bitmap_operations {
 	int (*startwrite)(struct mddev *mddev, sector_t offset,
 			  unsigned long sectors);
 	void (*endwrite)(struct mddev *mddev, sector_t offset,
-			 unsigned long sectors, bool success);
+			 unsigned long sectors);
 	bool (*start_sync)(struct mddev *mddev, sector_t offset,
 			   sector_t *blocks, bool degraded);
 	void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 15ba7a001f30..81dff2cea0db 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -423,8 +423,7 @@ static void close_write(struct r1bio *r1_bio)
 	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
 		mddev->bitmap_ops->end_behind_write(mddev);
 	/* clear the bitmap if all writes complete successfully */
-	mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors,
-				    !test_bit(R1BIO_Degraded, &r1_bio->state));
+	mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors);
 	md_write_end(mddev);
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c3a93b2a26a6..3dc0170125b2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -429,8 +429,7 @@ static void close_write(struct r10bio *r10_bio)
 	struct mddev *mddev = r10_bio->mddev;
 
 	/* clear the bitmap if all writes complete successfully */
-	mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors,
-				    !test_bit(R10BIO_Degraded, &r10_bio->state));
+	mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors);
 	md_write_end(mddev);
 }
 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 4c7ecdd5c1f3..ba4f9577c737 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -314,8 +314,7 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
 			conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf),
-					!test_bit(STRIPE_DEGRADED, &sh->state));
+					sh->sector, RAID5_STRIPE_SECTORS(conf));
 		}
 	}
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 93cc7e252dd4..6eb2841ce28c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3664,8 +3664,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		}
 		if (bitmap_end)
 			conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf),
-					false);
+					sh->sector, RAID5_STRIPE_SECTORS(conf));
 		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
@@ -3711,8 +3710,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		}
 		if (bitmap_end)
 			conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf),
-					false);
+					sh->sector, RAID5_STRIPE_SECTORS(conf));
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -4062,8 +4060,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					wbi = wbi2;
 				}
 				conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf),
-					!test_bit(STRIPE_DEGRADED, &sh->state));
+					sh->sector, RAID5_STRIPE_SECTORS(conf));
 				if (head_sh->batch_head) {
 					sh = list_first_entry(&sh->batch_list,
 							      struct stripe_head,
-- 
2.43.0

